# Comprobar si se esta ejecutando como administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Relanzar como administrador
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# Script de inicio para Windows10DebloaterGUI
$DebloaterURL = "https://raw.githubusercontent.com/hidekisenpai1/WinDebloater/main/Windows10DebloaterGUI.ps1"

Write-Host "Descargando Windows10DebloaterGUI..." -ForegroundColor Cyan
try {
    # Crear carpeta temporal si no existe
    $tempFolder = "$env:TEMP\W10Debloater"
    if (!(Test-Path $tempFolder)) {
        New-Item -Path $tempFolder -ItemType Directory -Force | Out-Null
    }
    
    # Descargar el script principal
    $mainScript = "$tempFolder\Windows10DebloaterGUI.ps1"
    Invoke-RestMethod -Uri $DebloaterURL -OutFile $mainScript
    
    # Ejecutar el script
    Write-Host "Iniciando Windows10DebloaterGUI..." -ForegroundColor Green
    & $mainScript
}
catch {
    Write-Host "Error al descargar o ejecutar el script: $_" -ForegroundColor Red
}