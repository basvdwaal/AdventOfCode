
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions
function New-Grid
{
    param (
        [int]$Gridsize
    )

    $Grid = @{}
    for ($y = 0; $y -lt $Gridsize; $y++)
    {
        for ($x = 0; $x -lt $Gridsize; $x++)
        {
            $obj = [PSCustomObject]@{
                X        = $x
                Y        = $y
                Letter   = "."
                Cost     = -1
                CameFrom = $null
            }
            $Grid["$x,$y"] = $obj
        }
    }

    $Script:GridHeight = $Gridsize
    $Script:GridWidth = $Gridsize
    return $Grid
}

function Write-GridToScreen
{
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
                [void]$arr.Add($pos.Letter)
            }
        }
        [void]$arr.Add("`r`n")
    }
    Write-Host $arr
}

function Find-PathToExit
{
    $Queue = New-Object 'System.Collections.Generic.PriorityQueue[PSCustomObject, int]'
    $Queue.Enqueue( $StartTile, 0 )
    $cost = @{}
    $Cost["$($StartTile.X),$($StartTile.Y)"] = 0
    $ComeFrom = @{}
    $possible = $false

    while ($Queue.Count -gt 0)
    {
        $Tile = $Queue.Dequeue()
        if ($Tile.Letter -eq "E")
        {
            $Possible = $true
            break
        }

        foreach ($D in $Directions)
        {
            $NextTile = $Grid["$($Tile.X + $D.X),$($Tile.Y + $D.Y)"]

            if (! $NextTile) { continue }
            if ($NextTile.Letter -eq "#") { continue }

            $NewCost = $Cost["$($Tile.X),$($Tile.Y)"] + 1
            $NextTileCost = $Cost["$($NextTile.X),$($NextTile.Y)"]

            if (! $NextTileCost -or $NewCost -lt $NextTileCost)
            {
                $Cost["$($NextTile.X),$($NextTile.Y)"] = $NewCost
                $priority = $NewCost
                $Queue.Enqueue($NextTile, $priority)
                $ComeFrom["$($NextTile.X),$($NextTile.Y)"] = $Tile
            }
        }
    }

    if ($possible)
    {
        $Path = New-Object System.Collections.ArrayList
        while ($Tile -ne $StartTile)
        {
            [void]$Path.Add("$($Tile.X),$($Tile.Y)")
            $Tile = $ComeFrom["$($Tile.X),$($Tile.Y)"]
        }
        return $Path
    }
    else
    {
        return $null
    }
}
#Endregion Functions

$Grid = New-Grid -Gridsize 71

$Directions = @(
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y = 0 },
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y = 0 },
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y = 1 },
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y = -1 }
)

$StartTile = $Grid["0,0"]
$EndTile = $Grid["70,70"]
$EndTile.Letter = "E"

for ($i = 0; $i -lt $PuzzleInput.Count; $i++)
{
    $Bx, $By = $PuzzleInput[$i] -split ","
    $Grid["$Bx,$By"].Letter = "#"

    # Do the first 1024 iterations on forehard
    if ($i -lt 1024) { continue }

    $path = Find-PathToExit
    if (!$path)
    {
        Write-Host "Blocking tile = $($PuzzleInput[$i]) after $($i + 1) steps."
        break
    }
    else
    {
        Write-Progress -Activity "calculating.." -Status "$I / $($PuzzleInput.Count)"
    }

    do
    {
        $Nx, $Ny = $PuzzleInput[($i + 1)] -split ","
        if ($("$Nx,$Ny") -notin $path)
        {
            # No need to pathfind again.
            $Grid["$Nx,$Ny"].Letter = "#"
            $I++
            $continue = $true
        }
        else
        {
            $continue = $false
        }
    }
    while ($continue)
}

Write-Progress -Activity "calculating.." -Completed

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:05.6593457