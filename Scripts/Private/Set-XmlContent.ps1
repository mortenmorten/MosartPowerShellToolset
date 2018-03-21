function Set-XmlContent {
  [CmdletBinding()]
  param(
    [Parameter(
      Position = 0,
      Mandatory = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [string] $Path,
    [Parameter(
      Position = 1,
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [xml] $Value
  )

  $Value.Save($Path)
  Write-Verbose "Saved XML to $($Path)"
}