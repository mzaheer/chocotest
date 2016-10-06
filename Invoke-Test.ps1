$projectLocation = (Get-ChildItem -Path c:\projects -Attributes directory).FullName
$projectLocation | Set-Location
$changedFiles = git diff --name-only --diff-filter=ACMRTUXB origin/master..HEAD
$nuspecFile = $changedFiles | Where-Object { $_ -like "*.nuspec" }

If ($null -eq $nuspecFile) { Exit }

[xml]$nuspecXML = Get-Content -Path $nuspecFile
$packageName = $nuspecXML.package.metadata.id

Write-Output ""
Write-Warning "TEST: Choco Install $packageName"
Add-AppveyorTest -Name "ChocoInstall" -Outcome Running
choco install $packageName -Source $projectLocation
If ($LastExitCode -eq 0) {
  Update-AppveyorTest -Name "ChocoInstall" -Outcome Passed
} Else {
  Add-AppveyorMessage -Message "Choco install $packageName failed. Check the 'Tests' tab of this build for more details." -Category Warning
  Update-AppveyorTest -Name "ChocoInstall" -Outcome Failed -ErrorMessage $Error[0].Exception.Message
  Throw "Build failed"
}

Write-Output ""
Write-Warning "TEST: Choco Uninstall $packageName"
Add-AppveyorTest -Name "ChocoUnInstall" -Outcome Running
choco uninstall $packageName
If ($LastExitCode -eq 0) {
  Update-AppveyorTest -Name "ChocoUnInstall" -Outcome Passed
} Else {
  Add-AppveyorMessage -Message "Choco uninstall $packageName failed. Check the 'Tests' tab of this build for more details." -Category Warning
  Update-AppveyorTest -Name "ChocoUnInstall" -Outcome Failed -ErrorMessage $Error[0].Exception.Message
  Throw "Build failed"
}
