import type { BaseEntity } from "./base";

export interface Direction extends BaseEntity {
  title: string;
  description: string;
  icon?: string;
  image?: string;
  sortOrder?: number;
}
