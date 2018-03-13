# Copies the keyboard shortcuts without loosing the default selected setup 
Function Copy-KeyboardShortcuts
{
  param(
    # Source keyboard settings file
    [Parameter(Mandatory = $true)][string]$file, 
    # Target keyboard settings file
    [Parameter(Mandatory = $true)][string]$output
  )

  Write-Host "File:" $file
  Write-Host "Output:" $output

  $currentName = Get-DefaultShortcutName -file $output
  Set-DefaultShortcuts -file $file -name $currentName -output $output
}
