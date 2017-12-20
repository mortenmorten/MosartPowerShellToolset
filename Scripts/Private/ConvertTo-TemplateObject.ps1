<#
.SYNOPSIS
  Converts a template from XML to object

.PARAMETER XmlElement
  An XML element node of a template
#>
function ConvertTo-TemplateObject {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [System.Xml.XmlElement]
    $XmlElement
  )

  process {
    $XmlElement | Select-Object @{Name = 'Name'; Expression = {$_.name}}, @{Name='Type';Expression = { [int] $_.type }}, @{Name='Variant';Expression = {$_.templatetype}}, @{Name = 'Implementation'; Expression = {$_}}
  }
}