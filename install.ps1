param([string]$CfgDirectory)

& {
    param([string]$CfgDirectory)
    $ErrorActionPreference = 'Stop'

    function Find-CS2CfgDirectory {
        $steamPaths = @(
            (Get-ItemProperty -LiteralPath 'HKCU:\Software\Valve\Steam' -ErrorAction SilentlyContinue).SteamPath
            (Get-ItemProperty -LiteralPath 'HKLM:\Software\WOW6432Node\Valve\Steam' -ErrorAction SilentlyContinue).InstallPath
            (Get-ItemProperty -LiteralPath 'HKLM:\Software\Valve\Steam' -ErrorAction SilentlyContinue).InstallPath
            if (${env:ProgramFiles(x86)}) { Join-Path ${env:ProgramFiles(x86)} 'Steam' }
            if ($env:ProgramFiles) { Join-Path $env:ProgramFiles 'Steam' }
        )

        $libraries = foreach ($steamPath in $steamPaths | Where-Object { $_ } | Sort-Object -Unique) {
            if (-not (Test-Path -LiteralPath $steamPath -PathType Container)) { continue }
            $steamPath
            $libraryFile = Join-Path $steamPath 'steamapps\libraryfolders.vdf'
            if (Test-Path -LiteralPath $libraryFile -PathType Leaf) {
                $libraryData = Get-Content -LiteralPath $libraryFile -Raw -Encoding UTF8
                foreach ($entry in [regex]::Matches($libraryData, '(?im)^\s*"path"\s*"([^"\r\n]+)"')) {
                    $entry.Groups[1].Value.Replace('\\', '\')
                }
            }
        }

        foreach ($library in $libraries | Sort-Object -Unique) {
            if (-not (Test-Path -LiteralPath $library -PathType Container)) { continue }
            $steamApps = Join-Path $library 'steamapps'
            $manifest = Join-Path $steamApps 'appmanifest_730.acf'
            $installDir = 'Counter-Strike Global Offensive'
            if (Test-Path -LiteralPath $manifest -PathType Leaf) {
                $manifestData = Get-Content -LiteralPath $manifest -Raw -Encoding UTF8
                if ($manifestData -match '(?im)^\s*"installdir"\s*"([^"\r\n]+)"') {
                    $installDir = $Matches[1]
                }
            }

            $gameRoot = Join-Path (Join-Path $steamApps 'common') $installDir
            $candidate = Join-Path $gameRoot 'game\csgo\cfg'
            if (Test-Path -LiteralPath $candidate -PathType Container) {
                (Resolve-Path -LiteralPath $candidate).Path
            }
        }
    }

    function Save-CS2Archive([string]$Destination) {
        $url = 'https://api.github.com/repos/enkhee-Osiris/cs/zipball/master'
        try {
            Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $Destination
            return
        } catch {
            if ($null -eq $_.Exception.Response -or [int]$_.Exception.Response.StatusCode -ne 404) {
                throw
            }
        }

        if (-not (Get-Command gh -CommandType Application -ErrorAction SilentlyContinue)) {
            throw 'For the private repository, install GitHub CLI and sign in with gh auth login.'
        }
        $token = gh auth token --hostname github.com
        if ($LASTEXITCODE -ne 0 -or -not $token) {
            throw 'Sign in with gh auth login using an account with access to enkhee-Osiris/cs.'
        }
        Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $Destination -Headers @{
            Authorization = "Bearer $token"
        }
    }

    if (Get-Process -Name cs2 -ErrorAction SilentlyContinue) {
        throw 'Close Counter-Strike 2 before installing its configs.'
    }
    if (-not $CfgDirectory) {
        $candidates = @(Find-CS2CfgDirectory | Sort-Object -Unique)
        if ($candidates.Count -ne 1) {
            throw 'Could not find exactly one CS2 cfg directory. Run install.ps1 with -CfgDirectory and the full path to game\csgo\cfg.'
        }
        $CfgDirectory = $candidates[0]
    }
    if (-not (Test-Path -LiteralPath $CfgDirectory -PathType Container)) {
        throw "CS2 cfg directory does not exist: $CfgDirectory"
    }
    $CfgDirectory = (Resolve-Path -LiteralPath $CfgDirectory).Path

    $configFiles = @(
        'autoexec.cfg', 'comp.cfg', 'gren.cfg', 'osiris.cfg',
        'show_keybinds.cfg', 'stop_warmup.cfg', 'warmup.cfg'
    )
    $tempDirectory = Join-Path ([IO.Path]::GetTempPath()) ('osiris-cs2-' + [guid]::NewGuid())
    New-Item -ItemType Directory -Path $tempDirectory | Out-Null
    try {
        $zip = Join-Path $tempDirectory 'cs.zip'
        Save-CS2Archive $zip
        $extracted = Join-Path $tempDirectory 'extracted'
        Expand-Archive -LiteralPath $zip -DestinationPath $extracted
        $source = (Get-ChildItem -LiteralPath $extracted -Directory).FullName
        foreach ($name in $configFiles) {
            $config = Get-Item -LiteralPath (Join-Path $source $name)
            if ($config.PSIsContainer -or $config.Length -eq 0) {
                throw "The archive is missing a usable $name."
            }
        }

        $lockPath = Join-Path $CfgDirectory '.osiris-install.lock'
        $lock = [IO.FileStream]::new(
            $lockPath, [IO.FileMode]::OpenOrCreate, [IO.FileAccess]::Write,
            [IO.FileShare]::None, 1, [IO.FileOptions]::DeleteOnClose
        )
        try {
            $existing = @(
                foreach ($name in $configFiles) {
                    $target = Join-Path $CfgDirectory $name
                    if (Test-Path -LiteralPath $target -PathType Container) {
                        throw "Expected a file but found a directory: $target"
                    }
                    if (Test-Path -LiteralPath $target -PathType Leaf) { $name }
                }
            )

            if ($existing.Count) {
                $backup = Join-Path $CfgDirectory ('osiris-backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
                New-Item -ItemType Directory -Path $backup | Out-Null
                foreach ($name in $existing) {
                    Copy-Item -LiteralPath (Join-Path $CfgDirectory $name) -Destination $backup
                }
                Write-Host "Backup saved to $backup"
            }

            $attempted = [Collections.Generic.List[string]]::new()
            try {
                foreach ($name in $configFiles) {
                    $attempted.Add($name)
                    Copy-Item -LiteralPath (Join-Path $source $name) -Destination (Join-Path $CfgDirectory $name) -Force
                }
            } catch {
                foreach ($name in $attempted) {
                    $target = Join-Path $CfgDirectory $name
                    if ($name -in $existing) {
                        Copy-Item -LiteralPath (Join-Path $backup $name) -Destination $target -Force -ErrorAction Continue
                    } elseif (Test-Path -LiteralPath $target -PathType Leaf) {
                        Remove-Item -LiteralPath $target -Force -ErrorAction Continue
                    }
                }
                throw
            }
        } finally {
            $lock.Dispose()
        }

        Write-Host "Installed $($configFiles.Count) CS2 configs in $CfgDirectory"
        Write-Host 'Start CS2 and run exec autoexec from the main-menu console.'
    } finally {
        Remove-Item -LiteralPath $tempDirectory -Recurse -Force -ErrorAction SilentlyContinue
    }
} $CfgDirectory
