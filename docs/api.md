# asheeighe API Documentation

## Base URL

| Environment | URL |
|-------------|-----|
| Production | `https://api.asheeighe.app/v1` |
| Staging | `https://staging-api.asheeighe.app/v1` |
| Local | `http://localhost:8787` |

## Authentication

All authenticated endpoints require a JWT access token in the `Authorization` header:

```
Authorization: Bearer <access_token>
```

### Token Flow

1. `POST /auth/register` or `POST /auth/login` returns `{ accessToken, refreshToken, expiresIn }`
2. Access tokens expire in **15 minutes** (`expiresIn: 900`)
3. Refresh tokens expire in **7 days**
4. Use `POST /auth/refresh` with `{ refreshToken }` to get a new access token

## Rate Limiting

- **100 requests per minute** per IP (authenticated)
- **20 requests per minute** per IP (unauthenticated)
- Rate limit headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`
- On rate limit exceeded: HTTP `429` with `{ error: "RATE_LIMIT", message: "..." }`

## Error Response Format

```json
{
  "success": false,
  "error": "ERROR_CODE",
  "message": "Human-readable description",
  "details": {}
}
```

### Standard Error Codes

| HTTP Status | Code | Description |
|-------------|------|-------------|
| 400 | `VALIDATION_ERROR` | Invalid request body |
| 401 | `AUTH_ERROR` | Missing or invalid token |
| 403 | `FORBIDDEN` | Insufficient permissions |
| 404 | `NOT_FOUND` | Resource not found |
| 409 | `CONFLICT` | Resource already exists |
| 429 | `RATE_LIMIT` | Too many requests |
| 500 | `INTERNAL_ERROR` | Server error |
| 502 | `EXTERNAL_SERVICE_ERROR` | External service failure |

## Health Check

```
GET /health
```

```json
{
  "success": true,
  "message": "asheeighe API is running",
  "timestamp": "2025-04-01T12:00:00.000Z",
  "version": "1.0.0"
}
```

---

## Auth Endpoints

### Register

```
POST /auth/register
```

**Body:**

```json
{
  "email": "user@example.com",
  "password": "securePassword123",
  "displayName": "Jane Doe"
}
```

**Response** `201`:

```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "userId": "usr_abc123",
    "accessToken": "eyJhbG...",
    "refreshToken": "eyJhbG...",
    "expiresIn": 900
  }
}
```

### Login

```
POST /auth/login
```

**Body:**

```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**Response** `200`:

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "userId": "usr_abc123",
    "accessToken": "eyJhbG...",
    "refreshToken": "eyJhbG...",
    "expiresIn": 900
  }
}
```

### Refresh Token

```
POST /auth/refresh
```

**Body:**

```json
{
  "refreshToken": "eyJhbG..."
}
```

**Response** `200`:

```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbG...",
    "refreshToken": "eyJhbG...",
    "expiresIn": 900
  }
}
```

### Verify Token

```
POST /auth/verify
Authorization: Bearer <token>
```

**Response** `200`:

```json
{
  "success": true,
  "data": {
    "userId": "usr_abc123",
    "email": "user@example.com"
  }
}
```

### Get Current User

```
GET /api/users/me
```

**Response** `200`:

```json
{
  "success": true,
  "data": {
    "id": "usr_abc123",
    "email": "user@example.com",
    "displayName": "Jane Doe",
    "avatarUrl": null,
    "timezone": "UTC",
    "preferences": {},
    "emailVerified": false,
    "createdAt": "2025-04-01T12:00:00.000Z",
    "updatedAt": "2025-04-01T12:00:00.000Z"
  }
}
```

---

## Calendar Endpoints

### List Events (Date Range)

```
GET /api/calendar?start=2025-04-01T00:00:00Z&end=2025-04-30T23:59:59Z
```

**Response** `200`:

```json
{
  "success": true,
  "data": [
    {
      "id": "evt_abc123",
      "userId": "usr_abc123",
      "title": "Team Standup",
      "description": "Daily sync",
      "startTime": "2025-04-02T09:00:00Z",
      "endTime": "2025-04-02T09:30:00Z",
      "allDay": false,
      "location": "Office A",
      "color": "#F4C2C2",
      "category": "work",
      "status": "confirmed",
      "createdAt": "2025-04-01T12:00:00Z",
      "updatedAt": "2025-04-01T12:00:00Z"
    }
  ]
}
```

**Query Parameters:**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| `start` | ISO 8601 | Yes | Start of range |
| `end` | ISO 8601 | Yes | End of range |
| `page` | number | No | Page number (default: 1) |
| `limit` | number | No | Items per page (default: 50, max: 100) |

### Get Event

```
GET /api/calendar/:eventId
```

### Create Event

```
POST /api/calendar
```

**Body:**

```json
{
  "title": "Team Standup",
  "description": "Daily sync",
  "startTime": "2025-04-02T09:00:00Z",
  "endTime": "2025-04-02T09:30:00Z",
  "allDay": false,
  "location": "Office A",
  "color": "#F4C2C2"
}
```

### Update Event

```
PUT /api/calendar/:eventId
```

### Delete Event

```
DELETE /api/calendar/:eventId
```

---

## Tasks Endpoints

### List Tasks

```
GET /api/tasks?status=pending&priority=high
```

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `status` | string | Filter by status: `pending`, `in_progress`, `done`, `archived` |
| `priority` | string | Filter by priority: `low`, `medium`, `high`, `urgent` |
| `category` | string | Filter by category |
| `dueDate` | ISO 8601 | Filter by due date (exact date) |
| `page` | number | Page number |
| `limit` | number | Items per page |

### Get Task

```
GET /api/tasks/:taskId
```

### Create Task

```
POST /api/tasks
```

**Body:**

```json
{
  "title": "Buy groceries",
  "description": "Milk, eggs, bread",
  "priority": "high",
  "dueDate": "2025-04-03T18:00:00Z",
  "tags": ["shopping", "personal"],
  "category": "errands"
}
```

### Update Task

```
PUT /api/tasks/:taskId
```

### Complete Task

```
PATCH /api/tasks/:taskId/complete
```

**Response** `200`:

```json
{
  "success": true,
  "data": {
    "id": "task_abc123",
    "status": "done",
    "completedAt": "2025-04-02T14:30:00Z"
  }
}
```

### Delete Task

```
DELETE /api/tasks/:taskId
```

---

## Reminders Endpoints

### List Reminders

```
GET /api/reminders?dismissed=false
```

### Get Reminder

```
GET /api/reminders/:reminderId
```

### Create Reminder

```
POST /api/reminders
```

**Body:**

```json
{
  "title": "Doctor appointment",
  "description": "Annual checkup",
  "remindAt": "2025-04-05T10:00:00Z",
  "repeatInterval": "P1Y",
  "linkedEntityType": "task",
  "linkedEntityId": "task_abc123"
}
```

### Update Reminder

```
PUT /api/reminders/:reminderId
```

### Dismiss Reminder

```
PATCH /api/reminders/:reminderId/dismiss
```

### Snooze Reminder

```
POST /api/reminders/:reminderId/snooze
```

**Body:**

```json
{
  "snoozeUntil": "2025-04-02T10:30:00Z"
}
```

### Delete Reminder

```
DELETE /api/reminders/:reminderId
```

---

## Notes Endpoints

### List Notes

```
GET /api/notes?pinned=true&archived=false
```

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `pinned` | boolean | Filter pinned notes |
| `archived` | boolean | Filter archived notes |
| `notebookId` | string | Filter by notebook |
| `tag` | string | Filter by tag |
| `page` | number | Page number |
| `limit` | number | Items per page |

### Search Notes

```
GET /api/notes/search?q=recipe&tag=cooking
```

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `q` | string | Full-text search query |
| `tag` | string | Filter by tag |
| `notebookId` | string | Filter by notebook |
| `page` | number | Page number |
| `limit` | number | Items per page |

### Get Note

```
GET /api/notes/:noteId
```

### Create Note

```
POST /api/notes
```

**Body:**

```json
{
  "title": "Pasta Recipe",
  "content": "## Ingredients\n\n- Pasta\n- Tomatoes\n...",
  "type": "text",
  "tags": ["recipe", "cooking"],
  "color": "#FFF8F0",
  "notebookId": "nb_abc123"
}
```

### Update Note

```
PUT /api/notes/:noteId
```

### Pin Note

```
PATCH /api/notes/:noteId/pin
```

### Archive Note

```
PATCH /api/notes/:noteId/archive
```

### Delete Note

```
DELETE /api/notes/:noteId
```

---

## Chat Endpoints

### Send Message

```
POST /api/chat/conversations/:conversationId/messages
```

**Body:**

```json
{
  "content": "Create a task to buy groceries tomorrow at 6pm"
}
```

**Response** `200`:

```json
{
  "success": true,
  "data": {
    "id": "msg_abc123",
    "role": "assistant",
    "content": "I've created a task 'Buy groceries' for tomorrow at 6:00 PM.",
    "skills": [
      {
        "name": "create_task",
        "result": { "taskId": "task_abc123", "title": "Buy groceries" },
        "status": "success"
      }
    ],
    "timestamp": "2025-04-02T12:00:00Z"
  }
}
```

### Stream Chat (SSE)

```
POST /api/chat/conversations/:conversationId/stream
```

Returns a Server-Sent Events stream with token-by-token delivery.

### List Conversations

```
GET /api/chat/conversations
```

### Get Conversation

```
GET /api/chat/conversations/:conversationId
```

### List Messages in Conversation

```
GET /api/chat/conversations/:conversationId/messages
```

**Query Parameters:**

| Param | Type | Description |
|-------|------|-------------|
| `before` | string | Pagination cursor (message ID) |
| `limit` | number | Items per page (default: 50) |

---

## Composio Endpoints

### List Integrations

```
GET /api/composio/integrations
```

**Response** `200`:

```json
{
  "success": true,
  "data": [
    {
      "id": "int_abc123",
      "name": "google_calendar",
      "authScheme": "oauth2",
      "description": "Google Calendar integration",
      "categories": ["calendar", "productivity"]
    }
  ]
}
```

### Connect Integration

```
POST /api/composio/connect
```

**Body:**

```json
{
  "integrationId": "int_abc123"
}
```

**Response** `200`:

```json
{
  "success": true,
  "data": {
    "connectionUrl": "https://backend.composio.dev/oauth/start?token=...",
    "connectionId": "conn_abc123"
  }
}
```

Redirect user to `connectionUrl` for OAuth flow.

### Get Connection Status

```
GET /api/composio/connections/:connectionId
```

### List Connected Accounts

```
GET /api/composio/connections
```

### Disconnect

```
DELETE /api/composio/connections/:connectionId
```

### List Available Actions

```
GET /api/composio/actions?app=google_calendar
```

### Execute Action

```
POST /api/composio/actions/execute
```

**Body:**

```json
{
  "connectionId": "conn_abc123",
  "actionName": "google_calendar_create_event",
  "input": {
    "summary": "Team Standup",
    "start": { "dateTime": "2025-04-02T09:00:00Z" },
    "end": { "dateTime": "2025-04-02T09:30:00Z" }
  }
}
```

---

## Users Endpoints

### Get Profile

```
GET /api/users/me
```

### Update Profile

```
PUT /api/users/me
```

**Body:**

```json
{
  "displayName": "Jane Smith",
  "timezone": "America/New_York",
  "preferences": {
    "theme": "light",
    "notifications": true,
    "weekStart": "monday"
  }
}
```

### Delete Account

```
DELETE /api/users/me
```

### Get User Stats

```
GET /api/users/me/stats
```

**Response** `200`:

```json
{
  "success": true,
  "data": {
    "totalTasks": 42,
    "completedTasks": 28,
    "totalNotes": 15,
    "totalEvents": 10,
    "activeReminders": 5,
    "streak": 7,
    "joinedAt": "2025-01-15T12:00:00Z"
  }
}
```

---

## Pagination Format

All list endpoints support pagination. Response format:

```json
{
  "success": true,
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 156,
    "totalPages": 8
  }
}
```

| Parameter | Description |
|-----------|-------------|
| `page` | Current page number |
| `limit` | Items per page |
| `total` | Total items across all pages |
| `totalPages` | Computed total pages |
