<#
.SYNOPSIS
Returns the pair of main and backup server names

.DESCRIPTION
The server names are calculated from the pattern of the computername. The main server name is returned as the first entry.

.PARAMETER ComputerName
The name of the computer

.EXAMPLE
.\Get-PairedComputerName.ps1 -ComputerName MyMosartServer01
MyMosartServer01
MyMosartServer02

.EXAMPLE
.\Get-PairedComputerName.ps1 -ComputerName MyMosartServer02
MyMosartServer01
MyMosartServer02

#>
function Get-PairedComputerName {
  param(
    [string]
    $ComputerName
  )

  If (-not $ComputerName) {
    $ComputerName = $Env:COMPUTERNAME
  }

  $regex = [regex] "(.+?)(\d+)"
  $m = $regex.Match($ComputerName)

  $r = $m.Groups[2].Value % 2
  $n = % {If ($r -eq 0) { [int]($m.Groups[2].Value) - 1 } Else { [int]($m.Groups[2].Value) + 1 }}


  $r = @($ComputerName)
  $r += "{0}{1:D2}" -f @($m.Groups[1].Value, $n)
  $r | Sort-Object
}