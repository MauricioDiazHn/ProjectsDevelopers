# Sistema de Autenticación - Project Grid

## 📋 Resumen

He creado un sistema completo de autenticación para tu aplicación Project Grid que incluye:

1. **Página de Login** (`login.html`)
2. **Página de Registro** (`register.html`)
3. **Políticas de seguridad actualizadas** en Supabase
4. **Protección de rutas** en la aplicación principal

## 🔐 Características del Sistema

### Login (`login.html`)
- **Diseño consistente** con la temática glassmorphism de tu app
- **Formulario seguro** con validación de email y contraseña
- **Mostrar/ocultar contraseña** con toggle visual
- **Recordar sesión** con checkbox para persistencia
- **Mensajes de error** específicos para diferentes problemas
- **Modo demo** para acceso sin autenticación
- **Redirección automática** al dashboard tras login exitoso

### Registro (`register.html`)
- **Formulario completo** con nombre, email, nivel y contraseña
- **Indicador de fortaleza** de contraseña en tiempo real
- **Confirmación de contraseña** con validación visual
- **Selección de nivel** de desarrollador (Junior, Senior, etc.)
- **Términos y condiciones** obligatorios
- **Creación automática** del perfil de desarrollador
- **Modo demo** disponible también

### Protección de la Aplicación Principal
- **Verificación automática** de autenticación al cargar
- **Redirección al login** si no está autenticado
- **Botón de cerrar sesión** para usuarios autenticados
- **Modo demo** que bypassa la autenticación

## 🚀 Configuración en Supabase

### Paso 1: Ejecutar Script de Políticas

Ve a tu **SQL Editor** en Supabase y ejecuta el archivo `update_auth_policies.sql`:

```sql
-- Este script actualiza las políticas para permitir:
-- ✅ Lectura para todos (anon + authenticated)
-- ✅ Escritura para todos (para modo demo)
-- ✅ Actualización/eliminación solo para autenticados
```

### Paso 2: Configurar Email (Opcional)

Si quieres emails de confirmación:

1. Ve a **Authentication > Settings**
2. Configura tu **SMTP provider**
3. Personaliza los **email templates**

Por ahora, la app funciona sin confirmación de email.

## 📱 Flujos de Usuario

### Usuario Nuevo
1. **Visita `index.html`** → Redirigido a `login.html`
2. **Clic en "Regístrate"** → Va a `register.html`
3. **Completa formulario** → Cuenta creada + perfil de desarrollador
4. **Redirección automática** a `login.html`
5. **Inicia sesión** → Acceso al dashboard

### Usuario Existente
1. **Visita `index.html`** → Redirigido a `login.html`
2. **Inicia sesión** → Acceso al dashboard
3. **Botón "Cerrar Sesión"** visible en el header

### Usuario Demo
1. **Visita `login.html` o `register.html`**
2. **Clic en "Acceso de demostración"** → Directo al dashboard
3. **Sin botón de cerrar sesión** (es modo demo)

## 🎨 Diseño y Estilo

### Consistencia Visual
- **Mismos colores** y efectos glassmorphism
- **Iconos Lucide** consistentes
- **Animaciones suaves** para transiciones
- **Responsive design** para móviles

### Temas de Color
- **Login**: Tema cyan (azul) como la app principal
- **Registro**: Tema magenta (rosa) para diferenciación
- **Efectos glow** en botones principales

### UX/UI Features
- **Estados de carga** con spinners
- **Validación en tiempo real** de contraseñas
- **Mensajes de error** específicos y útiles
- **Auto-hide** de mensajes después de 5 segundos

## 🔧 Configuración de Archivos

### Archivos Creados
- `login.html` - Página de inicio de sesión
- `register.html` - Página de registro
- `update_auth_policies.sql` - Script de políticas de Supabase
- `AUTH_GUIDE.md` - Esta documentación

### Archivos Modificados
- `index.html` - Agregada verificación de auth + botón logout
- `README.md` - Políticas de seguridad actualizadas

### Dependencias
- Usa las mismas librerías que tu app principal
- Importa funciones de `supabase.js`
- No requiere instalaciones adicionales

## 📊 Políticas de Seguridad

### Estructura de Permisos

| Tabla | Lectura | Inserción | Actualización | Eliminación |
|-------|---------|-----------|---------------|-------------|
| developers | Todos | Todos | Solo auth | Solo auth |
| projects | Todos | Todos | Solo auth | Solo auth |
| timeline_events | Todos | Todos | Solo auth | Solo auth |
| system_configs | Todos | Solo auth | Solo auth | Solo auth |

### Explicación
- **Lectura libre**: Para que funcione el modo demo
- **Inserción libre**: Para crear datos en modo demo
- **Modificación restringida**: Solo usuarios autenticados pueden editar/eliminar

## 🚦 Testing y Validación

### Pruebas Recomendadas

1. **Registro de usuario nuevo**
   - Completar formulario con datos válidos
   - Verificar que se cree cuenta en Supabase
   - Confirmar creación de perfil de desarrollador

2. **Login con credenciales correctas**
   - Usar email/password del registro
   - Verificar redirección al dashboard
   - Confirmar que aparece botón "Cerrar Sesión"

3. **Login con credenciales incorrectas**
   - Verificar mensaje de error apropiado
   - Confirmar que no se permite acceso

4. **Modo demo**
   - Clic en "Acceso de demostración"
   - Verificar acceso directo al dashboard
   - Confirmar que NO aparece botón "Cerrar Sesión"

5. **Protección de rutas**
   - Visitar `index.html` sin estar autenticado
   - Verificar redirección automática a login

## 🔄 Flujo de Desarrollo

### Para Desarrollo (Actual)
- **Políticas permisivas** - Lectura/escritura para todos
- **Modo demo** disponible
- **No requiere confirmación** de email

### Para Producción (Futuro)
- **Políticas restrictivas** - Solo usuarios autenticados
- **Confirmación de email** obligatoria
- **Modo demo deshabilitado**

## 🔧 Personalización

### Cambiar Colores de Tema
```css
/* En login.html - cambiar tema cyan */
:root {
    --glow-cyan: 0 0 5px #tu-color;
}

/* En register.html - cambiar tema magenta */
:root {
    --glow-magenta: 0 0 5px #tu-color;
}
```

### Agregar Campos al Registro
1. Agregar input en `register.html`
2. Modificar función `createDeveloper()` 
3. Actualizar tabla `developers` si es necesario

### Personalizar Mensajes de Error
- Editar las condiciones en los archivos `.html`
- Función `showError()` maneja la visualización

## 🚨 Troubleshooting

### Error: "Invalid login credentials"
- **Causa**: Email/password incorrectos
- **Solución**: Verificar credenciales o crear nueva cuenta

### Error: "User already registered"
- **Causa**: Email ya existe en Supabase
- **Solución**: Usar login en lugar de registro

### Error: "Row level security policy"
- **Causa**: Políticas no actualizadas
- **Solución**: Ejecutar `update_auth_policies.sql`

### App redirige al login constantemente
- **Causa**: Funciones de auth no importadas correctamente
- **Solución**: Verificar imports en `index.html`

## 📞 Próximos Pasos

1. **Ejecuta** `update_auth_policies.sql` en Supabase
2. **Prueba** el registro de un usuario nuevo
3. **Verifica** que el login funcione correctamente
4. **Testa** el modo demo
5. **Personaliza** mensajes/colores si deseas

¡Tu sistema de autenticación está listo! 🎉
