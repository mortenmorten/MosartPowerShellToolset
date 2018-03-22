Function Remove-KeyboardShortcut {
  [CmdletBinding()]
  param(
    [Parameter(
      Position = 0,
      Mandatory = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [string[]] $Path,
    [Parameter(
      Position = 1,
      Mandatory = $false,
      ValueFromPipelineByPropertyName = $true
    )]
    [string] $ShortcutName
  )

  foreach($file in $Path) {
    Write-Verbose "Target: $($file)"

    If (-not (Test-Path $file)) {
      Throw "Target file does not exist: $($file)"
    }

    $xml = [xml] (Get-Content -LiteralPath $file -Encoding UTF8)

    If (-Not $ShortcutName) {
      $counter = 0
      $shortcutNames = Get-KeyboardShortcutNames $xml
      $optionNames = ($shortcutNames | % { "&{0:X}: {1}" -f $counter++, $_ })
      $index = Select-Item -ChoiceList $optionNames -Caption "Missing shortcut name" -Message "Please make a selection"
      $ShortcutName = $shortcutNames[$index]
      Write-Verbose "User choice is: $($ShortcutName)"
    }

    Remove-KeyboardShortcutsContent -Content $xml -ShortcutName $ShortcutName | Set-XmlContent -Path $file
  }
}

Export-ModuleMember -Function Remove-KeyboardShortcut