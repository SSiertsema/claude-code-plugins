# API Reference

<!--
TEMPLATE INSTRUCTIONS:
Document all API endpoints, their parameters, and responses.
Investigate: route files, controllers, API handlers, OpenAPI/Swagger specs.
-->

## Base URL

<!--
Specify the base URL for API requests.
Include different environments if applicable (dev, staging, production).
-->

| Environment | Base URL |
|-------------|----------|
| Development | `http://localhost:PORT` |
| Production | |

## Authentication

<!--
Describe how API authentication works.
Include: auth method (Bearer token, API key, OAuth), how to obtain credentials.
-->

### Method

### Headers Required

```
Authorization: Bearer <token>
```

### Obtaining Credentials

## Endpoints

<!--
For each endpoint, document:
- HTTP method and path
- Description
- Request parameters (path, query, body)
- Response format
- Example request/response
- Error codes
-->

### Resource Name

#### GET /resource

**Description:**

**Parameters:**

| Name | Type | In | Required | Description |
|------|------|-----|----------|-------------|
| | | query | | |

**Response:**

```json
{
  "status": "success",
  "data": {}
}
```

**Example:**

```bash
curl -X GET "http://localhost:3000/api/resource" \
  -H "Authorization: Bearer <token>"
```

#### POST /resource

**Description:**

**Request Body:**

```json
{
  "field": "value"
}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": "123"
  }
}
```

## Error Handling

<!--
Document common error responses and their meanings.
-->

### Error Response Format

```json
{
  "status": "error",
  "code": "ERROR_CODE",
  "message": "Human readable message"
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `UNAUTHORIZED` | 401 | Invalid or missing authentication |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `NOT_FOUND` | 404 | Resource not found |
| `VALIDATION_ERROR` | 400 | Invalid request parameters |
| `INTERNAL_ERROR` | 500 | Server error |

## Rate Limiting

<!--
Document rate limiting if applicable.
Include: limits, headers returned, how to handle 429 responses.
-->

## Versioning

<!--
Explain API versioning strategy if applicable.
Include: how version is specified, supported versions, deprecation policy.
-->
