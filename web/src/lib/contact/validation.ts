export type ContactSource = "home" | "therapy" | "header" | "fab";

export interface ContactPayload {
  name: string;
  contact: string;
  message: string;
  source: ContactSource;
  website?: string;
  startedAt?: number;
}

export interface ContactValidationResult {
  valid: boolean;
  payload: ContactPayload;
  errors: Partial<Record<"name" | "contact" | "message", string>>;
  spam: boolean;
}

function clean(value: unknown, max: number): string {
  return String(value ?? "").trim().replace(/\s+/g, " ").slice(0, max);
}

function cleanMessage(value: unknown): string {
  return String(value ?? "").trim().replace(/\r\n?/g, "\n").slice(0, 3000);
}

function normalizeSource(value: unknown): ContactSource {
  return value === "therapy" || value === "header" || value === "fab" ? value : "home";
}

export function normalizeContactPayload(input: Record<string, unknown>): ContactPayload {
  const startedAtValue = Number(input.startedAt);

  return {
    name: clean(input.name, 100),
    contact: clean(input.contact, 120),
    message: cleanMessage(input.message),
    source: normalizeSource(input.source),
    website: clean(input.website, 200),
    startedAt: Number.isFinite(startedAtValue) && startedAtValue > 0 ? startedAtValue : undefined
  };
}

export function validateContactPayload(input: Record<string, unknown>): ContactValidationResult {
  const payload = normalizeContactPayload(input);
  const errors: ContactValidationResult["errors"] = {};

  if (payload.name.length < 2) errors.name = "Укажите имя (минимум 2 символа).";
  if (payload.contact.length < 3) errors.contact = "Укажите контакт для обратной связи.";
  if (payload.message.length < 10) errors.message = "Опишите запрос минимум в 10 символах.";

  const submittedTooFast = payload.startedAt ? Date.now() - payload.startedAt < 1500 : false;
  const spam = Boolean(payload.website) || submittedTooFast;

  return {
    valid: Object.keys(errors).length === 0 && !spam,
    payload,
    errors,
    spam
  };
}
