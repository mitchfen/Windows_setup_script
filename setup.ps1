# Simple check to determine if current user is administrator
$isAdmin = (new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole("Administrators")
if ($isAdmin) {
    # Create a powershell profile
    New-Item -path $profile -type file -force

    Write-Host "Installing chocolatey" -ForegroundColor Magenta
    # This line is from: https://chocolatey.org/install
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

    # Need to refresh before running choco commands
    RefreshEnv.cmd

    # Install git, add Unix tools to PATH, and make vim the default editor
    Write-Host "Installing git and adding to path" -ForegroundColor Magenta
    choco install -y git --package-parameters="'/GitAndUnixToolsOnPath'"

    # Install my frequently used programs
    Write-Host "Beginning installation of programs..." -ForegroundColor Magenta
    $packages = @(
        'python', 'sqlite', 'youtube-dl', 'ffmpeg', 'keepassxc', 'vscode',
        '7zip.install', 'vcredist140', 'docker-desktop', 
        'github-desktop', 'hwinfo', 'nodejs', 'vlc', 'vim'
    )

    choco install $packages

    # Disable hibernation
    powercfg -h off

    #Disable Bing search
    New-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -PropertyType DWORD -Value 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "CortanaConsent" 0

    # Enabling Verbose mode in Windows 10
    New-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name VerboseStatus -PropertyType DWORD -Value 1

   
} else {    
    Write-Host "Please run this script as an administrator" -ForegroundColor Red
}