package com.tareas.backend.dto;

import jakarta.validation.constraints.NotNull;
import java.util.UUID;

public class AsignacionRequestDTO {
    @NotNull(message = "usuarioId no puede ser nulo")
    private UUID usuarioId;

    @NotNull(message = "tareaId no puede ser nulo")
    private UUID tareaId;

    // Constructor
    public AsignacionRequestDTO() {
    }

    public AsignacionRequestDTO(UUID usuarioId, UUID tareaId) {
        this.usuarioId = usuarioId;
        this.tareaId = tareaId;
    }

    // Getters y Setters
    public UUID getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(UUID usuarioId) {
        this.usuarioId = usuarioId;
    }

    public UUID getTareaId() {
        return tareaId;
    }

    public void setTareaId(UUID tareaId) {
        this.tareaId = tareaId;
    }
}
