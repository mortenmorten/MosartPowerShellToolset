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
    $ServerName
  )

  if ($AppName.Length -gt 24) {
    $AppName = $AppName.SubString(0, 24)
  }

  # If server name is $null then use local settings
  $localAppDataFolder = $Env:LOCALAPPDATA

  if ($ServerName -ne $null) {
    $localAppDataFolder = $localAppDataFolder -replace "([a-z]\:)", "\\$($ServerName)\c$"
  }

  Join-Path $localAppDataFolder -ChildPath 'Mosart_Medialab' `
    | Join-Path -ChildPath "$($AppName)*\*\user.config" -Resolve `
    | Sort -Descending | Select-Object -First 1 | Convert-Path
}