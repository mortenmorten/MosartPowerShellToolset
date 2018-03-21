$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests\\', '\'
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-KeyboardShortcutNames" {
  It "Returns all shortcut names" {
    $testData = [xml] "<keyboard_shortcuts><shortcuts name='1' /><shortcuts name='2' /></keyboard_shortcuts>"
    Get-KeyboardShortcutNames $testData | Should Be @("1", "2")
  }
}