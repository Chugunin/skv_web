-- Read-only audit for Directus 11/12 policy-based public access.
-- The built-in anonymous/public policy is resolved through directus_access
-- where both role and user are NULL, rather than relying on a hard-coded UUID.

\echo '=== Public policy ==='
SELECT p.id, p.name, p.admin_access, p.app_access
FROM directus_policies p
JOIN directus_access a ON a.policy = p.id
WHERE a.role IS NULL AND a."user" IS NULL
ORDER BY p.name;

\echo '=== Public permissions relevant to SKV ==='
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

\echo '=== Any PUBLIC write/delete access (should return zero rows for SKV content) ==='
SELECT p.name AS policy_name, dp.collection, dp.action, dp.fields, dp.permissions
FROM directus_permissions dp
JOIN directus_policies p ON p.id = dp.policy
JOIN directus_access a ON a.policy = p.id
WHERE a.role IS NULL
  AND a."user" IS NULL
  AND dp.action IN ('create', 'update', 'delete')
  AND dp.collection IN ('articles', 'categories', 'directions', 'directus_files')
ORDER BY dp.collection, dp.action;
