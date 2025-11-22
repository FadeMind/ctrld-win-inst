# Sprawdzenie, czy skrypt działa jako administrator
$currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Add-Type -AssemblyName PresentationFramework

    $message = "Skrypt wymaga uprawnień administratora. Czy chcesz uruchomić ponownie jako administrator?"
    $caption = "Wymagane uprawnienia administratora"
    $buttons = [System.Windows.MessageBoxButton]::YesNo

    $result = [System.Windows.MessageBox]::Show($message, $caption, $buttons, [System.Windows.MessageBoxImage]::Question)

    if ($result -eq [System.Windows.MessageBoxResult]::Yes) {
        Start-Process -FilePath powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    }
    exit
}

# Jeśli jest adminem, to utwórz folder
if (-not (Test-Path 'C:\ControlD')) {
    New-Item -ItemType Directory -Path 'C:\ControlD' -Force | Out-Null
}

# Ustawienie uprawnień – korzystamy z SID dla pewności
icacls 'C:\ControlD' /grant '*S-1-5-32-544':(OI)(CI)F '*S-1-5-32-545':(OI)(CI)M /T | Out-Null

# Pobierz i zapisz skrypt instalacyjny
(Invoke-WebRequest -Uri 'https://api.controld.com/dl/ps1' -UseBasicParsing).Content |
    Set-Content "$env:TEMP\ctrld_install.ps1"

# Uruchom skrypt
Invoke-Expression "& '$env:TEMP\ctrld_install.ps1' 'x-oisd' 'forced'"

##############################################################################################
#																							 #
# Zamień x-oisd na inny wariant z https://docs.controld.com/docs/free-dns 					 #
# Przykłady: 																				 #
#																							 #
# p0																						 #
# p1 																						 #
# p3																						 #
# x-hagezi-light																			 #
# x-hagezi-normal 																			 #
# x-hagezi-pro 																				 #
# x-hagezi-proplus 																			 #
# x-hagezi-ultimate 																		 #
# x-hagezi-tif 																				 #
# x-adguard 																				 #
#																							 #
##############################################################################################
