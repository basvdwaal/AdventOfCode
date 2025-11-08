
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample2.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions

function Get-GearRatio ([array]$Gears)
{

    $Ratio = 0
    for ($Index = 0; $Index -lt ($Gears.Count -1 ); $Index++) 
    {
        $Gear1 = $Gears[$Index]
        $Gear2 = $Gears[$Index + 1]

        if (! $Ratio)
        {
            $Ratio = $Gear1 / $Gear2
        }
        else
        {
            $Ratio *= $Gear1 / $Gear2
        }
    }

    return $Ratio
}

#Endregion Functions

$Rotations = 10000000000000
$Ratio = Get-GearRatio -Gears $PuzzleInput

Write-Host ([math]::Ceiling($Rotations / $Ratio))

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"