import type {Article} from "@/models/article.ts";

export function mapArticle(article: any): Article {

    return {

        ...article,

        featured: article.featured ?? false,

        tags: article.tags ?? [],

        category: article.category ?? undefined

    };

}