param(
    [Parameter(Mandatory = $false)]
    [string]$ProjectPath = (Get-Location).Path,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "",

    [Parameter(Mandatory = $false)]
    [switch]$IncludeBuildOutputs
)

$ErrorActionPreference = "Stop"

$ProjectPath = (Resolve-Path $ProjectPath).Path

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $projectName = Split-Path $ProjectPath -Leaf
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $OutputPath = Join-Path (Split-Path $ProjectPath -Parent) "$projectName-source-$timestamp.zip"
}

$OutputPath = [System.IO.Path]::GetFullPath($OutputPath)

# Папки, которые никогда не нужны для анализа исходников.
$ExcludedDirectories = @(
    ".git",
    ".idea",
    ".vs",
    ".vscode",
    "node_modules",
    ".astro",
    ".cache",
    ".parcel-cache",
    ".turbo",
    ".next",
    ".nuxt",
    ".output",
    ".vercel",
    ".netlify",
    "coverage",
    "tmp",
    "temp"
)

if (-not $IncludeBuildOutputs) {
    $ExcludedDirectories += @(
        "dist",
        "build",
        "out",
        "bin",
        "obj"
    )
}

# Файлы/маски, которые не нужны либо могут содержать локальные секреты.
$ExcludedFileNames = @(
    ".env",
    ".env.local",
    ".env.development.local",
    ".env.production.local",
    ".DS_Store",
    "Thumbs.db",
    "desktop.ini"
)

$ExcludedExtensions = @(
    ".log",
    ".tmp",
    ".temp",
    ".bak",
    ".swp",
    ".swo",
    ".user",
    ".suo",
    ".nupkg",
    ".snupkg"
)

# Крупные бинарные/архивные файлы, которые обычно не нужны для анализа исходников.
$ExcludedBinaryExtensions = @(
    ".zip",
    ".7z",
    ".rar",
    ".tar",
    ".gz",
    ".tgz",
    ".iso",
    ".dmp",
    ".dump"
)

# Временная staging-папка.
$stagingRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("project-pack-" + [Guid]::NewGuid().ToString("N"))

try {
    New-Item -ItemType Directory -Path $stagingRoot | Out-Null

    Write-Host "Project: $ProjectPath"
    Write-Host "Archive: $OutputPath"
    Write-Host "Collecting files..."

    $files = Get-ChildItem -LiteralPath $ProjectPath -Recurse -File -Force | Where-Object {
        $file = $_

        # Не включаем сам создаваемый архив, если он лежит внутри проекта.
        if ([System.IO.Path]::GetFullPath($file.FullName) -eq $OutputPath) {
            return $false
        }

        # Проверка директорий по всем сегментам относительного пути.
        $relative = $file.FullName.Substring($ProjectPath.Length).TrimStart('\', '/')
        $segments = $relative -split '[\\/]'

        foreach ($dir in $ExcludedDirectories) {
            if ($segments -contains $dir) {
                return $false
            }
        }

        # Локальные секреты .env* исключаем, но шаблоны оставляем.
        if ($file.Name -match '^\.env(\..+)?$') {
            if ($file.Name -notin @(".env.example", ".env.sample", ".env.template")) {
                return $false
            }
        }

        if ($ExcludedFileNames -contains $file.Name) {
            return $false
        }

        if ($ExcludedExtensions -contains $file.Extension.ToLowerInvariant()) {
            return $false
        }

        if ($ExcludedBinaryExtensions -contains $file.Extension.ToLowerInvariant()) {
            return $false
        }

        return $true
    }

    $count = 0
    $totalBytes = 0

    foreach ($file in $files) {
        $relative = $file.FullName.Substring($ProjectPath.Length).TrimStart('\', '/')
        $destination = Join-Path $stagingRoot $relative
        $destinationDirectory = Split-Path $destination -Parent

        if (-not (Test-Path $destinationDirectory)) {
            New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
        }

        Copy-Item -LiteralPath $file.FullName -Destination $destination -Force

        $count++
        $totalBytes += $file.Length
    }

    if ($count -eq 0) {
        throw "No files selected for archive."
    }

    $outputDirectory = Split-Path $OutputPath -Parent
    if (-not (Test-Path $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    }

    if (Test-Path $OutputPath) {
        Remove-Item -LiteralPath $OutputPath -Force
    }

    Write-Host "Creating ZIP..."
    Compress-Archive -Path (Join-Path $stagingRoot "*") -DestinationPath $OutputPath -CompressionLevel Optimal

    $archive = Get-Item -LiteralPath $OutputPath

    Write-Host ""
    Write-Host "Done."
    Write-Host "Files: $count"
    Write-Host ("Source size: {0:N2} MB" -f ($totalBytes / 1MB))
    Write-Host ("Archive size: {0:N2} MB" -f ($archive.Length / 1MB))
    Write-Host "Archive: $($archive.FullName)"
}
finally {
    if (Test-Path $stagingRoot) {
        Remove-Item -LiteralPath $stagingRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
