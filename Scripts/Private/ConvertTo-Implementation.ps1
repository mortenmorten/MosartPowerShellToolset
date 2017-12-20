function ConvertTo-Implementation {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [System.Xml.XmlElement[]]
    $XmlElement
  )

  process {
    $XmlElement 
  }
}