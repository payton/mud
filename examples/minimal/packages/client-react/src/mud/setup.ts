import { createClientComponents } from "./createClientComponents";
import { createSystemCalls } from "./createSystemCalls";
import { setupNetwork } from "./setupNetwork";
import { setupViemNetwork } from "./setupViemNetwork";

export type SetupResult = Awaited<ReturnType<typeof setup>>;

export async function setup() {
  const { storeCache } = await setupViemNetwork();

  storeCache.tables.Inventory.subscribe((updates) => {
    console.log("inventory updates", updates);
  });

  const network = await setupNetwork();
  const components = createClientComponents(network);
  const systemCalls = createSystemCalls(network, components);
  return {
    network,
    components,
    systemCalls,
  };
}
