import {
    createDirectus,
    rest
} from "@directus/sdk";

import { config } from "@lib/config";

import type { DirectusSchema } from "./schema";

export const directus = createDirectus<DirectusSchema>(
    config.apiUrl
).with(rest());