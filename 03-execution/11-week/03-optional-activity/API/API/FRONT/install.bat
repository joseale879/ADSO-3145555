@echo off
REM Script para instalar dependencias del frontend

echo.
echo ========================================
echo Instalando dependencias del Frontend
echo ========================================
echo.

cd /d "%~dp0"

if not exist "node_modules" (
    echo Descargando dependencias con npm...
    call npm install
) else (
    echo Las dependencias ya están instaladas
)

echo.
echo ========================================
echo Instalación completada!
echo ========================================
echo.
echo Para ejecutar en desarrollo: npm run dev
echo Para hacer build: npm run build
echo.
pause
