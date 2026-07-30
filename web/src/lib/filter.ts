import type {Article} from "@/models/article.ts";

export function filterByCategory(

    articles: Article[],

    slug: string

): Article[] {

    return articles.filter(

        article => article.category?.slug === slug

    );

}

export function filterByTag(

    articles: Article[],

    slug: string

): Article[] {

    return articles.filter(

        article =>

            article.tags?.some(

                tag => tag.slug === slug

            )

    );

}