export function formatDate(date: string): string {

    return new Intl.DateTimeFormat("ru-RU", {

        day: "2-digit",

        month: "long",

        year: "numeric"

    }).format(new Date(date));

}

export function calculateReadingTime(text: string): number {

    const words = text
        .trim()
        .split(/\s+/)
        .filter(Boolean).length;

    return Math.max(1, Math.ceil(words / 200));

}

export function truncate(
    text: string,
    length = 180
): string {

    if (text.length <= length) {

        return text;

    }

    return `${text.slice(0, length).trimEnd()}…`;

}