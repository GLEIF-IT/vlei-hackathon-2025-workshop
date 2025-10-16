import fs from 'fs';
import {getOrCreateClient} from "../client/keystore-creation.js";
import {EnvType} from "../client/resolve-env.js";
import {waitOperation} from "../client/operations.js";

const args = process.argv.slice(2);
const env = args[0] as 'docker' | 'testnet';
const qviPasscode = args[1];
const dataDir = args[2];

async function createAid(name: string, passcode: string, environment: EnvType) {
    const client = await getOrCreateClient(passcode, environment);

    // incept
    const icpResp = await client.identifiers()
        .create(name);
    const op = await icpResp.op();
    const aid = op.name.split('.')[1];

    // add endpoint role
    const endRoleOp = await client.identifiers()
        .addEndRole(name, 'agent', client!.agent!.pre);
    await waitOperation(client, await endRoleOp.op());

    // get OOBI
    const oobiResp = await client.oobis().get(name, 'agent');
    const oobi = oobiResp.oobis[0];

    return {aid, oobi};
}

const gedaInfo: any = await createAid('geda', qviPasscode, env);
await fs.promises.writeFile(`${dataDir}/geda-aid.txt`, gedaInfo.aid);
await fs.promises.writeFile(`${dataDir}/geda-info.json`, JSON.stringify(gedaInfo));
console.log(`GEDA info written to ${dataDir}/geda-*`)
