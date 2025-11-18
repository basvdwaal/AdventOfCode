
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample3.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input3.txt)

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

[Int64[]]$Formation = $PuzzleInput
$Total = 0

# Phase 1 is not needed since all are ascending.

[Int64]$Mean = $Formation | measure -Average | select -ExpandProperty Average

foreach ($Number in $Formation)
{
    # Since there are 
    if ($Number -lt $Mean)
    {
        $total += $mean - $Number
    }
}

Write-Host $Total

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0037138