import {EnvType} from "../../client/resolve-env.js";
import {getOrCreateClient} from "../../client/identifiers.js";
import {waitOperation} from "../../client/operations.js";

const args = process.argv.slice(2);
const env = args[0] as 'docker' | 'testnet';
const qviPasscode = args[1];

async function getQviOobi(qviPasscode: string, environment: EnvType) {
    const qviClient = await getOrCreateClient(qviPasscode, environment);

    // delegate agent OOBI
    const qviOobiResp = await qviClient.oobis().get('qvi', 'agent');
    console.log("QVI OOBI response:", qviOobiResp);

    const identifierResp = await qviClient.identifiers().get('qvi');
    console.log("QVI Identifier:", identifierResp);


    return qviOobiResp.oobis[0];
}
const qviOobi = await getQviOobi(qviPasscode, env);
console.log("QVI OOBI:", qviOobi);