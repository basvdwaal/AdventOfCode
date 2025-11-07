
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample2.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$Numbers = $PuzzleInput -split "," | foreach {[int]$_}
$Sorted = $Numbers  | select -Unique |Sort-Object -Descending| select -Last 20


write-host ($Sorted |Measure-Object -Sum).Sum


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"