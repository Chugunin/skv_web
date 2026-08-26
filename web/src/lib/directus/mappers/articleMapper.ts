import type { Article } from "@/models/article";
import type { Category } from "@/models/category";
import { config } from "@lib/config";
import { calculateReadingTime } from "@lib/utils";

function assetUrl(value: unknown): string {
  if (!value) return "";
  if (typeof value === "string") {
    if (/^https?:\/\//.test(value) || value.startsWith("/")) return value;
    return `${config.apiUrl}/assets/${value}`;
  }
  if (typeof value === "object" && value && "id" in value) {
    return `${config.apiUrl}/assets/${String((value as { id: unknown }).id)}`;
  }
  return "";
}

function mapCategory(value: unknown): Category | undefined {
  if (!value || typeof value !== "object") return undefined;
  const category = value as Record<string, unknown>;
  if (!category.id || !category.slug || !category.title) return undefined;
  return {
    id: String(category.id),
    slug: String(category.slug),
    title: String(category.title),
    description: category.description ? String(category.description) : undefined
  };
}

export function mapArticle(raw: unknown): Article {
  const article = raw as Record<string, any>;
  const content = String(article.content ?? "");
  const image = assetUrl(article.cover ?? article.image);
  const seoImage = assetUrl(article.seo_image) || image;

  return {
    id: String(article.id),
    slug: String(article.slug ?? ""),
    title: String(article.title ?? ""),
    description: String(article.description ?? article.lead ?? ""),
    content,
    image,
    date: String(article.published_at ?? article.date ?? article.date_created ?? ""),
    author: article.author ? String(article.author) : "SKV",
    readingTime: Number(article.reading_time ?? article.readingTime) || calculateReadingTime(content),
    category: mapCategory(article.category),
    tags: Array.isArray(article.tags) ? article.tags : [],
    featured: Boolean(article.featured),
    seoTitle: article.seo_title ? String(article.seo_title) : undefined,
    seoDescription: article.seo_description ? String(article.seo_description) : undefined,
    seoImage
  };
}
