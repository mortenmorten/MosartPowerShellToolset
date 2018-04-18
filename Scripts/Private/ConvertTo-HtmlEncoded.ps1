function ConvertTo-HtmlEncoded {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    $xml
  )

  [System.Net.WebUtility]::HtmlEncode($xml)
}