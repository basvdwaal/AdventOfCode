
Set-StrictMode -Version latest

$PuzzleInput = (Get-Content $PSScriptRoot\sample3.txt)
# $PuzzleInput = (Get-Content $PSScriptRoot\Input3.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions

function Measure-ArrayLengthIterative
{
    param (
        [Parameter(Mandatory)]
        [int[]]$Instructions,

        [Parameter(Mandatory)]
        [long]$NumberOfBlocks
    )

    $CurrentBlocks = 0
    $index = 0

    # We loop until we hit or exceed the max increments
    while ($CurrentBlocks -lt $NumberOfBlocks)
    {
        # Convert 0-based index to 1-based position for modulo math
        # Index 0 = Pos 1, Index 1 = Pos 2, etc.
        $position = $index + 1
        
        # Check every instruction
        foreach ($inst in $Instructions)
        {
            if ($position % $inst -eq 0)
            {
                $CurrentBlocks++
            }
        }

        # If we haven't exceeded the limit, move to next index
        if ($CurrentBlocks -lt $NumberOfBlocks)
        {
            $index++
        }
    }
    return ($index + 1), $CurrentBlocks
}

function Get-BlocksNeeded
{
    param (
        [Parameter(Mandatory)]
        [int[]]$Instructions,

        [Parameter(Mandatory)]
        [int]$length
    )

    $CurrentBlocks = 0

    foreach ($i in $Instructions)
    {
        $CurrentBlocks += [math]::Floor($length / $i)
    }

    return $CurrentBlocks
}


#Endregion Functions


# Calculate spell
$list = [int[]]0
$list += [int[]]($PuzzleInput -split ",") 
$Instructions = @()

for ($i = 0; $i -lt $list.Count; $i++)
{
    if ($list[$i] -gt 0)
    {
        $Instructions += $I
        for ($j = 0; $j -lt $list.Count; $j++)
        {
            # Subtract one every $i ste
            if ($j % $i -eq 0)
            {
                $list[$j]--
            }
        }
    }
    elseif ($list[$i] -lt 0)
    {
        Write-Host "Logic error found: $i is below 0!"
        break
    }
}

Write-Host "Spell: $($Instructions -join ',')"


$Length, $BlocksUsed = Measure-ArrayLengthIterative -Instructions $Instructions -NumberOfBlocks 100000000

# for ($Blocks = 1; $Blocks -le 1000000000; $Blocks *= 10)
# {
#     $Length, $BlocksUsed = Measure-ArrayLengthIterative -Instructions $Instructions -NumberOfBlocks $Blocks

#     Write-Host "Blocks in Wall with $blocks blocks: - $length"
# }

Write-Host "Length of Wall with $blocks blocks: - $length"
# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"