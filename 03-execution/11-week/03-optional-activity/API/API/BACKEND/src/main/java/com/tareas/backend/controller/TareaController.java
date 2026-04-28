package com.tareas.backend.controller;

import com.tareas.backend.dto.TareaRequestDTO;
import com.tareas.backend.dto.TareaResponseDTO;
import com.tareas.backend.model.Tarea;
import com.tareas.backend.service.TareaService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/tareas")
@CrossOrigin(origins = "*")
public class TareaController {

    @Autowired
    private TareaService tareaService;

    // Método auxiliar para convertir Tarea a TareaResponseDTO
    private TareaResponseDTO tareaToDTO(Tarea tarea) {
        return new TareaResponseDTO(tarea.getTareaId(), tarea.getTitulo(), tarea.getDescripcion(), tarea.getEstado(), tarea.getCreatedAt());
    }

    // Método auxiliar para convertir TareaRequestDTO a Tarea
    private Tarea dtoToTarea(TareaRequestDTO dto) {
        Tarea tarea = new Tarea();
        tarea.setTitulo(dto.getTitulo());
        tarea.setDescripcion(dto.getDescripcion());
        tarea.setEstado(dto.getEstado() != null ? dto.getEstado() : "PENDIENTE");
        return tarea;
    }

    @GetMapping
    public List<TareaResponseDTO> getAllTareas() {
        return tareaService.findAll().stream()
                .map(this::tareaToDTO)
                .collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    public ResponseEntity<TareaResponseDTO> getTareaById(@PathVariable UUID id) {
        return tareaService.findById(id)
                .map(tarea -> ResponseEntity.ok(tareaToDTO(tarea)))
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<TareaResponseDTO> createTarea(@Valid @RequestBody TareaRequestDTO tareaRequest) {
        Tarea tarea = dtoToTarea(tareaRequest);
        Tarea savedTarea = tareaService.save(tarea);
        return ResponseEntity.status(HttpStatus.CREATED).body(tareaToDTO(savedTarea));
    }

    @PutMapping("/{id}")
    public ResponseEntity<TareaResponseDTO> updateTarea(@PathVariable UUID id, @Valid @RequestBody TareaRequestDTO tareaDetails) {
        Tarea tareaActualizada = dtoToTarea(tareaDetails);
        return tareaService.update(id, tareaActualizada)
                .map(tarea -> ResponseEntity.ok(tareaToDTO(tarea)))
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTarea(@PathVariable UUID id) {
        if (tareaService.deleteById(id)) {
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}