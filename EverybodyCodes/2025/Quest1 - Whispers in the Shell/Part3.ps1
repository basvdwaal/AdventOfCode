
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\input3.txt)

# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$Names = $PuzzleInput[0] -split ","
$Instructions = $PuzzleInput[2] -split ","

Write-Host "Starting name: $($Names[0])"
Foreach ($Instruction in $Instructions)
{
    [string]$Direction, $StepArr = $Instruction.ToCharArray()
    [int]$Steps = $StepArr -join ""

    if ($Direction -eq "R")
    {
        $Index = (0 + $Steps) % $Names.Length
        Write-Host "$Instruction - Swapping $($Names[0]) and $($names[$Index])"
        $Temp = $Names[0]
        $Names[0] = $Names[$Index]
        $Names[$Index] = $Temp
    }
    else 
    {
        $Index = 0 - $Steps
        while ($Index -lt 0)
        {
            # Simulate a full round past the array.
            $Index = $Index + $Names.length
        }
        
        Write-Host "$Instruction - Swapping $($Names[0]) and $($names[$Index])"
        $Temp = $Names[0]
        $Names[0] = $Names[$Index]
        $Names[$Index] = $Temp
        
    }
}
Write-Host "Current name on index 0 - $($names[0])"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0779569