
Set-StrictMode -Version latest

$PuzzleInput = (Get-Content $PSScriptRoot\sample3.txt)
# $PuzzleInput = (Get-Content $PSScriptRoot\Input3.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions




# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"