# SKV — план разработки

План собран по ТЗ v2.0, текущему Astro-проекту и приложенным визуальным референсам. Новые продуктовые решения в него не добавлены.

## Этап A — Baseline и архитектурный фундамент

Статус: **в работе**.

- Зафиксировать текущее состояние Astro-проекта, routes, dependencies, styles и Directus.
- Отделить то, что можно сохранить, от тестовых решений, которые будут заменены.
- Собрать единую Foundation / Design System: tokens, typography, container/grid, spacing, базовые состояния, Header, Footer, Button, Section, SectionHeading.
- Привести BaseLayout к общей SEO/accessibility-базе.
- Не начинать самостоятельные визуальные темы для отдельных страниц.

## Этап B — Графический язык и motion

- Реализовать переиспользуемые PaintStroke, GeometricFigure, DecorativeLine и Reveal.
- Работать с приложенными/утвержденными художественными ассетами; не генерировать новый визуальный язык.
- Ввести controlled variants и `prefers-reduced-motion`.
- Проверить, что декоративные элементы не участвуют в семантической структуре и не ухудшают CLS/LCP.

## Этап C — Контентные страницы

Порядок: **Главная → Therapy → Journal**.

- Главная: Hero, О SKV, принципы, направления, аудитория, контактная форма.
- Therapy: Hero, основа работы, схема, области, методология, подход, форматы, возможности, форма.
- Journal: Hero, о журнале, направления, featured, архив/фильтры, article route, related, финальный CTA.
- На каждом маршруте сразу закрывать responsive, a11y и SEO, а не откладывать их отдельной переделкой.

## Этап D — Data/CMS и формы

- Привести модель Directus Journal к ТЗ: articles/categories, статусы публикации, SEO-поля и asset URLs.
- Определить стратегию fallback для локальной разработки без Directus.
- Реализовать server endpoint формы, клиентскую и серверную валидацию, spam protection, состояния sending/success/error.
- Канал доставки формы остается заблокирован до решения OQ-02.
- Механизм подписки Journal остается заблокирован до решения OQ-03.

## Этап E — Practice

Статус: **заблокирован по ТЗ**.

До утверждения OQ-01 реализуется только вход в направление из общей навигации/карточки. Каталог, цены, checkout, выдача и CMS-модель не проектируются.

## Этап F — QA и Production

- Functional QA, responsive/visual QA, keyboard/focus/reduced-motion.
- Production build, broken assets, console, Directus connectivity, forms.
- Meta/OG/canonical/JSON-LD/sitemap/robots/404.
- Performance: image sizing/optimization, fonts, LCP/CLS, минимизация client JS.
- Production env, domain/HTTPS, analytics и deployment documentation.

## Прогресс 2026-08-17 — проход 2

- Этап A: Foundation собран до уровня, достаточного для начала страниц; окончательная калибровка tokens/типографики будет идти по результатам визуального QA.
- Этап B: добавлены базовые reusable-компоненты `PaintStroke`, `GeometricFigure`, `DecorativeLine`, `Reveal`, включая reduced-motion через общий foundation.
- Этап C: начата Главная. Реализованы Hero, О SKV, Принципы, Направления, Для кого, контактный блок и responsive-композиции.
- Художественные фрагменты для текущего тестового прохода взяты только из предоставленного референса Главной; новые художественные ассеты не генерировались.
- ContactForm сейчас является UI-слоем и намеренно не отправляет данные: endpoint и конечный канал доставки относятся к Этапу D / OQ-02.
- Следующий проход: Therapy, затем визуальное приведение Journal к общей светлой системе.

## Прогресс 2026-08-26 — проход 3

- Этап C / Therapy: реализован полный маршрут `/therapy/` по структуре ТЗ — Hero, основа работы и editorial-схема, области работы, методология, подход, форматы, новые возможности и финальный диалог с формой. Добавлены responsive-композиции и SEO metadata маршрута.
- Этап C / Journal: визуальная система Journal переведена со старой темной/карточной реализации на общий светлый Foundation. Переработаны Hero, «О журнале», направления исследований, featured, архив с фильтрами, финальный контактный блок и статья `/journal/[slug]/` со связанными материалами.
- Этап D / CMS: добавлен безопасный development fallback на локальные fixtures при недоступном Directus. Для CI/production строгий режим включается через `DIRECTUS_STRICT=true`.
- Directus article mapper подготовлен к целевой терминологии ТЗ (`cover`, `published_at`) при сохранении совместимости с текущими полями (`image`, `date`).
- Добавлена страница `404` и базовый `robots.txt` без выдуманного production-domain.
- Practice по-прежнему не реализуется до закрытия OQ-01.
- Формы по-прежнему остаются UI-слоем: канал доставки заблокирован OQ-02.
- Production build в этой итерации не был подтвержден в изолированной среде подготовки патча: `npm ci` требует пакет `zwitch@2.0.4`, отсутствующий в локальном npm-cache. После применения патча требуется выполнить `npm ci`/`npm install` в рабочем окружении и `npm run build`.

## Прогресс 2026-08-26 — проход 4

- Этап D / Journal Data: frontend-контракт статьи расширен SEO-полями (`seo_title`, `seo_description`, `seo_image`), Directus mapper нормализует `cover`, `published_at`, relation `category`, reading time и asset URLs.
- Категории Journal теперь читаются из Directus с локальным fallback, а не только из статического массива.
- Добавлен единый `ArticleCard`, используемый featured/archive/related-блоками; устранено дублирование карточной разметки.
- Страница статьи получила полноценный rich-text rendering для Directus WYSIWYG, related fallback, Article JSON-LD, article Open Graph metadata и SEO fallbacks.
- BaseLayout дополнен absolute canonical/OG URLs и Twitter Card metadata.
- Добавлен prerendered `/sitemap.xml` со статическими маршрутами и опубликованными статьями Journal.
- `SITE`, `DIRECTUS_URL`, `DIRECTUS_STRICT` документированы в `web/.env.example`; Astro `site` теперь читается из окружения.
- Зафиксирована целевая CMS-схема и минимальные Public permissions в `docs/DIRECTUS_SCHEMA.md`.
- OQ-02 и OQ-03 остаются блокерами для реальной отправки форм и подписки; Practice остается заблокирован OQ-01.

## Прогресс 2026-08-26 — проход 5

- Этап F / accessibility: добавлен skip-link и единый `main#main-content` на пользовательских маршрутах; мобильная навигация переведена с `details` на управляемую кнопку с `aria-expanded`, Escape, закрытием после перехода и блокировкой фоновой прокрутки.
- Этап D / формы: `ContactForm` получил реальные состояния validation/sending/success/error, доступные labels, `aria-live`, `aria-busy`, honeypot и JSON transport через `PUBLIC_CONTACT_ENDPOINT`.
- OQ-02 остается открытым: конкретный CRM/email/Telegram transport и server-side endpoint не фиксируются до решения владельца проекта. При пустом endpoint форма не показывает ложный success.
- Этап F / SEO/technical QA: добавлены `/404` и динамический `/robots.txt`, использующий `SITE`; незавершенный `/practice/` помечен `noindex` до закрытия OQ-01.
- Исправлен broken route Footer `/privacy/`: добавлена временная `noindex`-страница. Это не юридическая политика; перед production требуется утвержденный текст.
- Добавлен `docs/QA_STAGE5.md` с ручным acceptance checklist и явным перечнем незакрытых production-блокеров.
- На Главной убран жесткий border-разделитель перед контактным блоком, чтобы лучше соблюдать требование единого бесшовного светлого пространства.

## Прогресс 2026-08-26 — проход 6

- Этап F / performance: hero-графика Главной, Therapy и Journal получила приоритетную загрузку; остальные декоративные изображения остаются lazy.
- Reference images и Journal cards/cover получили intrinsic dimensions для снижения layout shift.
- Google Fonts вынесены из CSS `@import` в `<head>` с preconnect; это уменьшает цепочку блокирующих запросов. Self-host не выполнялся, потому что font assets не входят в исходные материалы.
- Добавлен `theme-color` и progressive `content-visibility` для нижеэкранных секций.
- Этап F / keyboard QA: мобильное меню дополнено focus containment при Tab/Shift+Tab и возвратом фокуса по Escape.
- Добавлен `docs/QA_STAGE6.md` с ручными проверками LCP/CLS и keyboard navigation.
- Production build по-прежнему должен быть подтверждён в рабочем окружении пользователя, где установлен полный `node_modules`.

## Прогресс 2026-08-26 — проход 7

- Этап D / формы: клиентская и будущая серверная валидация унифицированы в `src/lib/contact/validation.ts`; добавлены нормализация payload, honeypot, защита от мгновенной bot-submit и поддержка field errors от будущего API.
- Runtime `POST /api/contact` намеренно не добавлялся без выбранного Astro server adapter: текущий сайт остаётся статическим, а корректная серверная реализация зависит от production hosting и решения OQ-02.
- Этап D / Journal: `featured` теперь является только признаком блока «Актуальные материалы» и не исключает публикацию из общего Архива; это сохраняет полный опубликованный каталог.
- CMS-запросы articles/categories мемоизируются во время production static build, чтобы несколько компонентов и article routes не повторяли одинаковые запросы к Directus. В `astro dev` memoization отключена.
- Этап F / SEO robustness: добавлена безопасная обработка дат; некорректные значения не формируют `Invalid Date`, `article:published_time`, JSON-LD date или sitemap `lastmod`.
- Добавлены `docs/PRODUCTION_READINESS.md` и `docs/QA_STAGE7.md`, где явно зафиксированы deployment/runtime блокеры и последовательность production acceptance.

## Прогресс 2026-08-26 — проход 8

- Этап F / progressive enhancement: reveal-анимации больше не делают контент невидимым без JavaScript; mobile navigation получила no-JS fallback; Archive без JS остаётся полной читаемой библиотекой.
- Этап F / interaction QA: mobile menu закрывается по pointer-down вне Header и корректно реагирует на переход desktop/mobile через `matchMedia`; ArticleCard получил полноценное focus-visible состояние.
- Этап F / SEO: Главная, Therapy и Journal получили собственные OG images и preload hero LCP-кандидатов. Главная получила минимальный `Organization`/`WebSite` JSON-LD без неподтверждённых данных.
- Этап F / accessibility: skip-link target на основных завершённых маршрутах сделан программно фокусируемым; фильтры Journal получили семантическую группу.
- OQ-01 Practice, OQ-02 delivery заявок и OQ-03 подписка по решению владельца проекта отложены и больше не считаются блокерами текущей frontend-доработки.
- Наполнение и окончательная Directus-настройка также отложены до завершения frontend/QA.
