function Select-Template {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [psobject[]]
    $TemplateObject,
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [int]
    $TemplateType,
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [string]
    $TemplateVariant
  )

  process {
    $TemplateObject | Where-Object { $_.Type -eq $TemplateType -and $_.Variant -eq $TemplateVariant}
  }
}