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
    
    # Descargar el script principal
    $mainScript = "$tempFolder\Windows10DebloaterGUI.ps1"
    Invoke-RestMethod -Uri $DebloaterURL -OutFile $mainScript
    
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
    
    # Ejecutar el script
    Write-Host "Iniciando Windows10DebloaterGUI..." -ForegroundColor Green
    & $mainScript
    
    Write-Host "\nScript ejecutado correctamente." -ForegroundColor Green
}
catch {
    Write-Host "Error al descargar o ejecutar el script: $_" -ForegroundColor Red
    Write-Host "Presione cualquier tecla para salir..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}