# Stage 6 — Performance / LCP / keyboard QA

## Реализовано

- hero-изображения Главной, Therapy и Journal загружаются `eager` + `fetchpriority="high"`;
- всем локальным reference-изображениям, проходящим через `PaintStroke`, заданы intrinsic `width/height`, чтобы снизить CLS;
- карточкам и cover статьи заданы intrinsic dimensions;
- Google Fonts перенесены из CSS `@import` в `<head>` с `preconnect`, что убирает лишний блокирующий CSS-hop;
- добавлен `theme-color`;
- mobile menu удерживает keyboard focus внутри открытого меню и возвращает focus на toggle по Escape;
- для нижеэкранных секций включён progressive `content-visibility: auto` с intrinsic fallback;
- reduced-motion логика сохранена без изменения.

## Что проверить вручную

1. DevTools → Network: hero reference image должен стартовать сразу, остальные декоративные изображения — lazy.
2. Lighthouse desktop/mobile: сравнить LCP и CLS с Stage 5.
3. На mobile открыть menu и пройти Tab/Shift+Tab — focus не должен уходить за пределы меню.
4. Escape должен закрывать меню и возвращать focus на кнопку.
5. Проверить Safari/iOS: layout не должен менять геометрию при `content-visibility` (браузеры без поддержки просто игнорируют правило).
6. Проверить внешний доступ к Google Fonts в production-сети. Self-host шрифтов остаётся предпочтительным production-вариантом, но файлы шрифтов отсутствуют в исходных материалах и поэтому в патч не добавлялись.

## Не закрыто

- реальный Lighthouse/axe прогон требует запуска проекта в браузере;
- self-host Cormorant/Manrope не реализован без утверждённых font assets;
- OQ-02 (канал форм), OQ-03 (Journal subscription), OQ-01 (Practice) остаются открытыми;
- финальный production domain/HTTPS/analytics зависят от production-окружения.
