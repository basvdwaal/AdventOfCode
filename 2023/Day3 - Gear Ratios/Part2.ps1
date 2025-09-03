
Set-StrictMode -Version latest

$ErrorActionPreference = 'break'

$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\input.txt)

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

$Total = 0

$grid = Convert-TextToGrid -TextLines $PuzzleInput



foreach ($node in ($grid.Values | sort y, x))
{
    # Find next possible gear
    if ($node.Value -ne "*") { continue } 

    # Find numbers around gear
    $NumbersArr = @()
    $CheckedNodes = @()
    foreach ($Direction in $Directions)
    {
        $TargetNode = $Grid["$($node.X + $Direction.X),$($node.Y + $Direction.Y)"]
        
        # Skip OoB nodes
        if (! $TargetNode) { continue }

        # Skip nodes without a number 
        if (! $TargetNode.IsNumber) { continue }

        # Skip already parsed nodes
        if ($TargetNode -in $CheckedNodes) { continue }


        # Find other nodes belonging to this number -> right side
        $NumberNodes = @($TargetNode)

        $NNode = $Grid["$($TargetNode.X),$($TargetNode.Y)"]
        While ($true)
        {
            $NNode = $Grid["$($NNode.X + 1),$($NNode.Y)"]
            if (-not $NNode -or -not $NNode.IsNumber) { break }

            $NumberNodes += $NNode
        }

        # Same for left side
        $NNode = $Grid["$($TargetNode.X),$($TargetNode.Y)"]
        While ($true)
        {
            $NNode = $Grid["$($NNode.X - 1),$($NNode.Y)"]
            if (-not $NNode -or -not $NNode.IsNumber) { break }

            $NumberNodes += $NNode
        }

        $NumbersArr += ,$NumberNodes
        $CheckedNodes += $NumberNodes
    }

    # Case: Not enough numbers
    if ($NumbersArr.Count -lt 2) { continue }

    # Case: too many numbers 
    if ($NumbersArr.Count -gt 2) { continue}

    $number1 = [int]::Parse( ($NumbersArr[0] | sort -Property 'x' | select -ExpandProperty Value) -join "")
    $number2 = [int]::Parse( ($NumbersArr[1] | sort -Property 'x' | select -ExpandProperty Value) -join "")
    
    $Total += $number1 * $number2
}  
    <#
    
    # Check if number has been parsed before
    if ($node -in $CheckedNodes) { continue }

    # Find other nodes belonging to this number
    $NumberNodes = @($node)
    While ($true)
    {
        $Node = $Grid["$($node.X + 1),$($node.Y)"]
        if (-not $node -or -not $node.IsNumber) { break }

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
                # Write-Host "Number starting with $($node.Value) at ($($node.X),$($node.y)) is valid"
                $number = [int]::Parse($NumberNodes.Value -join "")
                $Total += $number
                # Write-Host "Adding $number to total"

                break Nodeloop
            }
        }

        # Write-Host "Number $($node.Value) at ($($node.X),$($node.y)) does NOT have a symbol adjacent" -ForegroundColor Yellow
    }

    $CheckedNodes += $NumberNodes
    #>

Write-Host $Total




# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:01.1064311