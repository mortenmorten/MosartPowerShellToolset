Function Update-KeyboardShortcutsFromExternal {
  param(
    [string]$repos_path = ${Env:ProgramData} + "\Vizrt\MosartGuiSettingsCache\",
    [string]$repos_filename = "keyboard_shortcuts.xml",
    [string]$file,
    [string]$output = ${Env:ProgramData} + "\Mosart Medialab\ConfigurationFiles\keyboard_shortcuts.xml"
  )

  $use_repository = $true;
  if ($file -ne $null) 
  {
    $use_repository = $false
  }
  else
  {
    $file = $repos_path + $repos_filename
    Write-Host "Repository path:" $repos_path
  }

  Write-Host "File:" $file
  Write-Host "Output:" $output

  if ($use_repository)
  {
    Write-Host "Pulling changes"

    $git_pull_result = Execute-Command -commandPath git -commandArguments "pull" -workingDirectory $repos_path

    If ($git_pull_result.stdout.StartsWith("Already up-to-date."))
    {
      If (-Not(Test-Path($output)))
      {
        # Check if the file exists - if not create it
        $dirName = Split-Path -Path $output
        if (($dirName -ne $null) -and (-Not(Test-Path($dirName))))
        {
          New-Item $dirName -ItemType Directory -Force | Out-Null
        }
        Copy-Item -Path $file -Destination $output
      }
      Else
      {
        Write-Host "Already up-to-date. Nothing to do."
      }
      Return
    }
  }

  Copy-KeyboardShortcuts $file $output
}

Export-ModuleMember -Function Update-KeyboardShortcutsFromExternal