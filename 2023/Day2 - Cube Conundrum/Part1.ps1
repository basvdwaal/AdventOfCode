
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

$LookupTable = @{
    "red" = 12
    "green" = 13
    "blue" = 14
}

$Total = 0

:outer
foreach ($game in $PuzzleInput)
{
    $GameId, $temp = $game -split ": "
    $GameId = [int]($GameId -replace "Game ")

    $rolls = $temp -split "; "

    foreach($roll in $rolls)
    {
        foreach ($dice in $roll -split ", ")
        {
            [int]$count, $color = $dice -split " "
            if ($count -gt $LookupTable[$color])
            {
                continue outer
            }
        }
    }
    $Total += $GameId
}

Write-Host "Total: $Total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0169161