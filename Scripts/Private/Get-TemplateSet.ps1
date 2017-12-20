function Get-TemplateSet {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [xml]
    $XmlDocument,
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [string[]]
    $TemplateSetName
  )

  process {
    $XmlDocument.avconfig.channeltemplates.channels | ConvertTo-TemplateSetObject | Where-Object {$TemplateSetName -contains $_.Name }
  }
}