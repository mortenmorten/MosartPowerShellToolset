
function Remove-KeyboardShortcutsContent {
  [CmdletBinding()]
  param(
    # Source keyboard settings file
    [Parameter(
      Position = 0,
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [xml] $Content,
    [Parameter(
      Position = 1,
      Mandatory = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [string] $ShortcutName
  )

  Write-Verbose "Shortcuts '$($ShortcutName)' requested for removal."

  $existingShortcutContent = $Content.SelectSingleNode(".//shortcuts[@name='$($ShortcutName)']")
  if ($existingShortcutContent) {
    $existingShortcutContent.ParentNode.RemoveChild($existingShortcutContent) | Out-Null
    Write-Information "Removing shortcuts done."
  }
  else {
    Write-Information "Shortcuts $($ShortcutName) was not found."
  }

  Write-Output $Content
}