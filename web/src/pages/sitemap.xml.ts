import type { APIRoute } from "astro";
import { getArticles } from "@lib/repository";
import { config } from "@lib/config";

const staticRoutes = ["/", "/therapy/", "/journal/"];

function escapeXml(value: string): string {
  return value.replace(/[<>&'\"]/g, char => ({
    "<": "&lt;", ">": "&gt;", "&": "&amp;", "'": "&apos;", '"': "&quot;"
  }[char] ?? char));
}

export const GET: APIRoute = async () => {
  const articles = await getArticles();
  const urls = [
    ...staticRoutes.map(path => ({ loc: new URL(path, config.siteUrl).toString() })),
    ...articles.map(article => ({
      loc: new URL(`/journal/${article.slug}/`, config.siteUrl).toString(),
      lastmod: article.date
    }))
  ];

  const body = `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${urls.map(item => `  <url>\n    <loc>${escapeXml(item.loc)}</loc>${item.lastmod ? `\n    <lastmod>${escapeXml(item.lastmod.slice(0, 10))}</lastmod>` : ""}\n  </url>`).join("\n")}\n</urlset>\n`;

  return new Response(body, {
    headers: { "Content-Type": "application/xml; charset=utf-8" }
  });
};
