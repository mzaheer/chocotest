Set-Location -Path c:\projects\chocotest
$changedFiles = git diff --name-only --diff-filter=ACMRTUXB origin/master..HEAD
$nuspecFile = $changedFiles | Where-Object { $_ -like "*.nuspec" }

If (-not($null -eq $nuspecFile)) {
    Invoke-Expression "choco pack $nuspecFile"
    Write-Warning "Setting up chocotest source"
    New-Item -Path C:\chocotest -Type Directory
    New-SMBShare -Path C:\chocotest -Name chocotest -FullAccess appvyr-win\appveyor
    Copy-Item .\*.nupkg \\$env:computername\chocotest\.
    } Else {
      Write-Warning "No nuspec files found. Nothing to build."
    }
