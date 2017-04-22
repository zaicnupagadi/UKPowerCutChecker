function Get-UKPowerCutsSPEnergyNetworks {

  Param (
    [Parameter(Mandatory=$true)][ValidatePattern("^([A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKS-UW])\ [0-9][ABD-HJLNP-UW-Z]{2}|(GIR\ 0AA)|(SAN\ TA1)|(BFPO\ (C\/O\ )?[0-9]{1,4})|((ASCN|BBND|[BFS]IQQ|PCRN|STHL|TDCU|TKCA)\ 1ZZ))$")] $PostCode,
    [bool]$ViewAll = $false
  )

  $PostCodeNoSpace = $PostCode -replace ' ',''
  $WebSite = ("https://www.spenergynetworks.co.uk/pages/postcode_results.aspx?post=$PostCodeNoSpace")
  $WebRequest = Invoke-WebRequest $WebSite
  if ($WebRequest.ParsedHtml.body.getElementsByClassName('spacer-top-10')[0].outertext -eq "No faults detected") {
  Write-Output "There are no power cuts for your area"
  } else {
  Write-Output "There are power cuts for your area, check 'SP Energy Networks' website for details."
  }


}