param(
  [switch] $Verbose = $Verbose
)

# Uninstall the module if it's already present
Remove-Module -Name MosartPowershellToolset -ErrorAction SilentlyContinue -Verbose:$Verbose

# Get the current users modules folder
$moduleFolder = "$home\Documents\WindowsPowerShell\Modules\MosartPowershellToolset"

# Delete the currently installed module
Remove-Item -Path $moduleFolder -Force -Recurse -ErrorAction SilentlyContinue -Verbose:$Verbose | Out-Null

# Re-create the module path
New-Item -ItemType Directory -Force -Path $moduleFolder -Verbose:$Verbose | Out-Null

$installDir = Split-Path $MyInvocation.MyCommand.Path -Parent -Verbose:$Verbose

# Copy the module to the users local modules folder
Copy-Item -Path $installDir\Scripts\* -Destination $moduleFolder -Recurse -Verbose:$Verbose | Out-Null

Import-Module -Name MosartPowershellToolset