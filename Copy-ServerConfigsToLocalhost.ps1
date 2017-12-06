$path = 'C:\ChannelTemplates\'

if(-Not (Test-Path $path -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $path
}

Write-Host "Copying files to $($path)"

$channel_template_files = @("..\C_ChannelTemplates\*")
Write-Host "Files to copy: $($channel_template_files)"
Copy-Item -Path $channel_template_files -Destination $path -Force -Verbose

$path = Join-Path -Path $Env:ProgramData -ChildPath "Mosart Medialab\ConfigurationFiles\"

if(-Not (Test-Path $path -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $path
}

Write-Host "Copying files to $($path)"

$programdata_config_files = @("..\C_ProgramData_MosartMedialab_ConfigurationFiles\*")
Write-Host "Files to copy: $($programdata_config_files)"
Copy-Item -Path $programdata_config_files -Destination $path -Force -Verbose
