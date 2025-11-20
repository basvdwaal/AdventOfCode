
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample3.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input3.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions


$Wheel = , @(1,1)
$oneindex = 0

for ($i = 0; $i -lt $PuzzleInput.Count; $i++)
{
    if ($i % 2 -eq 0) # even (0,2,4 etc)
    {
        [int]$N1, [int]$N2 = $PuzzleInput[$i] -split "-" 

        $Wheel += , @($N1,$N2)
    }
    else
    {
        [int]$N1, [int]$N2 = $PuzzleInput[$i] -split "-" 
        $Wheel = , @($N2,$N1) + $Wheel
        $oneindex += $range.Count
    }
}

$wheelsize = 0
foreach ($pair in $Wheel)
{
    if ($pair[0] -eq 1)
    {
        $IndexOne = $wheel.IndexOf($pair)
    }
    $wheelsize += [math]::Abs($pair[0] - $pair[1]) + 1
}


# Rotate index by $indexOne to simpplify next step
$wheel = $Wheel[$indexOne..($wheel.Length - 1)] + $Wheel[0..($indexOne - 1)]

# 2025 right turns -> 2025 % amount of numbers on the wheel
$index = 202520252025 % $wheelsize

foreach ($pair in $Wheel)
{
    if ($index -gt [math]::Abs($pair[0] - $pair[1]))
    {
        $index -= [math]::Abs($pair[0] - $pair[1]) + 1
        continue
    }

    if ($pair[0] -gt $pair[1])
    {
        write-host ($pair[0] - $index)
    }
    else
    {
        write-host ($pair[0] + $index)
    }
    break
}


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:27:57.4097118 -> Brute force method
# Runtime: 00:00:00.0144536 -> Proper method