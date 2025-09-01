
Set-StrictMode -Version latest

$ErrorActionPreference = 'break'

$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)

# ======================================================================
# ======================================================================

#region Functions
function Convert-TextToGrid {
    param (
        [string[]]$TextLines
    )

    # Resultaat grid
    $Grid = @{}

    for ($y = 0; $y -lt $TextLines.Count; $y++) {
        $line = $TextLines[$y]
        for ($x = 0; $x -lt $line.Length; $x++) {
            $Value = $line[$x]
            $obj = [PSCustomObject]@{
                X        = $x
                Y        = $y
                Value    = $Value
                IsNumber = $Value -match "\d" ? $true : $false
            }
            $Grid["$x,$y"] = $obj
        }
    }

    $Script:GridWidth = $line.Length
    $Script:GridHeight = $TextLines.Count

    return $Grid
}

function Write-GridToScreen {
    param (
        [hashtable]$Grid
    )

    Clear-Host
    $arr = New-Object System.Collections.ArrayList
    [void]$arr.Add("")
    for ($Y = 0; $Y -lt $script:GridHeight; $Y++)
    {
        
        for ($X = 0; $X -le $Script:GridWidth; $X++)
        {
            $pos = $Grid["$x,$y"]

            if ($pos)
            {
                [void]$arr.Add($pos.Value)
            }
        }
        [void]$arr.Add("`r`n")
    }
    Write-Host $arr
}


#Endregion Functions

$Directions = @(
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y =  0},
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y =  0},
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y =  1},
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y =  -1},
    [PSCustomObject]@{ Direction = "TopRight"; X = 1; Y =  1},
    [PSCustomObject]@{ Direction = "TopLeft"; X = -1; Y =  1},
    [PSCustomObject]@{ Direction = "BottomRight"; X = 1; Y =  -1},
    [PSCustomObject]@{ Direction = "BottomLeft"; X = -1; Y =  -1}
)

$SymbolList = ("*", "/", "+", "&", "#", "@", "%", "!", "=", "(", ")", "_")
$Total = 0

$grid = Convert-TextToGrid -TextLines $PuzzleInput
$SkipRestOfNumber = $false

foreach ($node in ($grid.Values | sort x, y))
{
    if ($SkipRestOfNumber)
    {
        # Number already counted, skip untill next empty space
        if ($node.IsNumber) { continue } else {$SkipRestOfNumber = $false}
    }

    # Find next number
    if (! $node.IsNumber) { continue } 

    $NumberNodes = @($node)
    While ($true)
    {
        $Node = $Grid["$($node.X + 1),$($node.Y)"]
        if (! $node.IsNumber) { break }

        $NumberNodes += $node
    }

    :Nodeloop
    foreach ($node in $NumberNodes) 
    {
        foreach ($Direction in $Directions)
        {
            $PointToCheck = $Grid["$($node.X + $Direction.X),$($node.Y + $Direction.Y)"]
            if (! $PointToCheck) {continue}

            if ($PointToCheck.Value -in $SymbolList)
            {
                Write-Host "Number starting with $($node.Value) at ($($node.X),$($node.y)) is valid"
                $number = [int]::Parse($NumberNodes.Value -join "")
                $Total += $number
                Write-Host "Adding $number to total"

                $SkipRestOfNumber = $true
                break Nodeloop
            }
        }

        Write-Host "Number $($node.Value) at ($($node.X),$($node.y)) does NOT have a symbol adjacent" -ForegroundColor Yellow
    }
}

Write-Host $Total




# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"