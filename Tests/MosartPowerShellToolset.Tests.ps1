$ModulePath = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$ModuleName = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -Replace ".Tests.ps1"

$ManifestPath = "$ModulePath\$ModuleName.psd1"

Import-Module $ManifestPath

Describe 'Module Manifest Tests' {
  $ManifestHash = Invoke-Expression (Get-Content $ManifestPath -Raw)

  It 'Passes Test-ModuleManifest' {
    Test-ModuleManifest -Path $ManifestPath
    $? | Should Be $true
  }

  It "Exports all public functions" {
    $ExFunctions = $ManifestHash.FunctionsToExport
    $FunctionFiles = Get-ChildItem "$ModulePath\Scripts\Public" -Filter *.ps1 | Select-Object -ExpandProperty BaseName
    $FunctionNames = $FunctionFiles
    foreach ($FunctionName in $FunctionNames) {
      $ExFunctions -contains $FunctionName | Should Be $true
    }
  }    
}
