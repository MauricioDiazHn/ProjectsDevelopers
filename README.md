# Project Grid - Dashboard de Gestión de Proyectos

Este es un dashboard moderno para la gestión de proyectos y desarrolladores, construido con HTML, CSS (TailwindCSS), JavaScript y Supabase como base de datos.

## 🚀 Características

- **Dashboard en tiempo real** con métricas de proyectos
- **Gestión de desarrolladores** y asignación de proyectos
- **Timeline de eventos** para seguimiento de cambios
- **Gráficos interactivos** de carga de trabajo
- **Proyectos que requieren atención** con alertas automáticas
- **Interfaz responsive** con diseño glassmorphism
- **Datos en tiempo real** desde Supabase

## 📋 Requisitos Previos

- Una cuenta en [Supabase](https://supabase.com)
- Un servidor web local o hosting para servir los archivos

## 🛠️ Configuración

### 1. Configuración de Supabase

1. Crea un nuevo proyecto en Supabase
2. Ve a la sección SQL Editor
3. Ejecuta el siguiente script para crear las tablas:

```sql
-- Tabla de desarrolladores
CREATE TABLE IF NOT EXISTS developers (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    level VARCHAR(50) NOT NULL DEFAULT 'Junior',
    avatar_url TEXT,
    github_username VARCHAR(100),
    skills TEXT[],
    hourly_rate DECIMAL(10,2),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Tabla de proyectos
CREATE TABLE IF NOT EXISTS projects (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'planning',
    priority VARCHAR(1) NOT NULL DEFAULT 'B',
    progress INTEGER DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
    assigned_to BIGINT REFERENCES developers(id) ON DELETE SET NULL,
    due_date DATE,
    start_date DATE DEFAULT CURRENT_DATE,
    estimated_hours INTEGER,
    actual_hours INTEGER DEFAULT 0,
    tags TEXT[],
    repository_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Tabla de eventos del timeline
CREATE TABLE IF NOT EXISTS timeline_events (
    id BIGSERIAL PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,
    event_date TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    description TEXT NOT NULL,
    project_id BIGINT REFERENCES projects(id) ON DELETE CASCADE,
    developer_id BIGINT REFERENCES developers(id) ON DELETE SET NULL,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Tabla de configuraciones del sistema
CREATE TABLE IF NOT EXISTS system_configs (
    id BIGSERIAL PRIMARY KEY,
    config_key VARCHAR(100) UNIQUE NOT NULL,
    config_value JSONB NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_projects_assigned_to ON projects(assigned_to);
CREATE INDEX IF NOT EXISTS idx_projects_status ON projects(status);
CREATE INDEX IF NOT EXISTS idx_projects_priority ON projects(priority);
CREATE INDEX IF NOT EXISTS idx_projects_due_date ON projects(due_date);
CREATE INDEX IF NOT EXISTS idx_timeline_events_project_id ON timeline_events(project_id);
CREATE INDEX IF NOT EXISTS idx_timeline_events_developer_id ON timeline_events(developer_id);
CREATE INDEX IF NOT EXISTS idx_timeline_events_event_date ON timeline_events(event_date);

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para actualizar updated_at
CREATE TRIGGER update_developers_updated_at BEFORE UPDATE ON developers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_system_configs_updated_at BEFORE UPDATE ON system_configs
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Políticas de seguridad RLS (Row Level Security)
-- Habilitar RLS en las tablas
ALTER TABLE developers ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE timeline_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_configs ENABLE ROW LEVEL SECURITY;

-- Eliminar políticas antiguas si existen
DROP POLICY IF EXISTS "Allow all operations for authenticated users" ON developers;
DROP POLICY IF EXISTS "Allow all operations for authenticated users" ON projects;
DROP POLICY IF EXISTS "Allow all operations for authenticated users" ON timeline_events;
DROP POLICY IF EXISTS "Allow all operations for authenticated users" ON system_configs;
DROP POLICY IF EXISTS "Public access for all operations" ON developers;
DROP POLICY IF EXISTS "Public access for all operations" ON projects;
DROP POLICY IF EXISTS "Public access for all operations" ON timeline_events;
DROP POLICY IF EXISTS "Public access for all operations" ON system_configs;


-- Políticas para permitir acceso público (rol anon)
-- Esto es necesario porque la aplicación no tiene un sistema de login.
-- Para un entorno de producción, deberías restringir las operaciones de escritura a usuarios autenticados.
CREATE POLICY "Public access for all operations" ON developers
    FOR ALL TO anon, authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Public access for all operations" ON projects
    FOR ALL TO anon, authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Public access for all operations" ON timeline_events
    FOR ALL TO anon, authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Public access for all operations" ON system_configs
    FOR ALL TO anon, authenticated
    USING (true)
    WITH CHECK (true);
```

### 2. Configuración de credenciales

1. Ve a tu proyecto de Supabase > Settings > API
2. Copia la URL del proyecto y la clave anon/public
3. Abre el archivo `supabase.js`
4. Reemplaza las credenciales en las siguientes líneas:

```javascript
const SUPABASE_URL = 'TU_SUPABASE_URL_AQUI';
const SUPABASE_KEY = 'TU_SUPABASE_ANON_KEY_AQUI';
```

### 3. Configuración del servidor

#### Opción A: Servidor local con Python
```bash
# En el directorio del proyecto
python -m http.server 8000
```
Luego abre `http://localhost:8000` en tu navegador.

#### Opción B: Servidor local con Node.js
```bash
npx serve .
```

#### Opción C: VS Code Live Server
Instala la extensión "Live Server" y haz clic derecho en `index.html` > "Open with Live Server"

## 📊 Estructura de datos

### Desarrolladores (developers)
- `name`: Nombre completo
- `email`: Email único
- `level`: Junior/Semi-Senior/Senior
- `avatar_url`: URL del avatar
- `github_username`: Usuario de GitHub
- `skills`: Array de habilidades
- `hourly_rate`: Tarifa por hora
- `is_active`: Estado activo/inactivo

### Proyectos (projects)
- `name`: Nombre del proyecto
- `description`: Descripción
- `status`: planning/in_progress/completed/on_hold
- `priority`: A/B/C (A=Alta, B=Media, C=Baja)
- `progress`: Porcentaje de completado (0-100)
- `assigned_to`: ID del desarrollador asignado
- `due_date`: Fecha de vencimiento
- `estimated_hours`: Horas estimadas
- `actual_hours`: Horas reales trabajadas
- `tags`: Array de etiquetas
- `repository_url`: URL del repositorio

### Timeline Events (timeline_events)
- `event_type`: Tipo de evento
- `description`: Descripción del evento
- `project_id`: ID del proyecto relacionado
- `developer_id`: ID del desarrollador relacionado
- `metadata`: Datos adicionales en JSON

## 🎨 Funcionalidades

### Dashboard Principal
- **KPIs en tiempo real**: Proyectos en curso, completados y en riesgo
- **Gráfico de carga de trabajo**: Distribución de proyectos por desarrollador
- **Proyectos que requieren atención**: Lista automática de proyectos críticos

### Gestión de Proyectos
- **Vista de tarjetas**: Cada proyecto muestra estado, progreso y desarrollador asignado
- **Códigos de color por prioridad**: 
  - 🔴 Prioridad A (Magenta)
  - 🔵 Prioridad B (Cyan)
  - 🟡 Prioridad C (Amber)
- **Indicadores visuales**: Proyectos completados con borde verde
- **Información detallada**: Progreso, fechas de vencimiento, desarrollador asignado

### Timeline de Eventos
- Registro automático de cambios en proyectos
- Eventos de creación, actualización y eliminación
- Seguimiento de cambios de estado y progreso

## 🔧 Personalización

### Agregar nuevos desarrolladores
La aplicación creará automáticamente desarrolladores de ejemplo si no existen. Para agregar más:

1. Ve a Supabase > Table Editor > developers
2. Agrega nuevos registros manualmente, o
3. Usa las funciones de la API para crear programáticamente

### Personalizar estilos
Los estilos están definidos en el CSS del archivo HTML:
- Variables CSS en `:root` para colores principales
- Clases de Tailwind CSS para layout y componentes
- Efectos glassmorphism personalizados

### Configurar alertas
Los proyectos requieren atención automáticamente si:
- Vencen en menos de 7 días y tienen menos del 90% de progreso
- Están retrasados (fecha de vencimiento pasada)
- Tienen prioridad A y menos del 50% de progreso

## 🚨 Solución de problemas

### Error de conexión con Supabase
1. Verifica que las credenciales sean correctas
2. Asegúrate de que las políticas RLS permitan el acceso
3. Revisa la consola del navegador para errores específicos

### Los datos no se cargan
1. Verifica que las tablas existan en Supabase
2. Revisa que los triggers y funciones estén creados
3. Confirma que el archivo se esté sirviendo desde un servidor HTTP

### Problemas con módulos ES6
- Asegúrate de servir los archivos desde un servidor HTTP
- Los módulos ES6 no funcionan abriendo archivos directamente en el navegador

## 🔄 Actualización automática

La aplicación se actualiza automáticamente cada 5 minutos. También puedes forzar una actualización ejecutando:

```javascript
window.refreshData()
```

En la consola del navegador.

## 📝 Licencia

Este proyecto está disponible bajo la licencia MIT.
