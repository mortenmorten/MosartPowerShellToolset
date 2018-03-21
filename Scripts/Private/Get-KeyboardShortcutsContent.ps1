function Get-KeyboardShortcutsContent {
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

  $XPath = "//shortcuts[@name='" + $ShortcutName + "']"
  
  Select-Xml $xml -XPath $XPath | Select-Object -ExpandProperty Node | Write-Output
}
