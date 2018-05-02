Function Import-KeyboardShortcuts {
  [CmdletBinding()]
  param(
    [Parameter(
      Position = 0,
      Mandatory = $false,
      ValueFromPipelineByPropertyName = $true
    )]
    [string] $LiteralPath = $MosartKeyboardSettings.RemoteShortcutsPath,
    [Parameter(
      Position = 1,
      Mandatory = $false,
      ValueFromPipelineByPropertyName = $true
    )]
    [string] $Destination = $MosartKeyboardSettings.LocalShortcutsPath
  )

  Copy-KeyboardShortcuts $LiteralPath $Destination
}

Export-ModuleMember -Function Import-KeyboardShortcuts