---
name: db-review
description: Review database schemas and suggest improvements for indexing, types, and constraints.
argument-hint: "<files> [instructions]"
user-invocable: true
context: fork
agent: Explore
paths: "*.sql, *.prisma, *.schema, **/migrations/**, **/models/**"
---

# Database Schema Review

Analyse the specified database schema files and provide actionable improvement suggestions.

Files and instructions: $ARGUMENTS

## What to review

- **Indexing**: missing indexes on foreign keys, frequently queried columns, and composite indexes for multi-column lookups. Flag redundant or duplicate indexes.
- **Data types**: overly wide types (e.g. `VARCHAR(255)` where `VARCHAR(50)` suffices, `BIGINT` where `INT` is enough), incorrect types (e.g. strings for dates, floats for currency), and missing precision on decimals.
- **Normalisation**: repeated data that should be extracted into separate tables, denormalisation without justification, and violation of normal forms.
- **Naming conventions**: inconsistent table/column naming (mixed camelCase and snake_case, plural vs singular), unclear or ambiguous column names.
- **Constraints**: missing `NOT NULL` where nullability is unlikely intentional, missing `UNIQUE` constraints, missing `CHECK` constraints for bounded values, and missing `DEFAULT` values.
- **Referential integrity**: missing or incorrect foreign key relationships, cascading deletes that may be dangerous, orphan-prone relationships.
- **Performance**: tables likely to grow large without partitioning strategy, missing covering indexes for known query patterns, N+1-prone relationship structures.
- **Schema-level concerns**: missing `created_at`/`updated_at` audit columns, soft-delete patterns without indexes on the deleted flag, missing composite primary keys on junction tables.

## How to interpret arguments

The arguments are free-form and flexible. They may contain:

- File references of any type and in any format: `@schema.sql`, `migrations/001.sql`, `models.py, schema.prisma`, `schema.rb db/structure.sql`
- Additional natural language instructions alongside file references, such as:
  - "focus on indexing only"
  - "this is a read-heavy workload"
  - "we use PostgreSQL 16"
  - "also check the migration files in db/migrations"

Parse the arguments to identify which files to review and what additional instructions apply. When additional instructions reference related files (e.g. migrations, ORM models), follow those instructions to identify and include those files as well.

### Examples

- `/db-review @schema.sql` — review a single schema file
- `/db-review schema.prisma, migrations/001.sql` — review multiple files
- `/db-review @models.py this is a write-heavy OLTP workload on PostgreSQL` — review with workload context
- `/db-review @schema.sql focus on indexing and performance only` — targeted review

## How to proceed

1. Read each specified file to understand the schema, dialect (PostgreSQL, MySQL, SQLite, etc.), and ORM (if applicable)
2. If the user included additional instructions (e.g. "also check migrations"), follow them to identify further files
3. Analyse the schema against every review category listed above
4. For each finding, provide:
   - **What**: the specific issue
   - **Why**: why it matters (performance, correctness, maintainability)
   - **Fix**: a concrete SQL or schema change to resolve it
5. Group findings by category and order by severity (critical first)
6. If the database engine is known, tailor recommendations to its specific features and best practices
