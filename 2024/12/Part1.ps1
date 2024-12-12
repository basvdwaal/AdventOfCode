
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
                Boundaries = 0
                Visited = $false
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
# $Visited = @()

foreach ($Tile in $Grid.Values)
{
    if ($tile.Visited)
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
                    if ($NextTile.Visited)
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
                    $tile.Boundaries++
                }
            }
            else
            {
                # Write-Host "Outside region"
                $tile.Boundaries++
            }
        }
        $Tile.Visited = $true
    }

    $PlotID++
    
}

$TotalCost = 0
Foreach ($PlotID in $Plots.Keys)
{
    $Plot = $Plots[$PlotID]
    $TotalBoundaries = 0
    foreach ($Tile in $Plot) { $TotalBoundaries += $Tile.Boundaries }
    $TotalCost += $TotalBoundaries * $Plot.Count
    # Write-Host "$PlotID - $($TotalBoundaries * $Plot.Count)"
}

Write-Host "Total Cost: $TotalCost" 
# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:06.8849584