\set ON_ERROR_STOP on

BEGIN;

DO $$
DECLARE
    public_policy_id uuid;
    public_policy_count integer;
    article_read_count integer;
BEGIN
    SELECT COUNT(DISTINCT p.id)
      INTO public_policy_count
      FROM directus_policies p
      JOIN directus_access a ON a.policy = p.id
     WHERE a.role IS NULL
       AND a."user" IS NULL
       AND p.admin_access = false;

    IF public_policy_count <> 1 THEN
        RAISE EXCEPTION 'Expected exactly one public Directus policy, found %', public_policy_count;
    END IF;

    SELECT DISTINCT p.id
      INTO public_policy_id
      FROM directus_policies p
      JOIN directus_access a ON a.policy = p.id
     WHERE a.role IS NULL
       AND a."user" IS NULL
       AND p.admin_access = false;

    SELECT COUNT(*)
      INTO article_read_count
      FROM directus_permissions
     WHERE policy = public_policy_id
       AND collection = 'articles'
       AND action = 'read';

    IF article_read_count <> 1 THEN
        RAISE EXCEPTION 'Expected exactly one public articles/read permission, found %', article_read_count;
    END IF;

    UPDATE directus_permissions
       SET permissions = '{"status":{"_eq":"published"}}'::json
     WHERE policy = public_policy_id
       AND collection = 'articles'
       AND action = 'read';
END $$;

COMMIT;

\echo '=== Effective public permissions for SKV after migration ==='
SELECT
    p.name AS policy_name,
    dp.collection,
    dp.action,
    dp.fields,
    dp.permissions,
    dp.validation,
    dp.presets
FROM directus_permissions dp
JOIN directus_policies p ON p.id = dp.policy
JOIN directus_access a ON a.policy = p.id
WHERE a.role IS NULL
  AND a."user" IS NULL
  AND dp.collection IN ('articles', 'categories', 'directions', 'directus_files')
ORDER BY dp.collection, dp.action;

\echo '=== Public articles/read must be limited to status=published ==='
SELECT
    dp.collection,
    dp.action,
    dp.permissions
FROM directus_permissions dp
JOIN directus_access a ON a.policy = dp.policy
WHERE a.role IS NULL
  AND a."user" IS NULL
  AND dp.collection = 'articles'
  AND dp.action = 'read';

\echo '=== Any PUBLIC write/delete access (must be zero rows for SKV content) ==='
SELECT
    dp.collection,
    dp.action,
    dp.fields,
    dp.permissions
FROM directus_permissions dp
JOIN directus_access a ON a.policy = dp.policy
WHERE a.role IS NULL
  AND a."user" IS NULL
  AND dp.collection IN ('articles', 'categories', 'directions')
  AND dp.action IN ('create', 'update', 'delete');
