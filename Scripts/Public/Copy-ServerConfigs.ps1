function Copy-ServerConfigs {
  [CmdletBinding()]
  param(
    [Parameter(
      Position = 0,
      Mandatory = $true,
      ParameterSetName = "0",
      ValueFromPipelineByPropertyName = $true
    )]
    [hashtable]
    $Paths,
    [Parameter(
      Position = 0,
      Mandatory = $true,
      ParameterSetName = "1",
      ValueFromPipelineByPropertyName = $true
    )]
    [string[]]
    $Path,
    [Parameter(
      Position = 1,
      Mandatory = $true,
      ParameterSetName = "1",
      ValueFromPipelineByPropertyName = $true
    )]
    [string]
    $Destination,
    [Parameter(
      Position = 0,
      Mandatory = $true,
      ParameterSetName = "2",
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The source folder for C:\ChannelTemplate files"
    )]
    [string]
    $ChannelTemplatesPath,
    [Parameter(
      Position = 1,
      Mandatory = $true,
      ParameterSetName = "2",
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "The source folder for '%PROGRAMDATA%\Mosart Medialab\ConfigurationFiles' files"
    )]
    [string]
    $ProgramDataPath
  )

  If (-Not $Paths) {
    If ($Path) {
      $Paths = @{$Destination = $Path}
    }
    Else {
      $Paths = @{
        "C:\ChannelTemplates\" = @(Join-Path -Path $ChannelTemplatesPath -ChildPath "*");
        (Join-Path -Path $Env:ProgramData -ChildPath "Mosart Medialab\ConfigurationFiles\") = @(Join-Path -Path $ProgramDataPath -ChildPath "*")
      }
    }
  }

  ForEach ($item in $Paths.GetEnumerator()) {
    If (-Not (Test-Path $item.Key -PathType Container)) {
      New-Item -ItemType Directory -Force -Path $item.Key
    }
  
    Write-Verbose "Copying files from $($Files) to $($item.Key)"
    Copy-Item -Path $item.Name -Destination $item.Key -Force
  }
}