$Global:MosartKeyboardSettings = [pscustomobject] @{
  LocalShortcutsPath = ${Env:ProgramData} + "\Mosart Medialab\ConfigurationFiles\keyboard_shortcuts.xml"
  RemoteShortcutsPath = [string] $null
}

$Global:PSDefaultParameterValues = @{
  "Import-KeyboardShortcuts:LiteralPath" = {$Global:MosartKeyboardSettings.RemoteShortcutsPath};
  "Import-KeyboardShortcuts:Destination" = {$Global:MosartKeyboardSettings.LocalShortcutsPath};
  "Export-KeyboardShortcuts:LiteralPath" = {$Global:MosartKeyboardSettings.LocalShortcutsPath};
  "Export-KeyboardShortcuts:Destination" = {$Global:MosartKeyboardSettings.RemoteShortcutsPath}
}