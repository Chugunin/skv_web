import type { Direction } from "@/models/direction";
import type { Article } from "@/models/article";
import type { Category } from "@/models/category";
import type { Tag } from "@/models/tag";

/**
 * Public application schema. Directus may expose additional system fields;
 * adapters map those records into the stable frontend models declared here.
 */
export interface DirectusSchema {
  directions: Direction[];
  articles: Article[];
  categories: Category[];
  tags: Tag[];
}
