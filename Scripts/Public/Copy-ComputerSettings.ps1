function Copy-ComputerSettings {
  param(
    $ReferenceServerName = $null,
    $DifferenceServerName = $null,
    $DefaultAppConfigSubFolder = "$($Env:ProgramFilesX86)\Mosart Server\",
    [switch]
    $UseIncludeSettings
  )

  $scriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

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
      @('Destination_1', 'Destination_2', 'Destination_3', 'Destination_4'))
  )

  $servers = Get-PairedComputerName $DifferenceServerName
  If ($ReferenceServerName -eq $null) {
    $ReferenceServerName = $servers[0]
    $DifferenceServerName = $servers[1]
  }
  Else {
    If ($DifferenceServerName -eq $null) {
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

  $targetServerName = $DifferenceServerName
  If ($DifferenceServerName -eq $Env:COMPUTERNAME) {
    $targetServerName = $null
  }

  ForEach ($app in $apps) {
    $appName = $app[0]
    $mainConfigPath = (Get-AppDataPath -ServerName $ReferenceServerName -AppName $appName)
    $backupConfigPath = (Get-AppDataPath -ServerName $targetServerName -AppName $appName)
    $defaultAppConfigPath = Join-Path $DefaultAppConfigSubfolder -ChildPath "$($appName).exe.config"

    $settingsToCopy = Compare-Settings -ReferenceSettings $mainConfigPath -DifferenceSettings $backupConfigPath -DefaultSettings $defaultAppConfigPath -ExcludeSettings $app[1] -UseIncludeSettings:$UseIncludeSettings -IncludeSettings $app[2] `
      | Select-Object -ExpandProperty Setting
        
    Copy-Settings -SourcePath $mainConfigPath -DestinationPath $backupConfigPath -SettingNames $SettingsToCopy -OutFile $backupConfigPath
  }
}