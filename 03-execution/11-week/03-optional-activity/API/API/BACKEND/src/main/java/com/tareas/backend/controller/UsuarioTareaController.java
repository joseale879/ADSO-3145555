package com.tareas.backend.controller;

import com.tareas.backend.dto.AsignacionRequestDTO;
import com.tareas.backend.dto.AsignacionResponseDTO;
import com.tareas.backend.model.UsuarioTarea;
import com.tareas.backend.service.UsuarioTareaService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/asignaciones")
@CrossOrigin(origins = "*")
public class UsuarioTareaController {

    @Autowired
    private UsuarioTareaService asignacionService;

    // Método auxiliar para convertir UsuarioTarea a AsignacionResponseDTO
    private AsignacionResponseDTO usuarioTareaToDTO(UsuarioTarea asignacion) {
        return new AsignacionResponseDTO(
                asignacion.getUsuarioId(),
                asignacion.getTareaId(),
                asignacion.getUsuario() != null ? 
                    new com.tareas.backend.dto.UsuarioResponseDTO(
                        asignacion.getUsuario().getUsuarioId(),
                        asignacion.getUsuario().getNombre(),
                        asignacion.getUsuario().getEmail(),
                        asignacion.getUsuario().getCreatedAt()) : null,
                asignacion.getTarea() != null ?
                    new com.tareas.backend.dto.TareaResponseDTO(
                        asignacion.getTarea().getTareaId(),
                        asignacion.getTarea().getTitulo(),
                        asignacion.getTarea().getDescripcion(),
                        asignacion.getTarea().getEstado(),
                        asignacion.getTarea().getCreatedAt()) : null
        );
    }

    // 1. Asignar tarea a usuario
    @PostMapping
    public ResponseEntity<?> asignarTarea(@Valid @RequestBody AsignacionRequestDTO payload) {
        UUID usuarioId = payload.getUsuarioId();
        UUID tareaId = payload.getTareaId();
        
        boolean asignado = asignacionService.asignarTarea(usuarioId, tareaId);
        if (asignado) {
            return ResponseEntity.status(HttpStatus.CREATED).body("Asignación creada exitosamente");
        } else {
            return ResponseEntity.badRequest().body("La asignación ya existe o datos inválidos");
        }
    }

    // 2. Desasignar tarea de usuario
    @DeleteMapping
    public ResponseEntity<?> desasignarTarea(@RequestParam UUID usuarioId, @RequestParam UUID tareaId) {
        if (usuarioId == null || tareaId == null) {
            return ResponseEntity.badRequest().body("usuarioId y tareaId son requeridos");
        }
        
        boolean desasignado = asignacionService.desasignarTarea(usuarioId, tareaId);
        if (desasignado) {
            return ResponseEntity.ok("Asignación eliminada");
        } else {
            return ResponseEntity.badRequest().body("No existía dicha asignación");
        }
    }

    // 3. Listar tareas asignadas a un usuario
    @GetMapping("/usuario/{usuarioId}")
    public List<AsignacionResponseDTO> getTareasDeUsuario(@PathVariable UUID usuarioId) {
        return asignacionService.findTareasDeUsuario(usuarioId).stream()
                .map(this::usuarioTareaToDTO)
                .collect(Collectors.toList());
    }

    // 4. Listar usuarios asignados a una tarea
    @GetMapping("/tarea/{tareaId}")
    public List<AsignacionResponseDTO> getUsuariosDeTarea(@PathVariable UUID tareaId) {
        return asignacionService.findUsuariosDeTarea(tareaId).stream()
                .map(this::usuarioTareaToDTO)
                .collect(Collectors.toList());
    }

    // 5. Verificar si existe una asignación concreta
    @GetMapping("/existe")
    public boolean existsAsignacion(@RequestParam UUID usuarioId, @RequestParam UUID tareaId) {
        return asignacionService.existsAsignacion(usuarioId, tareaId);
    }
}