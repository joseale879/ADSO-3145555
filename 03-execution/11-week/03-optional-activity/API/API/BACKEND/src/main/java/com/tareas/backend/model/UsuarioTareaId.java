package com.tareas.backend.model;

import lombok.Data;
import java.io.Serializable;
import java.util.UUID;

@Data
public class UsuarioTareaId implements Serializable {
    private UUID usuarioId;
    private UUID tareaId;
}