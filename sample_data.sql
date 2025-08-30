-- Datos de ejemplo para la aplicación Project Grid
-- Ejecutar después de crear las tablas principales

-- Insertar desarrolladores de ejemplo
INSERT INTO developers (name, email, level, avatar_url, github_username, skills, hourly_rate, is_active) VALUES
('Ana Cardenas', 'ana.cardenas@company.com', 'Senior', 'https://placehold.co/64x64/d946ef/ffffff?text=AC', 'anacardenas', ARRAY['React', 'Node.js', 'TypeScript', 'PostgreSQL', 'Docker'], 85.00, true),
('Luis Martinez', 'luis.martinez@company.com', 'Semi-Senior', 'https://placehold.co/64x64/06b6d4/ffffff?text=LM', 'luismartinez', ARRAY['Vue.js', 'Python', 'Django', 'Docker', 'AWS'], 65.00, true),
('David Rodriguez', 'david.rodriguez@company.com', 'Junior', 'https://placehold.co/64x64/f59e0b/ffffff?text=DR', 'davidrodriguez', ARRAY['JavaScript', 'HTML', 'CSS', 'React'], 45.00, true),
('Sofia Chen', 'sofia.chen@company.com', 'Senior', 'https://placehold.co/64x64/10b981/ffffff?text=SC', 'sofiachen', ARRAY['PHP', 'Laravel', 'MySQL', 'Redis', 'Kubernetes'], 80.00, true),
('Miguel Torres', 'miguel.torres@company.com', 'Lead', 'https://placehold.co/64x64/8b5cf6/ffffff?text=MT', 'migueltorres', ARRAY['Java', 'Spring Boot', 'Microservices', 'DevOps', 'Terraform'], 120.00, true);

-- Insertar proyectos de ejemplo
INSERT INTO projects (name, description, status, priority, progress, assigned_to, due_date, start_date, estimated_hours, actual_hours, tags, repository_url) VALUES
('QuantumCore API', 'API principal del sistema QuantumCore con autenticación JWT y arquitectura de microservicios', 'in_progress', 'A', 75, 1, '2025-09-15', '2025-08-01', 120, 90, ARRAY['API', 'Backend', 'Critical', 'Microservices'], 'https://github.com/company/quantumcore-api'),

('Helios Dashboard UI', 'Interfaz de usuario moderna para el dashboard administrativo usando React y Tailwind CSS', 'in_progress', 'A', 95, 2, '2025-09-05', '2025-07-20', 80, 76, ARRAY['Frontend', 'UI/UX', 'React', 'Dashboard'], 'https://github.com/company/helios-dashboard'),

('Orion Analytics Engine', 'Motor de análisis de datos en tiempo real con procesamiento de streams y machine learning', 'planning', 'B', 40, 1, '2025-10-01', '2025-08-15', 200, 80, ARRAY['Analytics', 'Backend', 'ML', 'Data Processing'], 'https://github.com/company/orion-analytics'),

('CI/CD Pipeline Jenkins', 'Configuración completa de pipeline de CI/CD con Jenkins, Docker y despliegue automático', 'completed', 'C', 100, 2, '2025-08-25', '2025-08-10', 40, 35, ARRAY['DevOps', 'Automation', 'Jenkins', 'Docker'], 'https://github.com/company/cicd-pipeline'),

('NexusAuth v2.1 Patch', 'Actualización de seguridad crítica para el sistema de autenticación con OAuth 2.0', 'in_progress', 'A', 60, 3, '2025-09-03', '2025-08-20', 60, 36, ARRAY['Security', 'Authentication', 'Critical', 'OAuth'], 'https://github.com/company/nexusauth'),

('Client Onboarding Module', 'Módulo de incorporación de clientes con workflows automatizados y notificaciones', 'planning', 'B', 25, 3, '2025-10-20', '2025-09-01', 100, 25, ARRAY['Frontend', 'Workflows', 'CRM'], 'https://github.com/company/client-onboarding'),

('E-commerce RecSys', 'Sistema de recomendaciones para plataforma e-commerce basado en IA y comportamiento de usuario', 'in_progress', 'B', 80, 1, '2025-09-22', '2025-07-15', 150, 120, ARRAY['AI', 'Recommendations', 'E-commerce', 'ML'], 'https://github.com/company/ecommerce-recsys'),

('QuantumLeap DB Migration', 'Migración crítica de base de datos legacy a PostgreSQL con mantenimiento de datos históricos', 'in_progress', 'A', 45, 2, '2025-09-01', '2025-08-05', 80, 36, ARRAY['Database', 'Migration', 'Critical', 'PostgreSQL'], 'https://github.com/company/quantumleap-migration'),

('Mobile App iOS', 'Aplicación móvil nativa para iOS con sincronización offline y notificaciones push', 'planning', 'B', 15, 4, '2025-11-15', '2025-09-15', 180, 27, ARRAY['iOS', 'Mobile', 'Swift', 'Offline'], 'https://github.com/company/mobile-ios'),

('Security Audit Platform', 'Plataforma automatizada de auditoría de seguridad con reportes en tiempo real', 'in_progress', 'A', 65, 5, '2025-09-30', '2025-08-01', 160, 104, ARRAY['Security', 'Automation', 'Audit', 'Reports'], 'https://github.com/company/security-audit'),

('Legacy System Refactor', 'Refactorización completa del sistema legacy PHP a arquitectura moderna con Node.js', 'planning', 'B', 30, 5, '2025-12-01', '2025-09-20', 300, 90, ARRAY['Refactoring', 'Legacy', 'Node.js', 'Architecture'], 'https://github.com/company/legacy-refactor'),

('API Gateway Implementation', 'Implementación de API Gateway con rate limiting, autenticación y monitoreo', 'on_hold', 'C', 55, 2, '2025-10-10', '2025-08-25', 70, 38, ARRAY['API Gateway', 'Infrastructure', 'Rate Limiting'], 'https://github.com/company/api-gateway');

-- Insertar eventos del timeline
INSERT INTO timeline_events (event_type, description, project_id, developer_id, metadata) VALUES
('project_created', 'Proyecto "QuantumCore API" creado', 1, 1, '{"initial_priority": "A", "estimated_duration": "120 hours"}'),
('assignment_change', 'Proyecto asignado a Ana Cardenas', 1, 1, '{"previous_assignee": null}'),
('progress_update', 'Progreso actualizado del 0% al 25%', 1, 1, '{"previous_progress": 0, "new_progress": 25}'),
('progress_update', 'Progreso actualizado del 25% al 50%', 1, 1, '{"previous_progress": 25, "new_progress": 50}'),
('progress_update', 'Progreso actualizado del 50% al 75%', 1, 1, '{"previous_progress": 50, "new_progress": 75}'),

('project_created', 'Proyecto "Helios Dashboard UI" creado', 2, 2, '{"initial_priority": "A", "estimated_duration": "80 hours"}'),
('progress_update', 'Progreso actualizado del 0% al 95%', 2, 2, '{"previous_progress": 0, "new_progress": 95}'),
('status_change', 'Estado cambiado de "planning" a "in_progress"', 2, 2, '{"previous_status": "planning", "new_status": "in_progress"}'),

('project_created', 'Proyecto "CI/CD Pipeline Jenkins" creado', 4, 2, '{"initial_priority": "C", "estimated_duration": "40 hours"}'),
('status_change', 'Estado cambiado de "in_progress" a "completed"', 4, 2, '{"previous_status": "in_progress", "new_status": "completed"}'),
('progress_update', 'Progreso actualizado del 90% al 100%', 4, 2, '{"previous_progress": 90, "new_progress": 100}'),

('project_created', 'Proyecto "NexusAuth v2.1 Patch" creado', 5, 3, '{"initial_priority": "A", "estimated_duration": "60 hours"}'),
('status_change', 'Estado cambiado de "planning" a "in_progress"', 5, 3, '{"previous_status": "planning", "new_status": "in_progress"}'),
('progress_update', 'Progreso actualizado del 30% al 60%', 5, 3, '{"previous_progress": 30, "new_progress": 60}'),

('project_created', 'Proyecto "Security Audit Platform" creado', 10, 5, '{"initial_priority": "A", "estimated_duration": "160 hours"}'),
('assignment_change', 'Proyecto asignado a Miguel Torres', 10, 5, '{"previous_assignee": null}'),
('progress_update', 'Progreso actualizado del 40% al 65%', 10, 5, '{"previous_progress": 40, "new_progress": 65}'),

('status_change', 'Proyecto "API Gateway Implementation" puesto en espera', 12, 2, '{"previous_status": "in_progress", "new_status": "on_hold", "reason": "Waiting for infrastructure approval"}');

-- Insertar configuraciones del sistema
INSERT INTO system_configs (config_key, config_value, description) VALUES
('app_name', '"Project Grid Dashboard"', 'Nombre de la aplicación'),
('version', '"1.0.0"', 'Versión actual de la aplicación'),
('max_projects_per_developer', '5', 'Máximo número de proyectos activos por desarrollador'),
('default_project_priority', '"B"', 'Prioridad por defecto para nuevos proyectos'),
('notification_settings', '{"email": true, "push": false, "slack": true}', 'Configuración de notificaciones'),
('working_hours_per_day', '8', 'Horas de trabajo por día para cálculos'),
('currency', '"USD"', 'Moneda para tarifas y presupuestos'),
('timezone', '"America/Mexico_City"', 'Zona horaria del equipo'),
('project_statuses', '["planning", "in_progress", "on_hold", "completed", "cancelled"]', 'Estados disponibles para proyectos'),
('developer_levels', '["Junior", "Semi-Senior", "Senior", "Lead", "Principal"]', 'Niveles disponibles para desarrolladores');

-- Consultas útiles para verificar los datos

-- Ver resumen de proyectos por desarrollador
-- SELECT 
--     d.name as developer_name,
--     d.level,
--     COUNT(p.id) as total_projects,
--     COUNT(CASE WHEN p.status = 'in_progress' THEN 1 END) as active_projects,
--     COUNT(CASE WHEN p.status = 'completed' THEN 1 END) as completed_projects,
--     ROUND(AVG(CASE WHEN p.status != 'completed' THEN p.progress END), 2) as avg_progress
-- FROM developers d
-- LEFT JOIN projects p ON d.id = p.assigned_to
-- GROUP BY d.id, d.name, d.level
-- ORDER BY active_projects DESC;

-- Ver proyectos que requieren atención
-- SELECT 
--     p.name,
--     p.priority,
--     p.progress,
--     p.due_date,
--     d.name as assigned_developer,
--     CASE 
--         WHEN p.due_date < CURRENT_DATE THEN 'OVERDUE'
--         WHEN p.due_date <= CURRENT_DATE + INTERVAL '7 days' AND p.progress < 90 THEN 'AT_RISK'
--         WHEN p.priority = 'A' AND p.progress < 50 THEN 'PRIORITY_BEHIND'
--         ELSE 'OK'
--     END as status_alert
-- FROM projects p
-- LEFT JOIN developers d ON p.assigned_to = d.id
-- WHERE p.status != 'completed'
--   AND (
--     p.due_date < CURRENT_DATE 
--     OR (p.due_date <= CURRENT_DATE + INTERVAL '7 days' AND p.progress < 90)
--     OR (p.priority = 'A' AND p.progress < 50)
--   )
-- ORDER BY p.due_date;

-- Ver timeline reciente
-- SELECT 
--     te.event_date,
--     te.event_type,
--     te.description,
--     p.name as project_name,
--     d.name as developer_name
-- FROM timeline_events te
-- LEFT JOIN projects p ON te.project_id = p.id
-- LEFT JOIN developers d ON te.developer_id = d.id
-- ORDER BY te.event_date DESC
-- LIMIT 10;
