# Estructura DDD - Backend de Horarios

## Descripción
Domain-Driven Design organiza el código por capas: Domain (núcleo del negocio), Application (casos de uso), Infrastructure (implementaciones técnicas), API (controladores).

## Ventajas
- Enfocado en la lógica de negocio compleja
- Alta mantenibilidad a largo plazo
- Ideal para dominios ricos y cambiantes
- Permite evolucionar sin afectar capas externas

## Desventajas
- Curva de aprendizaje alta
- Over-engineering para dominios simples
- Requiere disciplina de equipo

## Estructura de Carpetas

Proyecto/
│
├── Domain/
│   ├── Entities/
│   │   ├── Security/
│   │   └── Inventory/
│   ├── Repositories/
│   │   ├── ISecurityRepository/
│   │   └── IInventoryRepository/
│   └── Services/
│       ├── ISecurityService/
│       └── IInventoryService/
│
├── Application/
│   ├── DTOs/
│   │   ├── Security/
│   │   └── Inventory/
│   ├── IDTOs/
│   │   ├── Security/
│   │   └── Inventory/
│   └── UseCases/
│       ├── Security/
│       └── Inventory/
│
├── Infrastructure/
│   ├── Repositories/
│   │   ├── SecurityRepository/
│   │   └── InventoryRepository/
│   ├── Services/
│   │   ├── SecurityService/
│   │   └── InventoryService/
│   └── Utils/
│       ├── JWT/
│       └── ProcessInventory/
│
└── API/
    ├── Controllers/
    │   ├── Security/
    │   └── Inventory/
    └── Middlewares/