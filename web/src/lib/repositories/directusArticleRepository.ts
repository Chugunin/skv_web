import { readItems } from "@directus/sdk";
import { directus } from "@lib/directus/client";
import type { Article } from "@/models/article";
import type { Category } from "@/models/category";
import { mapArticle } from "@lib/directus/mappers/articleMapper";
import * as local from "./articleRepository";
import { categories as localCategories } from "@data/categories";

const strict = import.meta.env.DIRECTUS_STRICT === "true";
let buildArticlesPromise: Promise<Article[]> | undefined;
let buildCategoriesPromise: Promise<Category[]> | undefined;

function fallbackWarning(label: string): void {
  console.warn(`[SKV] Directus недоступен (${label}): используются локальные fixtures.`);
}

async function requestArticles(): Promise<Article[]> {
  try {
    const data = await directus.request(readItems("articles", {
      filter: { status: { _eq: "published" } } as any,
      sort: ["-published_at"] as any,
      fields: [
        "id", "slug", "title", "description", "content", "cover", "published_at",
        "category.id", "category.slug", "category.title", "category.description",
        "featured", "reading_time", "author", "seo_title", "seo_description", "seo_image"
      ] as any
    }));
    return data.map(mapArticle).filter(article => article.slug && article.title);
  } catch (error) {
    if (strict) throw error;
    fallbackWarning("articles");
    return local.getArticles();
  }
}

async function fromDirectus(): Promise<Article[]> {
  // During a static production build the same collection is requested by several
  // components/routes. Memoizing only outside dev avoids duplicate CMS calls while
  // preserving live content updates during `astro dev`.
  if (import.meta.env.DEV) return requestArticles();
  buildArticlesPromise ??= requestArticles();
  return buildArticlesPromise;
}

export async function getArticles(): Promise<Article[]> {
  return fromDirectus();
}

export async function getFeaturedPosts(): Promise<Article[]> {
  const articles = await fromDirectus();
  const explicit = articles.filter(article => article.featured);
  return (explicit.length ? explicit : articles).slice(0, 3);
}

export async function getArchive(): Promise<Article[]> {
  // "Archive" is the full published library. Featured is a presentation flag and
  // must not remove an article from the archive/filtering section.
  return fromDirectus();
}

export async function getArticleBySlug(slug: string): Promise<Article | undefined> {
  return (await fromDirectus()).find(article => article.slug === slug);
}

async function requestCategories(): Promise<Category[]> {
  try {
    const data = await directus.request(readItems("categories", {
      sort: ["title"] as any,
      fields: ["id", "slug", "title", "description"] as any
    }));
    return data.map((item: any) => ({
      id: String(item.id),
      slug: String(item.slug),
      title: String(item.title),
      description: item.description ? String(item.description) : undefined
    })).filter(item => item.slug && item.title);
  } catch (error) {
    if (strict) throw error;
    fallbackWarning("categories");
    return localCategories;
  }
}

export async function getCategories(): Promise<Category[]> {
  if (import.meta.env.DEV) return requestCategories();
  buildCategoriesPromise ??= requestCategories();
  return buildCategoriesPromise;
}
