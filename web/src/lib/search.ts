import type {Article} from "@/models/article.ts";


export function searchArticles(

    articles: Article[],

    query: string

): Article[] {

    const value = query
        .trim()
        .toLowerCase();

    if (!value) {

        return articles;

    }

    return articles.filter(article =>

        article.title
            .toLowerCase()
            .includes(value)

        ||

        article.description
            .toLowerCase()
            .includes(value)

    );

}