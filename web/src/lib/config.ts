export const config = {
  siteName: "SKV",
  siteUrl: import.meta.env.SITE ?? "http://localhost:4321",
  apiUrl: import.meta.env.DIRECTUS_URL ?? "http://localhost:8055",
  pageSize: 12
} as const;
