# SKV Astro baseline

Дата фиксации: 2026-08-17.

## Что есть сейчас

- Astro 7.1.5, TypeScript/ESM, Node >=22.12.
- `@directus/sdk` 24.x и `sharp`.
- Реализованы только `/journal/` и `/journal/[slug]/`.
- Journal разбит на Hero / About / Directions / FeaturedArticles / Archive / Subscribe.
- Есть Header, Footer, Container и BaseLayout.
- Есть SDK client Directus, schema/types и repositories.
- `src/lib/repository.ts` сейчас экспортирует Directus repositories, то есть Journal фактически ожидает доступный Directus при сборке.
- Одновременно в `src/data/*` лежат тестовые локальные данные и отдельный `articleRepository.ts`; этот слой сейчас не подключен к публичному repository barrel.

## Что сохраняем

- Astro как платформу и текущую alias-схему.
- Идею component decomposition.
- Directus SDK client/repository boundary как направление архитектуры.
- Article/category/domain models как основу, но их поля будут синхронизированы с ТЗ.
- Static article route как подход, если он согласуется с выбранной стратегией публикации Directus.

## Что заменяем / перерабатываем

- Текущий Journal visual layer: темные секции, full-bleed photo hero, generic cards и Tilda CDN asset не соответствуют новой единой светлой системе.
- Header/Footer: сейчас они рассчитаны на темный Journal и не соответствуют общей навигации ТЗ.
- Глобальную типографику Inter-only: ТЗ требует serif для editorial headings и grotesk для UI/body.
- Hardcoded colors/spacing в компонентах: переводим в design tokens.
- Inline IntersectionObserver в BaseLayout: переносим в единый motion/reveal слой с reduced-motion.
- `config.apiUrl = http://localhost:8055`: переводим на environment configuration с контролируемым dev fallback.
- Тестовые `picsum.photos` и тестовый контент — только временный источник разработки, не production content.
- README starter content — заменить проектной документацией позже.

## Расхождения Directus с ТЗ

ТЗ минимально требует для `articles`:

`id, slug, title, description, content, cover, published_at, status, category, seo_title, seo_description, seo_image`.

Текущая модель использует `image`, `date`, `author`, `readingTime`, `tags`, `featured`. Эти поля не считаются утвержденной production-схемой и требуют миграционного решения перед CMS-этапом.

## Baseline build

В текущем sandbox `npm run build` не стартует, потому что зависимости не установлены (`astro: not found`). Попытка `npm ci` в окружении не завершилась успешно. Поэтому первичная фиксация сделана по исходникам; production build остается обязательным gate на QA-этапе и должен быть повторен в среде с установленными зависимостями.
