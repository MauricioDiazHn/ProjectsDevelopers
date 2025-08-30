-- Script simple para desactivar Row Level Security (RLS)
-- Ejecuta esto en tu consola SQL de Supabase

ALTER TABLE developers DISABLE ROW LEVEL SECURITY;
ALTER TABLE projects DISABLE ROW LEVEL SECURITY;
ALTER TABLE timeline_events DISABLE ROW LEVEL SECURITY;

-- Verificar que el RLS esté desactivado
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename IN ('developers', 'projects', 'timeline_events');

-- El resultado debe mostrar 'f' (false) en la columna rowsecurity
