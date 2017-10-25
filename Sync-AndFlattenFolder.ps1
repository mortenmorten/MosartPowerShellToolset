<#
.SYNOPSIS
  Syunchronizes the files from all subfolders of a folder to a new folder 
.DESCRIPTION
  Copies all files from a folder - including subfolders - by flattening the folder structure and copying 
  or removing the files in a common root folder  
#>
function Sync-AndFlattenFolder {
  [CmdletBinding()]
  param(
    # Specifies a path to the source location.
    [Parameter(Mandatory = $true,
      Position = 0,
      ParameterSetName = "LiteralPath",
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "Literal path to one or more locations.")]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $LiteralPath,
        
    # Specifies the path to the new location.
    [Parameter(Mandatory = $true,
      Position = 1,
      ValueFromPipelineByPropertyName = $true,
      HelpMessage = "Path to the new location.")]
    [ValidateNotNullOrEmpty()]
    [string]
    $Destination,

    # The seperator character used when joining subfolders.
    [Parameter(HelpMessage = "The seperator character used when joining subfolders.")]
    [string]
    $SeparatorChar = "-"
  )
  
  $absolutePath = Resolve-Path $LiteralPath
  
  if (!$Destination.EndsWith([IO.Path]::DirectorySeparatorChar)) {
    $Destination += [IO.Path]::DirectorySeparatorChar
  }

  if (!(Test-Path $Destination -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $Destination  
  } 

  $existingFiles = Get-ChildItem $Destination -File
  $newFiles = @()

  foreach ($file in Get-ChildItem $absolutePath -File -Recurse) {
    $flattenedPath = $file.DirectoryName.Replace($absolutePath, "").Replace([IO.Path]::DirectorySeparatorChar, $SeparatorChar)
    $destinationFileName = ($flattenedPath + $SeparatorChar + $file).Substring(1)
    $newFiles += $destinationFileName

    $destinationFullPath = $Destination + $destinationFileName

    $sourcePath = [IO.Path]::Combine($file.DirectoryName, $file.Name)

    $existingFile = $existingFiles | where Name -eq $destinationFileName 
    if (($existingFile -eq $null) -or ($existingFile.LastWriteTime -lt $file.LastWriteTime)) {
      Copy-Item -LiteralPath $sourcePath -Destination $destinationFullPath -Force
      Write-Verbose "Copied $($destinationFileName)" 
    }
    else {
      Write-Verbose "No changes to $($destinationFileName)"
    }
  }

  # Delete files not present in $Path
  ($existingFiles | Where {$newFiles -notcontains $_}) | Remove-Item
}

Export-ModuleMember -Function Sync-AndFlattenFolder