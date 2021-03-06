function ConvertTo-HashTable {
  param(
    $Path
  )
    
  $settings = @{}
  if ($Path -and (Test-Path -Path $Path)) {
    ([xml] (Get-Content -Path $Path)).SelectNodes("//setting") | ForEach-Object { $settings.Add($_.name, $_.value) }
  }
  $settings
}

function Get-ActualOrDefaultSetting {
  param(
    [string]
    $Key,
    [hashtable]
    $ActualHash,
    [hashtable]
    $DefaultHash
  )
    
  $value = $null
  If ($ActualHash.ContainsKey($Key)) {
    $value = $ActualHash[$Key]
  }
    
  $value
}

function ConvertTo-Text {
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [AllowNull()]
    $Value
  )
 
  If ($Value -and ($Value.GetType() -eq [System.Xml.XmlElement])) {
    $Value.InnerXml
  }
  Else {
    $Value
  }
    
}

function Select-DifferentValues {
  param(
    [hashtable]
    $ReferenceHash = @{},
    [hashtable]
    $DifferenceHash = @{},
    [hashtable]
    $DefaultSettings = @{},
    [hashtable]
    $ExcludeSettings = @{},
    [hashtable]
    $IncludeSettings = @{}
  )
    
  ForEach ($Key in $ReferenceHash.Keys) {
    $diffValue = (Get-ActualOrDefaultSetting $Key $DifferenceHash $DefaultSettings | ConvertTo-Text)
    $refValue = (Get-ActualOrDefaultSetting $Key $ReferenceHash $DefaultSettings | ConvertTo-Text)
    $defaultValue = $null
    If ($DefaultSettings.ContainsKey($Key)) { $defaultValue = ($DefaultSettings[$Key] | ConvertTo-Text)}

    If (($IncludeSettings.Count -eq 0) -or $IncludeSettings.ContainsKey($Key)) {
      If ((-not $ExcludeSettings.ContainsKey($Key)) -and ($refValue -ne $defaultValue) -and ($refValue -ne $diffValue)) {
        $Key | Select-Object @{Name = 'Setting'; Expression = {$_}}, @{Name = 'DefaultValue'; Expression = {$defaultValue}}, @{Name = 'ReferenceValue'; Expression = {$refValue}}, @{Name = 'DifferenceValue'; Expression = {$diffValue}}
      }
    }
  }
}

function Compare-Settings {
  param(
    [string]
    $ReferenceSettings,
    [string]
    $DifferenceSettings,
    [string]
    $DefaultSettings,
    [string[]]
    $ExcludeSettings = @(),
    [switch]
    $UseIncludeSettings,
    [string[]]
    $IncludeSettings = @()
  )
  
  $ExcludeHash = @{}
  $ExcludeSettings | ForEach-Object { $ExcludeHash.Add($_, $null) }

  $IncludeHash = @{}
  If ($UseIncludeSettings) { $IncludeSettings | ForEach-Object { $IncludeHash.Add($_, $null) } }

  $ReferenceHash = ConvertTo-HashTable $ReferenceSettings
  $DifferenceHash = ConvertTo-HashTable $DifferenceSettings
  $DefaultSettingsHash = ConvertTo-HashTable $DefaultSettings

  Select-DifferentValues -ReferenceHash $ReferenceHash -DifferenceHash $DifferenceHash -DefaultSettings $DefaultSettingsHash -ExcludeSettings $ExcludeHash -IncludeSettings $IncludeHash | Sort -Property Setting
}