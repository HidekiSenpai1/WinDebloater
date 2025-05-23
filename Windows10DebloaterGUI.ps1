﻿<#
    Windows 10/11 Debloater GUI
    
    Copyright 2025 Hideki
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
#>

Write-Host "╔════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║          Windows 10/11 Debloater GUI           ║" -ForegroundColor Cyan
Write-Host "║                                                ║" -ForegroundColor Cyan
Write-Host "║  Made by:              Hideki <3               ║" -ForegroundColor Cyan
Write-Host "║  GitHub:   https://github.com/HidekiSenpai1    ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
#This will self elevate the script so with a UAC prompt since this script needs to be run as an Administrator in order to function properly.

$ErrorActionPreference = 'SilentlyContinue'

#Unnecessary Windows 10 AppX apps that will be removed by the blacklist.
$global:Bloatware = @(
    # Original bloatware list
    "Microsoft.PPIProjection"
    "Microsoft.BingNews"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.News"
    "Microsoft.Office.Lens"
    "Microsoft.Office.OneNote"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.RemoteDesktop"
    "Microsoft.SkypeApp"
    "Microsoft.StorePurchaseApp"
    "Microsoft.Office.Todo.List"
    "Microsoft.Whiteboard"
    "Microsoft.WindowsAlarms"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    
    # Added newer Windows 10/11 bloatware
    "Microsoft.BingWeather"
    "Microsoft.GamingApp"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MixedReality.Portal"
    "Microsoft.People"
    "Microsoft.ScreenSketch"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet"
    "Microsoft.Windows.NarratorQuickStart"
    "Microsoft.WindowsAlarms"
    "Microsoft.WindowsCamera"
    "Microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.YourPhone"
    "Microsoft.549981C3F5F10" # Cortana
    "Microsoft.MicrosoftTeams"
    "MicrosoftTeams"
    "Microsoft.PowerAutomateDesktop"
    "Microsoft.Todos"
    "SpotifyAB.SpotifyMusic"
    "Disney.37853FC22B2CE"
    "Microsoft.GamingApp"
    
    #Sponsored Windows 10 AppX Apps
    #Add sponsored/featured apps to remove in the "*AppName*" format
    "EclipseManager"
    "ActiproSoftwareLLC"
    "AdobeSystemsIncorporated.AdobePhotoshopExpress"
    "Duolingo-LearnLanguagesforFree"
    "PandoraMediaInc"
    "CandyCrush"
    "BubbleWitch3Saga"
    "Wunderlist"
    "Flipboard"
    "Twitter"
    "Facebook"
    "Spotify"
    "Minecraft"
    "Royal Revolt"
    "Sway"
    "Dolby"
    "Disney+"
    "TikTok"
    "Instagram"
    "Prime Video"
    "Netflix"
    "Hidden City"
)

#Valuable Windows 10 AppX apps that most people want to keep. Protected from DeBloat All.
$global:WhiteListedApps = @(
    "Microsoft.WindowsCalculator"
    "Microsoft.WindowsStore"
    "Microsoft.Windows.Photos"
    "CanonicalGroupLimited.UbuntuonWindows"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.MSPaint"
    "\.NET"
    "Microsoft.HEIFImageExtension"
    "Microsoft.VP9VideoExtensions"
    "Microsoft.WebMediaExtensions"
    "Microsoft.WebpImageExtension"
    "Microsoft.DesktopAppInstaller"
    "WindSynthBerry"
    "MIDIBerry"
    "Slack"
    "*Nvidia*"
    "Microsoft.VCLibs*"
    "Microsoft.Services.Store.Engagement"
    "Microsoft.UI.Xaml*"
    "Microsoft.WindowsTerminal"
    "Microsoft.PowerShell"
    "Microsoft.VisualStudioCode"
    "Microsoft.WindowsNotepad"
    "Microsoft.Paint"
    "Microsoft.WindowsTerminalPreview"
    "Microsoft.StorePurchaseApp"
    "Microsoft.SecHealthUI"
    "Microsoft.Windows.ShellExperienceHost"
    "Microsoft.Windows.CloudExperienceHost"
    "Microsoft.Windows.ContentDeliveryManager"
)

#NonRemovable Apps that where getting attempted and the system would reject the uninstall, speeds up debloat and prevents 'initalizing' overlay when removing apps
$NonRemovables = Get-AppxPackage -AllUsers | Where-Object { $_.NonRemovable -eq $true } | ForEach-Object { $_.Name }
$NonRemovables += Get-AppxPackage | Where-Object { $_.NonRemovable -eq $true } | ForEach-Object { $_.Name }
$NonRemovables += Get-AppxProvisionedPackage -Online | Where-Object { $_.NonRemovable -eq $true } | ForEach-Object { $_.DisplayName }
$NonRemovables = $NonRemovables | Sort-Object -Unique

if ($null -eq $NonRemovables ) {
    # the .NonRemovable property doesn't exist until version 18xx. Use a hard-coded list instead.
    #WARNING: only use exact names here - no short names or wildcards
    $NonRemovables = @(
        "1527c705-839a-4832-9118-54d4Bd6a0c89"
        "c5e2524a-ea46-4f67-841f-6a9465d9d515"
        "E2A4F912-2574-4A75-9BB0-0D023378592B"
        "F46D4000-FD22-4DB4-AC8E-4E1DDDE828FE"
        "InputApp"
        "Microsoft.AAD.BrokerPlugin"
        "Microsoft.AccountsControl"
        "Microsoft.BioEnrollment"
        "Microsoft.CredDialogHost"
        "Microsoft.ECApp"
        "Microsoft.LockApp"
        "Microsoft.MicrosoftEdgeDevToolsClient"
        "Microsoft.MicrosoftEdge"
        "Microsoft.PPIProjection"
        "Microsoft.Win32WebViewHost"
        "Microsoft.Windows.Apprep.ChxApp"
        "Microsoft.Windows.AssignedAccessLockApp"
        "Microsoft.Windows.CapturePicker"
        "Microsoft.Windows.CloudExperienceHost"
        "Microsoft.Windows.ContentDeliveryManager"
        "Microsoft.Windows.Cortana"
        "Microsoft.Windows.HolographicFirstRun"         # Added 1709
        "Microsoft.Windows.NarratorQuickStart"
        "Microsoft.Windows.OOBENetworkCaptivePortal"    # Added 1709
        "Microsoft.Windows.OOBENetworkConnectionFlow"   # Added 1709
        "Microsoft.Windows.ParentalControls"
        "Microsoft.Windows.PeopleExperienceHost"
        "Microsoft.Windows.PinningConfirmationDialog"
        "Microsoft.Windows.SecHealthUI"                 # Issue 117 Windows Defender
        "Microsoft.Windows.SecondaryTileExperience"     # Added 1709
        "Microsoft.Windows.SecureAssessmentBrowser"
        "Microsoft.Windows.ShellExperienceHost"
        "Microsoft.Windows.XGpuEjectDialog"
        "Microsoft.XboxGameCallableUI"                  # Issue 91
        "Windows.CBSPreview"
        "windows.immersivecontrolpanel"
        "Windows.PrintDialog"
        "Microsoft.VCLibs.140.00"
        "Microsoft.Services.Store.Engagement"
        "Microsoft.UI.Xaml.2.0"
    )
}

# import library code - located relative to this script
Function dotInclude() {
    Param(
        [Parameter(Mandatory)]
        [string]$includeFile
    )
    # Look for the file in the same directory as this script
    $scriptPath = $PSScriptRoot
    if ( $PSScriptRoot -eq $null -and $psISE) {
        $scriptPath = (Split-Path -Path $psISE.CurrentFile.FullPath)
    }
    if ( test-path $scriptPath\$includeFile ) {
        # import and immediately execute the requested file
        .$scriptPath\$includeFile
    }
}

# Override built-in blacklist/whitelist with user defined lists
dotInclude 'custom-lists.ps1'

#convert to regular expression to allow for the super-useful -match operator
$global:BloatwareRegex = $global:Bloatware -join '|'
$global:WhiteListedAppsRegex = $global:WhiteListedApps -join '|'

# Función para manejar errores de forma centralizada
Function Write-ErrorLog {
    param (
        [string]$Operation,
        [string]$ItemName,
        [System.Management.Automation.ErrorRecord]$ErrorRecord,
        [ref]$FailedCounter
    )
    
    Write-Warning "Error al $Operation ${ItemName}: $ErrorRecord"
    if ($null -ne $FailedCounter) {
        $FailedCounter.Value++
    }
}

# Función para restaurar una aplicación específica
Function Restore-AppPackage {
    param (
        [object]$ProvisionedApp,
        [ref]$RestoredCounter,
        [ref]$FailedCounter
    )
    
    try {
        Write-Host "Restaurando $($ProvisionedApp.DisplayName)..." -ForegroundColor Yellow
        Add-AppxPackage -DisableDevelopmentMode -Register "$($ProvisionedApp.InstallLocation)\AppXManifest.xml" -ErrorAction Stop
        $RestoredCounter.Value++
        return $true
    }
    catch {
        Write-ErrorLog -Operation "restaurar" -ItemName $ProvisionedApp.DisplayName -ErrorRecord $_ -FailedCounter $FailedCounter
        return $false
    }
}

# Función para buscar aplicaciones que coincidan con un patrón
Function Find-MatchingApps {
    param (
        [string]$Pattern,
        [object[]]$AppCollection,
        [string]$PropertyName = "Name"
    )
    
    return $AppCollection | Where-Object { $_.$PropertyName -match $Pattern }
}

# Función para procesar la restauración de aplicaciones
Function Restore-AppProvisioning {
    param (
        [string]$AppPattern,
        [object[]]$ProvisionedApps,
        [ref]$RestoredCounter,
        [ref]$FailedCounter
    )
    
    $MatchingProvisionedApps = Find-MatchingApps -Pattern $AppPattern -AppCollection $ProvisionedApps -PropertyName "DisplayName"
    
    if ($MatchingProvisionedApps.Count -gt 0) {
        foreach ($ProvisionedApp in $MatchingProvisionedApps) {
            Restore-AppPackage -ProvisionedApp $ProvisionedApp -RestoredCounter $RestoredCounter -FailedCounter $FailedCounter
        }
        return $true
    }
    
    # No se encontraron aplicaciones aprovisionadas para restaurar
    Write-Host "La aplicación $AppPattern no se encontró en los paquetes aprovisionados. Intenta reinstalarla desde la Microsoft Store." -ForegroundColor Yellow
    return $false
}

# Function to fix WhiteListed Apps that were removed
Function FixWhitelistedApps {
    Write-Host "Comprobando si se eliminaron aplicaciones de la lista blanca y restaurándolas..." -ForegroundColor Cyan
    
    # Obtener todas las aplicaciones aprovisionadas y las instaladas en una sola operación
    $Packages = Get-AppxProvisionedPackage -Online
    $InstalledApps = Get-AppxPackage -AllUsers | Select-Object -ExpandProperty Name
    $WhitelistedApps = $global:WhiteListedApps
    
    $restoredCount = 0
    $failedCount = 0
    
    # Recorrer la lista de aplicaciones de la lista blanca
    foreach ($App in $WhitelistedApps) {
        # Verificar si la aplicación ya está instalada
        $MatchingApps = Find-MatchingApps -Pattern $App -AppCollection $InstalledApps
        
        # Solo intentar restaurar si no está instalada
        if ($MatchingApps.Count -eq 0) {
            Restore-AppRestoration -AppPattern $App -ProvisionedApps $Packages -RestoredCounter ([ref]$restoredCount) -FailedCounter ([ref]$failedCount)
        }
    }
    
    Write-Host "Proceso de restauración completado: $restoredCount aplicaciones restauradas, $failedCount fallos." -ForegroundColor Green
}

# Add a new function to handle Windows 11 specific features
# Función para asegurar que existe una ruta de registro
Function Test-RegistryPath {
    param (
        [string]$Path
    )
    
    if (!(Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
        return $true
    }
    return $false
}

# Función para aplicar configuración de registro
Function Set-RegistrySetting {
    param (
        [string]$Path,
        [string]$Name,
        [object]$Value,
        [string]$Type
    )
    
    Test-RegistryPath -Path $Path
    Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type
}

Function HandleWindows11Features {
    # Check if running on Windows 11
    $OSVersion = [System.Environment]::OSVersion.Version
    $IsWindows11 = $OSVersion.Build -ge 22000
    
    if ($IsWindows11) {
        Write-Host "Windows 11 detectado. Aplicando ajustes específicos para Windows 11..."
        
        # Restaurar el menú contextual clásico (menú del clic derecho)
        Write-Host "Restaurando el menú contextual clásico..."
        $contextMenuPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
        Test-RegistryPath -Path $contextMenuPath
        Test-RegistryPath -Path "$contextMenuPath\InprocServer32"
        Set-ItemProperty -Path "$contextMenuPath\InprocServer32" -Name "(Default)" -Value "" -Type String
        
        # Ruta común para configuraciones de la barra de tareas
        $taskbarPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        
        # Desactivar Widgets
        Write-Host "Desactivando Widgets..."
        Set-RegistrySetting -Path $taskbarPath -Name "TaskbarDa" -Value 0 -Type DWord
        
        # Desactivar icono de Chat
        Write-Host "Desactivando icono de Chat..."
        Set-RegistrySetting -Path $taskbarPath -Name "TaskbarMn" -Value 0 -Type DWord
        
        Write-Host "Ajustes de Windows 11 aplicados correctamente. Es necesario reiniciar el Explorador de Windows para que los cambios surtan efecto."
    }
    else {
        Write-Host "No se detectó Windows 11. No se aplicaron ajustes específicos."
    }
}

# Función para obtener la última versión desde GitHub
Function Get-LatestVersion {
    param (
        [string]$RepoUrl
    )
    
    try {
        $latestRelease = Invoke-RestMethod -Uri $RepoUrl -Method Get -ErrorAction Stop
        return $latestRelease
    }
    catch {
        Write-ErrorLog -Operation "obtener" -ItemName "información de versión" -ErrorRecord $_ -FailedCounter $null
        return $null
    }
}

# Función para comparar versiones y mostrar diálogo de actualización
Function Show-UpdateDialog {
    param (
        [string]$CurrentVersion,
        [string]$LatestVersion,
        [string]$UpdateUrl
    )
    
    $updateMsg = "Hay una nueva versión disponible: $LatestVersion`nTu versión actual es: $CurrentVersion"
    $updatePrompt = [System.Windows.MessageBox]::Show($updateMsg, "Actualización disponible", [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Information)
    
    if ($updatePrompt -eq 'Yes') {
        Start-Process $UpdateUrl
        return $true
    }
    
    return $false
}

Function CheckForUpdates {
    $repoUrl = "https://api.github.com/repos/hidekisenpai1/WinDebloater/releases/latest"
    $currentVersion = "1.0.0" # Cambia esto a tu versión actual
    
    Write-Host "Verificando actualizaciones..." -ForegroundColor Cyan
    
    $latestRelease = Get-LatestVersion -RepoUrl $repoUrl
    
    if ($null -ne $latestRelease) {
        $latestVersion = $latestRelease.tag_name
        
        if ($latestVersion -gt $currentVersion) {
            Show-UpdateDialog -CurrentVersion $currentVersion -LatestVersion $latestVersion -UpdateUrl $latestRelease.html_url
        }
        else {
            Write-Host "Estás utilizando la última versión." -ForegroundColor Green
        }
    }
    else {
        Write-Host "No se pudo verificar actualizaciones." -ForegroundColor Yellow
    }
}

Function BackupRegistry {
    $backupFolder = "$env:USERPROFILE\Desktop\WinDebloater_Backup"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupFile = "$backupFolder\registry_backup_$timestamp.reg"
    
    if (!(Test-Path $backupFolder)) {
        New-Item -Path $backupFolder -ItemType Directory -Force | Out-Null
    }
    
    try {
        Write-Host "Creando copia de seguridad del registro en: $backupFile" -ForegroundColor Cyan
        $regExportProcess = Start-Process -FilePath "reg.exe" -ArgumentList "export HKLM $backupFile /y" -NoNewWindow -PassThru -Wait
        Start-Process -FilePath "reg.exe" -ArgumentList "export HKCU $backupFile /y" -NoNewWindow -PassThru -Wait
        
        if ($regExportProcess.ExitCode -eq 0) {
            Write-Host "Copia de seguridad del registro creada correctamente." -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "Error al crear la copia de seguridad del registro." -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "Error al crear la copia de seguridad del registro: $_" -ForegroundColor Red
        return $false
    }
}

# Función para calcular el tamaño de una carpeta en MB
Function Get-FolderSizeMB {
    param (
        [string]$FolderPath
    )
    
    $size = (Get-ChildItem -Path $FolderPath -Recurse -File -ErrorAction SilentlyContinue | 
        Measure-Object -Property Length -Sum).Sum / 1MB
    return [math]::Round($size, 2)
}

# Función para limpiar una carpeta específica
Function Remove-TempFolder {
    param (
        [string]$FolderPath,
        [int]$DaysOld = 2
    )
    
    if (!(Test-Path $FolderPath)) {
        return 0
    }
    
    $folderSize = Get-FolderSizeMB -FolderPath $FolderPath
    Write-Host "Limpiando $FolderPath ($folderSize MB)..." -ForegroundColor Yellow
    
    try {
        Get-ChildItem -Path $FolderPath -Recurse -Force -ErrorAction SilentlyContinue | 
        Where-Object { ($_.CreationTime -lt (Get-Date).AddDays(-$DaysOld)) -and (!$_.PSIsContainer) } | 
        Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
        return $folderSize
    }
    catch {
        Write-ErrorLog -Operation "limpiar" -ItemName $FolderPath -ErrorRecord $_ -FailedCounter $null
        return 0
    }
}

Function CleanTempFiles {
    Write-Host "Limpiando archivos temporales..." -ForegroundColor Cyan
    
    $tempFolders = @(
        "$env:TEMP",
        "$env:SystemRoot\Temp",
        "$env:SystemRoot\Prefetch",
        "$env:SystemRoot\SoftwareDistribution\Download"
    )
    
    $totalCleaned = 0
    
    foreach ($folder in $tempFolders) {
        $totalCleaned += Remove-TempFolder -FolderPath $folder
    }
    
    Write-Host "Limpieza completada. Se liberaron aproximadamente $totalCleaned MB de espacio." -ForegroundColor Green
}

# This form was created using POSHGUI.com  a free online gui designer for PowerShell
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object system.Windows.Forms.Form
$Form.ClientSize = New-Object System.Drawing.Point(500, 650)
$Form.StartPosition = 'CenterScreen'
$Form.FormBorderStyle = 'FixedSingle'
$Form.MinimizeBox = $false
$Form.MaximizeBox = $false
$Form.ShowIcon = $false
$Form.text = "Windows 10/11 Debloater - by Hideki"
$Form.TopMost = $false
$Form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#1E1E1E")

$DebloatPanel = New-Object system.Windows.Forms.Panel
$DebloatPanel.height = 160
$DebloatPanel.width = 480
$DebloatPanel.Anchor = 'top,right,left'
$DebloatPanel.location = New-Object System.Drawing.Point(10, 10)
$DebloatPanel.BorderStyle = 'FixedSingle'

$RegistryPanel = New-Object system.Windows.Forms.Panel
$RegistryPanel.height = 80
$RegistryPanel.width = 480
$RegistryPanel.Anchor = 'top,right,left'
$RegistryPanel.location = New-Object System.Drawing.Point(10, 180)
$RegistryPanel.BorderStyle = 'FixedSingle'

$CortanaPanel = New-Object system.Windows.Forms.Panel
$CortanaPanel.height = 120
$CortanaPanel.width = 153
$CortanaPanel.Anchor = 'top,right,left'
$CortanaPanel.location = New-Object System.Drawing.Point(10, 270)
$CortanaPanel.BorderStyle = 'FixedSingle'

$EdgePanel = New-Object system.Windows.Forms.Panel
$EdgePanel.height = 120
$EdgePanel.width = 154
$EdgePanel.Anchor = 'top,right,left'
$EdgePanel.location = New-Object System.Drawing.Point(173, 270)
$EdgePanel.BorderStyle = 'FixedSingle'

$DarkThemePanel = New-Object system.Windows.Forms.Panel
$DarkThemePanel.height = 120
$DarkThemePanel.width = 153
$DarkThemePanel.Anchor = 'top,right,left'
$DarkThemePanel.location = New-Object System.Drawing.Point(337, 270)
$DarkThemePanel.BorderStyle = 'FixedSingle'

$OtherPanel = New-Object system.Windows.Forms.Panel
$OtherPanel.height = 240
$OtherPanel.width = 480
$OtherPanel.Anchor = 'top,right,left'
$OtherPanel.location = New-Object System.Drawing.Point(10, 400)
$OtherPanel.BorderStyle = 'FixedSingle'

$CheckUpdates = New-Object system.Windows.Forms.Button
$CheckUpdates.FlatStyle = 'Flat'
$CheckUpdates.text = "VERIFICAR ACTUALIZACIONES"
$CheckUpdates.width = 460
$CheckUpdates.height = 30
$CheckUpdates.Anchor = 'top,right,left'
$CheckUpdates.location = New-Object System.Drawing.Point(10, 600)
$CheckUpdates.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$CheckUpdates.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$CheckUpdates.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#0063B1")
$CheckUpdates.Add_Click({ 
        CheckForUpdates
    })

$Debloat = New-Object system.Windows.Forms.Label
$Debloat.text = "DEBLOAT OPTIONS"
$Debloat.AutoSize = $true
$Debloat.width = 457
$Debloat.height = 142
$Debloat.Anchor = 'top,right,left'
$Debloat.location = New-Object System.Drawing.Point(10, 9)
$Debloat.Font = New-Object System.Drawing.Font('Consolas', 15, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Debloat.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$CustomizeBlacklist = New-Object system.Windows.Forms.Button
$CustomizeBlacklist.FlatStyle = 'Flat'
$CustomizeBlacklist.text = "CUSTOMISE BLOCKLIST"
$CustomizeBlacklist.width = 460
$CustomizeBlacklist.height = 30
$CustomizeBlacklist.Anchor = 'top,right,left'
$CustomizeBlacklist.location = New-Object System.Drawing.Point(10, 40)
$CustomizeBlacklist.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$CustomizeBlacklist.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$CustomizeBlacklist.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#2b5797")

$RemoveAllBloatware = New-Object system.Windows.Forms.Button
$RemoveAllBloatware.FlatStyle = 'Flat'
$RemoveAllBloatware.text = "REMOVE ALL BLOATWARE"
$RemoveAllBloatware.width = 460
$RemoveAllBloatware.height = 30
$RemoveAllBloatware.Anchor = 'top,right,left'
$RemoveAllBloatware.location = New-Object System.Drawing.Point(10, 80)
$RemoveAllBloatware.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$RemoveAllBloatware.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$RemoveAllBloatware.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#c50f1f")

$RemoveBlacklistedBloatware = New-Object system.Windows.Forms.Button
$RemoveBlacklistedBloatware.FlatStyle = 'Flat'
$RemoveBlacklistedBloatware.text = "REMOVE BLOATWARE WITH CUSTOM BLOCKLIST"
$RemoveBlacklistedBloatware.width = 460
$RemoveBlacklistedBloatware.height = 30
$RemoveBlacklistedBloatware.Anchor = 'top,right,left'
$RemoveBlacklistedBloatware.location = New-Object System.Drawing.Point(10, 120)
$RemoveBlacklistedBloatware.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$RemoveBlacklistedBloatware.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$RemoveBlacklistedBloatware.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#107c10")

$Registry = New-Object system.Windows.Forms.Label
$Registry.text = "REGISTRY CHANGES"
$Registry.AutoSize = $true
$Registry.width = 457
$Registry.height = 142
$Registry.Anchor = 'top,right,left'
$Registry.location = New-Object System.Drawing.Point(10, 10)
$Registry.Font = New-Object System.Drawing.Font('Consolas', 15, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Registry.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$RevertChanges = New-Object system.Windows.Forms.Button
$RevertChanges.FlatStyle = 'Flat'
$RevertChanges.text = "REVERT REGISTRY CHANGES"
$RevertChanges.width = 460
$RevertChanges.height = 30
$RevertChanges.Anchor = 'top,right,left'
$RevertChanges.location = New-Object System.Drawing.Point(10, 40)
$RevertChanges.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$RevertChanges.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$RevertChanges.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#5c2d91")

$Cortana = New-Object system.Windows.Forms.Label
$Cortana.text = "CORTANA"
$Cortana.AutoSize = $true
$Cortana.width = 457
$Cortana.height = 142
$Cortana.Anchor = 'top,right,left'
$Cortana.location = New-Object System.Drawing.Point(10, 10)
$Cortana.Font = New-Object System.Drawing.Font('Consolas', 15, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Cortana.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$EnableCortana = New-Object system.Windows.Forms.Button
$EnableCortana.FlatStyle = 'Flat'
$EnableCortana.text = "ENABLE"
$EnableCortana.width = 133
$EnableCortana.height = 30
$EnableCortana.Anchor = 'top,right,left'
$EnableCortana.location = New-Object System.Drawing.Point(10, 40)
$EnableCortana.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$EnableCortana.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$DisableCortana = New-Object system.Windows.Forms.Button
$DisableCortana.FlatStyle = 'Flat'
$DisableCortana.text = "DISABLE"
$DisableCortana.width = 133
$DisableCortana.height = 30
$DisableCortana.Anchor = 'top,right,left'
$DisableCortana.location = New-Object System.Drawing.Point(10, 80)
$DisableCortana.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$DisableCortana.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Edge = New-Object system.Windows.Forms.Label
$Edge.text = "EDGE PDF"
$Edge.AutoSize = $true
$Edge.width = 457
$Edge.height = 142
$Edge.Anchor = 'top,right,left'
$Edge.location = New-Object System.Drawing.Point(10, 10)
$Edge.Font = New-Object System.Drawing.Font('Consolas', 15, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Edge.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$EnableEdgePDFTakeover = New-Object system.Windows.Forms.Button
$EnableEdgePDFTakeover.FlatStyle = 'Flat'
$EnableEdgePDFTakeover.text = "ENABLE"
$EnableEdgePDFTakeover.width = 134
$EnableEdgePDFTakeover.height = 30
$EnableEdgePDFTakeover.Anchor = 'top,right,left'
$EnableEdgePDFTakeover.location = New-Object System.Drawing.Point(10, 40)
$EnableEdgePDFTakeover.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$EnableEdgePDFTakeover.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$DisableEdgePDFTakeover = New-Object system.Windows.Forms.Button
$DisableEdgePDFTakeover.FlatStyle = 'Flat'
$DisableEdgePDFTakeover.text = "DISABLE"
$DisableEdgePDFTakeover.width = 134
$DisableEdgePDFTakeover.height = 30
$DisableEdgePDFTakeover.Anchor = 'top,right,left'
$DisableEdgePDFTakeover.location = New-Object System.Drawing.Point(10, 80)
$DisableEdgePDFTakeover.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$DisableEdgePDFTakeover.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Theme = New-Object system.Windows.Forms.Label
$Theme.text = "DARK THEME"
$Theme.AutoSize = $true
$Theme.width = 457
$Theme.height = 142
$Theme.Anchor = 'top,right,left'
$Theme.location = New-Object System.Drawing.Point(10, 10)
$Theme.Font = New-Object System.Drawing.Font('Consolas', 15, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Theme.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$EnableDarkMode = New-Object system.Windows.Forms.Button
$EnableDarkMode.FlatStyle = 'Flat'
$EnableDarkMode.text = "ENABLE"
$EnableDarkMode.width = 133
$EnableDarkMode.height = 30
$EnableDarkMode.Anchor = 'top,right,left'
$EnableDarkMode.location = New-Object System.Drawing.Point(10, 40)
$EnableDarkMode.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$EnableDarkMode.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$DisableDarkMode = New-Object system.Windows.Forms.Button
$DisableDarkMode.FlatStyle = 'Flat'
$DisableDarkMode.text = "DISABLE"
$DisableDarkMode.width = 133
$DisableDarkMode.height = 30
$DisableDarkMode.Anchor = 'top,right,left'
$DisableDarkMode.location = New-Object System.Drawing.Point(10, 80)
$DisableDarkMode.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$DisableDarkMode.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Other = New-Object system.Windows.Forms.Label
$Other.text = "OTHER CHANGES & FIXES"
$Other.AutoSize = $true
$Other.width = 457
$Other.height = 142
$Other.Anchor = 'top,right,left'
$Other.location = New-Object System.Drawing.Point(10, 10)
$Other.Font = New-Object System.Drawing.Font('Consolas', 15, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Other.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$RemoveOnedrive = New-Object system.Windows.Forms.Button
$RemoveOnedrive.FlatStyle = 'Flat'
$RemoveOnedrive.text = "UNINSTALL ONEDRIVE"
$RemoveOnedrive.width = 225
$RemoveOnedrive.height = 30
$RemoveOnedrive.Anchor = 'top,right,left'
$RemoveOnedrive.location = New-Object System.Drawing.Point(10, 40)
$RemoveOnedrive.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$RemoveOnedrive.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$UnpinStartMenuTiles = New-Object system.Windows.Forms.Button
$UnpinStartMenuTiles.FlatStyle = 'Flat'
$UnpinStartMenuTiles.text = "UNPIN TILES FROM START MENU"
$UnpinStartMenuTiles.width = 225
$UnpinStartMenuTiles.height = 30
$UnpinStartMenuTiles.Anchor = 'top,right,left'
$UnpinStartMenuTiles.location = New-Object System.Drawing.Point(245, 40)
$UnpinStartMenuTiles.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$UnpinStartMenuTiles.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$DisableTelemetry = New-Object system.Windows.Forms.Button
$DisableTelemetry.FlatStyle = 'Flat'
$DisableTelemetry.text = "DISABLE TELEMETRY / TASKS"
$DisableTelemetry.width = 225
$DisableTelemetry.height = 30
$DisableTelemetry.Anchor = 'top,right,left'
$DisableTelemetry.location = New-Object System.Drawing.Point(10, 80)
$DisableTelemetry.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$DisableTelemetry.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$RemoveRegkeys = New-Object system.Windows.Forms.Button
$RemoveRegkeys.FlatStyle = 'Flat'
$RemoveRegkeys.text = "REMOVE BLOATWARE REGKEYS"
$RemoveRegkeys.width = 225
$RemoveRegkeys.height = 30
$RemoveRegkeys.Anchor = 'top,right,left'
$RemoveRegkeys.location = New-Object System.Drawing.Point(245, 80)
$RemoveRegkeys.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$RemoveRegkeys.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$RestoreWhitelistedApps = New-Object system.Windows.Forms.Button
$RestoreWhitelistedApps.FlatStyle = 'Flat'
$RestoreWhitelistedApps.text = "RESTORE IMPORTANT APPS"
$RestoreWhitelistedApps.width = 225
$RestoreWhitelistedApps.height = 30
$RestoreWhitelistedApps.Anchor = 'top,right,left'
$RestoreWhitelistedApps.location = New-Object System.Drawing.Point(10, 120)
$RestoreWhitelistedApps.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$RestoreWhitelistedApps.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")
$RestoreWhitelistedApps.Add_Click({
        FixWhitelistedApps
    })

$InstallNet35 = New-Object system.Windows.Forms.Button
$InstallNet35.FlatStyle = 'Flat'
$InstallNet35.text = "INSTALL .NET V3.5"
$InstallNet35.width = 225
$InstallNet35.height = 30
$InstallNet35.Anchor = 'top,right,left'
$InstallNet35.location = New-Object System.Drawing.Point(245, 120)
$InstallNet35.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$InstallNet35.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Win11Features = New-Object system.Windows.Forms.Button
$Win11Features.FlatStyle = 'Flat'
$Win11Features.text = "APLICAR AJUSTES WINDOWS 11"
$Win11Features.width = 460
$Win11Features.height = 30
$Win11Features.Anchor = 'top,right,left'
$Win11Features.location = New-Object System.Drawing.Point(10, 160)
$Win11Features.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
$Win11Features.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")
$Win11Features.Add_Click({
        HandleWindows11Features
    })

# Añade un botón para esta función
$CleanTemp = New-Object system.Windows.Forms.Button
$CleanTemp.FlatStyle = 'Flat'
$CleanTemp.text = "LIMPIAR ARCHIVOS TEMPORALES"
$CleanTemp.width = 460
$CleanTemp.height = 30
$CleanTemp.Anchor = 'top,right,left'
$CleanTemp.location = New-Object System.Drawing.Point(10, 200)
$CleanTemp.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$CleanTemp.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$CleanTemp.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#0078d7")
$CleanTemp.Add_Click({
        CleanTempFiles
    })

$Form.controls.AddRange(@($RegistryPanel, $DebloatPanel, $CortanaPanel, $EdgePanel, $DarkThemePanel, $OtherPanel, $CheckUpdates))
$DebloatPanel.controls.AddRange(@($Debloat, $CustomizeBlacklist, $RemoveAllBloatware, $RemoveBlacklistedBloatware))
$RegistryPanel.controls.AddRange(@($Registry, $RevertChanges))
$CortanaPanel.controls.AddRange(@($Cortana, $EnableCortana, $DisableCortana))
$EdgePanel.controls.AddRange(@($EnableEdgePDFTakeover, $DisableEdgePDFTakeover, $Edge))
$DarkThemePanel.controls.AddRange(@($Theme, $DisableDarkMode, $EnableDarkMode))
$OtherPanel.controls.AddRange(@($Other, $RemoveOnedrive, $UnpinStartMenuTiles, $DisableTelemetry, $RemoveRegkeys, $RestoreWhitelistedApps, $InstallNet35, $Win11Features, $CleanTemp))

$DebloatFolder = "C:\Temp\Windows10Debloater"
If (Test-Path $DebloatFolder) {
    Write-Host "${DebloatFolder} exists. Skipping."
}
Else {
    Write-Host "The folder ${DebloatFolder} doesn't exist. This folder will be used for storing logs created after the script runs. Creating now."
    Start-Sleep 1
    New-Item -Path "${DebloatFolder}" -ItemType Directory
    Write-Host "The folder ${DebloatFolder} was successfully created."
}

Start-Transcript -OutputDirectory "${DebloatFolder}"

Write-Output "Creating System Restore Point if one does not already exist. If one does, then you will receive a warning. Please wait..."
Checkpoint-Computer -Description "Before using W10DebloaterGUI.ps1" 


#region gui events {
$CustomizeBlacklist.Add_Click( {
        $CustomizeForm = New-Object System.Windows.Forms.Form
        $CustomizeForm.ClientSize = New-Object System.Drawing.Point(580, 570)
        $CustomizeForm.StartPosition = 'CenterScreen'
        $CustomizeForm.FormBorderStyle = 'FixedSingle'
        $CustomizeForm.MinimizeBox = $false
        $CustomizeForm.MaximizeBox = $false
        $CustomizeForm.ShowIcon = $false
        $CustomizeForm.Text = "Customize Allowlist and Blocklist"
        $CustomizeForm.TopMost = $false
        $CustomizeForm.AutoScroll = $false
        $CustomizeForm.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#252525")

        $ListPanel = New-Object system.Windows.Forms.Panel
        $ListPanel.height = 510
        $ListPanel.width = 572
        $ListPanel.Anchor = 'top,right,left'
        $ListPanel.location = New-Object System.Drawing.Point(10, 10)
        $ListPanel.AutoScroll = $true
        $ListPanel.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#252525")


        $SaveList = New-Object System.Windows.Forms.Button
        $SaveList.FlatStyle = 'Flat'
        $SaveList.Text = "Save custom Allowlist and Blocklist to custom-lists.ps1"
        $SaveList.width = 560
        $SaveList.height = 30
        $SaveList.Location = New-Object System.Drawing.Point(10, 530)
        $SaveList.Font = New-Object System.Drawing.Font('Consolas', 9, [System.Drawing.FontStyle]::Regular)
        $SaveList.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

        $CustomizeForm.controls.AddRange(@($SaveList, $ListPanel))

        $SaveList.Add_Click( {
                # $ErrorActionPreference = 'SilentlyContinue'

                '$global:WhiteListedApps = @(' | Out-File -FilePath $PSScriptRoot\custom-lists.ps1 -Encoding utf8
                @($ListPanel.controls) | ForEach-Object {
                    if ($_ -is [System.Windows.Forms.CheckBox] -and $_.Enabled -and !$_.Checked) {
                        "    ""$( $_.Text )""" | Out-File -FilePath $PSScriptRoot\custom-lists.ps1 -Append -Encoding utf8
                    }
                }
                ')' | Out-File -FilePath $PSScriptRoot\custom-lists.ps1 -Append -Encoding utf8

                '$global:Bloatware = @(' | Out-File -FilePath $PSScriptRoot\custom-lists.ps1 -Append -Encoding utf8
                @($ListPanel.controls) | ForEach-Object {
                    if ($_ -is [System.Windows.Forms.CheckBox] -and $_.Enabled -and $_.Checked) {
                        "    ""$($_.Text)""" | Out-File -FilePath $PSScriptRoot\custom-lists.ps1 -Append -Encoding utf8
                    }
                }
                ')' | Out-File -FilePath $PSScriptRoot\custom-lists.ps1 -Append -Encoding utf8

                #Over-ride the white/blacklist with the newly saved custom list
                dotInclude custom-lists.ps1

                #convert to regular expression to allow for the super-useful -match operator
                $global:BloatwareRegex = $global:Bloatware -join '|'
                $global:WhiteListedAppsRegex = $global:WhiteListedApps -join '|'
            })

        Function AddAppToCustomizeForm() {
            Param(
                [Parameter(Mandatory)]
                [int] $position,
                [Parameter(Mandatory)]
                [string] $appName,
                [Parameter(Mandatory)]
                [bool] $enabled,
                [Parameter(Mandatory)]
                [bool] $checked,
                [Parameter(Mandatory)]
                [bool] $autocheck,

                [string] $notes
            )

            $label = New-Object System.Windows.Forms.Label
            $label.Location = New-Object System.Drawing.Point(-10, (2 + $position * 25))
            $label.Text = $notes
            $label.Font = New-Object System.Drawing.Font('Consolas', 8, [System.Drawing.FontStyle]::Regular)
            $label.Width = 260
            $label.Height = 27
            $Label.TextAlign = [System.Drawing.ContentAlignment]::TopRight
            $label.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#888888")
            $ListPanel.controls.AddRange(@($label))

            $Checkbox = New-Object System.Windows.Forms.CheckBox
            $Checkbox.Text = $appName
            $CheckBox.Font = New-Object System.Drawing.Font('Consolas', 8, [System.Drawing.FontStyle]::Regular)
            $CheckBox.FlatStyle = 'Flat'
            $CheckBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")
            $Checkbox.Location = New-Object System.Drawing.Point(268, (0 + $position * 25))
            $Checkbox.Autosize = 1;
            $Checkbox.Checked = $checked
            $Checkbox.Enabled = $enabled
            $CheckBox.AutoCheck = $autocheck
            $ListPanel.controls.AddRange(@($CheckBox))
        }


        $Installed = @( (Get-AppxPackage).Name )
        $Online = @( (Get-AppxProvisionedPackage -Online).DisplayName )
        $AllUsers = @( (Get-AppxPackage -AllUsers).Name )
        [int]$checkboxCounter = 0

        ForEach ($item in $NonRemovables) {
            $string = ""
            if ( $null -notmatch $global:BloatwareRegex -and $item -cmatch $global:BloatwareRegex ) { $string += " ConflictBlacklist " }
            if ( $null -notmatch $global:WhiteListedAppsRegex -and $item -cmatch $global:WhiteListedAppsRegex ) { $string += " ConflictWhitelist" }
            if ( $null -notmatch $Installed -and $Installed -cmatch $item) { $string += "Installed" }
            if ( $null -notmatch $AllUsers -and $AllUsers -cmatch $item) { $string += " AllUsers" }
            if ( $null -notmatch $Online -and $Online -cmatch $item) { $string += " Online" }
            $string += "  Non-Removable"
            AddAppToCustomizeForm $checkboxCounter $item $true $false $false $string
            ++$checkboxCounter
        }
        ForEach ( $item in $global:WhiteListedApps ) {
            $string = ""
            if ( $null -notmatch $NonRemovables -and $NonRemovables -cmatch $item ) { $string += " Conflict NonRemovables " }
            if ( $null -notmatch $global:BloatwareRegex -and $item -cmatch $global:BloatwareRegex ) { $string += " ConflictBlacklist " }
            if ( $null -notmatch $Installed -and $Installed -cmatch $item) { $string += "Installed" }
            if ( $null -notmatch $AllUsers -and $AllUsers -cmatch $item) { $string += " AllUsers" }
            if ( $null -notmatch $Online -and $Online -cmatch $item) { $string += " Online" }
            AddAppToCustomizeForm $checkboxCounter $item $true $false $true $string
            ++$checkboxCounter
        }
        ForEach ( $item in $global:Bloatware ) {
            $string = ""
            if ( $null -notmatch $NonRemovables -and $NonRemovables -cmatch $item ) { $string += " Conflict NonRemovables " }
            if ( $null -notmatch $global:WhiteListedAppsRegex -and $item -cmatch $global:WhiteListedAppsRegex ) { $string += " Conflict Whitelist " }
            if ( $null -notmatch $Installed -and $Installed -cmatch $item) { $string += "Installed" }
            if ( $null -notmatch $AllUsers -and $AllUsers -cmatch $item) { $string += " AllUsers" }
            if ( $null -notmatch $Online -and $Online -cmatch $item) { $string += " Online" }
            AddAppToCustomizeForm $checkboxCounter $item $true $true $true $string
            ++$checkboxCounter
        }
        ForEach ( $item in $AllUsers ) {
            $string = "NEW   AllUsers"
            if ( $null -notmatch $NonRemovables -and $NonRemovables -cmatch $item ) { continue }
            if ( $null -notmatch $global:WhiteListedAppsRegex -and $item -cmatch $global:WhiteListedAppsRegex ) { continue }
            if ( $null -notmatch $global:BloatwareRegex -and $item -cmatch $global:BloatwareRegex ) { continue }
            if ( $null -notmatch $Installed -and $Installed -cmatch $item) { $string += " Installed" }
            if ( $null -notmatch $Online -and $Online -cmatch $item) { $string += " Online" }
            AddAppToCustomizeForm $checkboxCounter $item $true $true $true $string
            ++$checkboxCounter
        }
        ForEach ( $item in $Installed ) {
            $string = "NEW   Installed"
            if ( $null -notmatch $NonRemovables -and $NonRemovables -cmatch $item ) { continue }
            if ( $null -notmatch $global:WhiteListedAppsRegex -and $item -cmatch $global:WhiteListedAppsRegex ) { continue }
            if ( $null -notmatch $global:BloatwareRegex -and $item -cmatch $global:BloatwareRegex ) { continue }
            if ( $null -notmatch $AllUsers -and $AllUsers -cmatch $item) { continue }
            if ( $null -notmatch $Online -and $Online -cmatch $item) { $string += " Online" }
            AddAppToCustomizeForm $checkboxCounter $item $true $true $true $string
            ++$checkboxCounter
        }
        ForEach ( $item in $Online ) {
            $string = "NEW   Online "
            if ( $null -notmatch $NonRemovables -and $NonRemovables -cmatch $item ) { continue }
            if ( $null -notmatch $global:WhiteListedAppsRegex -and $item -cmatch $global:WhiteListedAppsRegex ) { continue }
            if ( $null -notmatch $global:BloatwareRegex -and $item -cmatch $global:BloatwareRegex ) { continue }
            if ( $null -notmatch $Installed -and $Installed -cmatch $item) { continue }
            if ( $null -notmatch $AllUsers -and $AllUsers -cmatch $item) { continue }
            AddAppToCustomizeForm $checkboxCounter $item $true $true $true $string
            ++$checkboxCounter
        }
        [void]$CustomizeForm.ShowDialog()
    })


$RemoveBlacklistedBloatware.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        Function DebloatBlacklist {
            Write-Host "Requesting removal of $global:BloatwareRegex"
            Write-Host "--- This may take a while - please be patient ---"
            Get-AppxPackage | Where-Object Name -cmatch $global:BloatwareRegex | Remove-AppxPackage
            Write-Host "...now starting the silent ProvisionedPackage bloatware removal..."
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -cmatch $global:BloatwareRegex | Remove-AppxProvisionedPackage -Online
            Write-Host "...and the final cleanup..."
            Get-AppxPackage -AllUsers | Where-Object Name -cmatch $global:BloatwareRegex | Remove-AppxPackage
        }
        Write-Host "`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`nRemoving blocklisted Bloatware.`n"
        DebloatBlacklist
        Write-Host "Bloatware removed!"
    })
$RemoveAllBloatware.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        #This function finds any AppX/AppXProvisioned package and uninstalls it, except for Freshpaint, Windows Calculator, Windows Store, and Windows Photos.
        #Also, to note - This does NOT remove essential system services/software/etc such as .NET framework installations, Cortana, Edge, etc.

        #This is the switch parameter for running this script as a 'silent' script, for use in MDT images or any type of mass deployment without user interaction.

        Function Start-SysPrep {

            Write-Host "Starting Sysprep Fixes"
   
            # Disable Windows Store Automatic Updates
            Write-Host "Adding Registry key to Disable Windows Store Automatic Updates"
            $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
            If (!(Test-Path $registryPath)) {
                Mkdir $registryPath
                New-ItemProperty $registryPath AutoDownload -Value 2 
            }
            Set-ItemProperty $registryPath AutoDownload -Value 2

            #Stop WindowsStore Installer Service and set to Disabled
            Write-Host "Stopping InstallService"
            Stop-Service InstallService
            Write-Host "Setting InstallService Startup to Disabled"
            Set-Service InstallService -StartupType Disabled
        }
        
        Function CheckDMWService {

            Param([switch]$Debloat)
  
            If (Get-Service dmwappushservice | Where-Object { $_.StartType -eq "Disabled" }) {
                Set-Service dmwappushservice -StartupType Automatic
            }

            If (Get-Service dmwappushservice | Where-Object { $_.Status -eq "Stopped" }) {
                Start-Service dmwappushservice
            } 
        }

        Function DebloatAll {
            #Removes AppxPackages
            Get-AppxPackage | Where-Object { !($_.Name -cmatch $global:WhiteListedAppsRegex) -and !($NonRemovables -cmatch $_.Name) } | Remove-AppxPackage
            Get-AppxProvisionedPackage -Online | Where-Object { !($_.DisplayName -cmatch $global:WhiteListedAppsRegex) -and !($NonRemovables -cmatch $_.DisplayName) } | Remove-AppxProvisionedPackage -Online
            Get-AppxPackage -AllUsers | Where-Object { !($_.Name -cmatch $global:WhiteListedAppsRegex) -and !($NonRemovables -cmatch $_.Name) } | Remove-AppxPackage
        }
  
        #Creates a PSDrive to be able to access the 'HKCR' tree
        New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
  
        Function Remove-Keys {         
            #These are the registry keys that it will delete.
          
            $Keys = @(
          
                #Remove Background Tasks
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
          
                #Windows File
                "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
          
                #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
          
                #Scheduled Tasks to delete
                "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
          
                #Windows Protocol Keys
                "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
                "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
             
                #Windows Share Target
                "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            )
      
            #This writes the output of each key it is removing and also removes the keys listed above.
            ForEach ($Key in $Keys) {
                Write-Host "Removing $Key from registry"
                Remove-Item $Key -Recurse
            }
        }
          
        Function Protect-Privacy { 
  
            #Creates a PSDrive to be able to access the 'HKCR' tree
            New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
          
            #Disables Windows Feedback Experience
            Write-Host "Disabling Windows Feedback Experience program"
            $Advertising = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
            If (Test-Path $Advertising) {
                Set-ItemProperty $Advertising Enabled -Value 0
            }
          
            #Stops Cortana from being used as part of your Windows Search Function
            Write-Host "Stopping Cortana from being used as part of your Windows Search Function"
            $Search = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
            If (Test-Path $Search) {
                Set-ItemProperty $Search AllowCortana -Value 0
            }
          
            #Stops the Windows Feedback Experience from sending anonymous data
            Write-Host "Stopping the Windows Feedback Experience program"
            $Period1 = 'HKCU:\Software\Microsoft\Siuf'
            $Period2 = 'HKCU:\Software\Microsoft\Siuf\Rules'
            $Period3 = 'HKCU:\Software\Microsoft\Siuf\Rules\PeriodInNanoSeconds'
            If (!(Test-Path $Period3)) { 
                mkdir $Period1
                mkdir $Period2
                mkdir $Period3
                New-ItemProperty $Period3 PeriodInNanoSeconds -Value 0
            }
                 
            Write-Host "Adding Registry key to prevent bloatware apps from returning"
            #Prevents bloatware applications from returning
            $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
            If (!(Test-Path $registryPath)) {
                Mkdir $registryPath
                New-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1 
            }          
      
            Write-Host "Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings"
            $Holo = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic'    
            If (Test-Path $Holo) {
                Set-ItemProperty $Holo FirstRunSucceeded -Value 0
            }
      
            #Disables live tiles
            Write-Host "Disabling live tiles"
            $Live = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications'    
            If (!(Test-Path $Live)) {
                mkdir $Live  
                New-ItemProperty $Live NoTileApplicationNotification -Value 1
            }
      
            #Turns off Data Collection via the AllowTelemtry key by changing it to 0
            Write-Host "Turning off Data Collection"
            $DataCollection = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection'    
            If (Test-Path $DataCollection) {
                Set-ItemProperty $DataCollection AllowTelemetry -Value 0
            }
      
            #Disables People icon on Taskbar
            Write-Host "Disabling People icon on Taskbar"
            $People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
            If (Test-Path $People) {
                Set-ItemProperty $People PeopleBand -Value 0
            }
  
            #Disables suggestions on start menu
            Write-Host "Disabling suggestions on the Start Menu"
            $Suggestions = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'    
            If (Test-Path $Suggestions) {
                Set-ItemProperty $Suggestions SystemPaneSuggestionsEnabled -Value 0
            }
            
            Write-Host "Disabling Bing Search when using Search via the Start Menu"
            $BingSearch = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
            If (Test-Path $BingSearch) {
                Set-ItemProperty $BingSearch DisableSearchBoxSuggestions -Value 1
            }
            
            Write-Host "Removing CloudStore from registry if it exists"
            $CloudStore = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore'
            If (Test-Path $CloudStore) {
                Stop-Process Explorer.exe -Force
                Remove-Item $CloudStore -Recurse -Force
                Start-Process Explorer.exe -Wait
            }

  
            #Loads the registry keys/values below into the NTUSER.DAT file which prevents the apps from redownloading. Credit to a60wattfish
            reg load HKU\Default_User C:\Users\Default\NTUSER.DAT
            Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SystemPaneSuggestionsEnabled -Value 0
            Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name PreInstalledAppsEnabled -Value 0
            Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name OemPreInstalledAppsEnabled -Value 0
            reg unload HKU\Default_User
      
            #Disables scheduled tasks that are considered unnecessary 
            Write-Host "Disabling scheduled tasks"
            #Get-ScheduledTask -TaskName XblGameSaveTaskLogon | Disable-ScheduledTask
            Get-ScheduledTask -TaskName XblGameSaveTask | Disable-ScheduledTask
            Get-ScheduledTask -TaskName Consolidator | Disable-ScheduledTask
            Get-ScheduledTask -TaskName UsbCeip | Disable-ScheduledTask
            Get-ScheduledTask -TaskName DmClient | Disable-ScheduledTask
            Get-ScheduledTask -TaskName DmClientOnScenarioDownload | Disable-ScheduledTask
        }

        Function UnpinStart {
            # https://superuser.com/a/1442733
            # Requires -RunAsAdministrator

            $START_MENU_LAYOUT = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
    <LayoutOptions StartTileGroupCellWidth="6" />
    <DefaultLayoutOverride>
        <StartLayoutCollection>
            <defaultlayout:StartLayout GroupCellWidth="6" />
        </StartLayoutCollection>
    </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@

            $layoutFile = "C:\Windows\StartMenuLayout.xml"

            #Delete layout file if it already exists
            If (Test-Path $layoutFile) {
                Remove-Item $layoutFile
            }

            #Creates the blank layout file
            $START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII

            $regAliases = @("HKLM", "HKCU")

            #Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
            foreach ($regAlias in $regAliases) {
                $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
                $keyPath = $basePath + "\Explorer" 
                IF (!(Test-Path -Path $keyPath)) { 
                    New-Item -Path $basePath -Name "Explorer"
                }
                Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
                Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
            }

            #Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
            Stop-Process -name explorer
            Start-Sleep -s 5
            $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
            Start-Sleep -s 5

            #Enable the ability to pin items again by disabling "LockedStartLayout"
            foreach ($regAlias in $regAliases) {
                $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
                $keyPath = $basePath + "\Explorer" 
                Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
            }

            #Restart Explorer and delete the layout file
            Stop-Process -name explorer

            # Uncomment the next line to make clean start menu default for all new users
            #Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\

            Remove-Item $layoutFile
        }
        
        Function CheckInstallService {
  
            If (Get-Service InstallService | Where-Object { $_.Status -eq "Stopped" }) {  
                Start-Service InstallService
                Set-Service InstallService -StartupType Automatic 
            }
        }
  
        Write-Host "Initiating Sysprep"
        Start-SysPrep
        Write-Host "Removing bloatware apps."
        DebloatAll
        Write-Host "Removing leftover bloatware registry keys."
        Remove-Keys
        Write-Host "Checking to see if any Allowlisted Apps were removed, and if so re-adding them."
        FixWhitelistedApps
        Write-Host "Stopping telemetry, disabling unneccessary scheduled tasks, and preventing bloatware from returning."
        Protect-Privacy
        Write-Host "Unpinning tiles from the Start Menu."
        UnpinStart
        Write-Host "Setting the 'InstallService' Windows service back to 'Started' and the Startup Type 'Automatic'."
        CheckDMWService
        CheckInstallService
        Write-Host "Finished all tasks. `n"
  
    } )
$RevertChanges.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        #This function will revert the changes you made when running the Start-Debloat function.
        
        #This line reinstalls all of the bloatware that was removed
        Get-AppxPackage -AllUsers | ForEach-Object { Add-AppxPackage -Verbose -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" } 
    
        #Tells Windows to enable your advertising information.    
        Write-Host "Re-enabling key to show advertisement information"
        $Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
        If (Test-Path $Advertising) {
            Set-ItemProperty $Advertising  Enabled -Value 1
        }
            
        #Enables Cortana to be used as part of your Windows Search Function
        Write-Host "Re-enabling Cortana to be used in your Windows Search"
        $Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        If (Test-Path $Search) {
            Set-ItemProperty $Search  AllowCortana -Value 1 
        }
            
        #Re-enables the Windows Feedback Experience for sending anonymous data
        Write-Host "Re-enabling Windows Feedback Experience"
        $Period = "HKCU:\Software\Microsoft\Siuf\Rules"
        If (!(Test-Path $Period)) { 
            New-Item $Period
        }
        Set-ItemProperty $Period PeriodInNanoSeconds -Value 1 
    
        #Enables bloatware applications               
        Write-Host "Adding Registry key to allow bloatware apps to return"
        $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        If (!(Test-Path $registryPath)) {
            New-Item $registryPath 
        }
        Set-ItemProperty $registryPath  DisableWindowsConsumerFeatures -Value 0 
        
        #Changes Mixed Reality Portal Key 'FirstRunSucceeded' to 1
        Write-Host "Setting Mixed Reality Portal value to 1"
        $Holo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic"
        If (Test-Path $Holo) {
            Set-ItemProperty $Holo  FirstRunSucceeded -Value 1 
        }
        
        #Re-enables live tiles
        Write-Host "Enabling live tiles"
        $Live = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
        If (!(Test-Path $Live)) {
            New-Item $Live 
        }
        Set-ItemProperty $Live  NoTileApplicationNotification -Value 0 
       
        #Re-enables data collection
        Write-Host "Re-enabling data collection"
        $DataCollection = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
        If (!(Test-Path $DataCollection)) {
            New-Item $DataCollection
        }
        Set-ItemProperty $DataCollection  AllowTelemetry -Value 1
        
        #Re-enables People Icon on Taskbar
        Write-Host "Enabling People Icon on Taskbar"
        $People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
        If (Test-Path $People) {
            Set-ItemProperty $People -Name PeopleBand -Value 1 -Verbose
        }
    
        #Re-enables suggestions on start menu
        Write-Host "Enabling suggestions on the Start Menu"
        $Suggestions = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        If (!(Test-Path $Suggestions)) {
            New-Item $Suggestions
        }
        Set-ItemProperty $Suggestions  SystemPaneSuggestionsEnabled -Value 1 
        
        #Re-enables scheduled tasks that were disabled when running the Debloat switch
        Write-Host "Enabling scheduled tasks that were disabled"
        Get-ScheduledTask XblGameSaveTaskLogon | Enable-ScheduledTask 
        Get-ScheduledTask  XblGameSaveTask | Enable-ScheduledTask 
        Get-ScheduledTask  Consolidator | Enable-ScheduledTask 
        Get-ScheduledTask  UsbCeip | Enable-ScheduledTask 
        Get-ScheduledTask  DmClient | Enable-ScheduledTask 
        Get-ScheduledTask  DmClientOnScenarioDownload | Enable-ScheduledTask 

        Write-Host "Re-enabling and starting WAP Push Service"
        #Enable and start WAP Push Service
        Set-Service "dmwappushservice" -StartupType Automatic
        Start-Service "dmwappushservice"
    
        Write-Host "Re-enabling and starting the Diagnostics Tracking Service"
        #Enabling the Diagnostics Tracking Service
        Set-Service "DiagTrack" -StartupType Automatic
        Start-Service "DiagTrack"
        Write-Host "Done reverting changes!"

        #
        Write-Output "Restoring 3D Objects from Explorer 'My Computer' submenu"
        $Objects32 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
        $Objects64 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
        If (!(Test-Path $Objects32)) {
            New-Item $Objects32
        }
        If (!(Test-Path $Objects64)) {
            New-Item $Objects64
        }
    })
$DisableCortana.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        Write-Host "Disabling Cortana"
        $Cortana1 = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
        $Cortana2 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
        $Cortana3 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
        If (!(Test-Path $Cortana1)) {
            New-Item $Cortana1
        }
        Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 0 
        If (!(Test-Path $Cortana2)) {
            New-Item $Cortana2
        }
        Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 1 
        Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 1 
        If (!(Test-Path $Cortana3)) {
            New-Item $Cortana3
        }
        Set-ItemProperty $Cortana3 HarvestContacts -Value 0
        Write-Host "Cortana has been disabled."
    })
$DisableEdgePDFTakeover.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        #Stops edge from taking over as the default .PDF viewer    
        Write-Host "Stopping Edge from taking over as the default .PDF viewer"
        $NoPDF = "HKCR:\.pdf"
        $NoProgids = "HKCR:\.pdf\OpenWithProgids"
        $NoWithList = "HKCR:\.pdf\OpenWithList" 
        If (!(Get-ItemProperty $NoPDF  NoOpenWith)) {
            New-ItemProperty $NoPDF NoOpenWith 
        }        
        If (!(Get-ItemProperty $NoPDF  NoStaticDefaultVerb)) {
            New-ItemProperty $NoPDF  NoStaticDefaultVerb 
        }        
        If (!(Get-ItemProperty $NoProgids  NoOpenWith)) {
            New-ItemProperty $NoProgids  NoOpenWith 
        }        
        If (!(Get-ItemProperty $NoProgids  NoStaticDefaultVerb)) {
            New-ItemProperty $NoProgids  NoStaticDefaultVerb 
        }        
        If (!(Get-ItemProperty $NoWithList  NoOpenWith)) {
            New-ItemProperty $NoWithList  NoOpenWith
        }        
        If (!(Get-ItemProperty $NoWithList  NoStaticDefaultVerb)) {
            New-ItemProperty $NoWithList  NoStaticDefaultVerb 
        }
            
        #Appends an underscore '_' to the Registry key for Edge
        $Edge = "HKCR:\AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_"
        If (Test-Path $Edge) {
            Set-Item $Edge AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_ 
        }
        Write-Host "Edge should no longer take over as the default .PDF."
    })
$EnableCortana.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        Write-Host "Re-enabling Cortana"
        $Cortana1 = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
        $Cortana2 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
        $Cortana3 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
        If (!(Test-Path $Cortana1)) {
            New-Item $Cortana1
        }
        Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 1 
        If (!(Test-Path $Cortana2)) {
            New-Item $Cortana2
        }
        Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 0 
        Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 0 
        If (!(Test-Path $Cortana3)) {
            New-Item $Cortana3
        }
        Set-ItemProperty $Cortana3 HarvestContacts -Value 1 
        Write-Host "Cortana has been enabled!"
    })
$EnableEdgePDFTakeover.Add_Click( { 
        New-PSDrive  HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
        $ErrorActionPreference = 'SilentlyContinue'
        Write-Host "Setting Edge back to default"
        $NoPDF = "HKCR:\.pdf"
        $NoProgids = "HKCR:\.pdf\OpenWithProgids"
        $NoWithList = "HKCR:\.pdf\OpenWithList"
        #Sets edge back to default
        If (Get-ItemProperty $NoPDF  NoOpenWith) {
            Remove-ItemProperty $NoPDF  NoOpenWith
        } 
        If (Get-ItemProperty $NoPDF  NoStaticDefaultVerb) {
            Remove-ItemProperty $NoPDF  NoStaticDefaultVerb 
        }       
        If (Get-ItemProperty $NoProgids  NoOpenWith) {
            Remove-ItemProperty $NoProgids  NoOpenWith 
        }        
        If (Get-ItemProperty $NoProgids  NoStaticDefaultVerb) {
            Remove-ItemProperty $NoProgids  NoStaticDefaultVerb 
        }        
        If (Get-ItemProperty $NoWithList  NoOpenWith) {
            Remove-ItemProperty $NoWithList  NoOpenWith
        }    
        If (Get-ItemProperty $NoWithList  NoStaticDefaultVerb) {
            Remove-ItemProperty $NoWithList  NoStaticDefaultVerb
        }
        
        #Removes an underscore '_' from the Registry key for Edge
        $Edge2 = "HKCR:\AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_"
        If (Test-Path $Edge2) {
            Set-Item $Edge2 AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723
        }
        Write-Host "Edge will now be able to be used for .PDF."
    })
$DisableTelemetry.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        #Disables Windows Feedback Experience
        Write-Host "Disabling Windows Feedback Experience program"
        $Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
        If (Test-Path $Advertising) {
            Set-ItemProperty $Advertising Enabled -Value 0 
        }
            
        #Stops Cortana from being used as part of your Windows Search Function
        Write-Host "Stopping Cortana from being used as part of your Windows Search Function"
        $Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        If (Test-Path $Search) {
            Set-ItemProperty $Search AllowCortana -Value 0 
        }

        #Disables Web Search in Start Menu
        Write-Host "Disabling Bing Search in Start Menu"
        $WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0 
        If (!(Test-Path $WebSearch)) {
            New-Item $WebSearch
        }
        Set-ItemProperty $WebSearch DisableWebSearch -Value 1 
            
        #Stops the Windows Feedback Experience from sending anonymous data
        Write-Host "Stopping the Windows Feedback Experience program"
        $Period = "HKCU:\Software\Microsoft\Siuf\Rules"
        If (!(Test-Path $Period)) { 
            New-Item $Period
        }
        Set-ItemProperty $Period PeriodInNanoSeconds -Value 0 

        #Prevents bloatware applications from returning and removes Start Menu suggestions               
        Write-Host "Adding Registry key to prevent bloatware apps from returning"
        $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        $registryOEM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        If (!(Test-Path $registryPath)) { 
            New-Item $registryPath
        }
        Set-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1 

        If (!(Test-Path $registryOEM)) {
            New-Item $registryOEM
        }
        Set-ItemProperty $registryOEM ContentDeliveryAllowed -Value 0 
        Set-ItemProperty $registryOEM OemPreInstalledAppsEnabled -Value 0 
        Set-ItemProperty $registryOEM PreInstalledAppsEnabled -Value 0 
        Set-ItemProperty $registryOEM PreInstalledAppsEverEnabled -Value 0 
        Set-ItemProperty $registryOEM SilentInstalledAppsEnabled -Value 0 
        Set-ItemProperty $registryOEM SystemPaneSuggestionsEnabled -Value 0          
    
        #Preping mixed Reality Portal for removal    
        Write-Host "Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings"
        $Holo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic"    
        If (Test-Path $Holo) {
            Set-ItemProperty $Holo  FirstRunSucceeded -Value 0 
        }

        #Disables Wi-fi Sense
        Write-Host "Disabling Wi-Fi Sense"
        $WifiSense1 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting"
        $WifiSense2 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"
        $WifiSense3 = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
        If (!(Test-Path $WifiSense1)) {
            New-Item $WifiSense1
        }
        Set-ItemProperty $WifiSense1  Value -Value 0 
        If (!(Test-Path $WifiSense2)) {
            New-Item $WifiSense2
        }
        Set-ItemProperty $WifiSense2  Value -Value 0 
        Set-ItemProperty $WifiSense3  AutoConnectAllowedOEM -Value 0 
        
        #Disables live tiles
        Write-Host "Disabling live tiles"
        $Live = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"    
        If (!(Test-Path $Live)) {      
            New-Item $Live
        }
        Set-ItemProperty $Live  NoTileApplicationNotification -Value 1 
        
        #Turns off Data Collection via the AllowTelemtry key by changing it to 0
        Write-Host "Turning off Data Collection"
        $DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
        $DataCollection2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        $DataCollection3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"    
        If (Test-Path $DataCollection1) {
            Set-ItemProperty $DataCollection1  AllowTelemetry -Value 0 
        }
        If (Test-Path $DataCollection2) {
            Set-ItemProperty $DataCollection2  AllowTelemetry -Value 0 
        }
        If (Test-Path $DataCollection3) {
            Set-ItemProperty $DataCollection3  AllowTelemetry -Value 0 
        }
    
        #Disabling Location Tracking
        Write-Host "Disabling Location Tracking"
        $SensorState = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
        $LocationConfig = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
        If (!(Test-Path $SensorState)) {
            New-Item $SensorState
        }
        Set-ItemProperty $SensorState SensorPermissionState -Value 0 
        If (!(Test-Path $LocationConfig)) {
            New-Item $LocationConfig
        }
        Set-ItemProperty $LocationConfig Status -Value 0 
        
        #Disables People icon on Taskbar
        Write-Host "Disabling People icon on Taskbar"
        $People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
        If (Test-Path $People) {
            Set-ItemProperty $People -Name PeopleBand -Value 0
        } 
        
        #Disables scheduled tasks that are considered unnecessary 
        Write-Host "Disabling scheduled tasks"
        #Get-ScheduledTask XblGameSaveTaskLogon | Disable-ScheduledTask
        Get-ScheduledTask XblGameSaveTask | Disable-ScheduledTask
        Get-ScheduledTask Consolidator | Disable-ScheduledTask
        Get-ScheduledTask UsbCeip | Disable-ScheduledTask
        Get-ScheduledTask DmClient | Disable-ScheduledTask
        Get-ScheduledTask DmClientOnScenarioDownload | Disable-ScheduledTask

        #Write-Host "Uninstalling Telemetry Windows Updates"
        #Uninstalls Some Windows Updates considered to be Telemetry. !WIP!
        #Wusa /Uninstall /KB:3022345 /norestart /quiet
        #Wusa /Uninstall /KB:3068708 /norestart /quiet
        #Wusa /Uninstall /KB:3075249 /norestart /quiet
        #Wusa /Uninstall /KB:3080149 /norestart /quiet        

        Write-Host "Stopping and disabling WAP Push Service"
        #Stop and disable WAP Push Service
        Stop-Service "dmwappushservice"
        Set-Service "dmwappushservice" -StartupType Disabled

        Write-Host "Stopping and disabling Diagnostics Tracking Service"
        #Disabling the Diagnostics Tracking Service
        Stop-Service "DiagTrack"
        Set-Service "DiagTrack" -StartupType Disabled
        Write-Host "Telemetry has been disabled!"
    })
$RemoveRegkeys.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        $Keys = @(
            
            New-PSDrive  HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
            
            # Telemetría y recopilación de datos
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
            "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
            "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
            
            # Cortana y búsqueda de Windows
            "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
            "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
            
            # Aplicaciones preinstaladas y sugerencias
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
            "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People"
            
            # Servicios de ubicación
            "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
            "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
            
            # OneDrive
            "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
            "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
            
            # Xbox y juegos
            "HKCU:\System\GameConfigStore"
            "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR"
            
            # Aplicaciones UWP problemáticas
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.YourPhone_8wekyb3d8bbwe"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.Windows.Cortana_cw5n1h2txyewy"
            
            # Servicios de sincronización y notificaciones
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications"
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}"
            
            # Servicios de diagnóstico
            "HKLM:\SYSTEM\CurrentControlSet\Services\DiagTrack"
            "HKLM:\SYSTEM\CurrentControlSet\Services\dmwappushservice"
            "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener"
        )
        
        #This writes the output of each key it is removing and also removes the keys listed above.
        ForEach ($Key in $Keys) {
            Write-Host "Removing $Key from registry"
            Remove-Item $Key -Recurse
        }
        Write-Host "Additional bloatware keys have been removed!"
    })
$UnpinStartMenuTiles.Add_Click( {
        #https://superuser.com/questions/1068382/how-to-remove-all-the-tiles-in-the-windows-10-start-menu
        #Unpins all tiles from the Start Menu
        Write-Host "Unpinning all tiles from the start menu"
        (New-Object -Com Shell.Application).
        NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').
        Items() |
        ForEach-Object { $_.Verbs() } |
        Where-Object { $_.Name -match 'Un.*pin from Start' } |
        ForEach-Object { $_.DoIt() }
    })

$RemoveOnedrive.Add_Click( { 
        If (Test-Path "$env:USERPROFILE\OneDrive\*") {
            Write-Host "Files found within the OneDrive folder! Checking to see if a folder named OneDriveBackupFiles exists."
            Start-Sleep 1
              
            If (Test-Path "$env:USERPROFILE\Desktop\OneDriveBackupFiles") {
                Write-Host "A folder named OneDriveBackupFiles already exists on your desktop. All files from your OneDrive location will be moved to that folder." 
            }
            else {
                If (!(Test-Path "$env:USERPROFILE\Desktop\OneDriveBackupFiles")) {
                    Write-Host "A folder named OneDriveBackupFiles will be created and will be located on your desktop. All files from your OneDrive location will be located in that folder."
                    New-item -Path "$env:USERPROFILE\Desktop" -Name "OneDriveBackupFiles"-ItemType Directory -Force
                    Write-Host "Successfully created the folder 'OneDriveBackupFiles' on your desktop."
                }
            }
            Start-Sleep 1
            Move-Item -Path "$env:USERPROFILE\OneDrive\*" -Destination "$env:USERPROFILE\Desktop\OneDriveBackupFiles" -Force
            Write-Host "Successfully moved all files/folders from your OneDrive folder to the folder 'OneDriveBackupFiles' on your desktop."
            Start-Sleep 1
            Write-Host "Proceeding with the removal of OneDrive."
            Start-Sleep 1
        }
        Else {
            Write-Host "Either the OneDrive folder does not exist or there are no files to be found in the folder. Proceeding with removal of OneDrive."
            Start-Sleep 1
            Write-Host "Enabling the Group Policy 'Prevent the usage of OneDrive for File Storage'."
            $OneDriveKey = 'HKLM:Software\Policies\Microsoft\Windows\OneDrive'
            If (!(Test-Path $OneDriveKey)) {
                Mkdir $OneDriveKey
                Set-ItemProperty $OneDriveKey -Name OneDrive -Value DisableFileSyncNGSC
            }
            Set-ItemProperty $OneDriveKey -Name OneDrive -Value DisableFileSyncNGSC
        }

        Write-Host "Uninstalling OneDrive. Please wait..."
    
        New-PSDrive  HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
        $onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
        $ExplorerReg1 = "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
        $ExplorerReg2 = "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
        Stop-Process -Name "OneDrive*"
        Start-Sleep 2
        If (!(Test-Path $onedrive)) {
            $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
        }
        Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
        Start-Sleep 2
        Write-Host "Stopping explorer"
        Start-Sleep 1
        taskkill.exe /F /IM explorer.exe
        Start-Sleep 3
        Write-Host "Removing leftover files"
        If (Test-Path "$env:USERPROFILE\OneDrive") {
            Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse
        }
        If (Test-Path "$env:LOCALAPPDATA\Microsoft\OneDrive") {
            Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse
        }
        If (Test-Path "$env:PROGRAMDATA\Microsoft OneDrive") {
            Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse
        }
        If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") {
            Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse
        }
        Write-Host "Removing OneDrive from windows explorer"
        If (!(Test-Path $ExplorerReg1)) {
            New-Item $ExplorerReg1
        }
        Set-ItemProperty $ExplorerReg1 System.IsPinnedToNameSpaceTree -Value 0 
        If (!(Test-Path $ExplorerReg2)) {
            New-Item $ExplorerReg2
        }
        Set-ItemProperty $ExplorerReg2 System.IsPinnedToNameSpaceTree -Value 0
        Write-Host "Restarting Explorer that was shut down before."
        Start-Process explorer.exe -NoNewWindow
        Write-Host "OneDrive has been successfully uninstalled!"
        
        Remove-item env:OneDrive
    })

$InstallNet35.Add_Click( {

        Write-Host "Initializing the installation of .NET 3.5..."
        DISM /Online /Enable-Feature /FeatureName:NetFx3 /All
        Write-Host ".NET 3.5 has been successfully installed!"
    } )

$EnableDarkMode.Add_Click( {
        Write-Host "Enabling Dark Mode"
        $Theme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        Set-ItemProperty $Theme AppsUseLightTheme -Value 0
        Start-Sleep 1
        Write-Host "Enabled"
    }
)

$DisableDarkMode.Add_Click( {
        Write-Host "Disabling Dark Mode"
        $Theme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        Set-ItemProperty $Theme AppsUseLightTheme -Value 1
        Start-Sleep 1
        Write-Host "Disabled"
    }
)

[void]$Form.ShowDialog()