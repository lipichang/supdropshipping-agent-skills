# Sourcing Requests List Endpoint

## Endpoint

```text
GET /api/ai/v1/sourcing-requests
```

## Safe Request Example

```sh
sh ./scripts/ai_api_request.sh request /api/ai/v1/sourcing-requests --param page=1 --param per_page=50 --param status=pending
```

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ai_api_request.ps1 request /api/ai/v1/sourcing-requests --param page=1 --param per_page=50 --param status=pending
```

## Supported Query Parameters

- `status`: one value or several separated by commas
- `keyword`: part of the product title or of the request number
- `start_date`, `end_date`: filter on `created_at`
- `page`, `per_page`

## Accepted Values

`status`:

- `pending`: waiting for SUP
- `success`: SUP found the product and replied
- `failed`: SUP could not source it
- `closed`

An unknown value returns `422` with `code=invalid_status`.

## Response Shape

```json
{
  "page": 1,
  "per_page": 50,
  "total_count": 1,
  "data": [
    {
      "id": 2201,
      "request_number": "S2026110100009",
      "title": "Portable Blender 380ml",
      "source_url": "https://example.com/item/123",
      "description": "Need custom logo, 500 pcs per month",
      "image": "https://...",
      "store_name": "My Store",
      "status": "success",
      "status_code": 2,
      "reply": "Unit price ... ",
      "created_at": "2026-11-01 08:30:00",
      "updated_at": "2026-11-02 16:45:10"
    }
  ]
}
```

## Field Semantics

- `request_number`: the sourcing request number shown in the website
- `source_url`: the reference link the user submitted, when there is one
- `description`: the user's own notes
- `store_name`: the store the request was made for, when set
- `reply`: SUP's reply text; `null` until SUP answers
- `updated_at`: last change, normally the time of SUP's reply

## Notes

- Rows are sorted newest first.
- `reply` can be long and may contain HTML. Summarize it and keep prices and quantities exactly as written.
