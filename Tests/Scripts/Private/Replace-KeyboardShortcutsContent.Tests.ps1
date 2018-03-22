$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests\\', '\'
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Replace-KeyboardShortcutsContent" {
  It "Replace-KeyboardShortcutsContent imports and replaces given shortcut" {
    $content = [xml] "<keyboard_shortcuts><shortcuts name='1' /><shortcuts name='2' /></keyboard_shortcuts>"
    $shortcutContent = [xml] "<shortcuts name='2'><shortcut /></shortcuts>"
    (Replace-KeyboardShortcutsContent $content $shortcutContent.DocumentElement).SelectNodes("//shortcuts[@name='2'][1]/shortcut") | Should Not Be $null
  }
}