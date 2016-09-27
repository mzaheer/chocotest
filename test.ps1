Add-AppveyorTest -Name "ChocoInstall" -Outcome Running
Try {
  Write-Warning "Install MY notepadplusplus"
  Invoke-Expression "choco install notepadplusplus -Source \\$env:computername\chocotest"
}
Catch {
  Update-AppveyorTest -Name "ChocoInstall" -Outcome Failed -ErrorMessage $Error[0].Exception.Message
  Throw "Build failed"
}
Finally {
  Update-AppveyorTest -Name "ChocoInstall" -Outcom Passed
}

Add-AppveyorTest -Name "ChocoUnInstall" -Outcome Running
Try {
  Write-Warning "Uninstall MY notepadplusplus"
  Invoke-Expression "choco uninstall notepadplusplus"
}
Catch {
  Update-AppveyorTest -Name "ChocoUnInstall" -Outcome Failed -ErrorMessage $Error[0].Exception.Message
  Throw "Build failed"
}
Finally {
  Update-AppveyorTest -Name "ChocoUnInstall" -Outcom Passed
}
