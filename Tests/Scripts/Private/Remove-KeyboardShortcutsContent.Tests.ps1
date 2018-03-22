$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests\\', '\'
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Remove-KeyboardShortcutsContent" {
  It "Remove-KeyboardShortcutsContent removes shortcut ste" {
    $content = [xml] "<keyboard_shortcuts><shortcuts name='1' /><shortcuts name='2' /></keyboard_shortcuts>"
    (Remove-KeyboardShortcutsContent $content "2").SelectSingleNode("//shortcuts[@name='2']") | Should Be $null
  }
}