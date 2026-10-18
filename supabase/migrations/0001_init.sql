-- Core tables. Enable row-level security on user-owned tables.
create table if not exists leagues (
  id bigserial primary key,
  name text not null,
  country text,
  source text,
  is_user_private boolean default false,
  owner_id uuid
);

create table if not exists teams (
  id bigserial primary key,
  league_id bigint references leagues(id),
  name text not null,
  alias_list text[]
);

create table if not exists matches (
  id bigserial primary key,
  league_id bigint references leagues(id),
  season text,
  match_date date,
  home_team bigint references teams(id),
  away_team bigint references teams(id),
  home_goals int,
  away_goals int,
  status text,
  source text
);

create table if not exists model_versions (
  id bigserial primary key,
  model_type text,
  trained_at timestamptz default now(),
  train_window text,
  metrics_json jsonb,
  is_live boolean default false
);

create table if not exists predictions (
  id bigserial primary key,
  user_id uuid not null,
  match_id bigint references matches(id),
  model_version bigint references model_versions(id),
  p_home numeric, p_draw numeric, p_away numeric,
  pred_home_goals int, pred_away_goals int,
  created_at timestamptz default now()
);

create table if not exists prediction_grades (
  prediction_id bigint primary key references predictions(id),
  actual_result text,
  correct boolean,
  graded_at timestamptz default now(),
  graded_by text
);

create table if not exists feedback (
  id bigserial primary key,
  prediction_id bigint references predictions(id),
  rating int,
  comment text
);

create table if not exists ingest_logs (
  id bigserial primary key,
  source text,
  run_at timestamptz default now(),
  rows_added int,
  errors text
);

alter table predictions enable row level security;
create policy "own predictions" on predictions
  for all using (auth.uid() = user_id);