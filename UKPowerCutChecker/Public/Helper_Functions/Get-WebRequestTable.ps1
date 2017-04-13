Function Get-WebRequestTable {

param(

    [Parameter(Mandatory = $true)]
    [String] $WebSite,
     
    [Parameter(Mandatory = $true)]
    [int] $TableNumber,

    [switch] $IeExperience
)

## Extract the tables out of the web request
If ($IeExperience) {
  $ie = new-object -ComObject "InternetExplorer.Application"
  $ie.navigate($WebSite)
  while($ie.busy) {Start-Sleep 1}
  $doc = $ie.Document.body
  $tables = @($doc.getElementsByTagName('TABLE'))
} else {
  $WebRequest = Invoke-WebRequest $WebSite
  $tables = @($WebRequest.ParsedHtml.getElementsByTagName("TABLE"))
}

$table = $tables[$TableNumber]

$titles = @()

$rows = @($table.Rows)

## Go through all of the rows in the table

foreach($row in $rows)

{

    $cells = @($row.Cells)

   

    ## If we've found a table header, remember its titles

    if($cells[0].tagName -eq "TH")

    {

        $titles = @($cells | ForEach-Object { ("" + $_.InnerText).Trim() })

        continue

    }

    ## If we haven't found any table headers, make up names "P1", "P2", etc.

    if(-not $titles)

    {

        $titles = @(1..($cells.Count + 2) | ForEach-Object { "P$_" })

    }

    ## Now go through the cells in the the row. For each, try to find the

    ## title that represents that column and create a hashtable mapping those

    ## titles to content

    $resultObject = [Ordered] @{}

    for($counter = 0; $counter -lt $cells.Count; $counter++)

    {

        $title = $titles[$counter]

        if(-not $title) { continue }

       

        $resultObject[$title] = ("" + $cells[$counter].InnerText).Trim()

    }

    ## And finally cast that hashtable to a PSCustomObject

    [PSCustomObject] $resultObject

}
if ($ie){
$ie.Quit()
}
}
