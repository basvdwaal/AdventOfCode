
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample3.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input3.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions

function Get-NumberOfCrosses ($Newline, $lines)
{
    $NumCrosses = 0
    # Nieuwe lijn
    # $Png = [System.Math]::Max($Newline[0], $Newline[1])
    $Pnk, $Png = $Newline | Sort-Object

    foreach ($line in $lines)
    {
        # Oude lijn
        $Pok, $Pog = $line
        # $Pok = [System.Math]::Min($line[0], $line[1])

        if ($Png -in $line -or $pnk -in $line)
        {
            # We also cut if the lines match
            if ($Png -in $line -and $pnk -in $line)
            {
                $NumCrosses++
            }
            continue
        }

        $counter = (
            ($png -lt $Pog -and $png -gt $pok) +
            ($pnk -lt $Pog -and $pnk -gt $pok) 
        )

        if ($counter -eq 1) { $NumCrosses++}
    }

    Return $NumCrosses
}

#Endregion Functions

$Points = $PuzzleInput -split ","
$Lines = @()

Write-Host "Adding lines.."
for ($i = 1; $i -lt $Points.Count; $i++)
{

    $StartNail = $points[$i - 1]
    $EndNail = $Points[$i]

    # $Total += (get-NumberOfCrosses -Newline @($StartNail, $EndNail) -lines $Lines)
    $Lines += , @( ($StartNail, $EndNail | Sort-Object) )

}

Write-Host "Checking cuts.."
$CheckedLines = @{}
for ($i = 1; $i -le 256; $i++)
{
    for ($j = 1; $j -le 256; $j++)
    {
        if ($j -eq $i) { continue }

        $s, $b = $i, $j | Sort-Object

        if ($CheckedLines.ContainsKey(@($s,$b))) { continue }
        else 
        {
            $CheckedLines.Add( @($s,$b), (Get-NumberOfCrosses -Newline @($s, $b) -lines $Lines) )
        }
    }
}

Write-host "Max number of cuts: $($CheckedLines.Values | measure -Maximum | select -ExpandProperty Maximum)"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"