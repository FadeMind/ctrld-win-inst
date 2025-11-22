# ======================================================
#  USUWANIE USŁUGI "ControlD Service DNS" (ctrld)
# ======================================================

# --- 1. Wymuszenie uruchomienia jako administrator ---
$currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Add-Type -AssemblyName PresentationFramework
    $msg = "Skrypt wymaga uprawnień administratora. Uruchomić ponownie z uprawnieniami admin?"
    $res = [System.Windows.MessageBox]::Show($msg, "ControlD – deinstalacja",
        [System.Windows.MessageBoxButton]::YesNo,
        [System.Windows.MessageBoxImage]::Question)

    if ($res -eq [System.Windows.MessageBoxResult]::Yes) {
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    }
    exit
}

Write-Host "`n=== Usuwanie ControlD Service DNS ===`n"


# --- 2. Lokalizacja ctrld.exe ---
$PossiblePaths = @(
    "C:\ControlD\ctrld.exe",
    "$env:ProgramFiles\ControlD\ctrld.exe",
    "$env:ProgramFiles(x86)\ControlD\ctrld.exe"
)

$CtrldPath = $PossiblePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $CtrldPath) {
    Write-Warning "Nie znaleziono ctrld.exe. Kontynuuję czyszczenie systemu..."
} else {
    Write-Host "Znaleziono ctrld.exe: $CtrldPath" -ForegroundColor Green
}

# --- 3. Zatrzymanie usługi Windows (jeśli istnieje) ---
$ServiceName = "ctrld"

if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
    Write-Host "Zatrzymywanie usługi Windows: $ServiceName..."
    Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
    sc.exe delete $ServiceName | Out-Null
} else {
    Write-Host "Usługa Windows 'ctrld' nie istnieje."
}

# --- 4. ctrld.exe stop ---
if ($CtrldPath) {
    Write-Host "Wywołanie: ctrld.exe stop"
    & $CtrldPath stop 2>$null
}

# --- 5. ctrld.exe uninstall ---
if ($CtrldPath) {
    Write-Host "Wywołanie: ctrld.exe uninstall"
    & $CtrldPath uninstall 2>$null
}

# --- 6. Usuwanie folderów pozostałości ---
$DirsToRemove = @(
    "C:\ControlD",
    "$env:ProgramFiles\ControlD",
    "$env:ProgramFiles(x86)\ControlD"
)

foreach ($dir in $DirsToRemove) {
    if (Test-Path $dir) {
        Write-Host "Usuwanie folderu: $dir"
        Remove-Item -Path $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# --- 7. Usuwanie wpisów z Harmonogramu zadań (jeśli były) ---
$TaskName = "ControlD Update"
schtasks /Delete /TN "$TaskName" /F 2>$null | Out-Null

# --- 8. Czyszczenie ścieżek z rejestru ---
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\ctrld"
if (Test-Path $RegPath) {
    Remove-Item $RegPath -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "`n=== ControlD został całkowicie usunięty z systemu ===`n" -ForegroundColor Green
