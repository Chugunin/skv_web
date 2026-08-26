import type { Article } from "@/models/article";
import { categories } from "./categories";

const category = (slug:string) => categories.find(c => c.slug === slug)!;

export const featuredPosts: Article[] = [
  {
    id: "featured-1", slug: "attention-and-quality-of-life",
    title: "Искусство замедления: как внимание меняет качество жизни",
    description: "Почему способность замечать происходящее влияет на решения, состояние и субъективное качество жизни.",
    content: "Внимание — не только когнитивная функция, но и способ взаимодействия с собственной жизнью. В этом материале рассматривается, как автоматические реакции сменяются более точным наблюдением и почему это меняет качество принимаемых решений.",
    image: "/assets/reference/journal-feature-1.webp", date: "2026-07-28", author: "SKV", readingTime: 6,
    category: category("perception"), featured: true
  },
  {
    id: "featured-2", slug: "beliefs-and-reality",
    title: "Убеждения, которые незаметно управляют нашей реальностью",
    description: "Как устойчивые интерпретации превращаются в фильтры восприятия и влияют на поведение.",
    content: "Убеждения помогают быстро ориентироваться в мире, но одновременно могут ограничивать диапазон интерпретаций. Статья посвящена тому, как распознавать такие фильтры и отделять факт от привычного способа объяснять происходящее.",
    image: "/assets/reference/journal-feature-2.webp", date: "2026-07-24", author: "SKV", readingTime: 7,
    category: category("thinking"), featured: true
  },
  {
    id: "featured-3", slug: "closeness-and-boundaries",
    title: "Близость и границы: поиск баланса в современных отношениях",
    description: "Почему границы не противоположны близости и как они поддерживают устойчивый контакт.",
    content: "Здоровые границы не создают дистанцию автоматически. Они делают контакт более определенным и позволяют людям оставаться в отношениях без постоянного отказа от собственных потребностей.",
    image: "/assets/reference/journal-feature-3.webp", date: "2026-07-20", author: "SKV", readingTime: 5,
    category: category("relationships"), featured: true
  }
];
