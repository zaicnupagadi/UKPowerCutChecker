function Get-UKPowerCutsScottishAndSouthern {

    
    Param (
        [Parameter(Mandatory = $true)][ValidatePattern("^([A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKS-UW])\ [0-9][ABD-HJLNP-UW-Z]{2}|(GIR\ 0AA)|(SAN\ TA1)|(BFPO\ (C\/O\ )?[0-9]{1,4})|((ASCN|BBND|[BFS]IQQ|PCRN|STHL|TDCU|TKCA)\ 1ZZ))$")] $PostCode,
        [switch]$ViewAll
    )
    $r = $NULL
    #$PostCode = "SL8 5EE"
    $AllObjects = @()
    $Allproperties = @()
    $FinalObject = @()
    $object = @{}
    $props = @{}
    $props2 = @{}
    $WebSite = ('https://www.ssepd.co.uk/Powertrack/')
    $WebRequest = Invoke-WebRequest $WebSite 

    $divs = $WebRequest.ParsedHtml.body.getElementsByTagName('div') | 
        Where-Object {$_.getAttributeNode('class').Value -eq 'power-track-summary clearfix'}
    $rows = $divs.getElementsByClassName('accordion-group')


    ForEach ($row in $rows) {
        $props = @{}
        $c = @()
        $MaxPElements = ($row.getElementsByTagName('P') | ? {$_.outerhtml -match "content"} | measure).count
        For ($i = 0; $i -lt $MaxPElements ; $i += 2) {
            $PropName = $row.getElementsByTagName('P')[$i].outertext.Replace(' ', '')
            $PropValue = $row.getElementsByTagName('P')[$i].nextsibling.nextsibling.outertext
            $props += @{"$PropName" = "$PropValue"}
        }
        $e = $row.getElementsByClassName('affected-areas row')
        $codes = $e[0].getElementsByClassName('col-xs-12 col-sm-3 col-md-2')
        ForEach ($code in $codes) { $c += $code.innertext.trim() + "," }
        $props += @{"AffectedPostCodes" = $c.trimend(',')}
        $object = new-object psobject -Property $props
        $AllObjects += $object
    }
    #$AllObjects | select -Property Faultreference, * -ErrorAction SilentlyContinue

    ForEach ($o in $AllObjects) {
        $props2 = @{}
        ForEach ($p in $o.psobject.Properties) {
            if ($p -notmatch "AffectedPostCodes") {
                $props2 += @{$p.name = $p.value}
                $Allproperties += $p.name
                $Allproperties += "AffectdPostCode"

            }
        }
        
        ForEach ($k in $o.AffectedPostCodes) {
            $props3 = @{}
            $props3 = $props2
            $props3 += @{"AffectdPostCode" = $k}

            $object2 = new-object psobject -Property $props3
            if ($ViewAll) {
                $FinalObject += $object2
            }
            else {
                if ($object2.AffectdPostCode.replace(" ", "") -match $PostCode.replace(" ", "")) {
                    $FinalObject += $object2
                }

            }
        }    
    }

    #$FinalObject | ft -Property *
    $uni = $Allproperties | select -Unique
    #$FinalObject | select $uni
    If ($FinalObject.count -eq 0 -and !$viewall) {
        Write-Output "There are no power cuts for your area."
    }
    elseif ($FinalObject.count -ne 0 -and !$viewall) {
        Write-Output "There are power cuts for your area."
        $FinalObject 
    }
    else {
        $FinalObject | ft $uni
    }

}  

#Get-UKPowerCutsChecker -PostCode "sl8 5ee" -ViewAll
#Get-UKPowerCutsScottishAndSouthern -PostCode "sl8 5ee" -ViewAll