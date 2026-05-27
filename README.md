# School API

Rails API service for managing students and school classes.  
Implemented according to `openapi.yaml`.

## Stack

- Ruby on Rails
- PostgreSQL
- Docker / Docker Compose
- RSpec + FactoryBot
- Postman collection

## Project structure

```text
app/
  controllers/   # API controllers
  models/        # ActiveRecord models
  services/      # business logic

db/
  migrate/       # database migrations
  seeds.rb       # initial school/class data

spec/
  requests/      # API request specs
  factories/     # FactoryBot factories

postman/         # Postman collection
```

## Run

```bash
docker compose up
```

API will be available at:

```text
http://localhost:3000
```

The app runs migrations and seeds automatically.

Seed data:

```text
School id: 1
Class id: 1
Class number: 10
Class letter: F
```

Stop containers:

```bash
docker compose down
```

Remove containers and database volumes:

```bash
docker compose down -v
```

## Tests

```bash
docker compose run --rm test
```

Expected result:

```text
11 examples, 0 failures
```

## Environment

The project works without a `.env` file because default values are defined in `docker-compose.yml`.

Optional `.env` example:

```env
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
DATABASE_NAME=school_api_development
TEST_DATABASE_NAME=school_api_test
DATABASE_HOST=db
DATABASE_PORT=5432
POSTGRES_VERSION=16
SECRET_SALT=secret_salt
```

## Authentication

After creating a student, the API returns an auth token:

```http
X-Auth-Token: <token>
```

Use it to delete the student:

```http
Authorization: Bearer <token>
```

Token format:

```text
sha256(user_id + secret_salt)
```

## API

### Create student

```http
POST /students
```

Body:

```json
{
  "first_name": "test",
  "last_name": "test",
  "surname": "test",
  "school_id": 1,
  "class_id": 1
}
```

Responses:

```text
201 Created
405 Invalid input
```

### Delete student

```http
DELETE /students/:user_id
Authorization: Bearer <token>
```

Responses:

```text
200 OK
400 Student not found
401 Invalid authorization
```

### Get school classes

```http
GET /schools/:school_id/classes
```

Example response:

```json
{
  "data": [
    {
      "id": 1,
      "number": 10,
      "letter": "F",
      "students_count": 0
    }
  ]
}
```

### Get class students

```http
GET /schools/:school_id/classes/:class_id/students
```

Example response:

```json
{
  "data": [
    {
      "id": 1,
      "first_name": "Ivan",
      "last_name": "Ivanov",
      "surname": "Ivanovich",
      "class_id": 1,
      "school_id": 1
    }
  ]
}
```

## Postman

Postman collection is located at:

```text
postman/postman_school_api_tests.postman_collection.json
```

Run the app first, then import the collection into Postman.

## Example flow

```bash
curl http://localhost:3000/schools/1/classes
```

```bash
curl -i -X POST http://localhost:3000/students \
  -H "Content-Type: application/json" \
  -d "{\"first_name\":\"Ivan\",\"last_name\":\"Ivanov\",\"surname\":\"Ivanovich\",\"school_id\":1,\"class_id\":1}"
```

```bash
curl http://localhost:3000/schools/1/classes/1/students
```

```bash
curl -X DELETE http://localhost:3000/students/1 \
  -H "Authorization: Bearer <token>"
```