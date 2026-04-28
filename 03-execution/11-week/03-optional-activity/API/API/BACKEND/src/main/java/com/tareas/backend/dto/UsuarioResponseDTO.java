package com.tareas.backend.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;
import java.util.UUID;

public class UsuarioResponseDTO {
    private UUID usuarioId;
    private String nombre;
    private String email;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime createdAt;

    // Constructor
    public UsuarioResponseDTO() {
    }

    public UsuarioResponseDTO(UUID usuarioId, String nombre, String email, LocalDateTime createdAt) {
        this.usuarioId = usuarioId;
        this.nombre = nombre;
        this.email = email;
        this.createdAt = createdAt;
    }

    // Getters y Setters
    public UUID getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(UUID usuarioId) {
        this.usuarioId = usuarioId;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
