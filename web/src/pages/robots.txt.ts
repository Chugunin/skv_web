import type { APIRoute } from "astro";
import { config } from "@lib/config";

export const GET: APIRoute = () => {
  const sitemap = new URL("/sitemap.xml", config.siteUrl).toString();
  const body = `User-agent: *\nAllow: /\n\nSitemap: ${sitemap}\n`;
  return new Response(body, { headers: { "Content-Type": "text/plain; charset=utf-8" } });
};
