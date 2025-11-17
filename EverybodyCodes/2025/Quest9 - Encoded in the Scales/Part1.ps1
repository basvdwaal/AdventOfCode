
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$null, [char[]]$Child = $PuzzleInput[2] -split ":"

# Parent 1
$count1 = 0
$null, [char[]]$Parent1 = $PuzzleInput[0] -split ":"

for ($i = 0; $i -lt $Child.Count; $i++)
{
    if ($Parent1[$i] -eq $Child[$i]) {$count1++}
}

# Parent 2
$count2 = 0
$null, [char[]]$Parent2 = $PuzzleInput[1] -split ":"

for ($i = 0; $i -lt $Child.Count; $i++)
{
    if ($Parent2[$i] -eq $Child[$i]) {$count2++}
}

Write-Host "Total: $($count1 * $count2)" 


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0010816