# Guía de Configuración Completa - Project Grid

## 🎯 Resumen de Cambios Realizados

He transformado completamente tu aplicación para que use una base de datos real de Supabase en lugar de datos estáticos. Aquí están los principales cambios:

### ✅ Archivos Modificados/Creados:

1. **`supabase.js`** - Nueva implementación de API para Supabase
2. **`index.html`** - Actualizado para usar datos dinámicos
3. **`extensions.js`** - Funcionalidades adicionales (modales, formularios)
4. **`sample_data.sql`** - Datos de ejemplo para poblar la BD
5. **`README.md`** - Documentación completa
6. **`SETUP.md`** - Esta guía de configuración

## 🔧 Pasos de Configuración

### 1. Configurar Supabase

1. **Crear cuenta en Supabase**: Ve a [supabase.com](https://supabase.com) y crea una cuenta
2. **Crear nuevo proyecto**: 
   - Nombre: "ProjectGrid" (o el que prefieras)
   - Región: Escoge la más cercana a tu ubicación
   - Anota la contraseña de la base de datos

3. **Configurar las tablas**:
   - Ve a SQL Editor en Supabase
   - Copia y pega el contenido de `README.md` (sección de SQL)
   - Ejecuta el script para crear todas las tablas

4. **Obtener credenciales**:
   - Ve a Settings > API
   - Copia la "Project URL" y "anon public key"

### 2. Configurar las Credenciales

Abre el archivo `supabase.js` y reemplaza estas líneas:

```javascript
const SUPABASE_URL = 'TU_SUPABASE_URL_AQUI';
const SUPABASE_KEY = 'TU_SUPABASE_ANON_KEY_AQUI';
```

### 3. Poblar con Datos de Ejemplo (Opcional)

Si quieres datos de ejemplo para probar:
1. Ve al SQL Editor en Supabase
2. Copia y pega el contenido de `sample_data.sql`
3. Ejecuta el script

### 4. Servir la Aplicación

La aplicación debe ejecutarse desde un servidor HTTP (no abrir archivos directamente):

**Opción 1: Python**
```bash
cd ProjectsDevelopers
python -m http.server 8000
```
Abre: `http://localhost:8000`

**Opción 2: Node.js**
```bash
npx serve .
```

**Opción 3: VS Code Live Server**
- Instala la extensión "Live Server"
- Clic derecho en `index.html` > "Open with Live Server"

## 🚀 Nuevas Funcionalidades

### Dashboard Dinámico
- **KPIs en tiempo real**: Los números se actualizan automáticamente desde la BD
- **Gráfico de carga**: Muestra la distribución real de proyectos por desarrollador
- **Proyectos críticos**: Lista automática de proyectos que requieren atención

### Gestión de Proyectos
- **Crear proyecto**: Botón "Nuevo Proyecto" abre modal con formulario completo
- **Búsqueda en tiempo real**: El campo de búsqueda filtra proyectos instantáneamente
- **Estados dinámicos**: Los colores y estados se basan en datos reales

### Gestión de Desarrolladores
- **Agregar desarrollador**: Nuevo botón para agregar miembros del equipo
- **Avatares automáticos**: Se generan automáticamente basados en iniciales
- **Asignación automática**: Los proyectos se pueden asignar a desarrolladores reales

### Características Técnicas
- **Actualización automática**: Los datos se refrescan cada 5 minutos
- **Timeline de eventos**: Registro automático de cambios en proyectos
- **Políticas de seguridad**: RLS configurado en Supabase
- **Responsive design**: Funciona en móviles y escritorio

## 📊 Estructura de Datos

### Desarrolladores
```sql
- id: Identificador único
- name: Nombre completo
- email: Email único
- level: Junior/Semi-Senior/Senior/Lead
- avatar_url: URL del avatar
- github_username: Usuario de GitHub
- skills: Array de habilidades
- hourly_rate: Tarifa por hora
- is_active: Estado activo/inactivo
```

### Proyectos
```sql
- id: Identificador único
- name: Nombre del proyecto
- description: Descripción detallada
- status: planning/in_progress/on_hold/completed
- priority: A (Alta) / B (Media) / C (Baja)
- progress: Porcentaje completado (0-100)
- assigned_to: ID del desarrollador
- due_date: Fecha de vencimiento
- estimated_hours: Horas estimadas
- actual_hours: Horas trabajadas
- tags: Etiquetas del proyecto
- repository_url: URL del repositorio
```

### Timeline Events
```sql
- event_type: Tipo de evento
- description: Descripción del cambio
- project_id: Proyecto relacionado
- developer_id: Desarrollador relacionado
- metadata: Datos adicionales en JSON
```

## 🎮 Cómo Usar la Aplicación

### Primera vez:
1. La aplicación detectará que no hay datos
2. Creará automáticamente desarrolladores y proyectos de ejemplo
3. Estos datos se guardarán en Supabase

### Crear nuevo proyecto:
1. Clic en "Nuevo Proyecto"
2. Llena el formulario
3. Selecciona desarrollador asignado
4. Guarda

### Agregar desarrollador:
1. Clic en el botón "Desarrollador" 
2. Completa la información
3. Las habilidades se agregan separadas por comas
4. Se genera automáticamente un avatar

### Buscar proyectos:
1. Usa la barra de búsqueda en la parte superior
2. Busca por nombre o descripción
3. Los resultados se filtran en tiempo real

## 🔍 Funciones Disponibles

### En la Consola del Navegador:
```javascript
// Refrescar datos manualmente
window.refreshData()

// Abrir modal de nuevo proyecto
ProjectGridExtensions.showCreateProjectModal()

// Abrir modal de nuevo desarrollador  
ProjectGridExtensions.showCreateDeveloperModal()

// Filtrar por estado
ProjectGridExtensions.filterProjectsByStatus('in_progress')

// Filtrar por prioridad
ProjectGridExtensions.filterProjectsByPriority('A')

// Buscar proyectos
ProjectGridExtensions.searchProjects('API')

// Cambiar tema
ProjectGridExtensions.toggleTheme()
```

## 🔧 Personalización

### Cambiar colores de prioridad:
Edita las variables CSS en `index.html`:
```css
:root {
    --glow-cyan: 0 0 5px #06b6d4;    /* Prioridad B */
    --glow-magenta: 0 0 5px #d946ef;  /* Prioridad A */
    --glow-amber: 0 0 5px #f59e0b;    /* Prioridad C */
}
```

### Agregar nuevos estados:
1. Modifica la tabla `system_configs` en Supabase
2. Actualiza las funciones en `supabase.js`
3. Ajusta los estilos en `index.html`

### Configurar notificaciones:
Edita la configuración en la tabla `system_configs`:
```sql
UPDATE system_configs 
SET config_value = '{"email": true, "push": true, "slack": false}'
WHERE config_key = 'notification_settings';
```

## 🐛 Solución de Problemas

### Error: "Cannot resolve module"
- Asegúrate de servir desde un servidor HTTP
- Los módulos ES6 no funcionan con archivos locales

### Error: "Invalid API key"
- Verifica las credenciales en `supabase.js`
- Usa la clave "anon public", no la "service role"

### Error: "Row Level Security"
- Verifica que las políticas RLS estén configuradas
- Revisa que el usuario tenga permisos

### Los datos no se cargan:
- Abre las herramientas de desarrollador (F12)
- Revisa la pestaña Console para errores
- Verifica la pestaña Network para requests fallidos

### Datos de ejemplo no aparecen:
- Ejecuta manualmente `sample_data.sql` en Supabase
- O espera a que la app cree datos automáticamente

## 🔄 Actualización y Mantenimiento

### Backup de datos:
```sql
-- Exportar desarrolladores
SELECT * FROM developers;

-- Exportar proyectos  
SELECT * FROM projects;

-- Exportar timeline
SELECT * FROM timeline_events;
```

### Limpiar datos de prueba:
```sql
-- CUIDADO: Esto borra todos los datos
DELETE FROM timeline_events;
DELETE FROM projects;
DELETE FROM developers;
DELETE FROM system_configs;
```

### Actualizar aplicación:
1. Descarga nuevas versiones de los archivos
2. Mantén tus credenciales en `supabase.js`
3. Ejecuta nuevas migraciones SQL si las hay

## 📞 Soporte

Si tienes problemas:
1. Revisa la consola del navegador (F12)
2. Verifica la configuración de Supabase
3. Confirma que el servidor HTTP está corriendo
4. Revisa que las credenciales sean correctas

¡Tu aplicación ahora está completamente integrada con Supabase y lista para usar en producción! 🎉
