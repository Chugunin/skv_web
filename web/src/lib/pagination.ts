export interface PaginationResult<T> {

    items: T[];

    page: number;

    pageSize: number;

    total: number;

    totalPages: number;

}

export function paginate<T>(
    items: T[],
    page: number,
    pageSize: number
): PaginationResult<T> {

    const total = items.length;

    const totalPages = Math.max(
        1,
        Math.ceil(total / pageSize)
    );

    const start = (page - 1) * pageSize;

    return {

        items: items.slice(start, start + pageSize),

        page,

        pageSize,

        total,

        totalPages

    };

}