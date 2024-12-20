
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


function Get-Shortcut {
    param (
        $StartTile,
        $nextTile,
        $depth,
        $Visited = (New-Object System.Collections.Generic.HashSet[string])
    )
    
    # Base cases
    if ($depth -gt 20) { return }
    if ($null -eq $nextTile) { return }
    if (-not $Visited.Add("$($nextTile.X),$($nextTile.Y)")) { return } # Already visited

    if ($nextTile.Letter -ne "#") {
        $DistanceSaved = $nextTile.Distance - $StartTile.Distance - $depth 
        if ($DistanceSaved -ge 50) {
            # Write-Host "$($StartTile.X),$($StartTile.Y) -> $($nextTile.X),$($nextTile.Y) saves: $DistanceSaved"
            [void]$script:Cheats.Add(
                [PSCustomObject]@{
                    Start = $StartTile
                    End = $nextTile
                    Distance = $DistanceSaved
                }
            )
        }
    }

    foreach ($D in $Directions) {
        $newX = $nextTile.X + $D.X
        $newY = $nextTile.Y + $D.Y
        
        # Check boundaries
        if ($newX -lt 0 -or $newX -ge $Script:GridWidth -or 
            $newY -lt 0 -or $newY -ge $Script:GridHeight) {
            continue
        }

        if ($Grid["$newX,$newY"] -eq $StartTile) { continue } # we can skip the tile we came from
        # Write-Host "Checking $newX,$newY with depth $($depth + 1)"
        Get-Shortcut -StartTile $StartTile -nextTile $Grid["$newX,$newY"] -depth ($depth + 1) -Visited $Visited
    }
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

Write-GridToScreen $Grid
$Cheats = New-Object System.Collections.ArrayList

$counter = 1
foreach ($Tile in $Grid.Values | where Letter -ne "#")
{
    if ($counter % 100 -eq 0)
    {
        Write-Progress -Activity "Checking shortcuts" -Status "$Counter/$($Grid.Values.Count)" -PercentComplete (($counter / $Grid.Values.Count) * 100)
    }

    for ($x = $Tile.x - 22; $x -lt $Tile.x + 22; $x++)
    {
        for ($y = $Tile.y - 22; $y -lt $Tile.y + 22; $y++)
        {
            $NT = $Grid["$x,$y"]
            
            if (!$NT) { continue }
            if ($NT.Letter -eq "#") { continue }
            if ($NT -eq $Tile) { continue }

            $Picoseconds = [Math]::Abs($NT.X - $Tile.X) + [Math]::Abs($NT.Y - $Tile.Y)
            # [math]::Sqrt( [math]::Pow(($NT.X - $Tile.X),2) + [math]::Pow(($NT.Y - $Tile.Y),2) )
            # math.sqrt((x1 - x2)**2 + (y1 - y2)**2)

            if ($Picoseconds -lt 0 -or $Picoseconds -gt 20) { continue }

            $DistanceSaved = $NT.Distance - $Tile.Distance - $Picoseconds
            if ($DistanceSaved -lt 100) { continue}

            # Write-Host "$($Tile.X),$($tile.Y) -> $($NT.X),$($NT.Y) saves: $DistanceSaved"

            [void]$Cheats.Add(
                [PSCustomObject]@{
                    Start = $Tile
                    End = $NT
                    Distance = $DistanceSaved
                }
            )
        }
    }
    $counter++
    
    
    
    
    
    
    <#
    
    # Check if there is a wall next to the tile
    foreach ($D in $Directions)
    {
        $NT = $Grid["$($Tile.x + $D.X),$($Tile.y + $D.Y)"]
        # Get-Shortcut -StartTile $Tile -nextTile $NT -depth 0
        
        <#
        $NT = $Grid["$($Tile.x + $D.X),$($Tile.y + $D.Y)"]
        if (!$NT -or $NT.Letter -ne "#") { continue }
        
        $NNT = $Grid["$($NT.x + $D.X),$($NT.y + $D.Y)"] 
        if (!$NNT -or $NNT.Letter -eq "#") { continue }

        $DistanceSaved = $NNT.Distance - $Tile.Distance - 2
        if ($DistanceSaved  -lt 100) { continue}
        
        Write-Host "$($Tile.X),$($tile.Y) -> $($NNT.X),$($NNT.Y) saves: $DistanceSaved"
        [void]$Cheats.Add(
            [PSCustomObject]@{
                Start = $Tile
                End = $NNT
                Distance = $DistanceSaved
            }
        )
        
    }
    #>
}

Write-Progress -Activity "Checking shortcuts" -Completed

Write-host "Cheats: $($Cheats.Count)"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:05:00.6310158