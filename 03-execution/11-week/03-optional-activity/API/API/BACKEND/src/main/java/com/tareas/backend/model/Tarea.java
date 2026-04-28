package com.tareas.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "tarea")
@Data
public class Tarea {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID tareaId;

    @Column(nullable = false, length = 200)
    private String titulo;

    private String descripcion;

    @Column(length = 50)
    private String estado; // PENDIENTE, EN_PROGRESO, COMPLETADA

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}