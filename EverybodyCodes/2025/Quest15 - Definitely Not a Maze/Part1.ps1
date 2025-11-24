
Set-StrictMode -Version latest

$PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
# $PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions

function Get-NextDirection ([pscustomobject]$CurrentDirection, [string]$Side)
{
    $DirIndex = $Directions.IndexOf($CurrentDirection)
    
    if ($Side -eq [char]"R")
    {
        $NextDirIndex = $DirIndex + 1
        return $Directions[$NextDirIndex % $Directions.Length]  # wrap around array if we overshoot it.
    }
    elseif ($side -eq [char]"L")
    {
        $NextDirIndex = $DirIndex - 1
        if ($NextDirIndex -eq -1)
        {
            return $Directions[($Directions.Length - 1)]
        }
        else
        {
            return $Directions[$NextDirIndex]
        }
    }
}

function Add-TileToGrid ([hashtable]$grid, [Int32]$X, [int32]$Y, [string]$Value = "#")
{
    # Add new row if it doesnt exist yet
    if (! $grid.Item($X)) { $Grid[$X] = @{} }

    $grid[$X][$Y] = [PSCustomObject]@{
        X = $X
        Y = $Y
        Value = $Value
        Steps = 0
    }

    return $grid
}


#Endregion Functions


$script:Directions = @(
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y =  -1},
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y =  0},
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y =  1},
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y =  0}
)
$Instructions = $PuzzleInput -split ","

# Define grid with Starttile
$Grid = @{}

# Start facing up on tile 0,0
$Direction = $Directions[0]
$TileX = 0
$TileY = 0

$grid = Add-TileToGrid -grid $grid -X $TileX -Y $TileY -Value "S"

foreach ($Instruction in $Instructions)
{
    $Side, [int]$Steps = $Instruction.ToCharArray()

    # Char to int gets the wrong number.
    $Steps -= 48 
    
    $Direction = Get-NextDirection -CurrentDirection $Direction -Side $Side
    
    for ($i = 1; $i -le $Steps; $i++)
    {
        $TileX = $TileX + $Direction.X
        $TileY = $TileY + $Direction.Y
        
        $grid = Add-TileToGrid -grid $Grid -X $TileX -Y $TileY
    }
}

# Set last segment as the end
$Grid[$TileX][$TileY].Value = "E"

# BFS for shortest path
$Queue = New-Object System.Collections.Queue
$Queue.Enqueue($Grid[0][0])

$Visited = New-Object System.Collections.Generic.HashSet[pscustomobject]
[void]$Visited.Add($Grid[0][0])

while ($Queue.Count -gt 0)
{
    $Tile = $Queue.Dequeue()
    if ($Tile.Value -eq "E")
    {
        Write-host "Steps from S to E: $($Tile.Steps)"
        break
    }

    foreach ($Direction in $Directions)
    {
        if (! $Grid[$Tile.X + $Direction.X]) { continue }

        $NextTile = $Grid[$Tile.X + $Direction.X][$Tile.Y + $Direction.Y]
        if (! $NextTile) { continue }
        
        if (-not $Visited.Contains($NextTile))
        {
            $NextTile.Steps = $Tile.Steps + 1
            $Queue.Enqueue($NextTile)
            [void]$Visited.Add($NextTile)
        }
    }
}






# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"