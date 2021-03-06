<#
.SYNOPSIS
Compare the Viz Mosart user.config files of two different computers

.DESCRIPTION


.PARAMETER ReferenceServerName

.PARAMETER ServerName

.PARAMETER DefaultAppConfigSubFolder

.PARAMETER UseIncludeSettings

.EXAMPLE

.EXAMPLE

#>
function Compare-ComputerSettings {
  param(
    $ReferenceServerName = $null,
    $ServerName = $null,
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

  $servers = Get-PairedComputerName $ServerName
  If ($ReferenceServerName -eq $null) {
    $ReferenceServerName = $servers[0]
    $ServerName = $servers[1]
  }
  Else {
    If ($ServerName -eq $null) {
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

  $targetServerName = $ServerName
  If ($ServerName -eq $Env:COMPUTERNAME) {
    $targetServerName = $null
    $UseIncludeSettings = $true
  }

  ForEach ($app in $apps) {
    $appName = $app[0]
    $mainConfigPath = (Get-AppDataPath -ServerName $ReferenceServerName -AppName $appName)
    $backupConfigPath = (Get-AppDataPath -ServerName $ServerName -AppName $appName)
    $defaultAppConfigPath = Join-Path $DefaultAppConfigSubfolder -ChildPath "$($appName).exe.config"

    Compare-Settings -ReferenceSettings $mainConfigPath -DifferenceSettings $backupConfigPath -DefaultSettings $defaultAppConfigPath -ExcludeSettings $app[1] -UseIncludeSettings:$UseIncludeSettings -IncludeSettings $app[2] `
      | Select-Object *, @{Name = 'Application'; Expression = {$appName}} `
      | Format-Table -GroupBy Application -Property Setting, DefaultValue, ReferenceValue, DifferenceValue
  }
}