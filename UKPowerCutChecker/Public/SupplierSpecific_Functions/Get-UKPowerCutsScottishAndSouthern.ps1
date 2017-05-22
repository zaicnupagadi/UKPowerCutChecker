
<#Param (
[ValidatePattern("^([A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKS-UW])\ [0-9][ABD-HJLNP-UW-Z]{2}|(GIR\ 0AA)|(SAN\ TA1)|(BFPO\ (C\/O\ )?[0-9]{1,4})|((ASCN|BBND|[BFS]IQQ|PCRN|STHL|TDCU|TKCA)\ 1ZZ))$")] $PostCode,
[bool]$ViewAll
)#>
$AllObjects = @()
$object = @{}
$obiekt  = @{}
$props = @{}
$WebSite = ('https://www.ssepd.co.uk/Powertrack/')
$WebRequest = Invoke-WebRequest $WebSite 

$divs = $WebRequest.ParsedHtml.body.getElementsByTagName('div') | 
    Where-Object {$_.getAttributeNode('class').Value -eq 'power-track-summary clearfix'}
$rows  = $divs.getElementsByClassName('accordion-group')


ForEach ($row in $rows) {
$props = @{}
$c = @()
$MaxPElements = ($row.getElementsByTagName('P') | ? {$_.outerhtml -match "content"} | measure).count
    For ($i=0; $i -lt $MaxPElements ; $i+=2) {
    $PropName = $row.getElementsByTagName('P')[$i].outertext.Replace(' ','')
    $PropValue = $row.getElementsByTagName('P')[$i].nextsibling.nextsibling.outertext
    $props += @{"$PropName" = "$PropValue"}
    }
    $e = $row.getElementsByClassName('affected-areas row')
    $codes = $e[0].getElementsByClassName('col-xs-12 col-sm-3 col-md-2')
    ForEach ($code in $codes) { $c += $code.innertext.trim()+"," }
    $props += @{"AffectedPostCodes" = $c.trimend(',')}
    $object = new-object psobject -Property $props
    $AllObjects += $object
}
$AllObjects | select -Property Faultreference, * -ErrorAction SilentlyContinue


<#
[string] $a = (($AllObjects | gm -MemberType noteproperty).name | ? {$_ -ne "FaultReference"})

$AllObjects | select -Property Faultreference, $a

select -Property Faultreference, * -ErrorAction SilentlyContinue

Restorationexpectedat, Reportedat, AffectedPostCodes







$o2 = @{}
$o2 = New-Object PsObject
$AllObjects.psobject.properties | % {
    if ($_.value -match "Faultreference"){
    $o2 | Add-Member -MemberType "NoteProperty" -Name $_.Name -Value $_.Value
}}
$o2.SyncRoot
###
<#
$cos=@{
    jeden=1
    dwa=2
    trzy=3
}

$cos.psobject.properties

$props2=[ordered]@{
    Faultreference=$AllObjects[0]['Faultreference']}
foreach ($bla in (($AllObjects[0].GetEnumerator()).name) | where {$_ -ne 'Faultreference'}) {
    $props2[$bla]= $AllObjects[0][$bla]
   }

$props2#>