
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample2.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions

function Get-NumberOfCrosses ($Newline, $lines)
{
    $NumCrosses = 0
    # Nieuwe lijn
    $Png = [System.Math]::Max($Newline[0], $Newline[1])
    $Pnk = [System.Math]::Min($Newline[0], $Newline[1])

    foreach ($line in $lines)
    {
        # Oude lijn
        $Pog = [System.Math]::Max($line[0], $line[1])
        $Pok = [System.Math]::Min($line[0], $line[1])

        if ($Png -in $line -or $pnk -in $line)
        {
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

$total = 0
for ($i = 1; $i -lt $Points.Count; $i++)
{

    $StartNail = $points[$i - 1]
    $EndNail = $Points[$i]

    $Total += (get-NumberOfCrosses -Newline @($StartNail, $EndNail) -lines $Lines)
    $Lines += , @($StartNail, $EndNail)

}

write-host "Total: $total"



# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"