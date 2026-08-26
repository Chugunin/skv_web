import { readItems } from "@directus/sdk";
import { directus } from "@lib/directus/client";
import type { Direction } from "@/models/direction";
import { directions as localDirections } from "@data/directions";

export async function getDirections(): Promise<Direction[]> {
  try {
    return await directus.request(readItems("directions"));
  } catch (error) {
    if (import.meta.env.DIRECTUS_STRICT === "true") throw error;
    console.warn("[SKV] Directus directions недоступны: используется локальный fallback.");
    return localDirections;
  }
}
