import fs from 'fs';
import {EnvType} from "../../client/resolve-env.js";
import {getOrCreateClient} from "../../client/identifiers.js";
import {waitOperation} from "../../client/operations.js";

// Pull in arguments from the command line and configuration
const args = process.argv.slice(2);
const env = args[0] as 'docker' | 'testnet';
const qviPasscode = args[1];
const delegateAidName = args[2];
const delegatorInfoPath = args[3];
const delegateInfoPath = args[4];
const delegateOutputPath = args[5];

async function finishDelegation(delPre: string, delegateName: string, delOpName: string, passcode: string, environment: EnvType) {
    console.log(`Finishing ${delPre} delegation to ${delegateName} on op: ${delOpName}...`);
    const delegateClient = await getOrCreateClient(passcode, environment);

    // refresh delegator key state to discover delegation anchor
    const op: any = await delegateClient.keyStates().query(delPre, '1');
    await waitOperation(delegateClient, op);

    // wait for delegate inception to complete
    const delOp: any = await delegateClient.operations().get(delOpName);
    await waitOperation(delegateClient, delOp);

    // finish identifier setup
    // add endpoint role
    const endRoleOp = await delegateClient.identifiers()
        .addEndRole(delegateName, 'agent', delegateClient!.agent!.pre);
    await waitOperation(delegateClient, await endRoleOp.op());

    // get oobi
    const oobiResp = await delegateClient.oobis().get(delegateName, 'agent');
    const oobi = oobiResp.oobis[0]

    const aid = await delegateClient.identifiers().get(delegateName)
    return {
        aid: aid.prefix,
        oobi
    }
}

// Read delegator info
const dgrInfo = JSON.parse(await fs.promises.readFile(delegatorInfoPath, 'utf-8'));

// Read delegate inception info
const dgtInfo = JSON.parse(await fs.promises.readFile(delegateInfoPath, 'utf-8'));
console.log(`${delegateAidName} delegate info`, dgtInfo);

// finish delegation and write data to file
const delegationInfo: any = await finishDelegation(dgrInfo.aid, delegateAidName, dgtInfo.icpOpName, qviPasscode, env);
await fs.promises.writeFile(delegateOutputPath, JSON.stringify(delegationInfo));
console.log(`Delegate data written to ${delegateOutputPath}`);
