
<#Param (
[ValidatePattern("^([A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKS-UW])\ [0-9][ABD-HJLNP-UW-Z]{2}|(GIR\ 0AA)|(SAN\ TA1)|(BFPO\ (C\/O\ )?[0-9]{1,4})|((ASCN|BBND|[BFS]IQQ|PCRN|STHL|TDCU|TKCA)\ 1ZZ))$")] $PostCode,
[bool]$ViewAll
)#>
$AllObjects = @()
$rows= @()
$WebSite = ('https://www.ssepd.co.uk/Powertrack/')
$WebRequest = Invoke-WebRequest $WebSite 

$divs = $WebRequest.ParsedHtml.body.getElementsByTagName('div') | 
    Where-Object {$_.getAttributeNode('class').Value -eq 'power-track-summary clearfix'}

$rows  = $divs.getElementsByClassName('accordion-group')
#$r = $rows[0].getElementsByClassName('content clearfix')
##$titles = @(
##$r[0].getElementsByClassName('content-label')[0]
## | % {$_.outertext})

#$r[0].getElementsByTagName('P') | ft innerhtml

ForEach ($row in $rows) {

$MaxPElements = ($row.getElementsByTagName('P') | ? {$_.outerhtml -match "content"} | measure).count

    For ($i=0; $i -eq $MaxPElements; $i+2) {
    $i
    $row.getElementsByTagName('P')[$i]| ft outerhtml
    $row.getElementsByTagName('P')[$i].nextsibling.nextsibling | ft outerhtml
    }
    #$titles = @($cells | ForEach-Object { ("" + $_.InnerText).Trim() })
}

