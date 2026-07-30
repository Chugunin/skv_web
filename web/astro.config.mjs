import { defineConfig } from "astro/config";
import { fileURLToPath } from "node:url";

export default defineConfig({

    vite: {

        resolve: {

            alias: {

                "@": fileURLToPath(new URL("./src", import.meta.url)),

                "@components": fileURLToPath(
                    new URL("./src/components", import.meta.url)
                ),

                "@layouts": fileURLToPath(
                    new URL("./src/layouts", import.meta.url)
                ),

                "@styles": fileURLToPath(
                    new URL("./src/styles", import.meta.url)
                ),

                "@lib": fileURLToPath(
                    new URL("./src/lib", import.meta.url)
                ),

                "@data": fileURLToPath(
                    new URL("./src/data", import.meta.url)
                ),

                "@assets": fileURLToPath(
                    new URL("./src/assets", import.meta.url)
                ),

                "@types": fileURLToPath(
                    new URL("./src/types", import.meta.url)
                )

            }

        }

    }

});