package com.tareas.backend.controller;

import com.tareas.backend.dto.UsuarioRequestDTO;
import com.tareas.backend.dto.UsuarioResponseDTO;
import com.tareas.backend.model.Usuario;
import com.tareas.backend.service.UsuarioService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/usuarios")
@CrossOrigin(origins = "*") // para desarrollo, permite peticiones desde cualquier origen
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    // Método auxiliar para convertir Usuario a UsuarioResponseDTO
    private UsuarioResponseDTO usuarioToDTO(Usuario usuario) {
        return new UsuarioResponseDTO(usuario.getUsuarioId(), usuario.getNombre(), usuario.getEmail(), usuario.getCreatedAt());
    }

    // Método auxiliar para convertir UsuarioRequestDTO a Usuario
    private Usuario dtoToUsuario(UsuarioRequestDTO dto) {
        Usuario usuario = new Usuario();
        usuario.setNombre(dto.getNombre());
        usuario.setEmail(dto.getEmail());
        return usuario;
    }

    // 1. Listar todos los usuarios
    @GetMapping
    public List<UsuarioResponseDTO> getAllUsuarios() {
        return usuarioService.findAll().stream()
                .map(this::usuarioToDTO)
                .collect(Collectors.toList());
    }

    // 2. Obtener usuario por ID
    @GetMapping("/{id}")
    public ResponseEntity<UsuarioResponseDTO> getUsuarioById(@PathVariable UUID id) {
        return usuarioService.findById(id)
                .map(usuario -> ResponseEntity.ok(usuarioToDTO(usuario)))
                .orElse(ResponseEntity.notFound().build());
    }

    // 3. Crear un nuevo usuario
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<UsuarioResponseDTO> createUsuario(@Valid @RequestBody UsuarioRequestDTO usuarioRequest) {
        Usuario usuario = dtoToUsuario(usuarioRequest);
        Usuario savedUsuario = usuarioService.save(usuario);
        return ResponseEntity.status(HttpStatus.CREATED).body(usuarioToDTO(savedUsuario));
    }

    // 4. Actualizar usuario existente
    @PutMapping("/{id}")
    public ResponseEntity<UsuarioResponseDTO> updateUsuario(@PathVariable UUID id, @Valid @RequestBody UsuarioRequestDTO usuarioDetails) {
        Usuario usuarioActualizado = dtoToUsuario(usuarioDetails);
        return usuarioService.update(id, usuarioActualizado)
                .map(usuario -> ResponseEntity.ok(usuarioToDTO(usuario)))
                .orElse(ResponseEntity.notFound().build());
    }

    // 5. Eliminar usuario
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUsuario(@PathVariable UUID id) {
        if (usuarioService.deleteById(id)) {
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}