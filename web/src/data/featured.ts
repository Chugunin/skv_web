import type { Article } from "@/models/article";

import { categories } from "./categories";
import { tags } from "./tags";

const featuredCategory = categories.find(
    c => c.slug === "featured"
)!;

const featuredTag = tags.find(
    t => t.slug === "featured"
)!;

export const featuredPosts: Article[] = [

    {
        id: "featured-1",

        slug: "a-september-market",

        title: "A September Market",

        description: "Description",

        content: "",

        image: "https://picsum.photos/900/600?11",

        date: "2026-07-03",

        author: "SKV",

        readingTime: 4,

        category: featuredCategory,

        tags: [featuredTag],

        featured: true
    },

    {
        id: "featured-2",

        slug: "literary-market",

        title: "Literary Market",

        description: "Description",

        content: "",

        image: "https://picsum.photos/900/600?12",

        date: "2026-07-03",

        author: "SKV",

        readingTime: 6,

        category: featuredCategory,

        tags: [featuredTag],

        featured: true
    },

    {
        id: "featured-3",

        slug: "kids-sports",

        title: "Kids Sports",

        description: "Description",

        content: "",

        image: "https://picsum.photos/900/600?13",

        date: "2026-07-03",

        author: "SKV",

        readingTime: 3,

        category: featuredCategory,

        tags: [featuredTag],

        featured: true
    }

];