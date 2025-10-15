import fs from 'fs';
import {EnvType} from "../client/resolve-env.js";
import {getOrCreateClient} from "../client/keystore-creation.js";
import {waitOperation} from "../client/operations.js";

// Pull in arguments from the command line and configuration
const args = process.argv.slice(2);
const env = args[0] as 'docker' | 'testnet';
const qviPasscode = args[1];
const dataDir = args[2];

async function finishDelegation(qviPasscode: string, dataDir: string, environment: EnvType) {
    console.log("Finishing QVI delegation...");
    const qviClient = await getOrCreateClient(qviPasscode, environment);
    // Read GEDA info
    const gedaInfo = JSON.parse(await fs.promises.readFile(`${dataDir}/geda-info.json`, 'utf-8'));

    // Read QVI inception info
    const qviDelInfo = JSON.parse(await fs.promises.readFile(`${dataDir}/qvi-delegate-info.json`, 'utf-8'));
    console.log('qvi delegate info', qviDelInfo);

    const op: any = await qviClient.keyStates().query(gedaInfo.prefix, '1');
    await waitOperation(qviClient, op);

    const delOp: any = await qviClient.operations().get(qviDelInfo.QVI.icpOpName);
    await waitOperation(qviClient, delOp);

    const aid = await qviClient.identifiers().get('qvi')
    return {
        QVI: {
            aid: aid.prefix
        }
    }
}
const qviInfo: any = await finishDelegation(qviPasscode, dataDir, env);
console.log("Writing QVI data to file...");
await fs.promises.writeFile(`${dataDir}/qvi-info.json`, JSON.stringify(qviInfo));