export class Logger {

    static info(...args: unknown[]) {

        console.info("[SKV]", ...args);

    }

    static warn(...args: unknown[]) {

        console.warn("[SKV]", ...args);

    }

    static error(...args: unknown[]) {

        console.error("[SKV]", ...args);

    }

}