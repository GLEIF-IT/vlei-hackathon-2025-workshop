import {
    CreateIdentiferArgs,
    EventResult,
    HabState,
    randomPasscode,
    ready,
    SignifyClient,
    Tier,
} from 'signify-ts';
import {EnvType, resolveEnvironment} from "./resolve-env.js";



/**
 * Connect or boot a SignifyClient instance
 */
export async function getOrCreateClient(
    bran: string | undefined = undefined,
    environment: EnvType | undefined = undefined,
): Promise<SignifyClient> {
    const env = resolveEnvironment(environment);
    await ready();
    bran ??= randomPasscode();
    bran = bran.padEnd(21, '_');
    let adminUrl = env.adminUrl;
    let bootUrl = env.bootUrl;
    const client = new SignifyClient(adminUrl, bran, Tier.low, bootUrl);
    try {
        await client.connect();
    } catch {
        const res = await client.boot();
        if (!res.ok) throw new Error();
        await client.connect();
    }
    console.log('client', {agent: client.agent?.pre, controller: client.controller.pre});
    return client;
}