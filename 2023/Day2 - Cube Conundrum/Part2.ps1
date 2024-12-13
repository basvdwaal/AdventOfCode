
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

$Total = 0

foreach ($game in $PuzzleInput)
{
    $DiceHT = @{}
    
    $GameId, $temp = $game -split ": "
    $GameId = [int]($GameId -replace "Game ")

    $rolls = $temp -split "; "

    foreach($roll in $rolls)
    {
        foreach ($dice in $roll -split ", ")
        {
            [int]$count, $color = $dice -split " "
            if ($DiceHT[$color])
            {
                if ($DiceHT[$color] -lt $count)
                {
                    $DiceHT[$color] = $count
                }
            }
            else
            {
                $DiceHT[$color] = $count
            }
        }
    }

    $sum = 0
    foreach ($value in $DiceHT.Values)
    {
        if ($sum -eq 0)
        {
            $sum = $value
        }
        else
        {
            $sum *= $value
        }
    }
    $Total += $sum
}

Write-Host "Total: $Total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0125878