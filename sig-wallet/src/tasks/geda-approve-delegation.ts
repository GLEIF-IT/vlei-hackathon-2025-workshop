import {EnvType} from "../client/resolve-env.js";
import {getOrCreateClient} from "../client/keystore-creation.js";
import {waitOperation} from "../client/operations.js";
import fs from "fs";

const args = process.argv.slice(2);
const env = args[0] as 'docker' | 'testnet';
const delegatorPasscode = args[1];
const delegatorName = args[2];
const delegateInfoFilePath = args[3];

/**
 *
 * @param dgrName delegator name
 * @param dgtPre delegate prefix
 * @param passcode delegator SignifyClient passcode
 * @param env environment
 */
async function approveDelegation(dgrName: string, dgtPre: string, passcode: string, env: EnvType) {
    const delegatorClient = await getOrCreateClient(passcode, env);

    // delegator anchor of delegate prefix in key event log - is the approval of delegation
    const anchor = {
        i: dgtPre,
        s: '0',
        d: dgtPre,
    };
    const apprDelRes = await delegatorClient
        .delegations()
        .approve(dgrName, anchor);
    const opResp = await waitOperation(delegatorClient, await apprDelRes.op());
    return opResp.done;
}

const delegateInfo = JSON.parse(await fs.promises.readFile(delegateInfoFilePath, 'utf-8'));
const delegatorApproved = await approveDelegation(delegatorName, delegateInfo.aid, delegatorPasscode, env);
console.log(`Delegator ${delegatorName} approved delegation of ${delegateInfo.aid}: ${delegatorApproved}`);
