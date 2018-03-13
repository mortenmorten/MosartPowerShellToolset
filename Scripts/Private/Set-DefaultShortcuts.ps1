# Reads a keyboard settings file, sets the default shortcuts and saves the file to a new location  
function Set-DefaultShortcuts {
  param(
    # Source keyboard settings file
    [Parameter(Mandatory = $true)]
    [string] $file = "keyboard_shortcuts.xml", 
    # Name of default shortcuts
    [Parameter(
      Mandatory = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [Alias('DefaultShortcutName')]
    [string] $name,
    # Target keyboard settings file
    [Parameter(Mandatory = $true)]
    [string] $output = $file
  )
  
  $xml = [xml](Get-Content $file)
  
  # Reset all default attributes
  foreach ($shortcut in $xml.keyboard_shortcuts.Shortcuts) {
    $shortcut.SetAttribute("isDefault", "false")
    $shortcut.SetAttribute("default", "false")
  }
  
  if ($name -ne $null) {
    $XPath = "//shortcuts[@name='" + $name + "']"
  
    $selectedShortcuts = Select-Xml $xml -XPath $XPath | Select-Object -ExpandProperty Node
    if ($selectedShortcuts -ne $null) {
      $selectedShortcuts.SetAttribute("isDefault", "true")
      $selectedShortcuts.SetAttribute("default", "true")
    }
  }
  
  $xml.Save($output)
}