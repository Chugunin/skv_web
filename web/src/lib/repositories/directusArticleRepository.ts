import { readItems } from "@directus/sdk";
import { directus } from "@lib/directus/client";
import type { Article } from "@/models/article";
import { mapArticle } from "@lib/directus/mappers/articleMapper";
import * as local from "./articleRepository";

const strict = import.meta.env.DIRECTUS_STRICT === "true";

async function fromDirectus(): Promise<Article[]> {
  try {
    const data = await directus.request(readItems("articles", {
      filter: { status: { _eq: "published" } } as any,
      sort: ["-published_at", "-date"] as any,
      fields: ["*", "category.*"] as any
    }));
    return data.map(mapArticle);
  } catch (error) {
    if (strict) throw error;
    console.warn("[SKV] Directus недоступен: используются локальные Journal fixtures.");
    return local.getArticles();
  }
}

export async function getArticles(): Promise<Article[]> { return fromDirectus(); }
export async function getFeaturedPosts(): Promise<Article[]> { return (await fromDirectus()).filter(article => article.featured).slice(0,3); }
export async function getArchive(): Promise<Article[]> { return (await fromDirectus()).filter(article => !article.featured); }
export async function getArticleBySlug(slug:string):Promise<Article|undefined>{ return (await fromDirectus()).find(article=>article.slug===slug); }
