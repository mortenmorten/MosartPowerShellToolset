Function Export-KeyboardShortcuts {
  [CmdletBinding(DefaultParameterSetName = "OneShortcut")]
  param(
    [Parameter(
      Position = 0,
      Mandatory = $false,
      ValueFromPipelineByPropertyName = $true
    )]
    [string] $LiteralPath = $MosartKeyboardSettings.LocalShortcutsPath,
    [Parameter(
      Position = 1,
      Mandatory = $false,
      ValueFromPipelineByPropertyName = $true
    )]
    [string] $Destination = $MosartKeyboardSettings.RemoteShortcutsPath,
    [Parameter(
      Position = 2,
      Mandatory = $true,
      ParameterSetName = "AllShortcuts"
    )]
    [switch] $All
    ,
    [Parameter(
      Position = 2,
      Mandatory = $false,
      ParameterSetName = "OneShortcut"
    )]
    [string] $ShortcutName
  )

  Write-Verbose "Source: $($LiteralPath)"
  Write-Verbose "Destination: $($Destination)"

  If (-not (Test-Path $LiteralPath)) {
    Throw "Source file does not exist: $($LiteralPath)"
  }

  If (-not (Test-Path $Destination) -or $All) {
    Copy-Item -LiteralPath $LiteralPath -Destination $Destination -Force
  }
  Else {
    $xml = [xml] (Get-Content -LiteralPath $LiteralPath -Encoding UTF8)

    If (-Not $ShortcutName) {
      $counter = 0
      $shortcutNames = Get-KeyboardShortcutNames $xml
      $optionNames = ($shortcutNames | % { "&{0:X}: {1}" -f $counter++, $_ })
      $index = Select-Item -ChoiceList $optionNames -Caption "Missing shortcut name" -Message "Please make a selection"
      $ShortcutName = $shortcutNames[$index]
      Write-Verbose "User choice is: $($ShortcutName)"
    }

    $shortcutContent = Get-KeyboardShortcutsContent -Content $xml -ShortcutName $ShortcutName
    ([xml] (Get-Content -LiteralPath $Destination -Encoding UTF8) | Replace-KeyboardShortcutsContent -ShortcutContent $shortcutContent) | Set-XmlContent -Path $Destination
  }
}

Export-ModuleMember -Function Export-KeyboardShortcuts