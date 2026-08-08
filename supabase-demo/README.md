# Product Usage Analytics — a Supabase demo

A small hands-on project I built to get comfortable with Supabase (Postgres + Row Level Security + auth) from the inside, framed around a problem I know well from running enterprise SaaS platforms: **how do you instrument feature usage well enough to make roadmap decisions from it?**

This isn't a client project — it's a self-directed exercise to understand Supabase at the schema and query level before applying, and to sanity-check how a Postgres-native tool like this maps onto the kind of product analytics work I already do with Power BI and SQL.

## What's here

- [`schema.sql`](./schema.sql) — tables for users, products, features, feature usage events, and feedback, plus Row Level Security policies scoping each account to its own data
- [`queries.sql`](./queries.sql) — analytics queries a PM would actually run: feature adoption rate, weekly active users, retention, and top-requested features from feedback

## Why this shape

The schema models a common SaaS pattern: multiple **products**, each with a set of **features**, instrumented by **usage events**, alongside a lightweight **feedback** loop. It's deliberately similar to the kind of platform telemetry I set up KPIs and governance around on the Deloitte Data Lens engagement — just rebuilt from scratch on Postgres/Supabase instead of an enterprise data warehouse.

## How to run it

1. Create a free project at [supabase.com](https://supabase.com)
2. Open the SQL Editor and run `schema.sql` to create the tables and RLS policies
3. Insert a few rows of sample data (or ask me — I'm happy to add a seed script)
4. Run the queries in `queries.sql` to see adoption, retention, and feedback metrics
