param(
  [switch] $WhatIf = $false,
  [switch] $Force = $false,
  [switch] $Verbose = $Verbose
)

$installDir = Split-Path $MyInvocation.MyCommand.Path -Parent

Import-Module $installDir\Scripts\MosartPowerShellToolset