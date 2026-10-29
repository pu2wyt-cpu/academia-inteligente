-- Academia Inteligente / FitPulse
-- Execute no SQL Editor do projeto Supabase antes de ativar o backend.
create extension if not exists pgcrypto;

create type public.app_role as enum ('admin', 'professor', 'aluno');

create table public.gyms (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz not null default now()
);

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  created_at timestamptz not null default now()
);

create table public.gym_members (
  id uuid primary key default gen_random_uuid(),
  gym_id uuid not null references public.gyms(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role public.app_role not null,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (gym_id, user_id)
);

create table public.students (
  id uuid primary key default gen_random_uuid(),
  gym_id uuid not null references public.gyms(id) on delete cascade,
  user_id uuid references public.profiles(id) on delete set null,
  full_name text not null,
  age integer check (age between 14 and 110),
  height_cm numeric(5,2) check (height_cm > 0 and height_cm < 260),
  weight_kg numeric(5,2) check (weight_kg > 0 and weight_kg < 500),
  experience text not null default 'Iniciante',
  goal text not null,
  training_days integer check (training_days between 1 and 7),
  session_minutes integer check (session_minutes between 10 and 300),
  equipment text,
  limitations text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.workouts (
  id uuid primary key default gen_random_uuid(),
  gym_id uuid not null references public.gyms(id) on delete cascade,
  student_id uuid not null references public.students(id) on delete cascade,
  title text not null,
  focus text,
  schedule text,
  status text not null default 'draft' check (status in ('draft','approved','archived')),
  created_by uuid references public.profiles(id) on delete set null,
  approved_by uuid references public.profiles(id) on delete set null,
  approved_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.workout_exercises (
  id uuid primary key default gen_random_uuid(),
  workout_id uuid not null references public.workouts(id) on delete cascade,
  exercise_name text not null,
  sort_order integer not null default 0,
  sets integer not null check (sets between 1 and 30),
  reps text not null,
  rest_seconds integer check (rest_seconds between 0 and 3600),
  load_note text
);

create table public.meal_plans (
  id uuid primary key default gen_random_uuid(),
  gym_id uuid not null references public.gyms(id) on delete cascade,
  student_id uuid not null references public.students(id) on delete cascade,
  title text not null,
  status text not null default 'draft' check (status in ('draft','approved','archived')),
  authored_by uuid references public.profiles(id) on delete set null,
  approved_by uuid references public.profiles(id) on delete set null,
  approved_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.meals (
  id uuid primary key default gen_random_uuid(),
  meal_plan_id uuid not null references public.meal_plans(id) on delete cascade,
  meal_name text not null,
  meal_time time,
  description text not null,
  notes text,
  sort_order integer not null default 0
);

create table public.assessments (
  id uuid primary key default gen_random_uuid(),
  gym_id uuid not null references public.gyms(id) on delete cascade,
  student_id uuid not null references public.students(id) on delete cascade,
  assessed_at date not null default current_date,
  weight_kg numeric(5,2) check (weight_kg > 0 and weight_kg < 500),
  waist_cm numeric(5,2),
  chest_cm numeric(5,2),
  hip_cm numeric(5,2),
  arm_cm numeric(5,2),
  thigh_cm numeric(5,2),
  notes text,
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now()
);

-- Funções auxiliares SECURITY DEFINER com search_path fixo evitam recursão nas políticas.
create or replace function public.is_gym_member(target_gym uuid)
returns boolean language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.gym_members gm
    where gm.gym_id = target_gym and gm.user_id = auth.uid() and gm.active
  );
$$;

create or replace function public.has_gym_role(target_gym uuid, allowed public.app_role[])
returns boolean language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.gym_members gm
    where gm.gym_id = target_gym and gm.user_id = auth.uid()
      and gm.active and gm.role = any(allowed)
  );
$$;

alter table public.gyms enable row level security;
alter table public.profiles enable row level security;
alter table public.gym_members enable row level security;
alter table public.students enable row level security;
alter table public.workouts enable row level security;
alter table public.workout_exercises enable row level security;
alter table public.meal_plans enable row level security;
alter table public.meals enable row level security;
alter table public.assessments enable row level security;

create policy "members read their gym" on public.gyms for select
using (public.is_gym_member(id));
create policy "profile read self or gym colleagues" on public.profiles for select
using (id = auth.uid() or exists (
  select 1 from public.gym_members mine
  join public.gym_members theirs on theirs.gym_id = mine.gym_id
  where mine.user_id = auth.uid() and mine.active and theirs.user_id = profiles.id and theirs.active
));
create policy "profile update self" on public.profiles for update
using (id = auth.uid()) with check (id = auth.uid());

create policy "members read memberships" on public.gym_members for select
using (public.is_gym_member(gym_id));
create policy "admins manage memberships" on public.gym_members for all
using (public.has_gym_role(gym_id, array['admin']::public.app_role[]))
with check (public.has_gym_role(gym_id, array['admin']::public.app_role[]));

create policy "staff manage students" on public.students for all
using (public.has_gym_role(gym_id, array['admin','professor']::public.app_role[]))
with check (public.has_gym_role(gym_id, array['admin','professor']::public.app_role[]));
create policy "student reads own record" on public.students for select
using (user_id = auth.uid());

create policy "staff manage workouts" on public.workouts for all
using (public.has_gym_role(gym_id, array['admin','professor']::public.app_role[]))
with check (public.has_gym_role(gym_id, array['admin','professor']::public.app_role[]));
create policy "student reads approved workouts" on public.workouts for select
using (status = 'approved' and exists (
  select 1 from public.students s where s.id = student_id and s.user_id = auth.uid()
));
create policy "staff manage exercises" on public.workout_exercises for all
using (exists (select 1 from public.workouts w where w.id = workout_id and public.has_gym_role(w.gym_id, array['admin','professor']::public.app_role[])))
with check (exists (select 1 from public.workouts w where w.id = workout_id and public.has_gym_role(w.gym_id, array['admin','professor']::public.app_role[])));
create policy "student reads exercises from approved workouts" on public.workout_exercises for select
using (exists (
  select 1 from public.workouts w join public.students s on s.id = w.student_id
  where w.id = workout_id and w.status = 'approved' and s.user_id = auth.uid()
));

create policy "staff manage meal plans" on public.meal_plans for all
using (public.has_gym_role(gym_id, array['admin','professor']::public.app_role[]))
with check (public.has_gym_role(gym_id, array['admin','professor']::public.app_role[]));
create policy "student reads approved meal plans" on public.meal_plans for select
using (status = 'approved' and exists (
  select 1 from public.students s where s.id = student_id and s.user_id = auth.uid()
));
create policy "staff manage meals" on public.meals for all
using (exists (select 1 from public.meal_plans p where p.id = meal_plan_id and public.has_gym_role(p.gym_id, array['admin','professor']::public.app_role[])))
with check (exists (select 1 from public.meal_plans p where p.id = meal_plan_id and public.has_gym_role(p.gym_id, array['admin','professor']::public.app_role[])));
create policy "student reads meals from approved plans" on public.meals for select
using (exists (
  select 1 from public.meal_plans p join public.students s on s.id = p.student_id
  where p.id = meal_plan_id and p.status = 'approved' and s.user_id = auth.uid()
));

create policy "staff manage assessments" on public.assessments for all
using (public.has_gym_role(gym_id, array['admin','professor']::public.app_role[]))
with check (public.has_gym_role(gym_id, array['admin','professor']::public.app_role[]));
create policy "student reads own assessments" on public.assessments for select
using (exists (select 1 from public.students s where s.id = student_id and s.user_id = auth.uid()));

grant usage on schema public to authenticated;
grant select on public.gyms, public.profiles, public.gym_members, public.students, public.workouts, public.workout_exercises, public.meal_plans, public.meals, public.assessments to authenticated;
grant insert, update, delete on public.gym_members, public.students, public.workouts, public.workout_exercises, public.meal_plans, public.meals, public.assessments to authenticated;
grant update on public.profiles to authenticated;
