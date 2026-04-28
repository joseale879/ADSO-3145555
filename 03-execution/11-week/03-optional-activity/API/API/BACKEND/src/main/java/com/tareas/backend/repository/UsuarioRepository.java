package com.tareas.backend.repository;

import com.tareas.backend.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface UsuarioRepository extends JpaRepository<Usuario, UUID> {
    // Puedes agregar métodos de consulta personalizados si los necesitas, ej:
    // Optional<Usuario> findByEmail(String email);
}