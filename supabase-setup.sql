-- BM Service — database "Vendita auto" (Supabase)
-- Da eseguire una volta nel progetto Supabase dedicato a BM Service.

create table if not exists public.cars (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  marca text not null,
  modello text not null,
  versione text,
  anno int not null check (anno between 1950 and 2100),
  km int not null default 0 check (km >= 0),
  alimentazione text,
  cambio text,
  potenza_cv int check (potenza_cv >= 0),
  colore text,
  prezzo int check (prezzo >= 0),              -- null = prezzo su richiesta
  condizione text not null default 'Usato',
  descrizione text,
  photos text[] not null default '{}',
  in_evidenza boolean not null default false,
  venduta boolean not null default false,
  visibile boolean not null default true
);

-- Chi può gestire gli annunci (account del titolare)
create table if not exists public.admins (
  user_id uuid primary key references auth.users on delete cascade
);

create or replace function public.is_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.admins where user_id = auth.uid());
$$;

alter table public.cars enable row level security;
alter table public.admins enable row level security;

create policy "cars: lettura pubblica delle auto visibili" on public.cars
  for select using (visibile or public.is_admin());
create policy "cars: inserimento admin" on public.cars
  for insert to authenticated with check (public.is_admin());
create policy "cars: modifica admin" on public.cars
  for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "cars: eliminazione admin" on public.cars
  for delete to authenticated using (public.is_admin());
create policy "admins: ognuno vede se stesso" on public.admins
  for select to authenticated using (user_id = auth.uid());

-- Foto: bucket pubblico in lettura, scrittura solo admin
insert into storage.buckets (id, name, public) values ('auto', 'auto', true)
  on conflict (id) do nothing;
create policy "auto: lettura pubblica" on storage.objects
  for select using (bucket_id = 'auto');
create policy "auto: caricamento admin" on storage.objects
  for insert to authenticated with check (bucket_id = 'auto' and public.is_admin());
create policy "auto: eliminazione admin" on storage.objects
  for delete to authenticated using (bucket_id = 'auto' and public.is_admin());

-- Dopo aver creato l'utente del titolare (Authentication → Users):
-- insert into public.admins (user_id) select id from auth.users where email = 'EMAIL_DEL_TITOLARE';
