import type { Article } from "@/models/article";
import { categories } from "./categories";
const category=(slug:string)=>categories.find(c=>c.slug===slug)!;
const base=[
  ["anxiety-signal-or-habit","Тревога: сигнал или привычка","Когда тревога помогает адаптироваться, а когда становится автоматическим способом реагирования.","emotions","2026-07-16","/assets/reference/journal-archive-1.webp"],
  ["identity-and-agency","Идентичность и чувство собственной ценности","Как формируется устойчивое представление о себе и почему оно меняется в разные периоды жизни.","personality","2026-07-12","/assets/reference/journal-archive-2.webp"],
  ["event-perception","Как формируется наше восприятие события","Почему одно и то же событие может вызывать разные реакции у разных людей.","perception","2026-07-08","/assets/reference/journal-archive-3.webp"],
  ["conscious-choice","Осознанный выбор каждый день: маленькие решения — большие изменения","Как повседневные решения формируют долгосрочное качество жизни.","quality-of-life","2026-07-04","/assets/reference/journal-archive-4.webp"],
  ["thought-patterns","Повторяющиеся мысли и внутренние сценарии","Как распознавать устойчивые мыслительные шаблоны и отделять их от текущей ситуации.","thinking","2026-06-28","/assets/reference/journal-feature-2.webp"],
  ["dialogue-in-relationships","Диалог в отношениях: слышать и быть услышанным","Что влияет на качество коммуникации и почему содержание разговора — только часть взаимодействия.","relationships","2026-06-21","/assets/reference/journal-feature-3.webp"]
] as const;
export const archiveArticles: Article[]=base.map((item,i)=>({
  id:`archive-${i+1}`, slug:item[0], title:item[1], description:item[2], content:item[2], category:category(item[3]), date:item[4], image:item[5], author:"SKV", readingTime:5, featured:false
}));
