-- Product Usage Analytics schema
-- Demonstrates: relational modeling, Postgres features, and Supabase Row Level Security

-- ============================================================
-- TABLES
-- ============================================================

create table accounts (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz not null default now()
);

create table app_users (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts(id) on delete cascade,
  auth_user_id uuid not null references auth.users(id) on delete cascade,
  email text not null,
  role text not null default 'member', -- 'admin' | 'member'
  created_at timestamptz not null default now()
);

create table products (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now()
);

create table features (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references products(id) on delete cascade,
  name text not null,
  released_at date
);

create table feature_events (
  id bigint generated always as identity primary key,
  feature_id uuid not null references features(id) on delete cascade,
  app_user_id uuid not null references app_users(id) on delete cascade,
  event_type text not null, -- 'viewed' | 'used' | 'completed'
  created_at timestamptz not null default now()
);

create table feedback (
  id bigint generated always as identity primary key,
  product_id uuid not null references products(id) on delete cascade,
  app_user_id uuid not null references app_users(id) on delete cascade,
  feature_requested text,
  votes int not null default 1,
  created_at timestamptz not null default now()
);

-- ============================================================
-- INDEXES
-- ============================================================

create index idx_feature_events_feature on feature_events(feature_id);
create index idx_feature_events_user on feature_events(app_user_id);
create index idx_app_users_account on app_users(account_id);

-- ============================================================
-- ROW LEVEL SECURITY
-- Every account only ever sees its own data.
-- ============================================================

alter table accounts enable row level security;
alter table app_users enable row level security;
alter table products enable row level security;
alter table features enable row level security;
alter table feature_events enable row level security;
alter table feedback enable row level security;

-- Helper: which account does the current authenticated user belong to?
create or replace function current_account_id()
returns uuid
language sql
security definer
stable
as $$
  select account_id from app_users where auth_user_id = auth.uid() limit 1;
$$;

create policy "Users see their own account" on accounts
  for select using (id = current_account_id());

create policy "Users see teammates in their account" on app_users
  for select using (account_id = current_account_id());

create policy "Users see their own products" on products
  for select using (account_id = current_account_id());

create policy "Users see features of their own products" on features
  for select using (
    product_id in (select id from products where account_id = current_account_id())
  );

create policy "Users see events for their own features" on feature_events
  for select using (
    feature_id in (
      select f.id from features f
      join products p on p.id = f.product_id
      where p.account_id = current_account_id()
    )
  );

create policy "Users see feedback for their own products" on feedback
  for select using (
    product_id in (select id from products where account_id = current_account_id())
  );
