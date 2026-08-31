-- SKV Directus one-time migration after schema apply.
-- Safe mappings only; legacy image -> cover is intentionally NOT converted
-- because image is a string while cover is a FK to directus_files.

UPDATE articles
SET published_at = COALESCE(published_at, date::timestamp with time zone)
WHERE published_at IS NULL AND date IS NOT NULL;

UPDATE articles
SET reading_time = COALESCE(reading_time, "readingTime")
WHERE reading_time IS NULL AND "readingTime" IS NOT NULL;

-- Existing records were content records in the old schema, so publish them.
-- Change this manually beforehand if some old records must remain drafts.
UPDATE articles
SET status = 'published'
WHERE status IS NULL OR status = 'draft';
