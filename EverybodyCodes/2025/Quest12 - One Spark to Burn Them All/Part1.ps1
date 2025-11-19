
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================


#region Functions
function Convert-TextToGrid
{
    param (
        [string[]]$TextLines
    )

    $Grid = @{}
    
    $width = $TextLines[0].Length
    0..($width - 1) | ForEach-Object { $Grid[$_] = @{} }

    for ($y = 0; $y -lt $TextLines.Count; $y++)
    {
        $chars = $TextLines[$y].ToCharArray() 

        for ($x = 0; $x -lt $chars.Count; $x++)
        {
            $Grid[$x][$y] = [PSCustomObject]@{
                X    = $x
                Y    = $y
                Size = [int]$chars[$x] - 48 
            }
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

$Grid = Convert-TextToGrid -TextLines $PuzzleInput

$Queue = New-Object System.Collections.Queue

# Add top left corner as start point
$Queue.Enqueue($Grid[0][0])
$VisitedTiles = New-Object System.Collections.Generic.HashSet[object]
$VisitedTiles.Add($Grid[0][0]) | Out-Null

while ($Queue.Count -gt 0)
{
    $Tile = $Queue.Dequeue()

    foreach ($Direction in $Directions)
    {
        # check if Outside grid
        if ($null -eq $Grid[$Tile.X + $Direction.X]) { continue }

        $NextTile = $Grid[$Tile.X + $Direction.X][$Tile.Y + $Direction.Y]

        if ($NextTile -and ($NextTile.Size -le $Tile.Size)) 
        {
            if ($VisitedTiles.Add($NextTile)) 
            {
                $Queue.Enqueue($NextTile)
            }
        }
    }
}

Write-Host $VisitedTiles.Count
# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"