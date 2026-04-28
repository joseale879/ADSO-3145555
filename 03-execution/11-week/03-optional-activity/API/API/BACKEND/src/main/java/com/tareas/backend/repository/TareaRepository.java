package com.tareas.backend.repository;

import com.tareas.backend.model.Tarea;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface TareaRepository extends JpaRepository<Tarea, UUID> {
    // Métodos adicionales opcionales
}