$packageName = 'notepadplusplus'
$fileType = 'EXE'
$url = 'http://chocopackages.ise.com/notepadplusplus/npp.6.7.8.2.Installer.exe'
$silentArgs = '/S'

#Install
Install-ChocolateyPackage $packageName $fileType $silentArgs $url
