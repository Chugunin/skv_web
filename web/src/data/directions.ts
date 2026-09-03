import type { Direction } from "@/models/direction";

export const directions: Direction[] = [
  { id: "1", title: "Восприятие", description: "Как мы видим себя и мир вокруг", icon: "◉", sortOrder: 1 },
  { id: "2", title: "Мышление", description: "Убеждения, установки и когнитивные процессы", icon: "⌁", sortOrder: 2 },
  { id: "3", title: "Эмоции", description: "Внутренние состояния и способы реагирования", icon: "♡", sortOrder: 3 },
  { id: "4", title: "Отношения", description: "Близость, границы и взаимодействие", icon: "♧", sortOrder: 4 },
  { id: "5", title: "Личность", description: "Особенности поведения и внутренние стратегии", icon: "♙", sortOrder: 5 },
  { id: "6", title: "Качество жизни", description: "Осознанность, выборы и устойчивость", icon: "✦", sortOrder: 6 }
];
