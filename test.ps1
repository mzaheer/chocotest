Set-Location -Path c:\projects\chocotest
$changedFiles = git diff --name-only --diff-filter=ACMRTUXB origin/master..HEAD
$nuspecFile = $changedFiles | Where-Object { $_ -like "*.nuspec" }

If ($null -eq $nuspecFile) { Exit }

$packageName = $nuspecFile.Split(".")[0]

Write-Warning "Install MY $packageName"
Add-AppveyorTest -Name "ChocoInstall" -Outcome Running
Invoke-Expression "choco install $packageName -Source \\$env:computername\chocotest" -ErrorVariable foo
$Errors = $Error[0].Exception.Message
If ($LastExitCode -eq 0) {
  Update-AppveyorTest -Name "ChocoInstall" -Outcome Passed
} Else {
  $foo
  Add-AppveyorMessage -Message "Choco install $packageName failed. Check the 'Tests' tab of this build for more details." -Category Warning
  Update-AppveyorTest -Name "ChocoInstall" -Outcome Failed -ErrorMessage $foo
  Throw "Build failed"
}


Write-Warning "Uninstall MY $packageName"
Add-AppveyorTest -Name "ChocoUnInstall" -Outcome Running
Invoke-Expression "choco uninstall $packageName"
If ($LastExitCode -eq 0) {
  Update-AppveyorTest -Name "ChocoUnInstall" -Outcome Passed
} Else {
  Add-AppveyorMessage -Message "Choco uninstall $packageName failed. Check the 'Tests' tab of this build for more details." -Category Warning
  Update-AppveyorTest -Name "ChocoUnInstall" -Outcome Failed -ErrorMessage $Error[0].Exception.Message
  Throw "Build failed"
}
