function Select-PrimaryTemplates {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [psobject[]]
    $TemplateObject
  )
    
  process {
    $TemplateObject | Where-Object { $_.Type -lt 100}
  }
}