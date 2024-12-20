
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
                Distance = $null
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
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y =  -1},
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y =  1}
)

$Grid = Convert-TextToGrid -TextLines $PuzzleInput

$StartTile = $Grid.Values | where Letter -eq "S"
$EndTile = $Grid.Values | where Letter -eq "E"


# DFS
$Stack = New-Object System.Collections.Stack
$Stack.Push( $StartTile )
$Distance = 0
while ($Stack.Count -gt 0)
{
    $T = $Stack.Pop()
    # $Grid["$($T.x),$($T.y)"].Letter = "X"

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
    $T.Distance = $Distance
    $Distance++
}

# Write-GridToScreen $Grid
$Cheats = New-Object System.Collections.ArrayList

foreach ($Tile in $Grid.Values | where Letter -ne "#")
{
    # Check if there is a wall next to the tile
    foreach ($D in $Directions)
    {
        $NT = $Grid["$($Tile.x + $D.X),$($Tile.y + $D.Y)"]
        if (!$NT -or $NT.Letter -ne "#") { continue }
        
        $NNT = $Grid["$($NT.x + $D.X),$($NT.y + $D.Y)"] 
        if (!$NNT -or $NNT.Letter -eq "#") { continue }

        $DistanceSaved = $NNT.Distance - $Tile.Distance - 2 # -2 because it takes 2 picoseconds to execute the cheat
        if ($DistanceSaved  -lt 100) { continue}
        
        # Write-Host "$($Tile.X),$($tile.Y) -> $($NNT.X),$($NNT.Y) saves: $DistanceSaved"
        [void]$Cheats.Add(
            [PSCustomObject]@{
                Start = $Tile
                End = $NNT
                Distance = $DistanceSaved
            }
        )
    }
}

Write-host "Cheats: $($Cheats.Count)"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:01.2393985