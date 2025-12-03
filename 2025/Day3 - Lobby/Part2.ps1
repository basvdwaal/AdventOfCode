
Set-StrictMode -Version latest

$PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
# $PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions




# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"