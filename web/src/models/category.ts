import type { BaseEntity } from "./base";

export interface Category extends BaseEntity {

    slug: string;

    title: string;

    description?: string;

}