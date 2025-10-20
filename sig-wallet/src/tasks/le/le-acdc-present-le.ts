import {CredentialResult, Serder, SignifyClient} from "signify-ts";
import {getOrCreateClient} from "../../client/identifiers.js";
import {getReceivedCredential} from "../../client/credentials.js";
import {createTimestamp} from "../../time.js";
import {waitOperation} from "../../client/operations.js";

// process arguments
const args = process.argv.slice(2);
const env = args[0] as 'docker' | 'testnet';
const passcode = args[1]
const senderAidName = args[2]
const credentialSAID = args[3]
const recipientPrefix = args[4]

/**
 * Uses IPEX to grant a credential to a recipient AID.
 *
 * @param client SignifyClient instance of the client performing the grant
 * @param senderAidName name of the AID sending the credential
 * @param credentialSAID The SAID of the credential to be granted
 * @param recipientPrefix identifier of the recipient AID who will receive the credential presentation
 * @returns {Promise<string>} String true/false if LE credential exists or not for the verifier
 */
export async function grantCredential(
    client: SignifyClient,
    senderAidName: string,
    credentialSAID: string,
    recipientPrefix: string): Promise<string> {
    // Check to see if the credential exists
    let receivedCred: CredentialResult = await getReceivedCredential(
        client,
        credentialSAID
    )
    if (!receivedCred) {
        throw Error(`Credential ${credentialSAID} not found.`)
    }

    const grantTime = createTimestamp();
    console.log(`IPEX Granting credential ${credentialSAID} to ${recipientPrefix}...`);
    const [grant, gsigs, gend] = await client.ipex().grant({
        senderName: senderAidName,
        acdc: new Serder(receivedCred.sad),
        anc: new Serder(receivedCred.anc),
        iss: new Serder(receivedCred.iss),
        ancAttachment: receivedCred.ancatc,
        recipient: recipientPrefix,
        datetime: grantTime,
    });

    const op = await client
        .ipex()
        .submitGrant(senderAidName, grant, gsigs, gend, [
            recipientPrefix,
        ]);
    await waitOperation(client, op);

    return op.response;
}
const client = await getOrCreateClient(passcode, env);
const granted: string = await grantCredential(client, senderAidName, credentialSAID, recipientPrefix);
console.log(granted);
