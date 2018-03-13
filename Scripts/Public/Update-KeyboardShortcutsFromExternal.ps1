$Global:MosartKeyboardSettings = [pscustomobject] @{
  LocalShortcutsPath = ${Env:ProgramData} + "\Mosart Medialab\ConfigurationFiles\keyboard_shortcuts.xml"
  RemoteShortcutsPath = [string] $null
}

$Global:PSDefaultParameterValues = @{
  "Update-KeyboardShortcutsFromExternal:file"   = {$Global:MosartKeyboardSettings.RemoteShortcutsPath};
  "Update-KeyboardShortcutsFromExternal:output" = {$Global:MosartKeyboardSettings.LocalShortcutsPath}
}

Function Update-KeyboardShortcutsFromExternal {
  [CmdletBinding()]
  param(
    [Parameter(
      Position = 0,
      Mandatory = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [string] $file,
    [Parameter(
      Position = 1,
      Mandatory = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [string] $output
  )

  Copy-KeyboardShortcuts $file $output
}

Export-ModuleMember -Function Update-KeyboardShortcutsFromExternal