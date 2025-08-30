# Solución para Error de Row Level Security (RLS)

## Problema
La aplicación muestra el siguiente error:
```
"new row violates row-level security policy for table developers"
```

## Causa
Supabase tiene habilitado Row Level Security (RLS) en las tablas, pero no hay políticas configuradas que permitan operaciones anónimas.

## Solución Rápida (Desarrollo)

### Opción 1: Desactivar RLS (Recomendado para desarrollo)

1. Ve a tu dashboard de Supabase
2. Abre el **SQL Editor**
3. Ejecuta el siguiente comando:

```sql
-- Desactivar RLS para todas las tablas
ALTER TABLE developers DISABLE ROW LEVEL SECURITY;
ALTER TABLE projects DISABLE ROW LEVEL SECURITY;
ALTER TABLE timeline_events DISABLE ROW LEVEL SECURITY;
```

4. Actualiza la página de la aplicación

### Opción 2: Configurar Políticas de RLS (Para producción)

Si quieres mantener RLS habilitado:

```sql
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
```

## Verificación

Después de ejecutar los comandos, la aplicación debería:
1. Cargar desarrolladores y proyectos existentes
2. Crear datos de ejemplo automáticamente si las tablas están vacías
3. Permitir crear nuevos proyectos y desarrolladores

## Archivos Creados
- `disable_rls.sql` - Script simple para desactivar RLS
- `fix_rls_policies.sql` - Script completo con opciones de políticas
