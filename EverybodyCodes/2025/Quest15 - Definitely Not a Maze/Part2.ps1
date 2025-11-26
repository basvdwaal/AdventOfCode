
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample2.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

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

function Get-GridBounds {
    param (
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$Grid
    )

    # Initialize variables to opposite extremes
    $minX = [int]::MaxValue
    $maxX = [int]::MinValue
    $minY = [int]::MaxValue
    $maxY = [int]::MinValue
    $hasPoints = $false

    # Iterate through the grid
    foreach ($xKey in $Grid.Keys) {
        # Cast to int to ensure numeric comparison (handles string keys like "10")
        $x = [int]$xKey

        if ($x -lt $minX) { $minX = $x }
        if ($x -gt $maxX) { $maxX = $x }

        # Check inner Y keys
        if ($null -ne $Grid[$xKey]) {
            foreach ($yKey in $Grid[$xKey].Keys) {
                $hasPoints = $true
                $y = [int]$yKey

                if ($y -lt $minY) { $minY = $y }
                if ($y -gt $maxY) { $maxY = $y }
            }
        }
    }

    # If the grid was empty, return nothing
    if (-not $hasPoints) {
        Write-Warning "Grid is empty."
        return $null
    }

    # Return a clean Custom Object
    return [PSCustomObject]@{
        MinX   = $minX
        MaxX   = $maxX
        MinY   = $minY
        MaxY   = $maxY
        # Calculate dimensions automatically (Absolute distance + 1)
        Width  = ($maxX - $minX) + 1
        Height = ($maxY - $minY) + 1
    }
}

function Write-GridToScreen
{
    param (
        [hashtable]$Grid
    )

    $arr = New-Object System.Collections.ArrayList
    [void]$arr.Add("")
    for ($Y = 0; $Y -lt $GridBounds.Height; $Y++)
    {
        for ($X = 0; $X -le $GridBounds.Width; $X++)
        {
            if (! $Grid[$x])
            {
                [void]$arr.Add(".")
                continue
            }

            $pos = $Grid[$x][$y]
            if ($pos)
            {
                [void]$arr.Add($pos.Value)
            }
            else
            {
                [void]$arr.Add(".")
            }
        }
        [void]$arr.Add("`r`n")
    }
    Write-Host $arr
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
    $Side = $Instruction[0]
    [int]$Steps = $Instruction[1..($Instruction.Length -1)] -join ""
    
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

$GridBounds = Get-GridBounds -Grid $Grid

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

        $Nx = $Tile.X + $Direction.X
        $Ny = $Tile.Y + $Direction.Y

        $NextTile = $Grid[$Nx][$Ny]


        if (! $NextTile)
        {
            # Check if within bounds of grid. If yes -> empty space. If no -> skip.
            if ($Nx -ge $GridBounds.MinX -and $Nx -le $GridBounds.MaxX -and
                $Ny -ge $GridBounds.MinY -and $Ny -le $GridBounds.MaxY
            )
            {
                $NextTile = [PSCustomObject]@{
                    X = $Nx
                    Y = $Ny
                    Value = "."
                    Steps = $Tile.Steps
                }
                $Grid[$Nx][$Ny] = $NextTile
            }
            else
            {
                # Outside grid, skip
                continue
            }
        }
        elseif ($NextTile.Value -eq "#") { continue }

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