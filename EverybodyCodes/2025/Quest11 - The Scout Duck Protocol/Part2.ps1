
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample2.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================


#region Functions

function Get-FormationChecksum ($Formation)
{
    $total = 0
    for ($i = 0; $i -lt $Formation.Count; $i++)
    {
        $total += ($i + 1) * $Formation[$i]
    }
    return $total
}
#  1 * 8 + 2 * 1 + 3 * 2 + 4 * 4 + 5 * 8 + 6 * 7

#Endregion Functions

[int[]]$Formation = $PuzzleInput
$Rounds = 0

# Phase 1
do
{
    $hasmoved = $false
    for ($i = 0; $i -lt $Formation.Count -1; $i++)
    {
        if ($Formation[$i + 1] -lt $Formation[$i])
        {
            $Formation[$i]--
            $Formation[$i + 1]++
            $hasmoved = $true
        }
    }

    if ($hasmoved -eq $true)
    {
        $Rounds++
    }

}
While ($hasmoved -eq $true)

# Phase 2
do
{
    $hasmoved = $false
    for ($i = 0; $i -lt $Formation.Count -1; $i++)
    {
        if ($Formation[$i + 1] -gt $Formation[$i])
        {
            $Formation[$i]++
            $Formation[$i + 1]--
            $hasmoved = $true
        }
    }

    if ($hasmoved -eq $true)
    {
        $Rounds++
    }
}
While ($hasmoved -eq $true)

Write-Host $Rounds

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:48.7296191