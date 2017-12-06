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
    
#    $defaultValue = $null
#    If ($DefaultHash.ContainsKey($Key)) {
#        $defaultValue = $DefaultHash[$Key]
#        If ($value -eq $defaultValue) { 
#            $value += " (default)" 
#        }
#    }
    
    $value
}

function ConvertTo-Text {
    param(
        $Value
    )
 
    If ($Value.GetType() -eq [System.Xml.XmlElement]) {
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
        $diffValue = Get-ActualOrDefaultSetting $Key $DifferenceHash $DefaultSettings
        $refValue = Get-ActualOrDefaultSetting $Key $ReferenceHash $DefaultSettings
        $defaultValue = $null
        If ($DefaultSettings.ContainsKey($Key)) { $defaultValue = $DefaultSettings[$Key]}

        If (($IncludeSettings.Count -eq 0) -or $IncludeSettings.ContainsKey($Key)) {
            If ((-not $ExcludeSettings.ContainsKey($Key)) -and ($refValue -ne $defaultValue) -and ($refValue -ne $diffValue)) {
                $Key | Select-Object @{Name='Setting';Expression={$_}}, @{Name='DefaultValue';Expression={ConvertTo-Text $defaultValue}}, @{Name='ReferenceValue';Expression={ConvertTo-Text $refValue}}, @{Name='DifferenceValue';Expression={ConvertTo-Text $diffValue}}
            }
        }
    }
}

$ExcludeHash = @{}
$ExcludeSettings | ForEach-Object { $ExcludeHash.Add($_, $null) }

$IncludeHash = @{}
If ($UseIncludeSettings) { $IncludeSettings | ForEach-Object { $IncludeHash.Add($_, $null) } }

$ReferenceHash = ConvertTo-HashTable $ReferenceSettings
$DifferenceHash = ConvertTo-HashTable $DifferenceSettings
$DefaultSettingsHash = ConvertTo-HashTable $DefaultSettings

Select-DifferentValues -ReferenceHash $ReferenceHash -DifferenceHash $DifferenceHash -DefaultSettings $DefaultSettingsHash -ExcludeSettings $ExcludeHash -IncludeSettings $IncludeHash | Sort -Property Setting

