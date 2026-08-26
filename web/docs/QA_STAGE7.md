# SKV — QA Stage 7

## Data / Journal

- [x] Featured-статья не исчезает из общего архива.
- [x] Повторные обращения к articles/categories во время production static build мемоизируются.
- [x] В `astro dev` CMS-запросы не кэшируются модулем и изменения контента видны без рестарта.
- [x] Некорректная дата не приводит к `Invalid Date` в ArticleMeta.
- [x] JSON-LD и `article:published_time` добавляют дату только при валидном значении.

## Forms foundation

- [x] Клиентская форма использует единый нормализатор/валидатор, пригодный и для будущего server endpoint.
- [x] Honeypot сохраняется.
- [x] Добавлена простая проверка слишком быстрой автоматической отправки.
- [x] API может вернуть field errors в JSON, и frontend покажет их рядом с нужными полями.
- [ ] Server-side validation — после выбора runtime adapter.
- [ ] Rate limiting — после выбора runtime adapter.
- [ ] Реальный transport — после OQ-02.

## Production blockers

- [ ] Подтвердить `npm run build` в рабочем окружении.
- [ ] Выбрать production hosting / Astro adapter для runtime формы.
- [ ] Зафиксировать точную версию Directus image.
- [ ] Закрыть OQ-01 Practice.
- [ ] Закрыть OQ-02 forms transport.
- [ ] Закрыть OQ-03 Journal subscription.
- [ ] Утвердить юридический текст `/privacy/`.
