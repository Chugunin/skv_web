import {

    archiveArticles

} from "../data/archive";

import {

    directions

} from "../data/directions";

import {

    featuredPosts

} from "../data/featured";

export async function getDirections() {

    return directions;

}

export async function getFeaturedPosts() {

    return featuredPosts;

}

export async function getArchive() {

    return archiveArticles;

}