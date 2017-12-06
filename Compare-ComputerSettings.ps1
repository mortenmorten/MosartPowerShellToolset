<#
.SYNOPSIS
Compare the Viz Mosart user.config files of two different computers

.DESCRIPTION


.PARAMETER RootServerPath

.PARAMETER ReferenceServerName

.PARAMETER ServerName

.PARAMETER DefaultAppConfigSubFolder

.PARAMETER UseIncludeSettings

.EXAMPLE

.EXAMPLE

#>

param(
    $RootServerPath = '.',
    $ReferenceServerName = $null,
    $ServerName = $null,
    $DefaultAppConfigSubFolder = 'DefaultAppConfig',
    [switch]
    $UseIncludeSettings
)

$apps = @(
    ('MMConsoleAdmin_2007', 
        @('ServerDescirption', 'TemplateDbDefaultInserter'), 
        @('IgnoreSendCueStatusToNCSFor', 'InewsFTPServerName', 'InewsWebserviceConnectionString', 'ManusExpirationTime', 'UseItemStatusToNCS')),
    ('MMMediaAdministrator', 
        @('UseVerboseLogging'), 
        @('ClipServer2')),
    ('MMAVAutomation', 
        @('Mirror_Host', 'InitialLocation', 'TemplateDbDefaultInserter'), 
        @('gfxShows', 'graphicsPreviewEngines', 'MeMappings', 'TemplateDbConnectionString', 'txt_Schema', 'UseDskOnOff')),
    ('MMOverlayGraphicsInterface', 
        @('InitialLocation'), 
        @('Destination_1','Destination_2','Destination_3','Destination_4'))
    )

$scriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

$servers = & "$scriptPath\Get-PairedComputerName.ps1" $ServerName
If ($ReferenceServerName -eq $null) {
    $ReferenceServerName = $servers[0]
    $ServerName = $servers[1]
}
Else {
    If($ServerName -eq $null) {
        If ($servers.Contains($ReferenceServerName)) {
            $ServerName = $servers[1]
        }
        Else {
            $ServerName = $Env:COMPUTERNAME
            $UseIncludeSettings = $true
        }
    }
    Else {
        $UseIncludeSettings = ($ReferenceServerName -ne $servers[0])
    }
}

Write-Output "Reference server: $($ReferenceServerName)"
Write-Output "Difference server: $($ServerName)"

ForEach($app in $apps) {
    $appName = $app[0]
    $mainConfigPath = (& "$scriptPath\Get-AppDataPath.ps1" -RootFolder $RootServerPath -ServerName $ReferenceServerName -AppName $appName)
    $backupConfigPath = (& "$scriptPath\Get-AppDataPath.ps1" -RootFolder $RootServerPath -ServerName $ServerName -AppName $appName)
    $defaultAppConfigPath = Join-Path $RootServerPath $DefaultAppConfigSubfolder | Join-Path -ChildPath "$($appName).exe.config"

    & "$scriptPath\Compare-Settings.ps1" -ReferenceSettings $mainConfigPath -DifferenceSettings $backupConfigPath -DefaultSettings $defaultAppConfigPath -ExcludeSettings $app[1] -UseIncludeSettings:$UseIncludeSettings -IncludeSettings $app[2] `
        | Select-Object *, @{Name='Application';Expression={$appName}} `
        | Format-Table -GroupBy Application -Property Setting,DefaultValue,ReferenceValue,DifferenceValue
}