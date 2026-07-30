import { archiveArticles } from "@data/archive";
import { directions } from "@data/directions";
import { featuredPosts } from "@data/featured";
import type {Article} from "@/models/article.ts";
import type {Direction} from "@/models/direction.ts";

export async function getDirections(): Promise<Direction[]> {

    return directions;

}

export async function getFeaturedPosts(): Promise<Article[]> {

    return featuredPosts;

}

export async function getArchive(): Promise<Article[]> {

    return archiveArticles;

}

export async function getArticleBySlug(
    slug: string
): Promise<Article | undefined> {

    return [...featuredPosts, ...archiveArticles]
        .find(article => article.slug === slug);

}