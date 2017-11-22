function Copy-ServerConfigs {
  [CmdletBinding()]
  param(
    [string[]]
    $Files,
    [string]
    $Destination
  )

  if (-Not (Test-Path $Destination -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $Destination
  }

  Write-Verbose "Copying files from $($Files) to $($Destination)"
  Copy-Item -Path $Files -Destination $Destination -Force
}

$paths = @{
    "C:\ChannelTemplates\" = @("..\C_ChannelTemplates\*");
    (Join-Path -Path $Env:ProgramData -ChildPath "Mosart Medialab\ConfigurationFiles\") = @("..\C_ProgramData_MosartMedialab_ConfigurationFiles\*")
}

$paths.GetEnumerator() | Copy-ServerConfigs -Files $_.Value -Destination $_.Name