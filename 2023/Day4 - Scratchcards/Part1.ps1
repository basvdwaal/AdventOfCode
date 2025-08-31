
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$Total = 0

foreach ($line in $PuzzleInput)
{
    $StrippedLine = $line -replace 'Card\s+\d+:\s+' -replace "  ", " "

    $WinningNumbersString, $NumbersString = $StrippedLine -split " \| "
    $WinningNumbers = $WinningNumbersString -split " "
    $Numbers = $NumbersString -split " "

    $counter = 0

    foreach ($number in $Numbers)
    {
        if ($number -in $WinningNumbers)
        {
            $counter++
        }
    }

    $CardPoints = $counter ? [Math]::Pow(2, ($counter - 1)) : 0

    Write-Host "Card is worth $CardPoints points"
    $Total += $CardPoints
}

Write-Host "Total: $total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.1003263