-- Script para configurar las políticas de Row Level Security en Supabase

-- Opción 1: Desactivar RLS temporalmente (más simple para desarrollo)
ALTER TABLE developers DISABLE ROW LEVEL SECURITY;
ALTER TABLE projects DISABLE ROW LEVEL SECURITY;
ALTER TABLE timeline_events DISABLE ROW LEVEL SECURITY;

-- Opción 2: Si quieres mantener RLS habilitado, usa estas políticas
-- (descomenta las siguientes líneas y comenta las de arriba)

/*
-- Habilitar RLS
ALTER TABLE developers ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE timeline_events ENABLE ROW LEVEL SECURITY;

-- Políticas para developers
CREATE POLICY "Permitir todas las operaciones en developers" 
ON developers FOR ALL 
TO anon, authenticated 
USING (true) 
WITH CHECK (true);

-- Políticas para projects
CREATE POLICY "Permitir todas las operaciones en projects" 
ON projects FOR ALL 
TO anon, authenticated 
USING (true) 
WITH CHECK (true);

-- Políticas para timeline_events
CREATE POLICY "Permitir todas las operaciones en timeline_events" 
ON timeline_events FOR ALL 
TO anon, authenticated 
USING (true) 
WITH CHECK (true);
*/
