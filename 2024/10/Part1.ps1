
Set-StrictMode -Version latest
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
            if ($line[$x] -eq ".")
            {
                $Height = "."
            }
            else
            {
                $Height = [int]::Parse($line[$x])
            }
            $obj = [PSCustomObject]@{
                X      = $x
                Y      = $y
                Height = $Height
            }
            $Grid["$x,$y"] = $obj
        }
    }

    return $Grid
}


#Endregion Functions

$Directions = @(
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y = 0 },
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y = 0 },
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y = 1 },
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y = -1 }
)

$script:Grid = Convert-TextToGrid -TextLines $PuzzleInput
$Script:TotalScore = 0

$Queue = New-Object System.Collections.Queue

foreach ($Tile in $Grid.Values)
{
    # Find trailheads
    if ($Tile.Height -eq 0)
    {

        $Queue.Enqueue($Tile)
        $VisitedTiles = New-Object System.Collections.ArrayList
        while ($Queue.Count -gt 0)
        {
            $Tile = $Queue.Dequeue()

            if ($Tile -in $VisitedTiles)
            {
                continue
            }
            else
            {
                $VisitedTiles.Add($Tile) | Out-Null
            }

            if ($Tile.Height -eq 9)
            {
                # Write-Host "Trail end found at: ($($Tile.X),$($Tile.Y)) with height $($Tile.Height)"
                $Script:TotalScore++
                $script:Trailheadscore++
                # Write-Host "New total: $script:TotalScore"
                continue
            }

            foreach ($Direction in $Directions)
            {
                $NextTile = $Grid["$($Tile.X + $Direction.X),$($($Tile.Y + $Direction.Y))"]

                if ($NextTile -and $NextTile -notin $VisitedTiles -and ($NextTile.Height -eq $Tile.Height + 1))
                {
                    $Queue.Enqueue($NextTile)
                }
            }
        }
    }
}

Write-Host "Total Score: $TotalScore"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"