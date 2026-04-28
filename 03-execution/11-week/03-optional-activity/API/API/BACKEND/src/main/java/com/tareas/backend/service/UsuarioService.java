package com.tareas.backend.service;

import com.tareas.backend.model.Usuario;
import com.tareas.backend.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    // 1. Listar todos
    public List<Usuario> findAll() {
        return usuarioRepository.findAll();
    }

    // 2. Buscar por ID
    public Optional<Usuario> findById(UUID id) {
        return usuarioRepository.findById(id);
    }

    // 3. Crear nuevo usuario
    @Transactional
    public Usuario save(Usuario usuario) {
        // Aquí podrías validar email único, etc.
        return usuarioRepository.save(usuario);
    }

    // 4. Actualizar usuario existente
    @Transactional
    public Optional<Usuario> update(UUID id, Usuario usuarioDetails) {
        return usuarioRepository.findById(id).map(usuario -> {
            usuario.setNombre(usuarioDetails.getNombre());
            usuario.setEmail(usuarioDetails.getEmail());
            return usuarioRepository.save(usuario);
        });
    }

    // 5. Eliminar usuario
    @Transactional
    public boolean deleteById(UUID id) {
        if (usuarioRepository.existsById(id)) {
            usuarioRepository.deleteById(id);
            return true;
        }
        return false;
    }
}