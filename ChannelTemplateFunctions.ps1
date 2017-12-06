function ConvertTo-TemplateType {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [int[]]
    $Value
  )

  process {
    switch ($Value) {
      0 { "CAMERA" }
      1 { "PACKAGE" }
      2 { "VO" }
      3 { "LIVE" }
      4 { "GFX" }
      5 { "DVE" }
      6 { "JINGLE" }
      7 { "PHONE" }
      8 { "FLOAT" }
      9 { "BREAK" }
      default { [string] $Value }
    }
  }
}

function ConvertTo-TemplateSetObject {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [System.Xml.XmlElement]
    $XmlElement
  )

  process {
    $XmlElement | Select-Object @{Name = 'Name'; Expression = {$_.name}}, @{Name = 'Templates'; Expression = {$_.channel}}
  }
}

function ConvertTo-TemplateObject {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [System.Xml.XmlElement]
    $XmlElement
  )

  process {
    $XmlElement | Select-Object @{Name = 'Name'; Expression = {$_.name}}, @{Name='Type';Expression = { [int] $_.type }}, @{Name='Variant';Expression = {$_.templatetype}}, @{Name = 'Implementation'; Expression = {$_}}
  }
}

function ConvertTo-Implementation {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [System.Xml.XmlElement[]]
    $XmlElement
  )

  process {
    $XmlElement 
  }
}

function Get-TemplateSet {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [xml]
    $XmlDocument,
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [string[]]
    $TemplateSetName
  )

  process {
    $XmlDocument.avconfig.channeltemplates.channels | ConvertTo-TemplateSetObject | Where-Object {$TemplateSetName -contains $_.Name }
  }
}

function Get-Templates {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ParameterSetName = 'object',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [psobject]
    $TemplateSetObject,
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ParameterSetName = 'xml',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [xml]
    $XmlDocument,
    [Parameter(
      Mandatory = $true,
      Position = 1,
      ParameterSetName = 'xml',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [string]
    $TemplateSetName
  )

  process {
    if (-not $TemplateSetObject) {
      $TemplateSetObject = Get-TemplateSet -XmlDocument $XmlDocument -TemplateSetName $TemplateSetName
    }

    $TemplateSetObject.Templates | ConvertTo-TemplateObject
  }
}

function Get-Template {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ParameterSetName = 'object',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [psobject]
    $TemplateSetObject,
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ParameterSetName = 'xml',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [xml]
    $XmlDocument,
    [Parameter(
      Mandatory = $true,
      Position = 1,
      ParameterSetName = 'xml',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [string]
    $TemplateSetName,
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [int]
    $TemplateType,
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [string]
    $TemplateVariant
  )

  process {
    Get-Templates 
    if (-not $TemplateSetObject) {
      $TemplateSetObject = Get-TemplateSet -XmlDocument $XmlDocument -TemplateSetName $TemplateSetName
    }

    $TemplateSetObject.Templates | ConvertTo-TemplateObject
  }
}

function Select-PrimaryTemplates {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [psobject[]]
    $TemplateObject
  )
    
  process {
    $TemplateObject | Where-Object { $_.Type -lt 100}
  }
}

function Select-Template {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [psobject[]]
    $TemplateObject,
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [int]
    $TemplateType,
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [string]
    $TemplateVariant
  )

  process {
    $TemplateObject | Where-Object { $_.Type -eq $TemplateType -and $_.Variant -eq $TemplateVariant}
  }
}

function List-TemplateSets {
  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)]
    [xml]
    $XmlDocument
  )

  process {
    $XmlDocument.avconfig.channeltemplates.channels | ConvertTo-TemplateSetObject
  }
}
