package com.tareas.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.UUID;

@Entity
@Table(name = "usuario_tarea")
@Data
@IdClass(UsuarioTareaId.class)
public class UsuarioTarea {

    @Id
    @Column(name = "usuario_id")
    private UUID usuarioId;

    @Id
    @Column(name = "tarea_id")
    private UUID tareaId;

    // Relación ManyToOne con Usuario (solo lectura para la BD)
    @ManyToOne
    @JoinColumn(name = "usuario_id", insertable = false, updatable = false)
    private Usuario usuario;

    // Relación ManyToOne con Tarea (solo lectura para la BD)
    @ManyToOne
    @JoinColumn(name = "tarea_id", insertable = false, updatable = false)
    private Tarea tarea;
}