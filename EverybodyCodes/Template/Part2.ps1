
Set-StrictMode -Version latest

$PuzzleInput = (Get-Content $PSScriptRoot\sample2.txt)
# $PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions




# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"