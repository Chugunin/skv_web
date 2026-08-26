# SKV — production readiness

## Что уже можно зафиксировать

Текущая frontend-архитектура Astro остаётся преимущественно статической. Journal получает данные Directus во время build, а в production рекомендуется включать строгий режим, чтобы fixtures не могли незаметно попасть на сайт.

Рекомендуемые production variables:

```dotenv
SITE=https://example.com
DIRECTUS_URL=https://cms.example.com
DIRECTUS_STRICT=true
PUBLIC_CONTACT_ENDPOINT=
```

`SITE` должен содержать реальный HTTPS-домен до production build — он используется для canonical, Open Graph, sitemap и structured data.

## Directus

Перед production:

1. Зафиксировать конкретный image tag Directus вместо плавающего `directus/directus:11`.
2. Создать коллекции и permissions по `docs/DIRECTUS_SCHEMA.md`.
3. Проверить, что public role читает только опубликованные материалы и нужные assets.
4. Сделать backup PostgreSQL и Directus uploads.
5. Включить `DIRECTUS_STRICT=true` на production/CI.

## Формы — текущий блокер

Frontend формы готов к JSON endpoint и использует общий контракт/валидацию из `src/lib/contact/validation.ts`.

Серверный `POST /api/contact` намеренно не добавлен в текущую статическую сборку Astro: runtime endpoint требует выбранного server adapter/deployment target. До выбора хостинга нельзя корректно зафиксировать Node/Vercel/Netlify/Cloudflare adapter.

После решения OQ-02 и production hosting необходимо:

1. выбрать Astro server adapter;
2. реализовать runtime endpoint;
3. повторно применить `validateContactPayload()` на сервере;
4. добавить server-side rate limiting / anti-spam;
5. подключить CRM/email/Telegram transport;
6. хранить все секреты только в server environment;
7. направить `PUBLIC_CONTACT_ENDPOINT` на этот endpoint.

Клиентская проверка не заменяет серверную валидацию.

## Build acceptance

Минимальная проверка перед deployment:

```bash
npm ci
npm run build
npm run preview
```

Проверить маршруты:

- `/`
- `/therapy/`
- `/journal/`
- минимум одну `/journal/[slug]/`
- `/robots.txt`
- `/sitemap.xml`
- `/404`

Practice остаётся `noindex` до закрытия OQ-01. Privacy остаётся технической `noindex`-заглушкой до утверждения юридического текста.
