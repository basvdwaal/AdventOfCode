
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions

function test-rotation ([string]$instruction, [int]$StartPos)
{
    $total = 0
    $pointer = $StartPos
    Write-host "instruction: $instruction"
    $Side = $Instruction[0]
    [int]$Steps = $Instruction[1..($Instruction.Length - 1)] -join ""

    
    if ($Side -eq "R") # Rotate right
    {
        $pointer += $Steps
        while ($pointer -gt 100 )
        {
            $pointer = $pointer - 100
            $total++
            # Write-host "Pointer passed 0!"
        }
    }
    else # Rotate left
    {
        $pointer = $pointer - $Steps
        while ($pointer -lt 0 )
        {
            if ($pointer -eq -100)
            {
                $pointer = 0
            }
            else
            {
                $pointer = 100 - [math]::Abs($pointer)
                $total++
                Write-host "Pointer passed 0!"
            }
        }
    }
    if ($pointer -eq 0) { $total++ }
    if ($pointer -eq 100) { $pointer = 0; $total++ }
    Write-host "Pointer: $pointer"
    Write-host "Total: $Total"

    Write-host "==========="
}

#Endregion Functions


$instructions = $PuzzleInput -split ","

$pointer = 50
$total = 0

foreach ($instruction in $instructions)
{
    # Write-host "instruction: $instruction"
    $Side = $Instruction[0]
    [int]$Steps = $Instruction[1..($Instruction.Length - 1)] -join ""

    
    if ($Side -eq "R") # Rotate right
    {
        $pointer += $Steps
        while ($pointer -gt 100 )
        {
            $pointer = $pointer - 100
            $total++
            # Write-host "Pointer passed 0!"
        }
    }
    else # Rotate left
    {
        if ($pointer -eq 0) {$total--} # We offset by 1 to fix the double counting
        $pointer = $pointer - $Steps
        while ($pointer -lt 0 )
        {
            $pointer = 100 - [math]::Abs($pointer)
            $total++
            # Write-host "Pointer passed 0!"
        }
    }
    if ($pointer -eq 0) { $total++ }
    if ($pointer -eq 100) { $pointer = 0; $total++ }
    # Write-host "Pointer: $pointer"
    # Write-host "Total: $Total"

    # Write-host "==========="
}

Write-host $total

<#
test-rotation -StartPos 50 -instruction "L50" # Should be 1
test-rotation -StartPos 0 -instruction "L100" # should be 1
test-rotation -StartPos 0 -instruction "R100" # should be 1
test-rotation -StartPos 0 -instruction "L650" # should be 7
#>

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0179364