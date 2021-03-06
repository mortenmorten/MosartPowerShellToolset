function Copy-Settings {
  param(
    [string]
    $SourcePath,
    [string]
    $DestinationPath,
    [string[]]
    $SettingNames,
    [string]
    $OutFile = $DestinationPath
  )

  $sourceSettings = ([xml] (Get-Content -Path $SourcePath)).configuration.userSettings.FirstChild
  $destinationSettings = ([xml] (Get-Content -Path $DestinationPath)).configuration.userSettings.FirstChild

  ForEach ($name in $SettingNames) {
    $original = $sourceSettings.SelectSingleNode("setting[@name='$($name)']")
    $existing = $destinationSettings.SelectSingleNode("setting[@name='$($name)']")
    If ($original) {
      $import = $destinationSettings.OwnerDocument.ImportNode($original, $true)
      If ($existing) {
        $newChild = $destinationSettings.ReplaceChild($import, $existing)
      }
      Else {
        $newChild = $destinationSettings.AppendChild($import)
      }
    }
    Else {
      If ($existing) {
        $oldChild = $destinationSettings.RemoveChild($existing)
      }
    }
  }

  $destinationSettings.OwnerDocument.Save($OutFile)
}