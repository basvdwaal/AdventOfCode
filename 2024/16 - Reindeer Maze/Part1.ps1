$ErrorActionPreference = 'Stop'
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
                Visited = $false
                String = "$x,$y"
                Cost = -1
                Direction = ""
            }
            $Grid["$x,$y"] = $obj
        }
    }

    $Script:GridWidth = $line.Length
    $Script:GridHeight = $TextLines.Count

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

$Directions = @(
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y =  0},
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y =  0},
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y =  1},
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y =  -1}
)

$Grid = Convert-TextToGrid -TextLines $PuzzleInput

$StartTile = $Grid.Values | where Letter -eq "S"
$EndTile = $Grid.Values | where Letter -eq "E"




<#  DEPTH FIRST SEARCH
$Stack = New-Object System.Collections.Stack
$Stack.Push( $StartTile )
while ($Stack.Count -gt 0)
{
    $T = $Stack.Pop()
    $Grid["$($T.x),$($T.y)"].Letter = "X"

    foreach ($D in $Directions)
    {
        $NT = $Grid["$($T.x + $D.X),$($T.y + $D.Y)"]

        if ($NT.Visited) { continue }

        if ($NT.Letter -eq "E")  # Reached the goal
        {
            Write-Host "Goal found!"
        }
        
        if ($NT.Letter -ne "#")
        {
            $Stack.Push( $NT )
        }
    }
    $T.Visited = $true

    Write-GridToScreen $Grid
    $null = Read-host " "
}
#>

<# A* algorithm
$Queue = New-Object 'System.Collections.Generic.PriorityQueue[PSCustomObject, int]'
$Queue.Enqueue( $StartTile, 0 )
$Came_from = @{}
$Cost_so_far = @{}
$Came_from[$StartTile.String] = $null
$cost_so_far[$StartTile.String] = 0

# Starting direction is east
$PD = $Directions | where Direction -eq "East"

while ($Queue.Count -gt 0)
{
    $Tile = $Queue.Dequeue()
    if ($Tile.Letter -eq "E")
    {
        Write-Host "Goal reached"
        break
    }

    foreach ($D in $Directions)
    {
        $NextTile = $Grid["$($Tile.X + $D.X),$($Tile.Y + $D.Y)"]
        if ($NextTile.Letter -eq "#") { continue }

        $ExtraCost = $D -ne $PD ? 1001 : 1  # Ternary checks!

        $NewCost = $Cost_so_far[$Tile.String] + $ExtraCost

        if (! ($Cost_so_far[$NextTile.String]) -or $NewCost -lt $Cost_so_far[$NextTile.String])
        {
            $Cost_so_far[$NextTile.String] = $NewCost
            $priority = $NewCost + (($EndTile.X - $NextTile.X) + ($EndTile.Y - $NextTile.Y))
            $Queue.Enqueue($NextTile, $priority)
            $Came_from[$NextTile.String] = $Tile.String
        }
    }
    $PD = $D
    $Tile.Letter = "X"

    Write-GridToScreen $Grid
    $null = Read-host " "
}
#>

# Dijkstra algorithm
$Queue = New-Object 'System.Collections.Generic.PriorityQueue[PSCustomObject, int]'
$Queue.Enqueue( $StartTile, 0 )
$Came_from = @{}
$Came_from[$StartTile.String] = $null
$StartTile.cost = 0

# Starting direction is east
$StartTile.Direction = $Directions | where Direction -eq "East" | select -ExpandProperty Direction

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
        if ($NextTile.Letter -eq "#") { continue }

        $ExtraCost = $D.Direction -ne $Tile.Direction ? 1001 : 1  # Ternary checks!

        $NewCost = $Tile.Cost + $ExtraCost

        if ($NextTile.Cost -eq -1 -or $NewCost -lt $NextTile.Cost)
        {
            $NextTile.Direction = $D.Direction
            $NextTile.Cost = $NewCost
            $priority = $NewCost
            $Queue.Enqueue($NextTile, $priority)
            $Came_from[$NextTile.String] = $Tile
        }
    }
    
    # Write-GridToScreen $Grid
    # $null = Read-host " "
}
#>

<#
$path = New-Object System.Collections.ArrayList
while ($Tile -ne $StartTile) {
    [void]$path.Add($Tile)
    $Tile = $came_from[$tile.String]
}
# [void]$path.Add($StartTile)
$path.Reverse()
$path.Remove($EndTile) | Out-Null # remove end tile from array

foreach ($tile in $path)
{
    $tile.Letter = "X"
    
    # Write-Host $Tile.Cost
    # $null = Read-host " "
    # Start-Sleep -Milliseconds 20
}

Write-GridToScreen $Grid

#>
Write-Host "Cost: $($EndTile.Cost)"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:01.2384169