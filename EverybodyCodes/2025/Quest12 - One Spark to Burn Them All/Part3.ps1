
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample3.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input3.txt)

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
    $PointsOfInterest = @{}
    
    $width = $TextLines[0].Length
    0..($width - 1) | ForEach-Object { $Grid[$_] = @{} }

    for ($y = 0; $y -lt $TextLines.Count; $y++)
    {
        $chars = $TextLines[$y].ToCharArray() 

        for ($x = 0; $x -lt $chars.Count; $x++)
        {
            $obj = [PSCustomObject]@{
                X    = $x
                Y    = $y
                Size = [int]$chars[$x] - 48 
            }

            $Grid[$x][$y] = $obj

            # GROUP THEM IMMEDIATELY
            if (-not $PointsOfInterest.ContainsKey($obj.Size))
            {
                $PointsOfInterest[$obj.Size] = [System.Collections.ArrayList]::new()
            }
            [void]$PointsOfInterest[$obj.Size].Add($obj)
        }
    }

    return $Grid, $PointsOfInterest
}

function Get-ImpactArea
{
    param (
        [Parameter(Mandatory)]
        [object[]]$StartTiles,

        [Parameter(Mandatory)]
        [hashtable]$Grid,

        # Optional: A list of tiles that are already destroyed/invalid
        [System.Collections.Generic.HashSet[object]]$IgnoreTiles
    )

    $Directions = @(
        [PSCustomObject]@{ X = 1; Y = 0 }, [PSCustomObject]@{ X = -1; Y = 0 },
        [PSCustomObject]@{ X = 0; Y = 1 }, [PSCustomObject]@{ X = 0; Y = -1 }
    )

    $Queue = New-Object System.Collections.Queue
    $Visited = New-Object System.Collections.Generic.HashSet[object]

    # Enqueue all starting points
    foreach ($start in $StartTiles)
    {
        $Queue.Enqueue($start)
        [void]$Visited.Add($start)
    }

    while ($Queue.Count -gt 0)
    {
        $Tile = $Queue.Dequeue()

        foreach ($Dir in $Directions)
        {
            if ($null -eq $Grid[$Tile.X + $Dir.X]) { continue }
    
            $NextTile = $Grid[$Tile.X + $Dir.X][$Tile.Y + $Dir.Y]

            # LOGIC CHECKS:
            # 1. Tile exists
            # 2. Logic: Next Size <= Current Size
            # 3. Has not been visited in THIS run
            # 4. Is not in the "Global Ignore List" (Already destroyed in previous passes)
            if ($NextTile -and 
                ($NextTile.Size -le $Tile.Size) -and 
                (-not $Visited.Contains($NextTile)))
            {
                # Check Ignore List (if provided)
                if ($null -ne $IgnoreTiles -and $IgnoreTiles.Contains($NextTile))
                {
                    continue 
                }

                [void]$Visited.Add($NextTile)
                $Queue.Enqueue($NextTile)
            }
        }
    }

    return $Visited
}

#Endregion Functions

$Grid, $TilesBySize = Convert-TextToGrid -TextLines $PuzzleInput

# We need to pick the 3 best starting locations
$ChosenStartTiles = @()

# This tracks everything destroyed so far across passes
$GlobalDestroyed = [System.Collections.Generic.HashSet[object]]::new()

# Optimization: Only look at high ground (Size 9)
$Candidates = $TilesBySize[9]
$Candidates += $TilesBySize[8]
$Candidates += $TilesBySize[7]
$Candidates += $TilesBySize[6]
$Candidates += $TilesBySize[5]
$Candidates += $TilesBySize[4]

Write-Host "Finding 3 best positions..." -ForegroundColor Cyan

for ($i = 1; $i -le 3; $i++)
{
    $BestCandidate = $null
    $BestCount = -1
    $BestPath = $null

    foreach ($StartNode in $Candidates)
    {
        # Skip if this candidate was already destroyed by a previous bomb
        if ($GlobalDestroyed.Contains($StartNode)) { continue }

        # Run Simulation passing the Global Ignore List
        $ImpactArea = Get-ImpactArea -StartTiles @($StartNode) -Grid $Grid -IgnoreTiles $GlobalDestroyed

        if ($ImpactArea.Count -gt $BestCount)
        {
            $BestCount = $ImpactArea.Count
            $BestCandidate = $StartNode
            $BestPath = $ImpactArea
        }
    }

    Write-Host "  Pass $i Winner: [$($BestCandidate.X), $($BestCandidate.Y)] destroying $BestCount tiles" -ForegroundColor Green
    
    $ChosenStartTiles += $BestCandidate
    
    # Add the destruction to the global list so the next pass avoids these tiles
    foreach ($tile in $BestPath)
    {
        [void]$GlobalDestroyed.Add($tile)
    }
}

# ======================================================================
# 3. FINAL CALCULATION
# ======================================================================

Write-Host "`nIgniting all three barrels..." -ForegroundColor Yellow

# Now we run the simulation with ALL 3 inputs at once.
# IMPORTANT: We do NOT pass $IgnoreTiles here. We want the full combined destruction
# on the original grid (which we never modified!).
$FinalDestruction = Get-ImpactArea -StartTiles $ChosenStartTiles -Grid $Grid

Write-Host "Total Unique Tiles Destroyed: $($FinalDestruction.Count)" -ForegroundColor Cyan

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:12:52.9700753