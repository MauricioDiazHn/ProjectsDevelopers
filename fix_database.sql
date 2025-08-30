-- Script de corrección para la estructura de base de datos existente
-- Ejecuta estos comandos en Supabase SQL Editor

-- Primero, vamos a verificar la estructura actual de la tabla developers
-- Ejecuta esto para ver qué columnas tienes:
-- SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'developers';

-- Si la tabla developers solo tiene columnas básicas, podemos agregar las que faltan:

-- Agregar columnas faltantes a la tabla developers (ejecuta solo si no existen)
ALTER TABLE developers ADD COLUMN IF NOT EXISTS email VARCHAR(255) UNIQUE;
ALTER TABLE developers ADD COLUMN IF NOT EXISTS level VARCHAR(50) DEFAULT 'Junior';
ALTER TABLE developers ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE developers ADD COLUMN IF NOT EXISTS github_username VARCHAR(100);
ALTER TABLE developers ADD COLUMN IF NOT EXISTS skills TEXT[];
ALTER TABLE developers ADD COLUMN IF NOT EXISTS hourly_rate DECIMAL(10,2);
ALTER TABLE developers ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

-- Agregar timestamps si no existen
ALTER TABLE developers ADD COLUMN IF NOT EXISTS created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW());
ALTER TABLE developers ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW());

-- Verificar estructura de projects (ejecuta para ver qué columnas tienes)
-- SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'projects';

-- Agregar columnas faltantes a projects si no existen
ALTER TABLE projects ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE projects ADD COLUMN IF NOT EXISTS tags TEXT[];
ALTER TABLE projects ADD COLUMN IF NOT EXISTS repository_url TEXT;

-- Insertar algunos desarrolladores de ejemplo si la tabla está vacía
INSERT INTO developers (name, email, level, avatar_url, github_username, skills, hourly_rate, is_active) 
SELECT 'Ana Cardenas', 'ana.cardenas@company.com', 'Senior', 'https://placehold.co/64x64/d946ef/ffffff?text=AC', 'anacardenas', ARRAY['React', 'Node.js', 'TypeScript'], 85.00, true
WHERE NOT EXISTS (SELECT 1 FROM developers WHERE email = 'ana.cardenas@company.com');

INSERT INTO developers (name, email, level, avatar_url, github_username, skills, hourly_rate, is_active) 
SELECT 'Luis Martinez', 'luis.martinez@company.com', 'Semi-Senior', 'https://placehold.co/64x64/06b6d4/ffffff?text=LM', 'luismartinez', ARRAY['Vue.js', 'Python', 'Docker'], 65.00, true
WHERE NOT EXISTS (SELECT 1 FROM developers WHERE email = 'luis.martinez@company.com');

INSERT INTO developers (name, email, level, avatar_url, github_username, skills, hourly_rate, is_active) 
SELECT 'David Rodriguez', 'david.rodriguez@company.com', 'Junior', 'https://placehold.co/64x64/f59e0b/ffffff?text=DR', 'davidrodriguez', ARRAY['JavaScript', 'HTML', 'CSS'], 45.00, true
WHERE NOT EXISTS (SELECT 1 FROM developers WHERE email = 'david.rodriguez@company.com');

-- Insertar algunos proyectos de ejemplo si la tabla está vacía
INSERT INTO projects (name, description, status, priority, progress, assigned_to, due_date, estimated_hours, actual_hours, tags) 
SELECT 
    'QuantumCore API', 
    'API principal del sistema QuantumCore', 
    'in_progress', 
    'A', 
    75, 
    d.id, 
    CURRENT_DATE + INTERVAL '15 days', 
    120, 
    90, 
    ARRAY['API', 'Backend', 'Critical']
FROM developers d 
WHERE d.name = 'Ana Cardenas' 
AND NOT EXISTS (SELECT 1 FROM projects WHERE name = 'QuantumCore API');

INSERT INTO projects (name, description, status, priority, progress, assigned_to, due_date, estimated_hours, actual_hours, tags) 
SELECT 
    'Helios Dashboard UI', 
    'Interfaz de usuario para el dashboard Helios', 
    'in_progress', 
    'A', 
    95, 
    d.id, 
    CURRENT_DATE + INTERVAL '5 days', 
    80, 
    76, 
    ARRAY['Frontend', 'UI/UX']
FROM developers d 
WHERE d.name = 'Luis Martinez' 
AND NOT EXISTS (SELECT 1 FROM projects WHERE name = 'Helios Dashboard UI');

INSERT INTO projects (name, description, status, priority, progress, assigned_to, due_date, estimated_hours, actual_hours, tags) 
SELECT 
    'CI/CD Pipeline Jenkins', 
    'Configuración de pipeline de CI/CD con Jenkins', 
    'completed', 
    'C', 
    100, 
    d.id, 
    CURRENT_DATE - INTERVAL '5 days', 
    40, 
    35, 
    ARRAY['DevOps', 'Automation']
FROM developers d 
WHERE d.name = 'Luis Martinez' 
AND NOT EXISTS (SELECT 1 FROM projects WHERE name = 'CI/CD Pipeline Jenkins');

-- Consulta para verificar que todo esté funcionando
SELECT 
    p.name as project_name,
    p.status,
    p.priority,
    p.progress,
    d.name as developer_name,
    d.level as developer_level
FROM projects p
LEFT JOIN developers d ON p.assigned_to = d.id
ORDER BY p.created_at DESC;
