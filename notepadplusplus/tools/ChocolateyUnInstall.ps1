$packageName = 'notepadplusplus'
$fileType = 'EXE'
$silentArgs = '/S'
$nppUninstaller = Join-Path ${Env:ProgramFiles(x86)} '\Notepad++\uninstall.exe'
$nppUninstaller32 = Join-Path $Env:ProgramFiles '\Notepad++\uninstall.exe'
$OSArch = Get-CimInstance Win32_OperatingSystem | Select-Object OSArchitecture

#Removal
if ($OSArch = '64-bit') {
  Uninstall-ChocolateyPackage $packageName $fileType $silentArgs $nppUninstaller
}
else {
  Uninstall-ChocolateyPackage $packageName $fileType $silentArgs $nppUninstaller32
}
