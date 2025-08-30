-- ACTUALIZACIÓN DE POLÍTICAS DE SEGURIDAD PARA PROYECTO CON AUTENTICACIÓN
-- Ejecuta este script en el SQL Editor de tu proyecto de Supabase

-- PASO 1: Eliminar las políticas antiguas que solo permitían usuarios autenticados
DROP POLICY IF EXISTS "Allow all operations for authenticated users" ON developers;
DROP POLICY IF EXISTS "Allow all operations for authenticated users" ON projects;
DROP POLICY IF EXISTS "Allow all operations for authenticated users" ON timeline_events;
DROP POLICY IF EXISTS "Allow all operations for authenticated users" ON system_configs;

-- PASO 2: Crear nuevas políticas que permitan tanto usuarios anónimos como autenticados
-- Esto es necesario porque ahora tenemos:
-- 1. Sistema de login/registro para usuarios autenticados
-- 2. Modo demo para usuarios anónimos

-- Políticas para desarrolladores
CREATE POLICY "Allow read access for all users" ON developers
    FOR SELECT TO anon, authenticated
    USING (true);

CREATE POLICY "Allow insert for all users" ON developers
    FOR INSERT TO anon, authenticated
    WITH CHECK (true);

CREATE POLICY "Allow update for authenticated users only" ON developers
    FOR UPDATE TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Allow delete for authenticated users only" ON developers
    FOR DELETE TO authenticated
    USING (true);

-- Políticas para proyectos
CREATE POLICY "Allow read access for all users" ON projects
    FOR SELECT TO anon, authenticated
    USING (true);

CREATE POLICY "Allow insert for all users" ON projects
    FOR INSERT TO anon, authenticated
    WITH CHECK (true);

CREATE POLICY "Allow update for authenticated users only" ON projects
    FOR UPDATE TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Allow delete for authenticated users only" ON projects
    FOR DELETE TO authenticated
    USING (true);

-- Políticas para timeline_events
CREATE POLICY "Allow read access for all users" ON timeline_events
    FOR SELECT TO anon, authenticated
    USING (true);

CREATE POLICY "Allow insert for all users" ON timeline_events
    FOR INSERT TO anon, authenticated
    WITH CHECK (true);

CREATE POLICY "Allow update for authenticated users only" ON timeline_events
    FOR UPDATE TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Allow delete for authenticated users only" ON timeline_events
    FOR DELETE TO authenticated
    USING (true);

-- Políticas para system_configs
CREATE POLICY "Allow read access for all users" ON system_configs
    FOR SELECT TO anon, authenticated
    USING (true);

CREATE POLICY "Allow insert for authenticated users only" ON system_configs
    FOR INSERT TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow update for authenticated users only" ON system_configs
    FOR UPDATE TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Allow delete for authenticated users only" ON system_configs
    FOR DELETE TO authenticated
    USING (true);

-- VERIFICAR QUE LAS POLÍTICAS SE CREARON CORRECTAMENTE
SELECT schemaname, tablename, policyname, roles, cmd, qual 
FROM pg_policies 
WHERE tablename IN ('developers', 'projects', 'timeline_events', 'system_configs')
ORDER BY tablename, policyname;

-- OPCIONAL: Si quieres políticas más restrictivas para producción,
-- descomenta y ejecuta las siguientes líneas:

/*
-- POLÍTICAS MÁS RESTRICTIVAS (solo para usuarios autenticados)
-- Ejecuta esto SOLO si quieres quitar el acceso anónimo completamente

DROP POLICY "Allow read access for all users" ON developers;
DROP POLICY "Allow insert for all users" ON developers;
DROP POLICY "Allow read access for all users" ON projects;
DROP POLICY "Allow insert for all users" ON projects;
DROP POLICY "Allow read access for all users" ON timeline_events;
DROP POLICY "Allow insert for all users" ON timeline_events;

CREATE POLICY "Authenticated users only" ON developers
    FOR ALL TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Authenticated users only" ON projects
    FOR ALL TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Authenticated users only" ON timeline_events
    FOR ALL TO authenticated
    USING (true)
    WITH CHECK (true);
*/
