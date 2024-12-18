
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions
function New-Grid {
    param (
        [int]$Gridsize
    )

    $Grid = @{}
    for ($y = 0; $y -lt $Gridsize; $y++) {
        for ($x = 0; $x -lt $Gridsize; $x++) {
            $obj = [PSCustomObject]@{
                X      = $x
                Y      = $y
                Letter = "."
                Cost = -1
                CameFrom = $null
            }
            $Grid["$x,$y"] = $obj
        }
    }

    $Script:GridHeight = $Gridsize
    $Script:GridWidth = $Gridsize
    return $Grid
}

function Write-GridToScreen {
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

#Endregion Functions

$Grid = New-Grid -Gridsize 71

foreach ($byte in $PuzzleInput[0..1024]) # Only do the first 1024 actions
{
    $Bx, $By = $byte -split ","
    $Grid["$Bx,$By"].Letter = "#" 
}

$Directions = @(
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y =  0},
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y =  0},
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y =  1},
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y =  -1}
)

$StartTile = $Grid["0,0"]
$EndTile = $Grid["70,70"]
$EndTile.Letter = "E"

# Dijkstra algorithm
$Queue = New-Object 'System.Collections.Generic.PriorityQueue[PSCustomObject, int]'
$Queue.Enqueue( $StartTile, 0 )
$StartTile.cost = 0

while ($Queue.Count -gt 0)
{
    $Tile = $Queue.Dequeue()
    if ($Tile.Letter -eq "E")
    {
        break
    }

    foreach ($D in $Directions)
    {
        $NextTile = $Grid["$($Tile.X + $D.X),$($Tile.Y + $D.Y)"]

        if (! $NextTile) { continue}
        if ($NextTile.Letter -eq "#") { continue }

        $NewCost = $Tile.Cost + 1

        if ($NextTile.Cost -eq -1 -or $NewCost -lt $NextTile.Cost)
        {
            $NextTile.Cost = $NewCost
            $priority = $NewCost
            $Queue.Enqueue($NextTile, $priority)
            $NextTile.CameFrom = $Tile
        }
    }
}

Write-Host "Cost: $($EndTile.Cost)"

$path = New-Object System.Collections.ArrayList
while ($Tile -ne $StartTile) {
    [void]$path.Add($Tile)
    $Tile = $Tile.CameFrom
}
# [void]$path.Add($StartTile)
$path.Reverse()
$path.Remove($EndTile) | Out-Null # remove end tile from array

foreach ($tile in $path)
{
    $tile.Letter = "X"
    Write-GridToScreen $Grid
    Write-Host $Tile.Cost
    $null = Read-host " "
    # Start-Sleep -Milliseconds 20
}

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.3173167