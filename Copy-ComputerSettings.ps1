param(
    $RootServerPath = '.',
    $ReferenceServerName = $null,
    $DifferenceServerName = $null,
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

$servers = & "$scriptPath\Get-PairedComputerName.ps1" $DifferenceServerName
If ($ReferenceServerName -eq $null) {
    $ReferenceServerName = $servers[0]
    $DifferenceServerName = $servers[1]
}
Else {
    If($DifferenceServerName -eq $null) {
        If ($servers.Contains($ReferenceServerName)) {
            $DifferenceServerName = $servers[1]
        }
        Else {
            $DifferenceServeName = $Env:COMPUTERNAME
            $UseIncludeSettings = $true
        }
    }
}

Write-Output "Reference server: $($ReferenceServerName)"
Write-Output "Difference server: $($DifferenceServerName)"

ForEach($app in $apps) {
    $appName = $app[0]
    $mainConfigPath = (& "$scriptPath\Get-AppDataPath.ps1" -RootFolder $RootServerPath -ServerName $ReferenceServerName -AppName $appName)
    $backupConfigPath = (& "$scriptPath\Get-AppDataPath.ps1" -RootFolder $RootServerPath -ServerName $DifferenceServerName -AppName $appName)
    $defaultAppConfigPath = Join-Path $RootServerPath $DefaultAppConfigSubfolder | Join-Path -ChildPath "$($appName).exe.config"

    $settingsToCopy = & "$scriptPath\Compare-Settings.ps1" -ReferenceSettings $mainConfigPath -DifferenceSettings $backupConfigPath -DefaultSettings $defaultAppConfigPath -ExcludeSettings $app[1] -UseIncludeSettings:$UseIncludeSettings -IncludeSettings $app[2] `
        | Select-Object -ExpandProperty Setting
        
    & "$scriptPath\Copy-Settings.ps1" -SourcePath $mainConfigPath -DestinationPath $backupConfigPath -SettingNames $SettingsToCopy -OutFile $backupConfigPath
}