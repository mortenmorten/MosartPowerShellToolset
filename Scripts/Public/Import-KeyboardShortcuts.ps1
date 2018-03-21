Function Import-KeyboardShortcuts {
  [CmdletBinding()]
  param(
    [Parameter(
      Position = 0,
      Mandatory = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [string] $LiteralPath,
    [Parameter(
      Position = 1,
      Mandatory = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [string] $Destination
  )

  Copy-KeyboardShortcuts $LiteralPath $Destination
}

Export-ModuleMember -Function Import-KeyboardShortcuts