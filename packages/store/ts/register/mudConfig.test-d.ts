import { describe, expectTypeOf } from "vitest";
import { mudConfig } from ".";

describe("mudConfig", () => {
  // Test possible inference confusion.
  // This would fail if you remove `AsDependent` from `MUDUserConfig`
  expectTypeOf<
    ReturnType<
      typeof mudConfig<{
        enums: {
          Enum1: ["E1"];
          Enum2: ["E1"];
        };
        namespaces: {
          "": {
            tables: {
              Table1: {
                keySchema: {
                  a: "Enum1";
                };
                schema: {
                  b: "Enum2";
                };
              };
              Table2: {
                schema: {
                  a: "uint32";
                };
              };
            };
          };
        };
      }>
    >
  >().toEqualTypeOf<{
    enums: {
      Enum1: ["E1"];
      Enum2: ["E1"];
    };
    namespaces: {
      "": {
        tables: {
          Table1: {
            keySchema: {
              a: "Enum1";
            };
            schema: {
              b: "Enum2";
            };
          };
          Table2: {
            schema: {
              a: "uint32";
            };
          };
        };
      };
    };
    storeImportPath: "@latticexyz/store/src/";
    userTypesPath: "Types";
    codegenDirectory: "codegen";
  }>();
});
