
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions


function Convert-TextToGrid
{
    param (
        [string[]]$TextLines
    )

    # Resultaat grid
    $Grid = @{}

    for ($y = 0; $y -lt $TextLines.Count; $y++)
    {
        $line = $TextLines[$y]
        for ($x = 0; $x -lt $line.Length; $x++)
        {
            $Value = $line[$x]
            
            $obj = [PSCustomObject]@{
                ID        = "$x,$y"
                X         = $x
                Y         = $y
                Value     = $Value
            }
            $Grid["$x,$y"] = $obj
        }
    }

    $Script:GridWidth = $line.Length
    $Script:GridHeight = $TextLines.Count

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
                [void]$arr.Add($pos.Value)
            }
        }
        [void]$arr.Add("`r`n")
    }
    Write-Host $arr
}


function Get-NextTiles ($Tile, $Grid)
{
    $NextTiles = @()

    Foreach ($transform in $Transformations)
    {
        $X = $Tile.X + $transform[0]
        $Y = $Tile.Y + $transform[1]

        if ( $Grid.ContainsKey("$x,$y") )
        {
            $NextTiles += $Grid.Item("$x,$y")
        }
    }

    return $NextTiles
}

#Endregion Functions

$Transformations = @(
    (-2,-1),
    (-1,-2),
    (2, -1),
    (1, -2),
    (-2, 1),
    (-1, 2),
    ( 2, 1),
    ( 1, 2)
)



$grid = Convert-TextToGrid -TextLines $PuzzleInput

$Tile = $grid.Values | where value -eq "D"

$MaxSteps = 4



$stack = New-Object System.Collections.Queue

$stack.Enqueue(@($Tile, 0))
$PossibleTiles = [System.Collections.Generic.HashSet[[pscustomobject]]]::new()

While ($Stack.Count -gt 0)
{
    $CurrentTile, $Count = $stack.Dequeue()

    if ($count -ge $MaxSteps) { continue }

    $NextTiles = Get-NextTiles -Tile $CurrentTile -Grid $grid
    foreach ($NextTile in $NextTiles)
    {
        $Added = $PossibleTiles.Add($NextTile)
        
        # If added is false, the tile was already in the list and we don't have to check the options again.
        if($Added)
        {
            $Stack.Enqueue(@($NextTile, ($Count + 1)) )
        }
    }
}




Write-host "Total: $($PossibleTiles | where value -eq "S" | measure | select -ExpandProperty Count)"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0353976