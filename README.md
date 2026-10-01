# Cinema — NestJS + Prisma ORM

This project completes the assignment using **TypeScript + NestJS + Prisma ORM + MariaDB + Faker**.

## Assignment checklist

1. **Docker Compose database** — `docker-compose.yml` starts MariaDB and Adminer.
2. **Backend language** — TypeScript.
3. **Framework / ORM** — NestJS + Prisma ORM.
4. **SQL structure converted to ORM** — all 15 tables from `project.sql` are represented in `prisma/schema.prisma` with primary keys, foreign keys, composite keys, unique constraints, nullability and relations.
5. **Seed script** — `prisma/seed.ts` uses `@faker-js/faker` and Prisma Client to create **100 rows in every table**.

The original SQL is kept in `docs/original-project.sql` for comparison.

## Requirements

- Node.js 20+
- Docker Desktop

## Run it

```bash
# 1. Install dependencies
npm install

# 2. Start MariaDB (+ Adminer)
docker compose up -d

# 3. Generate Prisma Client
npm run prisma:generate

# 4. Create DB tables from Prisma schema
npm run db:migrate

# 5. Insert fake data (100 rows per table)
npm run db:seed

# 6. Start NestJS
npm run start:dev
```

API: http://localhost:3000  
Adminer: http://localhost:8080

Adminer connection:

- System: `MySQL`
- Server: `db` if opening Adminer from Docker network context; in a desktop DB client use `localhost`
- User: `cinema`
- Password: `cinema`
- Database: `cinema`
- Host port for DataGrip: `33061`

## Useful endpoints

```text
GET /
GET /health
GET /stats
GET /movies?take=20
GET /cinemas?take=20
```

`GET /stats` is useful for the demo: after seeding, every value should be `100`.

## DataGrip connection

Create a MariaDB/MySQL data source:

```text
Host: localhost
Port: 33061
User: cinema
Password: cinema
Database: cinema
```

Then refresh the schema. You should see the same 15 tables represented by Prisma.

## Important note about the source SQL

The original SQL contains the column name `characher_name`. It looks like a typo, but it is deliberately preserved at database level with Prisma `@map("characher_name")`. In TypeScript code the field is named correctly as `characterName`.

The original `tickets` table also makes `screening_id` and `seat_id` separately unique. That behavior is preserved in Prisma. It means a screening can have only one ticket in this exact schema; in a real cinema system a composite uniqueness rule such as `(screening_id, seat_id)` would usually be more appropriate.

## Stop database

```bash
docker compose down
```

To also delete the database volume/data:

```bash
docker compose down -v
```
