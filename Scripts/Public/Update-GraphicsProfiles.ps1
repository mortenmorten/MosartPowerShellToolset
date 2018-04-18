<#
.SYNOPSIS
  Update the config files for Overlay Graphics Interface or AvAutomation with graphics profiles settings.
.DESCRIPTION
  Update the config files for Overlay Graphics Interface or AvAutomation with graphics profiles settings from an external source.
.EXAMPLE
  $json = "[ { "name": "News", "default": true, "concept": "News", "overlaygraphics": { "showpath": "News/L3" }, "avautomation": { "showpath": "News/FS" } } ]""
  ConvertFrom-Json $json | Update-GraphicsProfiles
.EXAMPLE
  $json = "[ { "name": "News", "default": true, "concept": "News", "overlaygraphics": { "showpath": "News/L3" } } ]""
  ConvertFrom-Json $json | Update-GraphicsProfiles -OverlayGraphics
.EXAMPLE
  $json = "[ { "name": "News", "default": true, "concept": "News", "avautomation": { "showpath": "News/FS" } } ]""
  ConvertFrom-Json $json | Update-GraphicsProfiles -AvAutomation
#>
Function Update-GraphicsProfiles {
  [CmdletBinding()]
  param(
    [Parameter(
      Position = 0,
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [PSObject] $Content,
    [Parameter(
      ParameterSetName = "Paths",
      Position = 1,
      Mandatory = $true,
      ValueFromPipelineByPropertyName = $true)]
    [string[]] $Path,
    [Parameter(
      ParameterSetName = "OLG",
      Position = 2,
      Mandatory = $true,
      ValueFromPipelineByPropertyName = $true)]
    [switch] $OverlayGraphics,
    [Parameter(
      ParameterSetName = "OLG",
      Position = 3,
      ValueFromPipelineByPropertyName = $true)]
    [string] $OverlayGraphicsPath,   
    [Parameter(
      ParameterSetName = "AVA",
      Position = 2,
      Mandatory = $true,
      ValueFromPipelineByPropertyName = $true)]
    [switch] $AvAutomation,
    [Parameter(
      ParameterSetName = "AVA",
      Position = 3,
      ValueFromPipelineByPropertyName = $true)]
    [string] $AvAutomationPath
  )

  $entries = @()

  if (!$OverlayGraphicsPath) {
    if ($Path -and $Path[0]) {
      $OverlayGraphicsPath = $Path[0]
    }
    elseif (!$AvAutomation) {
      $OverlayGraphicsPath = "C:\ProgramData\Mosart Medialab\ConfigurationFiles\graphic_settings.xml"
    }
  }
  if ($OverlayGraphicsPath) {
    $entries += @{ 
      "filepath"     = $OverlayGraphicsPath;
      "xpath"        = "//GraphicProfiles";
      "fullscreen" = $false
    }
  }

  if (!$AvAutomationPath) {
    if ($Path -and $Path[1]) {
      $AvAutomationPath = $Path[1]
    }
    elseif (!$OverlayGraphics) {
      $AvAutomationPath = Get-AppDataPath -AppName MMAVAutomation
    }
  }
  if ($AvAutomationPath) {
    $entries += @{ 
      "filepath"     = $AvAutomationPath;
      "xpath"        = "//setting[@name='gfxShows']/value";
      "fullscreen" = $true
    }
  }

  foreach ($entry in $entries) {
    Write-Verbose "Replacing inner text in '$($entry.xpath)' in file $($entry.filepath)"

    [xml] $configContent = gc $entry.filepath
    $configContent.SelectSingleNode($entry.xpath).InnerText = (ConvertTo-GraphicsProfileXml -Profiles $Content -AvAutomation:$entry.fullscreen)
    $configContent.Save($entry.filepath)
  }
}

Export-ModuleMember -Function Update-GraphicsProfiles