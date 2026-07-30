import { archiveArticles } from "@data/archive";
import { featuredPosts } from "@data/featured";
import { paginate } from "@lib/pagination";
import { filterByCategory, filterByTag } from "@lib/filter";
import { searchArticles } from "@lib/search";
import type {Article} from "@/models/article.ts";

const articles: Article[] = [
    ...featuredPosts,
    ...archiveArticles
];

export async function getArticles(): Promise<Article[]> {

    return articles;

}

export async function getArchive(): Promise<Article[]> {

    return archiveArticles;

}

export async function getFeaturedPosts(): Promise<Article[]> {

    return featuredPosts;

}

export async function getArticleBySlug(
    slug: string
): Promise<Article | undefined> {

    return articles.find(
        article => article.slug === slug
    );

}

export async function search(query: string) {

    return searchArticles(
        articles,
        query
    );

}

export async function getByCategory(
    slug: string
) {

    return filterByCategory(
        articles,
        slug
    );

}

export async function getByTag(
    slug: string
) {

    return filterByTag(
        articles,
        slug
    );

}

export async function getArchivePage(
    page: number,
    pageSize: number
) {

    return paginate(
        archiveArticles,
        page,
        pageSize
    );

}