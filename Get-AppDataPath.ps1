param(
    [string]
    $AppName,
    [string]
    $RootFolder = '.',
    [string]
    $ServerName
    )

if ($AppName.Length -gt 24) {
    $AppName = $AppName.SubString(0,24)
}

# If server name is $null then use local settings
$localAppDataFolder = $Env:LOCALAPPDATA

if ($ServerName -ne $null) {
    $localAppDataFolder = Join-Path $RootFolder $ServerName `
        | Get-ChildItem | ?{ $_.PSIsContainer } | Sort-Object LastWriteTime -Descending `
        | Select-Object -ExpandProperty FullName -First 1 `
        | Join-Path -ChildPath '*\Users\mosart\AppData\Local'
}

Join-Path $localAppDataFolder -ChildPath 'Mosart_Medialab' `
| Join-Path -ChildPath "$($AppName)*\*\user.config" -Resolve `
| Sort -Descending | Select-Object -First 1
