
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$Points = $PuzzleInput -split ","

$HalfSize = 16
$total = 0

for ($i = 1; $i -lt $Points.Count; $i++)
{

    $StartNail = $points[$i - 1]
    $EndNail = $Points[$i]

    $point1 = [System.Math]::Max($StartNail, $EndNail)
    $point2 = [System.Math]::Min($StartNail, $EndNail)

    if ( ($point1 - $point2) -eq $HalfSize )
    {
        Write-host "$point1 -> $point2" -ForegroundColor Green
        $total++
    }
    else
    {
        Write-host "$point1 -> $point2" -ForegroundColor Red
    }
}

write-host "Total: $total"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"