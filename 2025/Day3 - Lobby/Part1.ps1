
Set-StrictMode -Version latest

$PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
# $PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

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

    Write-Host "BiggestPair: $($BiggestPair[0])$($BiggestPair[1])"
    $total += [int]::Parse("$($BiggestPair[0])$($BiggestPair[1])")

}

Write-Host "Total: $total"

#####################################################
#   Alternative solution
#####################################################

$total = 0
foreach ($Sequence in $PuzzleInput)
{
    $Numbers = [int[]]($Sequence.ToCharArray() | % { $_ - 48})
    $BiggestPair = @(0, 0)
    
    # Find biggest number in array minus last spot (so we can always get two numbers)
    $FirstNumberIndex = 0
    for ($i = 0; $i -lt $Numbers.Count - 1; $i++)
    {
        $number = $Numbers[$i]
        if ($number -gt $Numbers[$FirstNumberIndex]) { $FirstNumberIndex = $i }
    }
    $FirstNumber = $numbers[$FirstNumberIndex]
        
    # Find second biggest number, starting at the index of the first
    $SecondNumber = 0
    for ($i = $FirstNumberIndex + 1; $i -lt $Numbers.Count; $i++)
    {
        $number = $Numbers[$i]
        if ($number -gt $SecondNumber) { $SecondNumber = $number }
    }

    Write-Host "BiggestPair: $(($FirstNumber * 10) + $SecondNumber)"
    $total += ($FirstNumber * 10) + $SecondNumber
}

Write-Host "Total: $total"
# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.4739651