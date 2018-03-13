# Gets the name of the default keyboard settings
function Get-DefaultShortcutName
{
  param(
    # Source keyboard settings file
    [Parameter(Mandatory = $true)][string]$file
  )
  
  if (-Not (Test-Path($file))) { 
    $value = $null 
  }
  else {
    $XPath = "(//shortcuts[translate(@default, 'TRUE', 'true')='true'] | //shortcuts[1])[1]/@name"
    $xml = [xml] (Get-Content $file)
    $value = $xml.SelectSingleNode($XPath).Value
  }

  Write-Verbose "Default name: $($value)"

  $rtrn = New-Object -TypeName PSObject
  $rtrn | Add-Member -MemberType NoteProperty -Name DefaultShortcutName -Value ($value) -PassThru
  Write-Output $rtrn
}