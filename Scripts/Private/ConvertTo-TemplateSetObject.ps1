<#
.SYNOPSIS
  Converts a template set from XML to object

.PARAMETER XmlElement
  An XML element node of a template set
#>
function ConvertTo-TemplateSetObject {
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
    $XmlElement | Select-Object @{Name = 'Name'; Expression = {$_.name}}, @{Name = 'Templates'; Expression = {$_.channel}}
  }
}