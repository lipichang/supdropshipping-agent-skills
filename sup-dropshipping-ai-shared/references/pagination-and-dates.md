# Pagination And Dates

## Dates

- Send dates as `YYYY-MM-DD`.
- The API expands `start_date` to the start of that day and `end_date` to the end of that day.
- Either side may be sent alone.
- An invalid date, or a start later than the end, returns HTTP `422` with `code=invalid_date`.
- Timestamps in responses are `YYYY-MM-DD HH:MM:SS` in the SUP server time zone (Asia/Shanghai, UTC+8).

Each list endpoint documents which timestamp its `start_date` / `end_date` filter applies to. Orders also support `paid_start_date` / `paid_end_date`.

## Pagination

- Default: `page=1`, `per_page=50`
- Maximum `per_page`: `100`
- List responses have this shape:

```json
{
  "page": 1,
  "per_page": 50,
  "total_count": 137,
  "data": []
}
```

- `total_count` is the number of rows matching the filters, across all pages.
- `GET /api/ai/v1/stores` is not paginated; it returns `total_count` and `data` only.

## Page Collection Rule

1. Start from `page=1`.
2. Keep incrementing `page`.
3. Stop when the returned `data` array is shorter than `per_page`, when `page * per_page >= total_count`, or when enough rows were collected for the task.

Before collecting many pages, check `total_count` and tell the user if the result set is large. Narrow it with filters when possible.
