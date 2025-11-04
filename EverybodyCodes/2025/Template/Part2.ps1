
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
# $PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions




# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"