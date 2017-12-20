<#
.SYNOPSIS
  Converts integer template type values to the text representation

.PARAMETER Value
  Template type as integer

.EXAMPLE
  ConvertTo-TemplateType 1
#>
function ConvertTo-TemplateType {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [int[]]
    $Value
  )

  process {
    switch ($Value) {
      0 { "CAMERA" }
      1 { "PACKAGE" }
      2 { "VO" }
      3 { "LIVE" }
      4 { "GFX" }
      5 { "DVE" }
      6 { "JINGLE" }
      7 { "PHONE" }
      8 { "FLOAT" }
      9 { "BREAK" }
      default { [string] $Value }
    }
  }
}