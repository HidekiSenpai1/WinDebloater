# Establecer política de ejecución para la sesión actual
try {
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction Stop
    Write-Host "Política de ejecución establecida correctamente para esta sesión." -ForegroundColor Green
} catch {
    Write-Host "ADVERTENCIA: No se pudo establecer la política de ejecución. Algunos comandos podrían fallar." -ForegroundColor Yellow
    Write-Host "Error: $_" -ForegroundColor Red
}

# Comprobar si se esta ejecutando como administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Relanzar como administrador
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

$DebloaterURL = "https://raw.githubusercontent.com/hidekisenpai1/WinDebloater/main/Windows10DebloaterGUI.ps1"

Write-Host "Descargando Windows10DebloaterGUI..." -ForegroundColor Cyan
try {
    # Crear carpeta temporal si no existe
    $tempFolder = "$env:TEMP\W10Debloater"
    if (!(Test-Path $tempFolder)) {
        New-Item -Path $tempFolder -ItemType Directory -Force | Out-Null
    }
    
    # Descargar el script principal con manejo de errores mejorado
    $mainScript = "$tempFolder\Windows10DebloaterGUI.ps1"
    Write-Host "Intentando descargar desde: $DebloaterURL" -ForegroundColor Cyan
    try {
        Invoke-RestMethod -Uri $DebloaterURL -OutFile $mainScript -ErrorAction Stop
        Write-Host "Descarga completada correctamente." -ForegroundColor Green
    } catch {
        Write-Host "Error al descargar el script: $_" -ForegroundColor Red
        Write-Host "Comprobando conexión a Internet..." -ForegroundColor Yellow
        if (Test-Connection -ComputerName github.com -Count 1 -Quiet) {
            Write-Host "Conexión a Internet disponible. El problema puede ser con el servidor o la URL." -ForegroundColor Yellow
        } else {
            Write-Host "No hay conexión a Internet. Verifique su conexión e intente nuevamente." -ForegroundColor Red
        }
        Write-Host "Presione cualquier tecla para salir..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        Exit
    }
    
    # Cargar ensamblados necesarios para evitar ambigüedad con Font
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName PresentationFramework
    
    # Corregir el problema de ambigüedad de Font en el script
    Write-Host "Corrigiendo problemas de compatibilidad..." -ForegroundColor Yellow
    $content = Get-Content -Path $mainScript -Raw
    
    # Reemplazar todas las instancias de Font con "Bold" como string por la versión con FontStyle
    $content = $content -replace 'New-Object System\.Drawing\.Font\(''Consolas'',9,"Bold"\)', 'New-Object System.Drawing.Font(''Consolas'',9,[System.Drawing.FontStyle]::Bold)'
    $content = $content -replace 'New-Object System\.Drawing\.Font\(''Consolas'',\d+,"Bold"\)', 'New-Object System.Drawing.Font(''Consolas'',9,[System.Drawing.FontStyle]::Bold)'
    
    # Guardar el script modificado
    $content | Set-Content -Path $mainScript -Force
    
    # Verificar que el script existe antes de ejecutarlo
    if (Test-Path $mainScript) {
        Write-Host "Iniciando Windows10DebloaterGUI..." -ForegroundColor Green
        try {
            # Ejecutar el script con manejo de errores explícito
            & $mainScript -ErrorAction Stop
            Write-Host "\nScript ejecutado correctamente." -ForegroundColor Green
        } catch {
            Write-Host "Error al ejecutar el script: $_" -ForegroundColor Red
            Write-Host "Si el error está relacionado con políticas de ejecución, intente ejecutar:" -ForegroundColor Yellow
            Write-Host "Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force" -ForegroundColor Yellow
            Write-Host "Para más información, consulte: https://go.microsoft.com/fwlink/?LinkID=135170" -ForegroundColor Cyan
        }
    } else {
        Write-Host "Error: No se pudo encontrar el script descargado en $mainScript" -ForegroundColor Red
    }
}
catch {
    Write-Host "Error al descargar o ejecutar el script: $_" -ForegroundColor Red
    Write-Host "\nSolución de problemas:" -ForegroundColor Yellow
    Write-Host "1. Si el error está relacionado con políticas de ejecución, ejecute este comando primero:" -ForegroundColor Yellow
    Write-Host "   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force" -ForegroundColor Cyan
    Write-Host "2. Si está ejecutando con 'irm | iex', intente este método alternativo:" -ForegroundColor Yellow
    Write-Host "   1. Descargue el script: Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/hidekisenpai1/WinDebloater/main/start.ps1' -OutFile 'start.ps1'" -ForegroundColor Cyan
    Write-Host "   2. Ejecute: powershell.exe -ExecutionPolicy Bypass -File start.ps1" -ForegroundColor Cyan
    Write-Host "3. Para más información sobre políticas de ejecución: https://go.microsoft.com/fwlink/?LinkID=135170" -ForegroundColor Cyan
    Write-Host "\nPresione cualquier tecla para salir..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}