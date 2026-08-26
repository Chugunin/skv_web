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
