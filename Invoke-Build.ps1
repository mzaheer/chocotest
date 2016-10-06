Get-ChildItem -Path c:\projects -Attributes directory | Set-Location
$changedFiles = git diff --name-only --diff-filter=ACMRTUXB origin/master..HEAD
$nuspecFile = $changedFiles | Where-Object { $_ -like "*.nuspec" }

If (-not($null -eq $nuspecFile)) {
    choco pack $nuspecFile
    } Else {
      Write-Warning "No nuspec files found. Nothing to build."
    }
