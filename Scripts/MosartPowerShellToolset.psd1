@{
  ModuleToProcess   = 'MosartPowerShellToolset.psm1'
  ModuleVersion     = '2.0'
  GUID              = '549626e6-7af0-4540-af3c-45bdf49383ed'
  Author            = 'Morten Larsen'
  Copyright         = '(c) 2017 Morten Larsen'
  Description       = 'A set of PowerShell cmdlets for simplifying various Viz Mosart operations'
  PowerShellVersion = '2.0'
  FunctionsToExport = @('Compare-ComputerSettings',
                        'Copy-ComputerSettings',
                        'Copy-ServerConfigs',
                        'Export-KeyboardShortcuts',
                        'Import-KeyboardShortcuts',
                        'Sync-AndFlattenFolder')
  CmdletsToExport   = @()
  VariablesToExport = '*'
  AliasesToExport   = @()
  PrivateData       = @{
    PSData = @{
      # Tags applied to this module. These help with module discovery in online galleries.
      # Tags = @()

      # A URL to the license for this module.
      # LicenseUri = ''

      # A URL to the main website for this project.
      # ProjectUri = ''

      # A URL to an icon representing this module.
      # IconUri = ''

      # ReleaseNotes of this module
      # ReleaseNotes = ''

    } # End of PSData hashtable

  } # End of PrivateData hashtable

  # HelpInfo URI of this module
  # HelpInfoURI = ''

  # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
  # DefaultCommandPrefix = ''
}
