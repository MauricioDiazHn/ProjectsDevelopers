// Configuración de Supabase para la aplicación de gestión de proyectos

// Configuración de Supabase usando variables de entorno con fallback
const SUPABASE_URL = 'https://mawrtjphpdnivenkydha.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1hd3J0anBocGRuaXZlbmt5ZGhhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY1MDQwMTEsImV4cCI6MjA3MjA4MDAxMX0.UWxn1Pod50mCgRAv_jabuP6qs4t2-sEWosSk3uwNNws';

// Esperar a que se cargue Supabase y luego inicializar cliente
let supabaseClient;

function initializeSupabase() {
    if (typeof window !== 'undefined' && window.supabase) {
        supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);
        return true;
    }
    return false;
}

// Función auxiliar para asegurar que Supabase esté inicializado
async function ensureSupabaseReady() {
    if (supabaseClient) return supabaseClient;
    
    // Intentar inicializar
    if (initializeSupabase()) {
        return supabaseClient;
    }
    
    // Si no está disponible, esperar un poco y volver a intentar
    return new Promise((resolve, reject) => {
        let attempts = 0;
        const maxAttempts = 50; // 5 segundos máximo
        
        const checkSupabase = () => {
            if (initializeSupabase()) {
                resolve(supabaseClient);
            } else if (attempts < maxAttempts) {
                attempts++;
                setTimeout(checkSupabase, 100);
            } else {
                reject(new Error('Supabase no se pudo cargar después de múltiples intentos'));
            }
        };
        
        checkSupabase();
    });
}

// ==== AUTENTICACIÓN ====

// Iniciar sesión con email y contraseña
async function signIn(email, password) {
  const client = await ensureSupabaseReady();
  const { data, error } = await client.auth.signInWithPassword({
    email,
    password
  });
  
  if (error) throw error;
  await saveSessionToStorage(data.session);
  return data.user;
}

// Registrar nuevo usuario
async function signUp(email, password) {
  const client = await ensureSupabaseReady();
  const { data, error } = await client.auth.signUp({
    email,
    password
  });
  
  if (error) throw error;
  if (data.session) await saveSessionToStorage(data.session);
  return data.user;
}

// Cerrar sesión
async function signOut() {
  const client = await ensureSupabaseReady();
  const { error } = await client.auth.signOut();
  if (error) throw error;
  sessionStorage.removeItem('supabase.auth.token');
  localStorage.removeItem('supabase.auth.token');
  return true;
}

// Obtener el usuario actual
async function getCurrentUser() {
  const client = await ensureSupabaseReady();
  const { data, error } = await client.auth.getUser();
  if (error) return null;
  return data.user;
}

// Verificar si el usuario está autenticado
async function isAuthenticated() {
  const user = await getCurrentUser();
  return user !== null;
}

// Almacenar sesión para persistencia
async function saveSessionToStorage(session) {
  if (session) {
    localStorage.setItem('supabase.auth.token', JSON.stringify(session));
  }
}

// ==== MANEJO DE DESARROLLADORES ====

// Obtener todos los desarrolladores
async function getDevelopers() {
  const client = await ensureSupabaseReady();
  const { data, error } = await client
    .from('developers')
    .select('*')
    .order('created_at', { ascending: true });
  
  if (error) throw error;
  return data || [];
}

// Obtener un desarrollador por ID
async function getDeveloperById(id) {
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('developers')
    .select('*')
    .eq('id', id)
    .single();
  
  if (error) throw error;
  return data;
}

// Crear un nuevo desarrollador
async function createDeveloper(developerData) {
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('developers')
    .insert(developerData)
    .select()
    .single();
  
  if (error) throw error;
  return data;
}

// Actualizar desarrollador
async function updateDeveloper(id, updates) {
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('developers')
    .update(updates)
    .eq('id', id)
    .select()
    .single();
  
  if (error) throw error;
  return data;
}

// Eliminar desarrollador
async function deleteDeveloper(id) {
  const client = await ensureSupabaseReady(); const { error } = await client
    .from('developers')
    .delete()
    .eq('id', id);
  
  if (error) throw error;
  return true;
}

// ==== MANEJO DE PROYECTOS ====

// Obtener todos los proyectos con información del desarrollador asignado
async function getProjects() {
  const client = await ensureSupabaseReady();
  const { data, error } = await client
    .from('projects')
    .select(`
      *,
      developers(
        id,
        name
      )
    `)
    .order('created_at', { ascending: false });
  
  if (error) throw error;
  return data || [];
}

// Obtener un proyecto por ID
async function getProjectById(id) {
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('projects')
    .select(`
      *,
      developers(
        id,
        name
      )
    `)
    .eq('id', id)
    .single();
  
  if (error) throw error;
  return data;
}

// Crear un nuevo proyecto
async function createProject(projectData) {
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('projects')
    .insert(projectData)
    .select()
    .single();
  
  if (error) throw error;
  
  // Crear evento en el timeline
  await createTimelineEvent({
    event_type: 'project_created',
    description: `Proyecto "${projectData.name}" creado`,
    project_id: data.id,
    developer_id: projectData.assigned_to
  });
  
  return data;
}

// Actualizar proyecto
async function updateProject(id, updates) {
  // Obtener el proyecto actual para comparar cambios
  const currentProject = await getProjectById(id);
  
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('projects')
    .update(updates)
    .eq('id', id)
    .select()
    .single();
  
  if (error) throw error;
  
  // Crear eventos en el timeline según los cambios
  if (updates.status && updates.status !== currentProject.status) {
    await createTimelineEvent({
      event_type: 'status_change',
      description: `Estado cambiado de "${currentProject.status}" a "${updates.status}"`,
      project_id: id,
      developer_id: updates.assigned_to || currentProject.assigned_to
    });
  }
  
  if (updates.progress && updates.progress !== currentProject.progress) {
    await createTimelineEvent({
      event_type: 'progress_update',
      description: `Progreso actualizado del ${currentProject.progress}% al ${updates.progress}%`,
      project_id: id,
      developer_id: updates.assigned_to || currentProject.assigned_to
    });
  }
  
  if (updates.assigned_to && updates.assigned_to !== currentProject.assigned_to) {
    await createTimelineEvent({
      event_type: 'assignment_change',
      description: `Proyecto reasignado`,
      project_id: id,
      developer_id: updates.assigned_to
    });
  }
  
  return data;
}

// Eliminar proyecto
async function deleteProject(id) {
  const project = await getProjectById(id);
  
  const client = await ensureSupabaseReady(); const { error } = await client
    .from('projects')
    .delete()
    .eq('id', id);
  
  if (error) throw error;
  
  // Crear evento en el timeline
  await createTimelineEvent({
    event_type: 'project_deleted',
    description: `Proyecto "${project.name}" eliminado`,
    project_id: null,
    developer_id: project.assigned_to
  });
  
  return true;
}

// Obtener proyectos por desarrollador
async function getProjectsByDeveloper(developerId) {
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('projects')
    .select('*')
    .eq('assigned_to', developerId)
    .order('created_at', { ascending: false });
  
  if (error) throw error;
  return data || [];
}

// Obtener proyectos por estado
async function getProjectsByStatus(status) {
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('projects')
    .select(`
      *,
      developers(
        id,
        name
      )
    `)
    .eq('status', status)
    .order('created_at', { ascending: false });
  
  if (error) throw error;
  return data || [];
}

// Obtener proyectos por prioridad
async function getProjectsByPriority(priority) {
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('projects')
    .select(`
      *,
      developers(
        id,
        name
      )
    `)
    .eq('priority', priority)
    .order('created_at', { ascending: false });
  
  if (error) throw error;
  return data || [];
}

// Buscar proyectos por nombre
async function searchProjects(query) {
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('projects')
    .select(`
      *,
      developers(
        id,
        name
      )
    `)
    .ilike('name', `%${query}%`)
    .order('created_at', { ascending: false });
  
  if (error) throw error;
  return data || [];
}

// ==== MANEJO DE TIMELINE ====

// Crear evento en el timeline
async function createTimelineEvent(eventData) {
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('timeline_events')
    .insert(eventData)
    .select()
    .single();
  
  if (error) throw error;
  return data;
}

// Obtener eventos del timeline
async function getTimelineEvents(limit = 50) {
  const client = await ensureSupabaseReady();
  const { data, error } = await client
    .from('timeline_events')
    .select(`
      *,
      projects(name),
      developers(name)
    `)
    .order('event_date', { ascending: false })
    .limit(limit);
  
  if (error) throw error;
  return data || [];
}

// Obtener eventos del timeline por proyecto
async function getTimelineEventsByProject(projectId) {
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('timeline_events')
    .select(`
      *,
      developers(name)
    `)
    .eq('project_id', projectId)
    .order('event_date', { ascending: false });
  
  if (error) throw error;
  return data || [];
}

// ==== ESTADÍSTICAS Y DASHBOARD ====

// Obtener estadísticas del dashboard
async function getDashboardStats() {
  try {
    // Obtener todos los proyectos
    const projects = await getProjects();
    
    // Calcular estadísticas
    const stats = {
      totalProjects: projects.length,
      inProgress: projects.filter(p => p.status === 'in_progress').length,
      completed: projects.filter(p => p.status === 'completed').length,
      atRisk: projects.filter(p => {
        const dueDate = new Date(p.due_date);
        const today = new Date();
        const daysUntilDue = Math.ceil((dueDate - today) / (1000 * 60 * 60 * 24));
        return daysUntilDue <= 7 && p.status !== 'completed' && p.progress < 90;
      }).length,
      highPriority: projects.filter(p => p.priority === 'A').length,
      mediumPriority: projects.filter(p => p.priority === 'B').length,
      lowPriority: projects.filter(p => p.priority === 'C').length
    };
    
    return stats;
  } catch (error) {
    console.error('Error obteniendo estadísticas:', error);
    throw error;
  }
}

// Obtener carga de trabajo por desarrollador
async function getWorkloadByDeveloper() {
  try {
    const developers = await getDevelopers();
    const projects = await getProjects();
    
    const workload = developers.map(dev => {
      const assignedProjects = projects.filter(p => p.assigned_to === dev.id);
      const activeProjects = assignedProjects.filter(p => p.status !== 'completed');
      
      return {
        developer: dev,
        totalProjects: assignedProjects.length,
        activeProjects: activeProjects.length,
        completedProjects: assignedProjects.filter(p => p.status === 'completed').length,
        averageProgress: activeProjects.length > 0 
          ? Math.round(activeProjects.reduce((sum, p) => sum + p.progress, 0) / activeProjects.length)
          : 0
      };
    });
    
    return workload;
  } catch (error) {
    console.error('Error obteniendo carga de trabajo:', error);
    throw error;
  }
}

// Obtener proyectos que requieren atención
async function getProjectsRequiringAttention() {
  try {
    const projects = await getProjects();
    const today = new Date();
    
    const projectsAtRisk = projects.filter(p => {
      if (p.status === 'completed') return false;
      
      const dueDate = new Date(p.due_date);
      const daysUntilDue = Math.ceil((dueDate - today) / (1000 * 60 * 60 * 24));
      
      // Proyecto requiere atención si:
      // - Vence en menos de 7 días y progreso < 90%
      // - Está retrasado (fecha de vencimiento pasada)
      // - Prioridad A y progreso < 50%
      return (daysUntilDue <= 7 && p.progress < 90) ||
             (daysUntilDue < 0) ||
             (p.priority === 'A' && p.progress < 50);
    });
    
    return projectsAtRisk.sort((a, b) => {
      const dueDateA = new Date(a.due_date);
      const dueDateB = new Date(b.due_date);
      return dueDateA - dueDateB;
    });
  } catch (error) {
    console.error('Error obteniendo proyectos que requieren atención:', error);
    throw error;
  }
}

// ==== CONFIGURACIONES DEL SISTEMA ====

// Obtener configuración del sistema
async function getSystemConfig(key) {
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('system_configs')
    .select('config_value')
    .eq('config_key', key)
    .single();
  
  if (error) {
    if (error.code === 'PGRST116') return null; // No encontrado
    throw error;
  }
  
  return data.config_value;
}

// Establecer configuración del sistema
async function setSystemConfig(key, value, description = null) {
  const client = await ensureSupabaseReady(); const { data, error } = await client
    .from('system_configs')
    .upsert({
      config_key: key,
      config_value: value,
      description: description
    })
    .select()
    .single();
  
  if (error) throw error;
  return data;
}

// ==== UTILIDADES ====

// Función para generar avatar basado en las iniciales
function generateAvatar(name) {
  const initials = name.split(' ').map(word => word.charAt(0)).join('').substring(0, 2).toUpperCase();
  const colors = ['818cf8', 'f472b6', '34d399', 'f97316', '0ea5e9', '8b5cf6', '10b981', 'ef4444', '22c55e', '3b82f6'];
  const randomColor = colors[Math.floor(Math.random() * colors.length)];
  return `https://placehold.co/64x64/${randomColor}/ffffff?text=${initials}`;
}

// Función para calcular días hasta la fecha de vencimiento
function getDaysUntilDue(dueDate) {
  const today = new Date();
  const due = new Date(dueDate);
  const diffTime = due - today;
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
}

// Función para obtener el estado de un proyecto basado en progreso y fecha
function getProjectStatus(project) {
  const daysUntilDue = getDaysUntilDue(project.due_date);
  
  if (project.progress === 100) return 'completed';
  if (daysUntilDue < 0) return 'overdue';
  if (daysUntilDue <= 3 && project.progress < 80) return 'at_risk';
  if (project.progress > 0) return 'in_progress';
  return 'planning';
}

// Exportar todas las funciones
export {
  // Autenticación
  signIn,
  signUp,
  signOut,
  getCurrentUser,
  isAuthenticated,
  
  // Desarrolladores
  getDevelopers,
  getDeveloperById,
  createDeveloper,
  updateDeveloper,
  deleteDeveloper,
  
  // Proyectos
  getProjects,
  getProjectById,
  createProject,
  updateProject,
  deleteProject,
  getProjectsByDeveloper,
  getProjectsByStatus,
  getProjectsByPriority,
  searchProjects,
  
  // Timeline
  createTimelineEvent,
  getTimelineEvents,
  getTimelineEventsByProject,
  
  // Dashboard y estadísticas
  getDashboardStats,
  getWorkloadByDeveloper,
  getProjectsRequiringAttention,
  
  // Configuraciones
  getSystemConfig,
  setSystemConfig,
  
  // Utilidades
  generateAvatar,
  getDaysUntilDue,
  getProjectStatus,
  
  // Función para obtener cliente de Supabase
  ensureSupabaseReady
};
