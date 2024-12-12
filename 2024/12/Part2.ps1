
Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

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
            $letter = $line[$x]
            $obj = [PSCustomObject]@{
                X      = $x
                Y      = $y
                Letter = $letter
                Boundaries = @()
                $corner = $false
            }
            $Grid["$x,$y"] = $obj
        }
    }

    return $Grid
}

#Endregion Functions

$Directions = @(
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y =  0},
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y =  0},
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y =  -1},
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y =  1}
)

$Grid = Convert-TextToGrid -TextLines $PuzzleInput
$Plots = @{}
$PlotID = 0
$Visited = @()

foreach ($Tile in $Grid.Values)
{
    if ($tile -in $Visited)
    {
        continue
    }
    
    $Queue = New-Object System.Collections.Queue
    $Queue.Enqueue($Tile)
    
    $Plots[$PlotID] = @()
    $Plots[$PlotID] += $Tile
    While ($Queue.Count -gt 0)
    {
        $Tile = $Queue.Dequeue()

        # Write-Host "Tile: ($($Tile.X),$($tile.y))"
        
        foreach ($Direction in $Directions)
        {
            # Write-Host "Checking $($Direction.Direction).."
            
            $NextTile = $Grid["$($Tile.X + $Direction.X),$($Tile.Y + $Direction.Y)"]
            if ($NextTile)
            {
                if ($NextTile.Letter -eq $Tile.Letter)
                {
                    if ($Visited -contains $NextTile)
                    {
                        # Write-Host "Tile ($($NextTile.X),$($NextTile.y)) already visited"
                        continue
                    }
                    
                    # Part of same plot
                    if (! ($Plots[$PlotID] -contains $NextTile))
                    {
                        # Write-Host "Found tile of same type ($($NextTile.X),$($NextTile.y))"
                        $Plots[$PlotID] += $NextTile
                        $Queue.Enqueue($NextTile)
                    }
                }
                else
                {
                    # Write-Host "Tile ($($NextTile.X),$($NextTile.y)) is a different type."
                    $tile.Boundaries += $Direction
                }
            }
            else
            {
                # Write-Host "Outside region"
                $tile.Boundaries += $Direction
            }
        }
        $Visited += $Tile
    }

    $PlotID++
    
}


$Directions = @(
    [PSCustomObject]@{ Direction = "TopRight"; X = 1; Y =  1},
    [PSCustomObject]@{ Direction = "TopLeft"; X = -1; Y =  1},
    [PSCustomObject]@{ Direction = "BottomRight"; X = 1; Y =  -1},
    [PSCustomObject]@{ Direction = "BottomLeft"; X = -1; Y =  -1}
)


$TotalCost = 0
Foreach ($PlotID in $Plots.Keys)
{
    $Plot = $Plots[$PlotID]
    $TotalBoundaries = 0
    foreach ($Tile in $Plot)
    {
        $TopRightTile = $Grid["$($Tile.X + 1),$($Tile.Y + 1)"]
        $TopLeftTile = $Grid["$($Tile.X - 1),$($Tile.Y + 1)"]
        $BottomRightTile = $Grid["$($Tile.X + 1),$($Tile.Y - 1)"]
        $BottomLeftTile = $Grid["$($Tile.X - 1),$($Tile.Y - 1)"]
        
        
        # Topright inner corner
        if ($TopRightTile.Letter -ne $Tile.Letter -and ($TopLeftTile.Letter -eq $Tile.Letter -or $BottomRightTile.Letter -eq $Tile.Letter))
        {
            $Tile.Corner = $true
        }
        # Topleft inner corner
        elseif ($TopLeftTile.Letter -ne $Tile.Letter -and ($TopRightTile.Letter -eq $Tile.Letter -or $BottomLeftTile.Letter -eq $Tile.Letter))
        {
            $Tile.Corner = $true
        }
        # Bottomright inner corner
        elseif ($BottomRightTile.Letter -ne $Tile.Letter -and ($BottomLeftTile.Letter -eq $Tile.Letter -or $TopRightTile.Letter -eq $Tile.Letter))
        {
            $Tile.Corner = $true
        }
        # Topleft inner corner
        elseif ($TopLeftTile.Letter -ne $Tile.Letter -and ($TopRightTile.Letter -eq $Tile.Letter -or $BottomLeftTile.Letter -eq $Tile.Letter))
        {
            $Tile.Corner = $true
        }
        # Topright outer corner
        elseif ($TopRightTile.Letter -ne $Tile.Letter -and ($TopLeftTile.Letter -eq $Tile.Letter -or $BottomRightTile.Letter -eq $Tile.Letter))
        {
            $Tile.Corner = $true
        }
        # Topleft inner corner
        elseif ($TopLeftTile.Letter -ne $Tile.Letter -and ($TopRightTile.Letter -eq $Tile.Letter -or $BottomLeftTile.Letter -eq $Tile.Letter))
        {
            $Tile.Corner = $true
        }
        # Bottomright inner corner
        elseif ($BottomRightTile.Letter -ne $Tile.Letter -and ($BottomLeftTile.Letter -eq $Tile.Letter -or $TopRightTile.Letter -eq $Tile.Letter))
        {
            $Tile.Corner = $true
        }
        # Topleft inner corner
        elseif ($TopLeftTile.Letter -ne $Tile.Letter -and ($TopRightTile.Letter -eq $Tile.Letter -or $BottomLeftTile.Letter -eq $Tile.Letter))
        {
            $Tile.Corner = $true
        }



        
    
    
    }



    $TotalCost += $TotalBoundaries * $Plot.Count
    # Write-Host "$PlotID - $($TotalBoundaries * $Plot.Count)"
}

Write-Host "Total Cost: $TotalCost" 
# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"