
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
    
    $BatteryArr = @()
    $LastNumberIndex = -1
    $NumbersNeeded = 12
    while ($BatteryArr.Length -lt 12)
    {
        $BiggestNumber = 0
        $BiggestNumberIndex = 0
        for ($i = $LastNumberIndex + 1; $i -le $Numbers.Count - $NumbersNeeded ; $i++)
        {
            $Number = $Numbers[$i]
            if ($Number -gt $BiggestNumber) { 
                $BiggestNumber = $Number
                $BiggestNumberIndex = $i
            }
        }

        $LastNumberIndex = $BiggestNumberIndex
        $BatteryArr += $BiggestNumber
        $NumbersNeeded--
    }
    
    # Write-Host "BiggestPair: $($BatteryArr -join '')"
    $total += [Int64]($BatteryArr -join "")
}

Write-Host "Total: $total"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.2697804