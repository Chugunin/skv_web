# Stage 9 — Final frontend audit / bugfix

## Исправлено суммарным патчем

- [x] Исправлен broken import Therapy: `MethodAndApproach.astro` → существующий `MethodApproach.astro`.
- [x] `vite`, импортируемый напрямую в `astro.config.mjs`, добавлен как direct dev dependency; обновлён `package-lock.json`.
- [x] Устранён конфликт двух реализаций `/robots.txt`: оставить динамический `src/pages/robots.txt.ts`, удалить `public/robots.txt`.
- [x] Journal Archive формирует категории из фактически загруженных статей, поэтому CMS-данные и fallback fixtures не смешивают лишние категории.
- [x] DOM-поиск фильтров Journal Archive ограничен собственным `[data-archive]`, без глобального поиска по документу.
- [x] Исправлен horizontal overflow длинного заголовка Privacy на мобильных экранах.
- [x] Progressive enhancement декоративных компонентов: `PaintStroke`, `DecorativeLine` и `GeometricFigure` больше не остаются скрытыми без JavaScript. Начальное состояние анимации применяется только при `html.js`.
- [x] `prefers-reduced-motion` для геометрических фигур оставляет линии видимыми без анимации.
- [x] Mobile menu focus trap включает кнопку открытия/закрытия меню; `Tab`/`Shift+Tab` остаются внутри открытого меню.
- [x] Дата статьи в `ArticleMeta` использует семантический `<time datetime="...">`.
- [x] Cover article page передаётся в `BaseLayout` как preload image для LCP-кандидата.
- [x] Исправлен TypeScript alias `@models/*`: `src/types/*` → `src/models/*`.

## Проверки, выполненные в исходных Stage 9 аудитах

- [x] Кодексом подтверждена успешная static build: собрано 15 страниц.
- [x] Кодексом проверены маршруты `/`, `/therapy/`, `/journal/`, article page, `/practice/`, `/privacy/`, `/404`.
- [x] Кодексом проверены контрольные ширины 375, 430, 768, 1024, 1440 и 1920 px.
- [x] Кодексом проверено отсутствие broken images и горизонтального overflow на основных маршрутах.
- [x] Кодексом проверены mobile menu, Escape и Journal category filters.
- [x] Кодексом подтверждено создание динамических `/robots.txt` и `/sitemap.xml` при build.
- [x] В отдельном статическом аудите проверены ссылки на `/assets/...`: отсутствующих файлов не найдено.
- [x] Фиктивные `href="#"` не обнаружены.

## Ограничения и повторная проверка после слияния

Суммарный патч объединяет два независимых Stage 9 набора изменений. Несмотря на успешный build одного из исходных патчей, после применения именно объединённой версии необходимо повторно выполнить штатную сборку на целевой машине:

```powershell
cd .\web
npm install
npm run build
```

После сборки проверить:

1. `/`, `/therapy/`, `/journal/` с JavaScript и без JavaScript.
2. `/journal/`: все category filters и empty state.
3. Любую `/journal/[slug]/`: cover, related articles, metadata.
4. `/privacy/` на 375 px.
5. Mobile menu: `Tab`, `Shift+Tab`, `Escape`, click outside.
6. Декоративные мазки, линии и геометрические фигуры без JavaScript и при `prefers-reduced-motion`.
7. `/robots.txt` — должна присутствовать строка `Sitemap:`.
8. `/sitemap.xml`.
9. Отсутствие console errors и горизонтального overflow на контрольных ширинах.

## Отложено по решению владельца

- SKV Practice;
- transport контактных форм;
- Journal subscription;
- финальное наполнение и настройка Directus;
- production domain и self-hosted fonts;
- окончательный юридический текст Privacy.
