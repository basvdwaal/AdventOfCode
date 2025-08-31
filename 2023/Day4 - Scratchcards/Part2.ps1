
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$CardCounter = @{}
$LastCardNo = $PuzzleInput.Count

foreach ($line in $PuzzleInput)
{
    $dummy = $line -match 'Card\s+?(\d+):'
    $CardNo = [int]$Matches[1]
    $StrippedLine = $line -replace 'Card\s+\d+:\s+' -replace "  ", " " 

    $WinningNumbersString, $NumbersString = $StrippedLine -split " \| "
    $WinningNumbers = $WinningNumbersString -split " "
    $Numbers = $NumbersString -split " "

    if ($null -eq $CardCounter[$cardno])
    {
        $CardCounter[$cardno] = 1
    }
    else
    {
        $CardCounter[$cardno] += 1
    }

    $counter = 0
    foreach ($number in $Numbers)
    {
        if ($number -in $WinningNumbers) { $counter++ }
    }

    if ($counter -eq 0) { continue }

    $counter = $counter 

    # Write-Host "Card $cardno has $counter hits * $($CardCounter[$CardNo]) cards"
    
    foreach ($i in 1..$counter)
    {
        $card = $CardNo + $i
        if ($card -gt $LastCardNo) { break }

        # Write-Host "Card $card + $(1 * $CardCounter[$CardNo])"
        if ($null -eq $CardCounter[$card])
        {
            $CardCounter[$card] = 1 * $CardCounter[$CardNo]
        }
        else
        {
            $CardCounter[$card] += 1 * $CardCounter[$CardNo]
        }
    }
}

$total = 0
foreach ($card in $CardCounter.Keys)
{
    $total += $CardCounter[$card]
}

Write-Host "Total: $total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0294196