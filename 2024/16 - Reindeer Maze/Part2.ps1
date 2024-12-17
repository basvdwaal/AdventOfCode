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
                Cost = $null
                Direction = ""
                Distance = $null
                FullPath = @()

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

# Dijkstra algorithm
$Queue = New-Object 'System.Collections.Generic.PriorityQueue[PSCustomObject, int]'
$Queue.Enqueue( $StartTile, 0 )
$Came_from = @{}
$Came_from[$StartTile.String] = $null
$StartTile.cost = 0

# Starting direction is east
$StartTile.Direction = $Directions | where Direction -eq "East" | select -ExpandProperty Direction
$lastTile = $null
while ($Queue.Count -gt 0)
{
    $Tile = $Queue.Dequeue()
    if ($Tile.Letter -eq "E")
    {
        continue
    }

    foreach ($D in $Directions)
    {
        $NextTile = $Grid["$($Tile.X + $D.X),$($Tile.Y + $D.Y)"]
        if ($nextTile.String -eq $lastTile) {continue}
        if ($NextTile.Letter -eq "#") { continue }

        $ExtraCost = $D.Direction -ne $Tile.Direction ? 1001 : 1  # Ternary checks!

        $NewCost = $Tile.Cost + $ExtraCost


        if ($null -eq $NextTile.Cost -or $NewCost -lt $NextTile.Cost)
        {
            # $NextTile.Letter = "X"
            $NextTile.Direction = $D.Direction
            $NextTile.Cost = $NewCost
            $NextTile.Distance = $Tile.Distance + 1
            $priority = $NewCost
            $Queue.Enqueue($NextTile, $priority)
            $Came_from[$NextTile.String] = $Tile

            # Write-GridToScreen $Grid

            # $NextTile.Letter = "0"
        }
        elseif ($NewCost -gt $NextTile.Cost){
            continue
        }

        if ($NextTile.FullPath)
        {
            $NextTile.FullPath += @($Tile)
        }
        else
        {
            $NextTile.FullPath = @($Tile)
        }
        
        $NextTile.FullPath += $Tile.FullPath

    }
    $lastTile = $tile.String
    
    # Write-GridToScreen $Grid
    # $null = Read-host " "
    # Start-Sleep -Milliseconds 200
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
#>

$Directions = @(
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y =  0},
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y =  0},
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y =  -1},
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y =  1}
)


foreach ($Tile in $EndTile.FullPath)
{
    if ($Tile.Letter -ne "S")
    {

        $Tile.Letter = "O"
    }
}



$Tile = $Grid.Values | where Letter -eq "S"
do
{
    $Tile.Letter = "X"

    Write-GridToScreen $Grid

    Write-Host " [$($Tile.X),$($Tile.y) Cost: $($Tile.Cost) Distance: $($Tile.Distance)]"
    
    $Key = [System.Console]::ReadKey()
    if ($Key.Key -notin @("UpArrow","DownArrow","RightArrow","leftArrow")) {continue}
    
    $D = $Directions | where Direction -eq ($key.Key -replace "Arrow","")
    $NextTile = $Grid["$($Tile.X + $D.X),$($Tile.Y + $D.Y)"]

    # if ($NextTile.Letter -eq "#") {
    #     continue
    # }
    $Tile.Letter = Switch ($Tile)
    {
        {$_ -eq $starttile} {"S"}
        {$_ -eq $EndTile} {"E"}
        {$_.Cost -eq $null} {"#"}
        Default {"."}
    }
    
    $Tile -eq $StartTile ? "S" : "."


    # $Tile.Letter = $OrigLetter
    $Tile = $NextTile
}
while ($Key.Key -ne "Enter")



Write-Host "Cost: $($EndTile.Cost)"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:01.2384169