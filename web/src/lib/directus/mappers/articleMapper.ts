import type { Article } from "@/models/article";
import { config } from "@lib/config";

function assetUrl(value: unknown): string {
  if (!value) return "";
  if (typeof value === "string") {
    if (/^https?:\/\//.test(value) || value.startsWith("/")) return value;
    return `${config.apiUrl}/assets/${value}`;
  }
  if (typeof value === "object" && value && "id" in value) return `${config.apiUrl}/assets/${(value as any).id}`;
  return "";
}

export function mapArticle(article: any): Article {
  return {
    id: String(article.id),
    slug: article.slug,
    title: article.title,
    description: article.description ?? article.lead ?? "",
    content: article.content ?? "",
    image: assetUrl(article.cover ?? article.image),
    date: article.published_at ?? article.date ?? article.date_created,
    author: article.author ?? "SKV",
    readingTime: article.reading_time ?? article.readingTime,
    category: article.category ?? undefined,
    tags: article.tags ?? [],
    featured: article.featured ?? false
  };
}
