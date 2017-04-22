function Get-UKPowerCutsChecker {

  <#
      .SYNOPSIS
      "Get-UKPowerCutsChecker" function has been created to give an information about power outages.
      "Get-UKPowerCutsChecker" is the main function of the module.

      .DESCRIPTION 
      "Get-UKPowerCutsChecker" allows you to check if there is any power cut for your post code, or if there are any power cuts for your power supplier.
      Valid post code need to be provided in order to see output.
      Verbose mode will additional show informarmation who has been identified as a power supplier for given post code.
      Currently 2 suppliers are included:
      "Western Power Disctribution"
      "UK Power Networks"
    
      .OUTPUTS
      Output so far is an object, at this point of time I think anyone will create a unique action is script returns an outage.
    
      .EXAMPLE
      Command to check if there is any ongoing power cut for some Coventry area:
      Get-UKPowerCutsChecker -PostCode "cv4 8hs"

      .EXAMPLE
      Command to list all ongoing power cuts for London, Cabot Square area:
      Get-UKPowerCutsChecker -PostCode "e14 4qr" -ViewAll

      .LINK
      https://paweljarosz.wordpress.com/2017/04/13/search-power-cuts-in-the-uk-using-powershell
      .NOTES
      Written By: Pawel Jarosz
      Website:	         http://paweljarosz.wordpress.com
      GitHub:            https://github.com/zaicnupagadi
      Technet:           https://gallery.technet.microsoft.com/scriptcenter/site/mydashboard
      PowerShellGallery: https://www.powershellgallery.com/packages/ukpowercutchecker

      Change Log
      V1.0.2, 13/04/2017 - Version with two power suppliers, creating proper function for ScottishAndSouthern.
      V1.0.1, 11/04/2017 - Initial version, dity and full of bugs :)
  #>

  Param (
    [Parameter(Mandatory=$true)][ValidatePattern("^([A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKS-UW])\ [0-9][ABD-HJLNP-UW-Z]{2}|(GIR\ 0AA)|(SAN\ TA1)|(BFPO\ (C\/O\ )?[0-9]{1,4})|((ASCN|BBND|[BFS]IQQ|PCRN|STHL|TDCU|TKCA)\ 1ZZ))$")] $PostCode,
    [switch]$ViewAll
  )

  $web = (Invoke-WebRequest http://www.powercut105.com/FindOperator?Postcode=$PostCode#dno)
  $a = ($web.tostring() -split "[`r`n]" | select-string "lblSupplier").ToString()
  $b = $a.Replace('bold;">','#').replace("</span>","#")
  $prog = [regex]::match($b,'#([^#]+)#')

  $PowerSupplier = $prog.Groups[1].Value
  Write-Verbose -Message "Power supplier has been identified as '$PowerSupplier'"
  if (!($ViewAll)){
    $params = @{
      PostCode = $PostCode
    }
  } else {
    $params = @{
      PostCode = $PostCode
      ViewAll  = $ViewAll
    }
  }

  switch ($PowerSupplier)
  { 
    "Postcode not found" {"Postcode not found"} 
    "Western Power Distribution" {Get-UKPowerCutsWesternPower @params}
    "UK Power Networks" {Get-UKPowerCutsUKPowerNetworks @params}
    "SP Energy Networks" {Get-UKPowerCutsSPEnergyNetworks @params}
    default {"Power supplier couldn't be identified - please report the problem to the Author."}
  }

    
}