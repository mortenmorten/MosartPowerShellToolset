function Get-Templates {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ParameterSetName = 'object',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [psobject]
    $TemplateSetObject,
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ParameterSetName = 'xml',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [xml]
    $XmlDocument,
    [Parameter(
      Mandatory = $true,
      Position = 1,
      ParameterSetName = 'xml',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [string]
    $TemplateSetName
  )

  process {
    if (-not $TemplateSetObject) {
      $TemplateSetObject = Get-TemplateSet -XmlDocument $XmlDocument -TemplateSetName $TemplateSetName
    }

    $TemplateSetObject.Templates | ConvertTo-TemplateObject
  }
}