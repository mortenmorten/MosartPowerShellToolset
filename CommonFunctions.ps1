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

<#
.SYNOPSIS
Gets the path to settings located in the local app data folder

.DESCRIPTION
Gets the path to Mosart settings on the local machine, or in a common settings repostitory (a shared folder)
#>
function Get-AppDataPath {
  param(
    [string]
    $AppName,
    [string]
    $RootFolder = '.',
    [string]
    $ServerName
  )

  if ($AppName.Length -gt 24) {
    $AppName = $AppName.SubString(0, 24)
  }

  # If server name is $null then use local settings
  $localAppDataFolder = $Env:LOCALAPPDATA

  if ($ServerName -ne $null) {
    $localAppDataFolder = Join-Path $RootFolder $ServerName `
      | Get-ChildItem | ? { $_.PSIsContainer } | Sort-Object LastWriteTime -Descending `
      | Select-Object -ExpandProperty FullName -First 1 `
      | Join-Path -ChildPath '*\Users\mosart\AppData\Local'
  }

  Join-Path $localAppDataFolder -ChildPath 'Mosart_Medialab' `
    | Join-Path -ChildPath "$($AppName)*\*\user.config" -Resolve `
    | Sort -Descending | Select-Object -First 1
}
