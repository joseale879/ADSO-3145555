package com.tareas.backend.service;

import com.tareas.backend.model.UsuarioTarea;
import com.tareas.backend.repository.UsuarioTareaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.UUID;

@Service
public class UsuarioTareaService {

    @Autowired
    private UsuarioTareaRepository usuarioTareaRepository;

    // 1. Asignar tarea a usuario (crear nuevo registro en usuario_tarea)
    @Transactional
    public boolean asignarTarea(UUID usuarioId, UUID tareaId) {
        if (usuarioTareaRepository.existsByUsuarioIdAndTareaId(usuarioId, tareaId)) {
            return false; // ya asignada
        }
        UsuarioTarea asignacion = new UsuarioTarea();
        asignacion.setUsuarioId(usuarioId);
        asignacion.setTareaId(tareaId);
        usuarioTareaRepository.save(asignacion);
        return true;
    }

    // 2. Desasignar tarea (eliminar registro)
    @Transactional
    public boolean desasignarTarea(UUID usuarioId, UUID tareaId) {
        if (!usuarioTareaRepository.existsByUsuarioIdAndTareaId(usuarioId, tareaId)) {
            return false;
        }
        usuarioTareaRepository.deleteByUsuarioIdAndTareaId(usuarioId, tareaId);
        return true;
    }

    // 3. Listar todas las asignaciones de un usuario (devuelve lista de UsuarioTarea, que incluye los detalles de tarea mediante @ManyToOne)
    public List<UsuarioTarea> findTareasDeUsuario(UUID usuarioId) {
        return usuarioTareaRepository.findByUsuarioId(usuarioId);
    }

    // 4. Listar todas las asignaciones de una tarea (usuarios asignados)
    public List<UsuarioTarea> findUsuariosDeTarea(UUID tareaId) {
        return usuarioTareaRepository.findByTareaId(tareaId);
    }

    // 5. Verificar si existe una asignación concreta
    public boolean existsAsignacion(UUID usuarioId, UUID tareaId) {
        return usuarioTareaRepository.existsByUsuarioIdAndTareaId(usuarioId, tareaId);
    }
}