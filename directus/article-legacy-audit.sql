-- Read-only audit before removing legacy article fields from Directus schema.
-- Run against the production PostgreSQL database and review the result first.

SELECT
  COUNT(*) AS total_articles,
  COUNT(*) FILTER (WHERE image IS NOT NULL AND BTRIM(image) <> '') AS legacy_image_rows,
  COUNT(*) FILTER (WHERE cover IS NULL AND image IS NOT NULL AND BTRIM(image) <> '') AS legacy_image_without_cover,
  COUNT(*) FILTER (WHERE date IS NOT NULL) AS legacy_date_rows,
  COUNT(*) FILTER (WHERE published_at IS NULL AND date IS NOT NULL) AS legacy_date_not_migrated,
  COUNT(*) FILTER (WHERE "readingTime" IS NOT NULL) AS legacy_reading_time_rows,
  COUNT(*) FILTER (WHERE reading_time IS NULL AND "readingTime" IS NOT NULL) AS legacy_reading_time_not_migrated
FROM articles;

SELECT id, slug, image, cover
FROM articles
WHERE cover IS NULL
  AND image IS NOT NULL
  AND BTRIM(image) <> ''
ORDER BY id;
