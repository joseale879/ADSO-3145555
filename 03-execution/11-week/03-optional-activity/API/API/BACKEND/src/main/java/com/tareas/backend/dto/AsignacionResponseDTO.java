package com.tareas.backend.dto;

import java.util.UUID;

public class AsignacionResponseDTO {
    private UUID usuarioId;
    private UUID tareaId;
    private UsuarioResponseDTO usuario;
    private TareaResponseDTO tarea;

    // Constructor
    public AsignacionResponseDTO() {
    }

    public AsignacionResponseDTO(UUID usuarioId, UUID tareaId, UsuarioResponseDTO usuario, TareaResponseDTO tarea) {
        this.usuarioId = usuarioId;
        this.tareaId = tareaId;
        this.usuario = usuario;
        this.tarea = tarea;
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

    public UsuarioResponseDTO getUsuario() {
        return usuario;
    }

    public void setUsuario(UsuarioResponseDTO usuario) {
        this.usuario = usuario;
    }

    public TareaResponseDTO getTarea() {
        return tarea;
    }

    public void setTarea(TareaResponseDTO tarea) {
        this.tarea = tarea;
    }
}
