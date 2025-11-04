
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$Names = $PuzzleInput[0] -split ","
$Instructions = $PuzzleInput[2] -split ","


$CurrIndex = 0
Write-Host "Starting name: $($Names[0])"
Foreach ($Instruction in $Instructions)
{
    [string]$Direction, $StepArr = $Instruction.ToCharArray()
    [int]$Steps = $StepArr -join ""
    if ($Direction -eq "R")
    {
        $CurrIndex = ($CurrIndex + $Steps) % $Names.Length
    }
    else 
    {
        $CurrIndex = $CurrIndex - $Steps
        if ($CurrIndex -lt 0) {$CurrIndex = $Names.length + $CurrIndex}
    }
    Write-Host "Current Name after $Instruction - $($names[$CurrIndex])"
}

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0471365