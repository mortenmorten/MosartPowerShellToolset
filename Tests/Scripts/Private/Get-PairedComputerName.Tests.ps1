$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests\\', '\'
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-PairedComputerName" {
  It "Returns paired computer for main" {
    Get-PairedComputerName "SERVER01" | Should Be @("SERVER01", "SERVER02")
  }

  It "Returns paired computer for backup" {
    Get-PairedComputerName "SERVER02" | Should Be @("SERVER01", "SERVER02")
  }
}