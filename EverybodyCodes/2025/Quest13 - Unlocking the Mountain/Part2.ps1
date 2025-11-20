
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample2.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions


$Wheel = @(1)
$oneindex = 0

for ($i = 0; $i -lt $PuzzleInput.Count; $i++)
{
    if ($i % 2 -eq 0) # even (0,2,4 etc)
    {
        $N1, $N2 = $PuzzleInput[$i] -split "-" 

        $Wheel += $N1..$N2
    }
    else
    {
        $N1, $N2 = $PuzzleInput[$i] -split "-" 
        $range = @($N2..$N1)
        $Wheel = $range + $Wheel
        $oneindex += $range.Count
    }
}

# 2025 right turns -> 2025 % amount of numbers on the wheel
$index = (20252025 + $oneindex) % $Wheel.Length

# Write-Host $Wheel
Write-Host $Wheel[$index]

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.2343266