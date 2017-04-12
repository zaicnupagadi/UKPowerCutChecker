function Get-UKPowerCuts-Checker {

Param (
#[ValidatePattern("^([a-zA-Z]){1}([0-9][0-9]|[0-9]|[a-zA-Z][0-9][a-zA-Z]|[a-zA-Z][0-9][0-9]|[a-zA-Z][0-9]){1}([ ])([0-9][a-zA-z][a-zA-z]){1}$")] $PostCode
[ValidatePattern("^([A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKS-UW])\ [0-9][ABD-HJLNP-UW-Z]{2}|(GIR\ 0AA)|(SAN\ TA1)|(BFPO\ (C\/O\ )?[0-9]{1,4})|((ASCN|BBND|[BFS]IQQ|PCRN|STHL|TDCU|TKCA)\ 1ZZ))$")] $PostCode,
[switch]$ViewAll
)

$web = (Invoke-WebRequest http://www.powercut105.com/FindOperator?Postcode=$PostCode#dno)
$a = ($web.tostring() -split "[`r`n]" | select-string "lblSupplier").ToString()
$b = $a.Replace('bold;">','#').replace("</span>","#")
$prog = [regex]::match($b,'#([^#]+)#')

$PowerSupplier = $prog.Groups[1].Value
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
        "Postcode not found" {"Error while checking the postcode"} 
        "Western Power Distribution" {Get-UKPowerCuts-WesternPower @params}
        "UK Power Networks" {Get-UKPowerCuts-UKPowerNetworks @params}
        default {"The color could not be determined."}
    }

    
}