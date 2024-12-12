
Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions
function Convert-TextToGrid
{
    param (
        [string[]]$TextLines
    )

    # Resultaat grid
    $Grid = @{}

    for ($y = 0; $y -lt $TextLines.Count; $y++)
    {
        $line = $TextLines[$y]
        for ($x = 0; $x -lt $line.Length; $x++)
        {
            $letter = $line[$x]
            $obj = [PSCustomObject]@{
                X          = $x
                Y          = $y
                Letter     = $letter
                Visited    = $false
            }
            $Grid["$x,$y"] = $obj
        }
    }

    return $Grid
}


function Count-Corners
{
    param (
        $Tile
    )

    if ($Grid["$($Tile.X + 1),$($Tile.Y - 1)"]) { $TopRightTile = $Grid["$($Tile.X + 1),$($Tile.Y - 1)"].Letter }    else { $TopRightTile = "" }
    if ($Grid["$($Tile.X - 1),$($Tile.Y - 1)"]) { $TopLeftTile = $Grid["$($Tile.X - 1),$($Tile.Y - 1)"].Letter }     else { $TopLeftTile = "" }
    if ($Grid["$($Tile.X + 1),$($Tile.Y + 1)"]) { $BottomRightTile = $Grid["$($Tile.X + 1),$($Tile.Y + 1)"].Letter } else { $BottomRightTile = "" }
    if ($Grid["$($Tile.X - 1),$($Tile.Y + 1)"]) { $BottomLeftTile = $Grid["$($Tile.X - 1),$($Tile.Y + 1)"].Letter }  else { $BottomLeftTile = "" }
    if ($Grid["$($Tile.X + 1),$($Tile.Y)"])     { $RightTile = $Grid["$($Tile.X + 1),$($Tile.Y)"].Letter }           else { $RightTile = "" }
    if ($Grid["$($Tile.X - 1),$($Tile.Y)"])     { $LeftTile = $Grid["$($Tile.X - 1),$($Tile.Y)"].Letter }            else { $LeftTile = "" }
    if ($Grid["$($Tile.X),$($Tile.Y - 1)"])     { $TopTile = $Grid["$($Tile.X),$($Tile.Y - 1)"].Letter }             else { $TopTile = "" }
    if ($Grid["$($Tile.X),$($Tile.Y + 1)"])     { $BottomTile = $Grid["$($Tile.X),$($Tile.Y + 1)"].Letter }          else { $BottomTile = "" }

    $CornerCount = 0

    if ($Tile.X -eq 3 -and $tile.Y -eq 2)
    {
        "" | Out-Null
    }


    # Inner corners
    if ($TopRightTile -ne $Tile.Letter -and $TopTile -eq $Tile.Letter -and $RightTile -eq $Tile.Letter)
    {
        $CornerCount++
    }
    if ($TopLeftTile -ne $Tile.Letter -and $TopTile -eq $Tile.Letter -and $LeftTile -eq $Tile.Letter)
    {
        $CornerCount++
    }
    if ($BottomRightTile -ne $Tile.Letter -and $BottomTile -eq $Tile.Letter -and $RightTile -eq $Tile.Letter)
    {
        $CornerCount++
    }
    if ($BottomLeftTile -ne $Tile.Letter -and $BottomTile -eq $Tile.Letter -and $LeftTile -eq $Tile.Letter)
    {
        $CornerCount++
    }

    # Outer Corners
    if ($TopTile -ne $Tile.Letter -and $RightTile -ne $Tile.Letter)
    {
        $CornerCount++
    }
    if ($TopTile -ne $Tile.Letter -and $LeftTile -ne $Tile.Letter)
    {
        $CornerCount++
    }
    if ($BottomTile -ne $Tile.Letter -and $RightTile -ne $Tile.Letter)
    {
        $CornerCount++
    }
    if ($BottomTile -ne $Tile.Letter -and $LeftTile -ne $Tile.Letter)
    {
        $CornerCount++
    }

    return $CornerCount
}


#Endregion Functions

$Directions = @(
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y = 0 },
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y = 0 },
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y = -1 },
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y = 1 }
)

$Grid = Convert-TextToGrid -TextLines $PuzzleInput
$Plots = @{}
$PlotID = 0
$Corners = @{}

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
            }
        }

        If ($Corners[$PlotID])
        {
            $Corners[$PlotID] += Count-Corners -Tile $Tile
        }
        else
        {
            $Corners[$PlotID] = Count-Corners -Tile $Tile   
        }

        $Tile.Visited = $true
    }
    $PlotID++
}

# Write-Host "Corners:"
# $Corners
# Write-Host ""
# Write-Host "Plots:"
# $Plots

$TotalCost = 0
Foreach ($PlotID in $Plots.Keys)
{
    $TotalCost += $Corners[$PlotID] * $Plots[$PlotID].Count
}

Write-Host "Total Cost: $TotalCost" 
# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:01.7874646