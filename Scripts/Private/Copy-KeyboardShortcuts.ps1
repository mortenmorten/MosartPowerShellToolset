# Copies the keyboard shortcuts without loosing the default selected setup 
Function Copy-KeyboardShortcuts {
  [CmdletBinding()]
  param(
    # Source keyboard settings file
    [Parameter(Mandatory = $true)]
    [string] $file, 
    # Target keyboard settings file
    [Parameter(Mandatory = $true)]
    [string] $output
  )

  Write-Verbose "File: $($file)"
  Write-Verbose "Output: $($output)"

  Get-DefaultShortcutName -file $output | Set-DefaultShortcuts -file $file -output $output
}
