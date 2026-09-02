#requires -Version 5.1

# RehamVim installer for Windows (winget / Chocolatey).

$ErrorActionPreference = "Stop"

# ────────────────────────────── Banner ────────────────────────────────────

Write-Host @"
██████╗ ███████╗██╗  ██╗ █████╗ ███╗   ███╗
██╔══██╗██╔════╝██║  ██║██╔══██╗████╗ ████║
██████╔╝█████╗  ███████║███████║██╔████╔██║
██╔══██╗██╔══╝  ██╔══██║██╔══██║██║╚██╔╝██║
██║  ██║███████╗██║  ██║██║  ██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝
"@ -ForegroundColor Blue

Write-Host "[START] RehamVim installer for Windows" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

$ErrorActionPreference = "Stop"

function Write-Info  { Write-Host "[RehamVim] $args" -ForegroundColor Cyan }
function Write-Ok    { Write-Host "[OK] $args" -ForegroundColor Green }
function Write-Warn  { Write-Host "[WARN] $args" -ForegroundColor Yellow }
function Write-ErrorS{ Write-Host "[ERROR] $args" -ForegroundColor Red }

$RepoUrl = "https://github.com/PzN2s/RehamVim.git"
$ConfigDir = Join-Path $env:LOCALAPPDATA "nvim"

# ─────────────────────── Package manager detection ────────────────────────

$Winget = $false
$Choco  = $false
if (Get-Command winget -ErrorAction SilentlyContinue) {
    $Winget = $true
    Write-Ok "Detected winget package manager"
} elseif (Get-Command choco -ErrorAction SilentlyContinue) {
    $Choco = $true
    Write-Ok "Detected Chocolatey package manager"
} else {
    Write-ErrorS "No package manager found. Install winget: https://winget.run / ms-windows-store"
    exit 1
}

# ────────────────────────────── Helpers ───────────────────────────────────

function Confirm-PkgInstall {
    param([string]$CommandLine)
    $answer = Read-Host "    Run: $CommandLine — proceed? (Y/n)"
    return ($answer -notmatch '^[Nn]$')
}

function Invoke-PkgInstall {
    param([string[]]$PackageIds)
    foreach ($id in $PackageIds) {
        $cmd = if ($Winget) { "winget install --id $id" } else { "choco install $id -y" }
        if (-not (Confirm-PkgInstall $cmd)) {
            Write-Warn "Skipped by user: $id"
            continue
        }
        Write-Info "Installing: $id"
        try {
            if ($Winget) {
                & winget install --id $id --silent --accept-package-agreements --accept-source-agreements --disable-interactivity
                if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) { throw "winget failed with code $LASTEXITCODE" }
            } else {
                & choco install $id -y --no-progress
                if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) { throw "choco failed with code $LASTEXITCODE" }
            }
            Write-Ok "$id installed"
        } catch {
            Write-Warn "Installation failed for $id : $($_.Exception.Message)"
            $retry = Read-Host "  (r)etry, (s)kip, (e)xit? [r/s/e]"
            switch ($retry) {
                { $_ -match '^[Rr]$' } {
                    $cmd2 = if ($Winget) { "winget install --id $id" } else { "choco install $id -y" }
                    if ((Confirm-PkgInstall $cmd2) -and
                        (($Winget -and (& winget install --id $id --silent --accept-package-agreements --accept-source-agreements)) -or
                         ($Choco -and (& choco install $id -y)))) {
                        Write-Ok "$id installed"
                    } else {
                        Write-Warn "Skipping $id after failed retry."
                    }
                }
                { $_ -match '^[Ee]$' } { Write-ErrorS "Aborted by user."; exit 1 }
                default { Write-Warn "Skipping $id" }
            }
        }
    }
}

function Test-Command {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

# ──────────────────────────── Core dependencies ───────────────────────────

$corePackageIds = @()
if (-not (Test-Command rg))     { $corePackageIds += "BurntSushi.ripgrep.MSVC" }
if (-not (Test-Command fd))     { $corePackageIds += "sharkdp.fd" }
if (-not (Test-Command lazygit)){ $corePackageIds += "JesseDuffield.lazygit" }
if (-not (Test-Command gh))     { $corePackageIds += "GitHub.cli" }
if (-not (Test-Command fzf))    { $corePackageIds += "junegunn.fzf" }
if (-not (Test-Command git))    { $corePackageIds += "Git.Git" }

if ($corePackageIds.Count -gt 0) {
    Invoke-PkgInstall -PackageIds $corePackageIds
} else {
    Write-Ok "All core dependencies already present."
}

# ─────────────────────────────── Neovim ───────────────────────────────────

if (-not (Test-Command nvim)) {
    $answer = Read-Host "Install Neovim? (Y/n)"
    if ($answer -notmatch '^[Nn]$') {
        $nvCmd = if ($Winget) { "winget install --id Neovim.Neovim" } else { "choco install neovim -y" }
        if (Confirm-PkgInstall $nvCmd) {
            Write-Info "Installing Neovim..."
            if ($Winget) {
                & winget install --id Neovim.Neovim --silent --accept-package-agreements --accept-source-agreements
            } else {
                & choco install neovim -y --no-progress
            }
            if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
                Write-Warn "Neovim install returned non-zero; you may need to install it manually."
            } else {
                Write-Ok "Neovim installed"
            }
        } else {
            Write-Warn "Skipping Neovim install."
        }
    } else {
        Write-Warn "Skipping Neovim install."
    }
} else {
    Write-Ok "Neovim already installed."
}

# ──────────────────────── Languages (interactive) ─────────────────────────

$languages = [ordered]@{
    "Go"      = if ($Winget) { "GoLang.Go" } else { "golang" }
    "Rust"    = if ($Winget) { "Rustlang.Rustup" } else { "rustup.install" }
    "Node.js" = if ($Winget) { "OpenJS.NodeJS" } else { "nodejs" }
    "Python"  = if ($Winget) { "Python.Python.3.12" } else { "python3" }
}

$selected = @()
Write-Host ""
Write-Info "Select languages to install:"
foreach ($lang in $languages.Keys) {
    $choice = Read-Host "  Install $lang? (y/N)"
    if ($choice -match '^[Yy]$') { $selected += $lang }
}

if ($selected.Count -gt 0) {
    foreach ($sel in $selected) {
        Invoke-PkgInstall -PackageIds @($languages[$sel])
    }
} else {
    Write-Warn "No languages selected — continuing."
}

# ──────────────────────── Clone / update config ───────────────────────────

if (Test-Path (Join-Path $ConfigDir ".git")) {
    Write-Info "Existing RehamVim install found — updating."
    if (Confirm-PkgInstall "git -C $ConfigDir pull --ff-only") {
        git -C $ConfigDir pull --ff-only
        if (-not $?) { Write-Warn "Could not auto-update; run 'git -C $ConfigDir pull' later." }
    } else {
        Write-Warn "Skipped update by user."
    }
} else {
    if (Test-Path $ConfigDir) {
        Write-Warn "Config directory exists but is not a git repo: $ConfigDir"
        $reply = Read-Host "  (b)ackup, (o)verwrite, (c)ancel? [b/o/c]"
        switch ($reply) {
            { $_ -match '^[Cc]$' } { Write-ErrorS "Cancelled."; exit 0 }
            { $_ -match '^[Bb]$' } {
                $backup = "${ConfigDir}_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                Copy-Item -Path $ConfigDir -Destination $backup -Recurse -Force
                if ($?) { Write-Ok "Backup created: $backup" } else { Write-ErrorS "Backup failed."; exit 1 }
                Remove-Item -Path $ConfigDir -Recurse -Force
            }
            { $_ -match '^[Oo]$' } { Remove-Item -Path $ConfigDir -Recurse -Force }
            default { Write-ErrorS "Invalid option."; exit 1 }
        }
    }
    Write-Info "Cloning RehamVim into $ConfigDir ..."
    if (Confirm-PkgInstall "git clone $RepoUrl $ConfigDir") {
        git clone $RepoUrl $ConfigDir
        if (-not $?) { Write-ErrorS "Clone failed."; exit 1 }
    } else {
        Write-Warn "Skipped config clone by user."
    }
}

Write-Host ""
Write-Ok "RehamVim is ready! Run 'nvim' to start."
Write-Ok "On first run, Lazy installs all plugins automatically."
