-- Crea la tabla que guarda toda la contaduría como un único registro
create table contaduria_state (
  id text primary key default 'main',
  data jsonb not null default '{}'::jsonb,
  updated_by text,
  updated_at timestamptz not null default now()
);

-- Fila inicial: arranca vacía, la app la completa sola la primera vez que carga
insert into contaduria_state (id, data) values ('main', '{}'::jsonb);

-- Seguridad a nivel de fila: solo esta tabla, solo lectura/escritura del registro "main"
alter table contaduria_state enable row level security;

create policy "anon puede leer" on contaduria_state
  for select to anon using (true);

create policy "anon puede actualizar" on contaduria_state
  for update to anon using (true) with check (true);

-- Habilita que los cambios se transmitan en tiempo real a todos los dispositivos conectados
alter publication supabase_realtime add table contaduria_state;
