import {CredentialData, CredentialSubject, Operation, SignifyClient} from "signify-ts";
import {createTimestamp, DEFAULT_TIMEOUT_MS} from "../utils.js";
import {waitOperation} from "./operations.js";

/**
 * Creates a credential registry under the specified AID.
 *
 * @returns {Promise<{registryRegk: string}>} Object containing the delegatee QVI multisig AID OOBI
 * @param client
 * @param aidName
 * @param registryName
 */
export async function createRegistry(
    client: SignifyClient,
    aidName: string,
    registryName: string,
) {
    const aid = await client.identifiers().get(aidName);

    const existing = await client.registries().list(aidName);
    if (existing.find((reg) => reg.name === registryName)) {
        console.log(`Registry "${registryName}" already exists under AID "${aidName}". Skipping creation.`);
        return { regk: existing.find((reg) => reg.name === registryName)?.regk, operation: null };
    }

    try {
        const createRegistryResult = await client
            .registries()
            .create({ name: aidName, registryName: registryName });

        const operationDetails = await createRegistryResult.op();
        const completedOperation: Operation<any> = await client
            .operations()
            .wait(operationDetails, {signal: AbortSignal.timeout(DEFAULT_TIMEOUT_MS)});

        if (completedOperation.error) {
            throw new Error(`Credential registry creation failed: ${JSON.stringify(completedOperation.error)}`);
        }

        const registrySaid = completedOperation?.response?.anchor?.i;
        console.log(`Successfully created credential registry: ${registrySaid}`);

        await client.operations().delete(completedOperation.name);
        return { regk: registrySaid, operation: completedOperation };
    } catch (error) {
        console.error(`Failed to create credential registry "${registryName}":`, error);
        throw error;
    }
}

/**
 * Issues a credential
 *
 * @param issClient The client issuing the credential
 * @param issAidName The name of the AID that is issuing the credential
 * @param registry the registry to use for the credential
 * @param schema the schema SAID for the credential
 * @param hldPrefix identifier prefix for the holder of the credential
 * @param credData
 * @param credEdge
 * @param credRules
 * @returns {Promise<>} Object containing holder's credential information
 */
export async function issueCredential(
    issClient: SignifyClient,
    issAidName: string,
    registry: string,
    schema: string,
    hldPrefix: string,
    credData: any,
    credEdge?: any,
    credRules?: any
): Promise<{said: string, issuer: string, issuee: string, acdc: any, anc: any, iss: any}> {
    // Ensure the registry exists
    const issAid = await issClient.identifiers().get(issAidName);

    const registries = await issClient.registries().list(issAidName)
    const issRegistry = registries.find((reg) => reg.name === registry);
    // console.log(`Found registry: ${issRegistry?.regk}`, issRegistry);

    console.log(`Cred data:`, credData)
    const kargsSub: CredentialSubject = {
        i: hldPrefix,
        dt: createTimestamp(),
        ...credData,
    };
    const issData: CredentialData = {
        i: issAid.prefix,
        ri: issRegistry.regk,
        s: schema,
        a: kargsSub,
        e: credEdge,
        r: credRules,
    };
    console.log("Credential data:", issData);
    const issResult = await issClient.credentials().issue(issAidName, issData);
    const issueOp = await waitOperation(issClient, issResult.op);
    if (issueOp.error) {
        throw new Error(`Credential issuance failed: ${JSON.stringify(issueOp.error)}`);
    }
    // console.log("Issuance succeeded:", issueOp)

    const credentialSad: any = issueOp.response; // The full Self-Addressing Data (SAD) of the credential
    const credentialSaid = credentialSad?.ced?.d; // The SAID of the credential

    const cred = await issClient.credentials().get(credentialSaid);
    console.log("found credential is:", cred)
    return {
        said: cred.sad.d,
        issuer: cred.sad.i,
        // @ts-ignore
        issuee: cred.sad?.a.i,
        acdc: issResult.acdc,
        anc: issResult.anc,
        iss: issResult.iss
    }
}

export async function grantCredential(
    client: SignifyClient,
    issueeAid: string,
    issName: string,
    acdc: any,
    anc: any,
    iss: any
){
    const dt = createTimestamp();
    const [grant, gsigs, end] = await client.ipex().grant({
            senderName: issName,
            recipient: issueeAid,
            datetime: dt,
            acdc: acdc,
            anc: anc,
            iss: iss,
        });

    let op = await client
        .ipex()
        .submitGrant(issName, grant, gsigs, end, [issueeAid]);
    op = await waitOperation(client, op);

    console.log('Grant message sent');
    return op
}