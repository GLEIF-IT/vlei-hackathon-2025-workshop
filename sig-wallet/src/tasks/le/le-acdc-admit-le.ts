import {getOrCreateClient} from "../../client/identifiers.js";
import { ipexAdmitGrant } from "../../client/credentials.js";

const args = process.argv.slice(2);
const env = args[0] as 'docker' | 'testnet';
const lePasscode = args[1];
const grantSAID = args[2];
const qviPrefix = args[3];

const leClient = await getOrCreateClient(lePasscode, env);

const op: any = await ipexAdmitGrant(leClient, 'le', qviPrefix, grantSAID)
const creds = await leClient.credentials().list();
console.log("LE IPEX Admit:", op.operation?.response?.said || "admitted successfully");
console.log("LE credential admitted:", creds[0].sad.d);
