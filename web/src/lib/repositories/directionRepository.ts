import { readItems } from "@directus/sdk";
import { directus } from "@lib/directus/client";
import type {Direction} from "@/models/direction";

export async function getDirections(): Promise<Direction[]> {

    return await directus.request(

        readItems("directions")

    );

}