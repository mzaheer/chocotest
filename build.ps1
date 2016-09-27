Set-Location -Path c:\projects\chocotest\notepadplusplus
Write-Output (Get-ChildItem)
Invoke-Expression "choco pack .\notepadplusplus.nuspec"

Write-Warning "Setting up chocotest source"
New-Item -Path C:\chocotest -Type Directory
New-SMBShare -Path C:\chocotest -Name chocotest -FullAccess appvyr-win\appveyor
Copy-Item .\notepadplusplus*.nupkg \\$env:computername\chocotest\.
