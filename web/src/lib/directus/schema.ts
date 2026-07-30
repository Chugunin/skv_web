import type {Direction} from "@/models/direction";
import type {Article} from "@/models/article";
import type {Category} from "@/models/category";
import type {Tag} from "@/models/tag";

export interface DirectusSchema {

    directions: Direction[];

    articles: Article[];

    categories: Category[];

    tags: Tag[];

}