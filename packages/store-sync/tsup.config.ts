import { defineConfig } from "tsup";

export default defineConfig({
  entry: ["src/index.ts", "src/sqlite/index.ts", "src/recs/index.ts"],
  target: "esnext",
  format: ["esm"],
  dts: false,
  sourcemap: true,
  clean: true,
  minify: true,
});
