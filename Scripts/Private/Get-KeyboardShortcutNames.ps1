function Get-KeyboardShortcutNames {
  [CmdletBinding()]
  param(
    [xml] $xml
  )
  
  Select-Xml $xml -XPath "//shortcuts/@name"
}