import { readItems } from "@directus/sdk";
import { directus } from "@lib/directus/client";
import type { Direction } from "@/models/direction";
import { directions as localDirections } from "@data/directions";

const allowDevFixtures = import.meta.env.DEV && import.meta.env.DIRECTUS_DEV_FALLBACK === "true";
let buildDirectionsPromise: Promise<Direction[]> | undefined;

function mapDirection(item: Record<string, unknown>): Direction {
  return {
    id: String(item.id),
    title: String(item.title ?? ""),
    description: String(item.description ?? ""),
    icon: item.icon ? String(item.icon) : undefined,
    image: item.image ? String(item.image) : undefined,
    sortOrder: item.sort_order == null ? undefined : Number(item.sort_order)
  };
}

async function requestDirections(): Promise<Direction[]> {
  try {
    const data = await directus.request(readItems("directions", {
      sort: ["sort_order", "id"] as any,
      fields: ["id", "title", "description", "icon", "image", "sort_order"] as any
    }));

    return data
      .map((item) => mapDirection(item as unknown as Record<string, unknown>))
      .filter((item) => item.title && item.description);
  } catch (error) {
    if (!allowDevFixtures) throw error;
    console.warn("[SKV] Directus directions недоступны: DIRECTUS_DEV_FALLBACK=true, используется локальный fallback.");
    return localDirections;
  }
}

export async function getDirections(): Promise<Direction[]> {
  if (import.meta.env.DEV) return requestDirections();
  buildDirectionsPromise ??= requestDirections();
  return buildDirectionsPromise;
}
