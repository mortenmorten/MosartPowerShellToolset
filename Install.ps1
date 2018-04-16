param(
  [switch] $AllUsers,
  [switch] $Verbose = $Verbose,
  [switch] $Confirm = $Confirm
)

# Require elevation if AllUsers
If ($AllUsers -and !([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { 
  Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -AllUsers" -Verb RunAs; 
  Exit
}

Write-Host "Installing MosartPowershellTools module to $(If ($AllUsers) { "all users"} Else { "local user" })"
While ($Confirm -and $choice -notmatch "[y|n]"){
  $choice = read-host "Do you want to continue? (Y/N)"
}

If ($choice -eq "n") {
  Write-Host "Installation cancelled!"
  Exit
}

# Uninstall the module if it's already present
Remove-Module -Name MosartPowershellToolset -ErrorAction SilentlyContinue -Verbose:$Verbose

# Get the current users modules folder
$moduleFolder = "$home\Documents\WindowsPowerShell"
If ($AllUsers) {
  $moduleFolder = $PSHome
}

$moduleFolder += "\Modules\MosartPowershellToolset"

# Delete the currently installed module
Remove-Item -Path $moduleFolder -Force -Recurse -ErrorAction SilentlyContinue -Verbose:$Verbose | Out-Null

# Re-create the module path
New-Item -ItemType Directory -Force -Path $moduleFolder -Verbose:$Verbose | Out-Null

$installDir = Split-Path $MyInvocation.MyCommand.Path -Parent -Verbose:$Verbose

# Copy the module to the users local modules folder
Copy-Item -Path $installDir\Scripts\* -Destination $moduleFolder -Recurse -Verbose:$Verbose | Out-Null

Import-Module -Name MosartPowershellToolset