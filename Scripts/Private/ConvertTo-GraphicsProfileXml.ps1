function ConvertTo-GraphicsProfileXml {
  param(
    $Profiles,
    [switch]$AvAutomation,
    [string]$DefaultProfileName
  )

  [xml]$doc = New-Object System.Xml.XmlDocument

  $root = $doc.CreateElement("NewDataSet")

  foreach ($profile in $profiles) {
    $e = $doc.CreateElement("setting")
    $e.SetAttribute("display_name", $profile.name) | Out-Null
    $showpath = ""
    $concept = $profile.concept
    if ($DefaultProfileName) {
      $default = $profile.name -eq $DefaultProfileName
    }
    else {
      $default = ($profile.default -ne $null) -and $profile.default
    }

    $data = $profile.overlaygraphics
    if ($AvAutomation) {
      $data = $profile.avautomation
    }

    if ($data) {
      $showpath = $data.showpath
      if ($data.concept) {
        $concept = $data.concept
      }
    }

    if ($AvAutomation) {
      $e.SetAttribute("description", "") | Out-Null
    }
    if (!$concept) {
      $concept = ""
    }
    $e.SetAttribute("concept", $concept) | Out-Null
    $e.SetAttribute("show_path", $showpath) | Out-Null
    $e.SetAttribute("default_scene_wall", "") | Out-Null
    $e.SetAttribute("default", [System.Xml.XmlConvert]::ToString($default)) | Out-Null
    $root.AppendChild($e) | Out-Null
  }

  $doc.AppendChild($root) | Out-Null

  Write-Output $doc.DocumentElement.OuterXml
}
