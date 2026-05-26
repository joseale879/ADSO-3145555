# Estructura MVC - Backend de Horarios

## Descripción
Model-View-Controller clásico. El Modelo contiene las entidades y lógica de negocio, la Vista son las respuestas JSON (o vistas HTML si aplica), y el Controlador maneja peticiones HTTP.

## Ventajas
- Sencillo y ampliamente conocido
- Rápido de implementar
- Bueno para APIs REST simples o prototipos

## Desventajas
- Escalabilidad limitada
- Mezcla de responsabilidades en controladores grandes
- No ideal para backend complejo con múltiples dominios

## Estructura de Carpetas

Proyecto/
│
├── Model/
│   ├── Security/
│   └── Inventory/
│
├── View/
│   (Interfaces o respuesta JSON)
│
└── Controller/
    ├── Security/
    └── Inventory/