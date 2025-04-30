# Función para mostrar mensajes con colores
function Write-ColorMessage {
    param (
        [string]$Message,
        [string]$ForegroundColor = "White"
    )
    Write-Host $Message -ForegroundColor $ForegroundColor
}

# Función para verificar conexión a internet
function Test-InternetConnection {
    if (Test-Connection -ComputerName github.com -Count 1 -Quiet) {
        Write-ColorMessage "Conexión a Internet disponible. El problema puede ser con el servidor o la URL." "Yellow"
    }
    else {
        Write-ColorMessage "No hay conexión a Internet. Verifique su conexión e intente nuevamente." "Red"
    }
}

# Función para esperar pulsación de tecla y salir
function Wait-KeyAndExit {
    Write-ColorMessage "Presione cualquier tecla para salir..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Exit
}

# Función para mostrar solución de problemas
function Show-TroubleshootingInfo {
    Write-ColorMessage "`nSolución de problemas:" "Yellow"
    Write-ColorMessage "1. Si el error está relacionado con políticas de ejecución, ejecute este comando primero:" "Yellow"
    Write-ColorMessage "   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force" "Cyan"
    Write-ColorMessage "2. Si está ejecutando con 'irm | iex', intente este método alternativo:" "Yellow"
    Write-ColorMessage "   1. Descargue el script: Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/hidekisenpai1/WinDebloater/main/start.ps1' -OutFile 'start.ps1'" "Cyan"
    Write-ColorMessage "   2. Ejecute: powershell.exe -ExecutionPolicy Bypass -File start.ps1" "Cyan"
    Write-ColorMessage "3. Para más información sobre políticas de ejecución: https://go.microsoft.com/fwlink/?LinkID=135170" "Cyan"
}

# Función para manejar errores
function Write-ErrorHandler {
    param (
        [System.Management.Automation.ErrorRecord]$ErrorRecord,
        [string]$Context
    )
    
    Write-ColorMessage "Error $Context`: $ErrorRecord" "Red"
    
    if ($ErrorRecord.Exception.Message -like "*Unable to connect*" -or 
        $ErrorRecord.Exception.Message -like "*No se puede conectar*") {
        Write-ColorMessage "Comprobando conexión a Internet..." "Yellow"
        Test-InternetConnection
    }
    else {
        Show-TroubleshootingInfo
    }
    
    Wait-KeyAndExit
}

# Función para corregir problemas de Font en el script
function Repair-FontIssues {
    param (
        [string]$ScriptPath
    )
    
    Write-ColorMessage "Corrigiendo problemas de compatibilidad..." "Yellow"
    $content = Get-Content -Path $ScriptPath -Raw
    
    # Reemplazar todas las instancias de Font con "Bold" como string por la versión con FontStyle
    $content = $content -replace 'New-Object System\.Drawing\.Font\(''Consolas'',9,"Bold"\)', 'New-Object System.Drawing.Font(''Consolas'',9,[System.Drawing.FontStyle]::Bold)'
    $content = $content -replace 'New-Object System\.Drawing\.Font\(''Consolas'',\d+,"Bold"\)', 'New-Object System.Drawing.Font(''Consolas'',9,[System.Drawing.FontStyle]::Bold)'
    
    # Guardar el script modificado
    $content | Set-Content -Path $ScriptPath -Force
}

# Función principal
function Start-Debloater {
    # Definición de variables globales
    $DebloaterURL = "https://raw.githubusercontent.com/hidekisenpai1/WinDebloater/main/Windows10DebloaterGUI.ps1"
    $tempFolder = "$env:TEMP\W10Debloater"
    $mainScript = "$tempFolder\Windows10DebloaterGUI.ps1"
    
    # Establecer política de ejecución para la sesión actual
    try {
        Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction Stop
        Write-ColorMessage "Política de ejecución establecida correctamente para esta sesión." "Green"
    }
    catch {
        Write-ColorMessage "ADVERTENCIA: No se pudo establecer la política de ejecución. Algunos comandos podrían fallar." "Yellow"
        Write-ColorMessage "Error: $_" "Red"
    }
    
    # Comprobar si se está ejecutando como administrador
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        # Relanzar como administrador
        # Detectar si se está ejecutando desde un archivo o desde memoria (irm | iex)
        if ([string]::IsNullOrEmpty($PSCommandPath)) {
            # Ejecutando desde memoria (irm | iex)
            $startUrl = "https://raw.githubusercontent.com/hidekisenpai1/WinDebloater/main/start.ps1"
            Start-Process powershell.exe "-NoProfile -Command `"Invoke-RestMethod -Uri '$startUrl' | Invoke-Expression`"" -Verb RunAs
        }
        else {
            # Ejecutando desde un archivo
            Start-Process powershell.exe "-NoProfile -File `"$PSCommandPath`"" -Verb RunAs
        }
        Exit
    }
    
    # Crear carpeta temporal si no existe
    if (!(Test-Path $tempFolder)) {
        New-Item -Path $tempFolder -ItemType Directory -Force | Out-Null
    }
    
    Write-ColorMessage "Descargando Windows10DebloaterGUI..." "Cyan"
    Write-ColorMessage "Intentando descargar desde: $DebloaterURL" "Cyan"
    
    try {
        # Descargar el script principal
        Invoke-RestMethod -Uri $DebloaterURL -OutFile $mainScript -ErrorAction Stop
        Write-ColorMessage "Descarga completada correctamente." "Green"
        
        # Cargar ensamblados necesarios para evitar ambigüedad con Font
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        Add-Type -AssemblyName PresentationFramework
        
        # Corregir el problema de ambigüedad de Font en el script
        Repair-FontIssues -ScriptPath $mainScript
        
        # Verificar que el script existe antes de ejecutarlo
        if (Test-Path $mainScript) {
            Write-ColorMessage "Iniciando Windows10DebloaterGUI..." "Green"
            try {
                # Ejecutar el script con manejo de errores explícito
                & $mainScript -ErrorAction Stop
                Write-ColorMessage "`nScript ejecutado correctamente." "Green"
            }
            catch {
                Write-ErrorHandler -ErrorRecord $_ -Context "al ejecutar el script"
            }
        }
        else {
            Write-ColorMessage "Error: No se pudo encontrar el script descargado en $mainScript" "Red"
            Wait-KeyAndExit
        }
    }
    catch {
        Write-ErrorHandler -ErrorRecord $_ -Context "al descargar el script"
    }
}

# Iniciar el script
Start-Debloater