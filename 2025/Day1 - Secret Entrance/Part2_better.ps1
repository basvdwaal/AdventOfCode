
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$instructions = $PuzzleInput -split ","

$pointer = 50
$total = 0

foreach ($instruction in $instructions)
{
    $Side = $Instruction[0]
    [int]$Steps = $Instruction[1..($Instruction.Length -1)] -join ""

       
    if ($Side -eq "R") # Rotate right
    {
        $pointer += $Steps
        while ($pointer -gt 100 )
        {
            $pointer = $pointer - 100
            $total++
        }
    }
    else # Rotate left
    {
        $pointer = $pointer - $Steps
        while ($pointer -lt 0 )
        {
            $pointer = 100 - [math]::Abs($pointer)
            $total++
        }
    }
    if ($pointer -eq 0) { $total++}
}

Write-host $total

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0393010