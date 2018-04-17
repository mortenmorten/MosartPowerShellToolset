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
  $absolutePath = Resolve-Path $LiteralPath | Select-Object -ExpandProperty Path
  Write-Verbose "Source path: $($absolutePath)"
  
  # Ensure the destination folder is suffixed with backslash
  $Destination = EnsureEndingSlash($Destination)
  Write-Verbose "Destination path: $($Destination)"
  
  # Ensure the destination folder exists
  if (!(Test-Path $Destination -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $Destination  
  } 

  # Temporarily store the local files, and prepare an array for the processed source files
  $existingFiles = @{}
  foreach ($file in Get-ChildItem $Destination | Where-Object { !$_.PSIsContainer }) {
    $existingFiles.Add($file.Name, $file)
  }

  $newFiles = @{}

  # Loop through and process all files in all subfolders
  $sourceFiles = (Get-ChildItem $absolutePath -Recurse | Where-Object { !$_.PSIsContainer })
  $i = 0
  $fileCount = $sourceFiles.length
  foreach ($file in $sourceFiles) {
    $flattenedPath = $file.DirectoryName.Replace($absolutePath, "").Replace([IO.Path]::DirectorySeparatorChar, $SeparatorChar)
    $destinationFileName = ($flattenedPath + $SeparatorChar + $file).Substring(1)
    
    $newFiles.Add($destinationFileName, $file)

    $sourcePath = Join-Path $file.DirectoryName $file.Name

    # Check if the file does not exists, or is newer than the existing one, if true then copy
    if ((!$existingFiles.ContainsKey($destinationFileName)) -or ($existingFiles.Get_Item($destinationFileName).LastWriteTime -lt $file.LastWriteTime)) {
      $destinationFullPath = Join-Path $Destination $destinationFileName
      $msg = "Copying $($sourcePath) to $($destinationFullPath)" 
      Copy-Item -LiteralPath $sourcePath -Destination $destinationFullPath -Force
    }
    else {
      $msg = "No changes to $($destinationFileName)"
    }
    
    Write-Progress -Activity "Processing remote files" -Status "Progress" -PercentComplete ($i / $filecount * 100) -CurrentOperation $msg
    $i++
  }

  # Delete files not present in $Path
  $existingFiles.GetEnumerator() | ? {!$newFiles.ContainsKey($_.Key)} | foreach ($_) { Remove-Item $_.Value.FullName }
}

function EnsureEndingSlash {
  param($path)
  if (!$path.EndsWith([IO.Path]::DirectorySeparatorChar)) {
    $path += [IO.Path]::DirectorySeparatorChar
  }
  $path
}

Export-ModuleMember -Function Sync-AndFlattenFolder