function Get-UKPowerCuts-UKPowerNetworks {

Param (
#[ValidatePattern("^([a-zA-Z]){1}([0-9][0-9]|[0-9]|[a-zA-Z][0-9][a-zA-Z]|[a-zA-Z][0-9][0-9]|[a-zA-Z][0-9]){1}([ ])([0-9][a-zA-z][a-zA-z]){1}$")] $PostCode
[ValidatePattern("^([A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKS-UW])\ [0-9][ABD-HJLNP-UW-Z]{2}|(GIR\ 0AA)|(SAN\ TA1)|(BFPO\ (C\/O\ )?[0-9]{1,4})|((ASCN|BBND|[BFS]IQQ|PCRN|STHL|TDCU|TKCA)\ 1ZZ))$")] $PostCode,
[bool]$ViewAll
)


$WebSite = "http://www.ukpowernetworks.co.uk/internet/en/power-cuts/list-of-powercuts/"
$Table = (Get-WebRequestTable $WebSite -TableNumber 0 -IeExperience)
$AllObjects = @()

ForEach ($f in $TAble) {
if ($f.'Potentially affected postcodes'){
$c = ($f.'Potentially affected postcodes').replace(" ","")
$d = $Postcode.replace(" ","")

    if ($f.'Potentially affected postcodes' -match ","){
    $ff = $f.'Potentially affected postcodes' -split(",")
    ForEach ($fff in $ff) {
    $obj = [PSCustomObject]@{
    AreasAffected = $fff
    TimeofIncident = $f.'This power cut was reported at'
    EstimatedRestorationTime = $f.'Estimated time for power to be restored'
    ReferenceNumber = $f.'Reference number'
    }
    $g = $fff.replace(" ","")
    if ($ViewAll -eq "True"){
    $AllObjects += $obj
    } else {
    if ($d -match $g) {
    $AllObjects += $obj
    }
    }
    }
    } else {
    $obj = [PSCustomObject]@{
    AreasAffected = $f.'Potentially affected postcodes'
    TimeofIncident = $f.'This power cut was reported at'
    EstimatedRestorationTime = $f.'Estimated time for power to be restored'
    ReferenceNumber = $f.'Reference number'
    }
    if ($ViewAll -eq "True"){
    $AllObjects += $obj
    } else {
    if ($d -match $c) {
    $AllObjects += $obj
    }
    }

}
}
}
$AllObjects
}