import type { Category } from "@/models/category";

export const categories: Category[] = [
  { id: "perception", slug: "perception", title: "Восприятие", description: "Как человек воспринимает себя и окружающий мир." },
  { id: "thinking", slug: "thinking", title: "Мышление", description: "Убеждения, установки и когнитивные процессы." },
  { id: "emotions", slug: "emotions", title: "Эмоции", description: "Внутренние состояния и способы реагирования." },
  { id: "relationships", slug: "relationships", title: "Отношения", description: "Близость, границы и взаимодействие с людьми." },
  { id: "personality", slug: "personality", title: "Личность", description: "Особенности поведения и внутренних стратегий." },
  { id: "quality-of-life", slug: "quality-of-life", title: "Качество жизни", description: "Осознанность, выборы и устойчивость." }
];
