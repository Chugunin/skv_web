# Directus — целевая модель SKV Journal

Документ фиксирует CMS-модель из ТЗ v2.0 и frontend-контракт текущего этапа.

## `categories`

| Поле | Тип Directus | Обязательно | Примечание |
|---|---|---:|---|
| `id` | UUID / integer | да | системный PK |
| `slug` | string | да | unique, URL-safe |
| `title` | string | да | название категории |
| `description` | text | нет | краткое описание |

## `articles`

| Поле | Тип Directus | Обязательно | Примечание |
|---|---|---:|---|
| `id` | UUID / integer | да | системный PK |
| `status` | string | да | публикуются записи со значением `published` |
| `slug` | string | да | unique, URL-safe |
| `title` | string | да | заголовок |
| `description` | text | да | lead / карточка / fallback SEO description |
| `content` | WYSIWYG / text | нет | основное тело статьи; frontend поддерживает HTML Directus |
| `cover` | file | нет | обложка |
| `published_at` | datetime | да | дата публикации и сортировка |
| `category` | M2O → categories | нет | категория статьи |
| `featured` | boolean | нет | вывод в «Актуальных материалах» |
| `reading_time` | integer | нет | если пусто, frontend рассчитывает автоматически |
| `author` | string | нет | fallback: `SKV` |
| `seo_title` | string | нет | fallback: title + SKV Journal |
| `seo_description` | text | нет | fallback: description |
| `seo_image` | file | нет | fallback: cover |

## Permissions для публичного сайта

Для Public role достаточно read-доступа:

- `articles`: только записи `status = published`;
- `categories`: read;
- `directus_files`: read только для файлов, используемых публичным контентом.

Create/update/delete для Public role не требуются.

## Frontend fallback

В development при недоступном Directus используются локальные fixtures.

```env
DIRECTUS_STRICT=false
```

Для production/CI необходимо:

```env
DIRECTUS_STRICT=true
```

Тогда недоступность CMS останавливает сборку вместо публикации demo-контента.

## Важное замечание по `content`

`content` из Directus WYSIWYG выводится как доверенный HTML редакционного CMS. Поэтому права редактирования `articles.content` должны предоставляться только доверенным администраторам/редакторам Directus.
