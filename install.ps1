param()

Write-Host @"
 ██╗ ██╗     ██╗   ██╗██╗███╗   ███╗   
████████╗    ██║   ██║██║████╗ ████║   
╚██╔═██╔╝    ██║   ██║██║██╔████╔██║   
████████╗    ╚██╗ ██╔╝██║██║╚██╔╝██║   
╚██╔═██╔╝     ╚████╔╝ ██║██║ ╚═╝ ██║██╗
 ╚═╝ ╚═╝       ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝
"@ -ForegroundColor Blue

Write-Host "[START] RehamVim Dependency Installer for Windows" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] git is not installed" -ForegroundColor Red
    exit 1
}

$pmCommand = $null
if (Get-Command winget -ErrorAction SilentlyContinue) {
    $pmCommand = "winget install --silent"
    Write-Host "[OK] Detected winget package manager" -ForegroundColor Green
} elseif (Get-Command choco -ErrorAction SilentlyContinue) {
    $pmCommand = "choco install -y"
    Write-Host "[OK] Detected Chocolatey package manager" -ForegroundColor Green
} else {
    Write-Host "[ERROR] No package manager found. Please install winget or Chocolatey." -ForegroundColor Red
    exit 1
}

Write-Host "[PKG] Installing external tools: opencode, github-cli, ripgrep, fd, lazygit..." -ForegroundColor Yellow
$externalTools = @("opencode", "ripgrep", "fd", "lazygit", "Github.Cli")
foreach ($tool in $externalTools) {
    try {
        Invoke-Expression "$pmCommand $tool" | Out-Null
        Write-Host "  [OK] $tool installed" -ForegroundColor Green
    } catch {
        Write-Host "  [ERROR] Failed to install $tool" -ForegroundColor Red
        exit 1
    }
}

$languages = @{
    "Go" = "Go.Go"
    "Rust" = "Rustlang.Rustup"
    "Node.js" = "OpenJS.NodeJS"
    "Python" = "Python.Python.3"
}

$selected = @()
Write-Host "[TOOLS] Select languages to install:" -ForegroundColor Magenta
foreach ($lang in $languages.Keys) {
    $choice = Read-Host "  Install $lang? (y/n)"
    if ($choice -match "^[Yy]$") {
        $selected += $lang
    }
}

if ($selected.Count -eq 0) {
    Write-Host "[WARN] No languages selected. Exiting." -ForegroundColor Yellow
    exit 0
}

Write-Host "[PKG] Installing selected languages..." -ForegroundColor Yellow
foreach ($sel in $selected) {
    $pkg = $languages[$sel]
    try {
        Write-Host "  Installing $pkg..." -ForegroundColor Blue
        Invoke-Expression "$pmCommand $pkg" | Out-Null
        Write-Host "  [OK] $sel installed" -ForegroundColor Green
    } catch {
        Write-Host "  [ERROR] Failed to install $sel" -ForegroundColor Red
        exit 1
    }
}

Write-Host "[REPO] Setting up RehamVim config..." -ForegroundColor Magenta

$ConfigDir = "$env:LOCALAPPDATA\nvim"
$RepoUrl = "https://github.com/PzN2s/RehamVim.git"

if (Test-Path $ConfigDir) {
    Write-Host "[WARN] Config directory $ConfigDir already exists." -ForegroundColor Yellow
    $reply = Read-Host "Do you want to (b)ackup, (o)verwrite, or (c)ancel? [b/o/c]"
    
    if ($reply -match "^[Cc]$") {
        Write-Host "[INFO] Installation cancelled" -ForegroundColor Yellow
        exit 0
    } elseif ($reply -match "^[Bb]$") {
        $BackupDir = "${ConfigDir}_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Write-Host "  Creating backup to $BackupDir..." -ForegroundColor Blue
        Copy-Item -Path $ConfigDir -Destination $BackupDir -Recurse -Force
        if ($?) {
            Write-Host "  [OK] Backup created" -ForegroundColor Green
        } else {
            Write-Host "  [ERROR] Failed to create backup" -ForegroundColor Red
            exit 1
        }
        Remove-Item -Path $ConfigDir -Recurse -Force
    } elseif ($reply -match "^[Oo]$") {
        Write-Host "  Removing existing directory..." -ForegroundColor Blue
        Remove-Item -Path $ConfigDir -Recurse -Force
    } else {
        Write-Host "[ERROR] Invalid option. Installation cancelled." -ForegroundColor Red
        exit 1
    }
    
    Write-Host "  Cloning RehamVim..." -ForegroundColor Blue
    git clone $RepoUrl $ConfigDir
    if (-not $?) {
        Write-Host "  [ERROR] Failed to clone repo" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "  Cloning RehamVim..." -ForegroundColor Blue
    git clone $RepoUrl $ConfigDir
    if (-not $?) {
        Write-Host "  [ERROR] Failed to clone repo" -ForegroundColor Red
        exit 1
    }
}

Write-Host "[DONE] RehamVim config ready! Run 'nvim' to start." -ForegroundColor Green
