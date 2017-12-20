function List-TemplateSets {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [xml]
    $XmlDocument
  )

  process {
    $XmlDocument.avconfig.channeltemplates.channels | ConvertTo-TemplateSetObject
  }
}
