-- Analytics queries a PM would actually run against this schema

-- ============================================================
-- 1. Feature adoption rate
-- % of account users who have used each feature at least once
-- ============================================================
select
  f.name as feature_name,
  count(distinct fe.app_user_id) as users_who_used_it,
  count(distinct au.id) as total_account_users,
  round(
    100.0 * count(distinct fe.app_user_id) / nullif(count(distinct au.id), 0),
    1
  ) as adoption_pct
from features f
join products p on p.id = f.product_id
join app_users au on au.account_id = p.account_id
left join feature_events fe
  on fe.feature_id = f.id
  and fe.app_user_id = au.id
  and fe.event_type = 'used'
group by f.id, f.name
order by adoption_pct desc;

-- ============================================================
-- 2. Weekly active users, per product, last 8 weeks
-- ============================================================
select
  p.name as product_name,
  date_trunc('week', fe.created_at) as week,
  count(distinct fe.app_user_id) as weekly_active_users
from feature_events fe
join features f on f.id = fe.feature_id
join products p on p.id = f.product_id
where fe.created_at >= now() - interval '8 weeks'
group by p.name, week
order by p.name, week;

-- ============================================================
-- 3. Retention: users active in week N who were still active in week N+1
-- ============================================================
with weekly_activity as (
  select distinct
    app_user_id,
    date_trunc('week', created_at) as active_week
  from feature_events
)
select
  w1.active_week as cohort_week,
  count(distinct w1.app_user_id) as active_users,
  count(distinct w2.app_user_id) as retained_next_week,
  round(
    100.0 * count(distinct w2.app_user_id) / nullif(count(distinct w1.app_user_id), 0),
    1
  ) as retention_pct
from weekly_activity w1
left join weekly_activity w2
  on w2.app_user_id = w1.app_user_id
  and w2.active_week = w1.active_week + interval '1 week'
group by w1.active_week
order by w1.active_week;

-- ============================================================
-- 4. Top requested features from feedback, by weighted votes
-- ============================================================
select
  p.name as product_name,
  fb.feature_requested,
  sum(fb.votes) as total_votes,
  count(*) as number_of_requests
from feedback fb
join products p on p.id = fb.product_id
where fb.feature_requested is not null
group by p.name, fb.feature_requested
order by total_votes desc
limit 10;
