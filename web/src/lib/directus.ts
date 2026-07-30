import { config } from "./config";

export class DirectusClient {

    readonly baseUrl = config.apiUrl;

}

export const directus = new DirectusClient();