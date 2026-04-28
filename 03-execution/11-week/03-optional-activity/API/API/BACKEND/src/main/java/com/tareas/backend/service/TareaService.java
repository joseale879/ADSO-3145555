package com.tareas.backend.service;

import com.tareas.backend.model.Tarea;
import com.tareas.backend.repository.TareaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class TareaService {

    @Autowired
    private TareaRepository tareaRepository;

    public List<Tarea> findAll() {
        return tareaRepository.findAll();
    }

    public Optional<Tarea> findById(UUID id) {
        return tareaRepository.findById(id);
    }

    @Transactional
    public Tarea save(Tarea tarea) {
        return tareaRepository.save(tarea);
    }

    @Transactional
    public Optional<Tarea> update(UUID id, Tarea tareaDetails) {
        return tareaRepository.findById(id).map(tarea -> {
            tarea.setTitulo(tareaDetails.getTitulo());
            tarea.setDescripcion(tareaDetails.getDescripcion());
            tarea.setEstado(tareaDetails.getEstado());
            return tareaRepository.save(tarea);
        });
    }

    @Transactional
    public boolean deleteById(UUID id) {
        if (tareaRepository.existsById(id)) {
            tareaRepository.deleteById(id);
            return true;
        }
        return false;
    }
}