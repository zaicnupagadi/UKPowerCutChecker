﻿function Get-UKPowerCuts-WesternPower {

Param (
#[ValidatePattern("^([a-zA-Z]){1}([0-9][0-9]|[0-9]|[a-zA-Z][0-9][a-zA-Z]|[a-zA-Z][0-9][0-9]|[a-zA-Z][0-9]){1}([ ])([0-9][a-zA-z][a-zA-z]){1}$")] $PostCode
[ValidatePattern("^([A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKS-UW])\ [0-9][ABD-HJLNP-UW-Z]{2}|(GIR\ 0AA)|(SAN\ TA1)|(BFPO\ (C\/O\ )?[0-9]{1,4})|((ASCN|BBND|[BFS]IQQ|PCRN|STHL|TDCU|TKCA)\ 1ZZ))$")] $PostCode,
[bool]$ViewAll
)

$web = (Invoke-WebRequest https://www.westernpower.co.uk/Power-outages/Power-cuts-in-your-area/Power-Cut-outages-list.aspx)
$AllObjects = @()
#$t = (E:\Get-WebRequestTable.ps1 $web -TableNumber 0 | Select @{Name="AreasAffected";Expression={$_."Areas Affected"}})

$Table = (Get-WebRequestTable $web -TableNumber 0)
ForEach ($f in $TAble) {
$c = ($f.'Areas Affected').replace(" ","")
$d = $Postcode.replace(" ","")

    if ($f.'Areas Affected' -match ","){
    $ff = $f.'Areas Affected' -split(",")
    ForEach ($fff in $ff) {
    $obj = [PSCustomObject]@{
    AreasAffected = $fff
    TimeofIncident = $f.'Time of Incident'
    NumberPropertiesWithoutPower = $f.'Number properties without power'
    EstimatedRestorationTime = $f.'Estimated Restoration Time'
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
    AreasAffected = $f.'Areas Affected'
    TimeofIncident = $f.'Time of Incident'
    NumberPropertiesWithoutPower = $f.'Number properties without power'
    EstimatedRestorationTime = $f.'Estimated Restoration Time'
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
$AllObjects
}
