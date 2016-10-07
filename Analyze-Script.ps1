<#
.Synopsis
    Analyze the quality of your code.
.DESCRIPTION
    Analyze-Script.ps1 utilizes PSScriptAnalyzer. PSScriptAnalyzer is a static code checker
    for Windows PowerShell modules and scripts. PSScriptAnalyzer checks the quality of Windows
    PowerShell code by running a set of rules. The rules are based on PowerShell best practices
    identified by PowerShell Team and the community. It generates DiagnosticResults
    (errors and warnings) to inform users about potential code defects and suggests possible
    solutions for improvements.

    Reference:
		https://github.com/PowerShell/PSScriptAnalyzer
.FUNCTIONALITY
    We consider ALL errors and MOST warnings violations. Warnings that we do not consider
    violations are stored in the variable #DoNotFailOnRules. All violations must be
    remediated.

    PSSCriptAnalyzer Rule Documentation:
    https://github.com/PowerShell/PSScriptAnalyzer/tree/development/RuleDocumentation
#>
[CmdletBinding()]
Param()

$DoNotFailOnRules = @(
    'PSAvoidGlobalVars',
    'PSUseDeclaredVarsMoreThanAssignments'
)

$WarningRules = Get-ScriptAnalyzerRule -Severity Warning
$FailOnRules = $WarningRules | Where-Object { -not ($DoNotFailOnRules -contains $_.RuleName) }

Add-AppveyorTest -Name "PsScriptAnalyzer" -Outcome Running

$Results = Invoke-ScriptAnalyzer -Path (Get-Location) -Recurse -ErrorAction SilentlyContinue
$Violations = $Results | Where-Object {($FailOnRules.RuleName -contains $_.RuleName) -or ($_.Severity -eq 'Error')}

If ($Violations) {
  $ViolationString = $Violations | Out-String
  Write-Warning $ViolationString
  Add-AppveyorMessage -Message "PSScriptAnalyzer output contained $($Violations.Count) violation(s). Check the 'Tests' tab of this build for more details." -Category Warning

  Update-AppveyorTest -Name "PsScriptAnalyzer" -Outcome Failed -ErrorMessage $ViolationString
  # Failing the build
  Throw "Build failed"
}
Else {
  Update-AppveyorTest -Name "PsScriptAnalyzer" -Outcome Passed
}
