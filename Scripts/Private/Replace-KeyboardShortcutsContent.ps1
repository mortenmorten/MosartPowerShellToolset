
function Replace-KeyboardShortcutsContent {
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
    [System.Xml.XmlElement] $ShortcutContent
  )

  $importContent = $Content.ImportNode($ShortcutContent, $true)
  $shortcutName = $importContent.Attributes.GetNamedItem("name").Value
  Write-Verbose "Importing shortcuts: $($shortcutName)"

  $existingShortcutContent = $Content.SelectSingleNode(".//shortcuts[@name='$($shortcutName)']")
  if ($existingShortcutContent) {
    $existingShortcutContent.ParentNode.ReplaceChild($importContent, $existingShortcutContent) | Out-Null
    Write-Verbose "Replacing shortcuts done."
  }
  else {
    $Content.SelectSingleNode(".//keyboard_shortcuts").AppendChild($importContent) | Out-Null
    Write-Verbose "Appended shortcuts done."
  }

  Write-Output $Content
}