# Gets the name of the default keyboard settings
function Get-DefaultShortcutName
{
  param(
    # Source keyboard settings file
    [Parameter(Mandatory = $true)][string]$file
  )
  
  if (-Not (Test-Path($file))) { return $null }
  
  $XPath = "//shortcuts[@default='True']/@name"
  $xml = [xml] (Get-Content $file)
  
  $value = $xml.SelectSingleNode($XPath).Value
  Write-Host "Default name:" $value
  return $value
}