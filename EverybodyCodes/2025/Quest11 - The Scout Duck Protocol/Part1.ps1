
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

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
        $SourceColumn = $Formation[$i]
        $TargetColumn = $Formation[$i + 1]

        if ($TargetColumn -lt $SourceColumn)
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
        $SourceColumn = $Formation[$i]
        $TargetColumn = $Formation[$i + 1]

        if ($TargetColumn -gt $SourceColumn)
        {
            $Formation[$i]++
            $Formation[$i + 1]--
            $hasmoved = $true
        }
    }

    if ($hasmoved -eq $true)
    {
        $Rounds++
        if ($Rounds -eq 10)
        {
            $checksum = Get-FormationChecksum -Formation $Formation
            Write-Host $checksum
            break
        }
    }
}
While ($hasmoved -eq $true)

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0061261