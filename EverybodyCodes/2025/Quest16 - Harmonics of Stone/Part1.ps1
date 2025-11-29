
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$Instructions = [int[]]($PuzzleInput -split ",")

$WallLength = 90

$list = New-Object int[] ($WallLength)

foreach ($Number in $Instructions)
{
    for ($i = $Number; $i -le $list.Length; $i += $Number) 
    {
        $list[($i -1)]++
    }
}

Write-Host ($list | measure -Sum).Sum

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0005535