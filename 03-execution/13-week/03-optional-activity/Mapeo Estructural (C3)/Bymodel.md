# Estructura ByModule - Backend de Horarios

## Descripción
Organización del código por módulos funcionales (Security, Inventory). Cada módulo contiene todas sus capas (Entity, Repository, Service, Controller, DTO, Utils).

## Ventajas
- Alta cohesión dentro de cada módulo
- Escalable y mantenible
- Facilita el trabajo en paralelo de equipos diferentes
- Ideal para microservicios o módulos independientes

## Desventajas
- Puede haber duplicación de código entre módulos
- Requiere buena definición de límites de dominio

## Estructura de Carpetas

Proyecto/
│
├── Security/
│   ├── Entity/
│   ├── IRepository/
│   ├── IService/
│   ├── Service/
│   ├── Controller/
│   ├── DTO/
│   ├── IDTO/
│   └── Utils/
│       └── JWT/
│
└── Inventory/
    ├── Entity/
    ├── IRepository/
    ├── IService/
    ├── Service/
    ├── Controller/
    ├── DTO/
    ├── IDTO/
    └── Utils/