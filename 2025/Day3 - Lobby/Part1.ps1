
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions
#Endregion Functions
$total = 0

foreach ($Sequence in $PuzzleInput)
{
    $Numbers = [int[]]($Sequence.ToCharArray() | % { $_ - 48})
    $BiggestPair = @(0, 0)

    # Loop over all numbers
    for ($i = 0; $i -lt $Numbers.Count - 1; $i++)
    {
        $FirstNumber = $numbers[$i]
        if ($FirstNumber -le $BiggestPair[0]) { continue }

        # Foreach number, find all possible pairs starting at index of first number + 1
        for ($j = $i + 1; $j -lt $Numbers.Count; $j++)
        {
            $SecondNumber = $Numbers[$j]

            if ($FirstNumber -gt $BiggestPair[0] -or
                ( $FirstNumber -ge $BiggestPair[0] -and
                $SecondNumber -gt $BiggestPair[1] )  
            )
            {
                $BiggestPair = @($FirstNumber, $SecondNumber)
            }
        }
    }

    # Write-Host "BiggestPair: $($BiggestPair[0])$($BiggestPair[1])"
    $total += [int]::Parse("$($BiggestPair[0])$($BiggestPair[1])")
}

Write-Host "Total: $total"
# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.4739651