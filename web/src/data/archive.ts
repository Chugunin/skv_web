import type { Article } from "@/models/article";

import { categories } from "./categories";
import { tags } from "./tags";

const researchCategory = categories.find(
    c => c.slug === "research"
)!;

const journalTag = tags.find(
    t => t.slug === "journal"
)!;

export const archiveArticles: Article[] = Array.from(
    { length: 10 },
    (_, i) => ({
            id: String(i + 1),

            slug: `article-${i + 1}`,

            title: `Статья ${i + 1}`,

            description: "Краткое описание статьи.",

            content: "",

            image: `https://picsum.photos/700/500?${i}`,

            date: "2026-07-03",

            author: "SKV",

            readingTime: 5,

            category: researchCategory,

            tags: [journalTag],

            featured: false
    })
);