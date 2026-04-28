package com.tareas.backend.repository;

import com.tareas.backend.model.UsuarioTarea;
import com.tareas.backend.model.UsuarioTareaId;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface UsuarioTareaRepository extends JpaRepository<UsuarioTarea, UsuarioTareaId> {

    List<UsuarioTarea> findByUsuarioId(UUID usuarioId);

    List<UsuarioTarea> findByTareaId(UUID tareaId);

    boolean existsByUsuarioIdAndTareaId(UUID usuarioId, UUID tareaId);

    void deleteByUsuarioIdAndTareaId(UUID usuarioId, UUID tareaId);
}