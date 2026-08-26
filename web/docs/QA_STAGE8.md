# SKV — QA Stage 8

## Progressive enhancement

- [x] Reveal-контент больше не скрывается при отключённом JavaScript.
- [x] Mobile navigation имеет no-JS fallback вместо недоступной кнопки меню.
- [x] Journal Archive без JavaScript показывает полный список материалов, а JS-фильтры скрываются.
- [x] Недоступные Telegram/Email действия подписки больше не являются фиктивными ссылками `href="#"`.

## SEO / social preview

- [x] Главная, Therapy и Journal получили page-specific Open Graph images.
- [x] Hero image этих маршрутов preload-ится как LCP-кандидат.
- [x] Главная получила базовый `Organization` + `WebSite` JSON-LD без выдуманных контактов и социальных профилей.
- [x] `noindex` больше не сопровождается `nofollow`; ссылки на технических страницах остаются crawlable.

## Accessibility / interaction

- [x] Основные `main#main-content` сделаны программно фокусируемыми для skip-link.
- [x] Mobile menu закрывается при клике/тапе вне Header.
- [x] Media-query transition desktop/mobile закрывает открытое mobile menu без постоянного resize handler.
- [x] Journal category filters объединены в семантическую группу с `aria-label`.
- [x] ArticleCard имеет явное keyboard focus state, совпадающее по выразительности с hover.

## Ручная проверка после применения

1. Отключить JavaScript в DevTools и открыть `/`, `/therapy/`, `/journal/`: контент не должен исчезать.
2. На ширине < 900 px без JavaScript должна быть доступна навигация.
3. `/journal/` без JavaScript должен показывать весь архив без неработающих filter controls.
4. С JavaScript проверить фильтры архива и mobile menu.
5. Проверить `View Source`/DevTools Head: OG image на `/`, `/therapy/`, `/journal/`.
6. Проверить Tab/Shift+Tab и skip-link.
7. Выполнить `npm run build` в рабочем окружении.

## Не закрыто и не относится к Stage 8

- реальный visual QA в браузерах desktop/tablet/mobile;
- подтверждённый production build в рабочем окружении;
- self-host font assets;
- финальный юридический текст `/privacy/`;
- production domain/HTTPS/deployment;
- отложенные владельцем проекта: Practice, доставка заявок, Journal subscription;
- фактическое наполнение и финальная настройка Directus выполняются после готовности текущего frontend.
