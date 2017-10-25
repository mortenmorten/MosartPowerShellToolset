<#
.SYNOPSIS
  Synchronizes the files from all subfolders of a folder to a new folder 
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
    [Parameter(HelpMessage = "The separator character used when joining subfolders.")]
    [string]
    $SeparatorChar = "-"
  )
  
  # Expand the source path, and uses
  $absolutePath = Resolve-Path $LiteralPath
  
  # Ensure the destination folder is suffixed with backslash
  if (!$Destination.EndsWith([IO.Path]::DirectorySeparatorChar)) {
    $Destination += [IO.Path]::DirectorySeparatorChar
  }

  # Ensure the destination folder exists
  if (!(Test-Path $Destination -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $Destination  
  } 

  # Temporarily store the local files, and prepare an array for the processed source files
  $existingFiles = Get-ChildItem $Destination -File
  $newFiles = @()

  # Loop through and process all files in all subfolders 
  foreach ($file in Get-ChildItem $absolutePath -File -Recurse) {
    $flattenedPath = $file.DirectoryName.Replace($absolutePath, "").Replace([IO.Path]::DirectorySeparatorChar, $SeparatorChar)
    $destinationFileName = ($flattenedPath + $SeparatorChar + $file).Substring(1)

    $newFiles += $destinationFileName

    $sourcePath = [IO.Path]::Combine($file.DirectoryName, $file.Name)

    # Check if the file does not exists, or is newer than the existing one, if true then copy
    $existingFile = $existingFiles | where Name -eq $destinationFileName 
    if (($existingFile -eq $null) -or ($existingFile.LastWriteTime -lt $file.LastWriteTime)) {
      $destinationFullPath = $Destination + $destinationFileName
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