
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

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
        $Wheel += $PuzzleInput[$i]
    }
    else
    {
        $Wheel = @($PuzzleInput[$i]) + $Wheel
        $oneindex++
    }
}

# 2025 right turns -> 2025 % amount of numbers on the wheel
$index = (2025 + $oneindex) % $Wheel.Length

Write-Host $Wheel[$index]

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0007042 