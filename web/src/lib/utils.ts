export function isValidDate(value?: string): boolean {
  if (!value) return false;
  return !Number.isNaN(new Date(value).getTime());
}

export function formatDate(date: string): string {
  if (!isValidDate(date)) return "";

  return new Intl.DateTimeFormat("ru-RU", {
    day: "2-digit",
    month: "long",
    year: "numeric"
  }).format(new Date(date));
}

export function toIsoDate(value?: string): string | undefined {
  if (!isValidDate(value)) return undefined;
  return new Date(value as string).toISOString();
}

export function calculateReadingTime(text: string): number {
  const words = text
    .trim()
    .split(/\s+/)
    .filter(Boolean).length;

  return Math.max(1, Math.ceil(words / 200));
}

export function truncate(text: string, length = 180): string {
  if (text.length <= length) return text;
  return `${text.slice(0, length).trimEnd()}…`;
}

export function joinTags(tags?: { title: string }[]): string {
  if (!tags?.length) return "";
  return tags.map(tag => tag.title).join(", ");
}
