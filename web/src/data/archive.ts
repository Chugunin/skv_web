export interface ArchiveArticle {

    title:string;

    description:string;

    image:string;

    date:string;

}

export const archiveArticles = Array.from(

    {length:10},

    (_,i)=>({

        title:`Статья ${i+1}`,

        description:"Краткое описание статьи",

        image:`https://picsum.photos/700/500?${i}`,

        date:"03.07.2026"

    })

);