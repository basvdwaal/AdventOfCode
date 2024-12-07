
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================


#region Functions
function Convert-TextToGrid {
    param (
        [string[]]$TextLines
    )

    $Grid = @{}

    for ($y = 0; $y -lt $TextLines.Count; $y++) {
        $line = $TextLines[$y]
        for ($x = 0; $x -lt $line.Length; $x++) {
            $obj = [PSCustomObject]@{
                X      = $x
                Y      = $y
                Letter = $line[$x]
            }
            $Grid["$x,$y"] = $obj
        }
    }

    $GridWidth = $line.Length
    $gridHeight = $TextLines.Count

    # Return Width and Height -1 so they match the coords of the last item
    return $grid, ($GridWidth - 1), ($gridHeight - 1)
}

function Get-NewDirection {
    param
    (
        [PSCustomObject]
        $CurrentDirection
    )

    $CurrentIndex = $Directions.IndexOf($CurrentDirection)
    $NewIndex = $CurrentIndex + 1

    # If NewIndex is out of bonds, we manually 'overflow'
    if ($NewIndex -lt 4)
    {
        Return $Directions[$NewIndex]
    }
    else
    {
        Return $Directions[0]
    }
}

function Write-GridToScreen {
    param (
        [hashtable]$Grid,
        [PSCustomObject]$CurrentPos,
        [PSCustomObject]$Direction
    )

    $Gridsize = 20

    Clear-Host
    for ($Y = $CurrentPos.Y - ($Gridsize/2); $Y -le ($CurrentPos.Y + ($Gridsize/2)); $Y++)
    {
        $arr = New-Object System.Collections.ArrayList       
        for ($X = $CurrentPos.X - ($Gridsize/2); $X -le ($CurrentPos.X + ($Gridsize/2)); $X++)
        {
            $pos = $Grid["$x,$y"]
            
            if ($pos)
            {
                $arr.Add($pos.Letter) | Out-Null
            }
        }
        Write-Host $arr
    }

    # Start-Sleep -Milliseconds 50
}

function Move-AlongPath {
    param
    (
        $Grid,
        $StartPos,
        $Direction
    )

    $WalkedTiles = @{}
    $CurrentPos = [PSCustomObject]@{X = $StartPos.X; Y =  $StartPos.Y; Direction = $Direction.Direction}
    # $WalkedTiles.Add("$($CurrentPos.X),$($CurrentPos.Y)",$CurrentPos)

    While ($CurrentPos.X -gt $LeftBoundary -and $CurrentPos.X -lt $RightBoundary -and $CurrentPos.Y -gt $TopBoundary -and $CurrentPos.y -lt $LowerBoundary)
    {
        try
        {
            $NewPos = [PSCustomObject]@{X = $CurrentPos.X + $Direction.X; Y = $CurrentPos.Y + $Direction.Y; Direction = $Direction.Direction}

            # Check for obstacle at new position
            if ($Grid["$($NewPos.X),$($NewPos.Y)"].Letter -eq '#')
            {
                $Direction = Get-NewDirection -CurrentDirection $Direction
            }
            else
            {   
                # $Grid["$($CurrentPos.X),$($CurrentPos.Y)"] = [PSCustomObject]@{X = $CurrentPos.X;Y = $CurrentPos.Y; Letter = '.' }
                # $Grid["$($NewPos.X),$($NewPos.Y)"] = [PSCustomObject]@{X = $NewPos.X;Y = $NewPos.Y; Letter = $Direction.Icon }
        
                $CurrentPos = $NewPos
                # Write-Host "Moved to ($($NewPos.X),$($NewPos.Y))"
                # Write-GridToScreen -Grid $Grid -CurrentPos $CurrentPos -Direction $Direction
                
                $WalkedTiles.Add("$($NewPos.X),$($NewPos.Y),$($NewPos.Direction)",$NewPos)
            }
        }
        catch
        {
            # Write-Warning "Loop detected!"
            $Script:LoopCount++
            Break
        }
    }

    return $WalkedTiles
}

function Get-DeepClone
{
    [cmdletbinding()]
    param(
        $InputObject
    )
    process
    {
        if($InputObject -is [hashtable]) {
            $clone = @{}
            foreach($key in $InputObject.keys)
            {
                $clone[$key] = Get-DeepClone $InputObject[$key]
            }
            return $clone
        } else {
            return $InputObject
        }
    }
}

#Endregion Functions

$Directions = @(
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y =  -1; Icon = '^'},
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y =  0; Icon = '>'},
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y =  1; Icon = 'v'},
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y =  0; Icon = '<'}
)

$Grid, $a, $b = Convert-TextToGrid -TextLines $PuzzleInput
$TopBoundary = 0
$RightBoundary = $a
$LowerBoundary = $b
$LeftBoundary = 0

$StartPos = $Grid.Values | Where-Object {$_.Letter -eq '^'}
$LoopCount = 0

# Start direction is Up
$Direction = $Directions[0]

# Find boundaries of the playfield

Write-Host "StartDir: $($Direction.Direction)"
Write-Host "StartPos: ($($StartPos.X),$($StartPos.Y))"

$WalkedTiles = Move-AlongPath -StartPos $StartPos -Direction $Direction -Grid $Grid
$UniqueTiles = $WalkedTiles.values | Group-Object -Property X, Y | ForEach-Object { $_.Name}

$TotalTilesCount = $UniqueTiles.Count
$Index = 1
foreach ($Tile in $UniqueTiles)
{
    $X, $Y = $Tile -split ", "
    $GridPos = $Grid["$X,$Y"]
    $OrigLetter = $GridPos.letter
    $GridPos.letter  = '#'

    # $Direction = $Directions | Where-Object {$_.Direction -eq $Tile.Direction}

    # Write-Host "Starting path $Index"
    # $PathStartTime = Get-Date
    $WalkedTilesNewPath = Move-AlongPath -Grid $Grid -StartPos $StartPos -Direction $Direction
    # Write-Host "Path runtime: $((Get-Date) - $PathStartTime)"
    # Write-Host "Total steps: $($WalkedTilesNewPath.Values.Count)"

    Write-Progress -Activity "Pathfinding.." -Status "$([Math]::Round($index / $TotalTilesCount,4) * 100)% complete" -PercentComplete $(($index / $TotalTilesCount) * 100)
    $Index++

    $GridPos.letter = $OrigLetter
}
Write-Progress -Activity "Pathfinding.." -Completed
Write-Host "Infinite loops: $LoopCount"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"