import type {BaseEntity} from "@/models/base.ts";
import type { Category } from "./category";
import type { Tag } from "./tag";

export interface Article extends BaseEntity {

    slug: string;

    title: string;

    description: string;

    content?: string;

    image: string;

    date: string;

    author?: string;

    readingTime?: number;

    category?: Category;

    tags?: Tag[];

    featured?: boolean;

}