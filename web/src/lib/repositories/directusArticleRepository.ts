import { readItems } from "@directus/sdk";
import { directus } from "@lib/directus/client";
import type {Article} from "@/models/article.ts";
import {mapArticle} from "@lib/directus/mappers/articleMapper.ts";


export async function getArticles(): Promise<Article[]> {

    const data = await directus.request(
        readItems("articles")
    );

    return data.map(mapArticle);

}

export async function getFeaturedPosts(): Promise<Article[]> {

    const articles = await getArticles();

    return articles.filter(

        article => article.featured

    );

}

export async function getArchive(): Promise<Article[]> {

    const articles = await getArticles();

    return articles.filter(

        article => !article.featured

    );

}

export async function getArticleBySlug(

    slug:string

):Promise<Article|undefined>{

    const articles=await getArticles();

    return articles.find(

        article=>article.slug===slug

    );

}