
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\input.txt)

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
                ID           = "$x,$y"
                X            = $x
                Y            = $y
                Value        = $Value
                DisplayValue = $Value
                Neighbors    = @()
                Mainpipe     = $false
            }
            $obj = Get-ConnectedTiles -Object $obj
            $Grid["$x,$y"] = $obj
        }
    }

    $Script:GridWidth = $line.Length
    $Script:GridHeight = $TextLines.Count

    return $Grid
}

function Get-ConnectedTiles
{
    param (
        [pscustomobject]$Object
    )
    
    try
    {
        if ($Object.Value -eq "." -or $object.Value -eq "S") { return $Object }

        # Get the transformations to apply.
        $Transformations = $ConnectionMap[$Object.Value]

        # Apply the transformation on the current coords to get the connected tiles
        foreach ($transformation in $Transformations)
        {
            $Object.Neighbors += "$($Object.x + $transformation[0]),$($Object.y + $transformation[1])"
        }

        return $Object
    }
    catch
    {
        $_
    }

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
    Write-Host ($arr -join "")
}

#Endregion Functions

$ConnectionMap = @{
    [char]"|" = ((0, 1), (0, -1))
    [char]"-" = ((-1, 0), (1, 0))
    [char]"L" = ((0, -1), (1, 0))
    [char]"J" = ((0, -1), (-1, 0))
    [char]"7" = ((-1, 0), (0, 1))
    [char]"F" = ((1, 0), (0, 1))
}

$Directions = @(
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y = 0 },
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y = 0 },
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y = 1 },
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y = -1 }
)

$Grid = Convert-TextToGrid $PuzzleInput

# Set start tile
$CurrentTile = $grid.Values | where Value -eq "S"


# Use a BSF-like search to walk each path step by step. The moment both paths are the same is the furthest point away (only true because it is a single enclosed loop)
# Other idea: Simply walk the path of the snake and get the total length. Half the lenght is the answer.

# Find neighbors for S
foreach ($Direction in $Directions)
{
    $NextTile = $Grid["$($CurrentTile.X + $Direction.X),$($($CurrentTile.Y + $Direction.Y))"]
    if ($NextTile.Neighbors -contains $CurrentTile.ID)
    {
        $CurrentTile.Neighbors += $NextTile.ID
    }
}

# Find out what type of pipe S is

$DirectionSet = [System.Collections.Generic.HashSet[string]]@()
Foreach ($Neighbor in $CurrentTile.Neighbors)
{
    [int]$X, [int]$Y = $Neighbor -split ","
    $DirectionSet += "$($CurrentTile.X - $X),$($($CurrentTile.y - $y))"
}


if ($DirectionSet.Contains("0,-1") -and $DirectionSet.Contains("0,1")) {
    $SType = [char]"|"
}
elseif ($DirectionSet.Contains("-1,0") -and $DirectionSet.Contains("1,0")) {
    $SType = [char]"-"
}
elseif ($DirectionSet.Contains("0,-1") -and $DirectionSet.Contains("1,0")) {
    $SType = [char]"L"
}
elseif ($DirectionSet.Contains("0,-1") -and $DirectionSet.Contains("-1,0")) {
    $SType = [char]"J"
}
elseif ($DirectionSet.Contains("-1,0") -and $DirectionSet.Contains("0,1")) {
    $SType = [char]"7"
}
elseif ($DirectionSet.Contains("1,0") -and $DirectionSet.Contains("0,1")) {
    $SType = [char]"F"
}

$CurrentTile.Value = $SType
$CurrentTile.Mainpipe = $true
$Grid[$CurrentTile.ID] = $CurrentTile

# Pick a random Neighbor as next tile and start the loop.
$PreviousTile = $CurrentTile
$CurrentTile = $grid[$CurrentTile.Neighbors[0]]

do
{
    if ($CurrentTile.DisplayValue -ne "S") { $CurrentTile.DisplayValue = "*" }
    $CurrentTile.Mainpipe = $true

    $NextTile = $grid[($CurrentTile.Neighbors -ne $PreviousTile.ID)[0]]

    $PreviousTile = $CurrentTile
    $CurrentTile = $NextTile
}
while ($CurrentTile.DisplayValue -ne "S")


$Total = 0
$Inside = $false
$PrevCorner = $null

# iterate over each row and check when we cross over the main pipe. if we do, toggle outside -> inside and vice versa.
# Special edge case for double corners (e.g. FJ) which is only one toggle.
for ($RowIndex = 0; $RowIndex -lt $GridHeight; $RowIndex++ )
{
    for ($ColumnIndex = 0; $ColumnIndex -lt $GridWidth; $ColumnIndex++ )
    {
        $Tile = $Grid["$($ColumnIndex),$($RowIndex)"]
        # New row, start outside again
        if ($Tile.X -eq 0) 
        {
            $Inside = $false
            $PrevCorner = $null
        }

        if ($Tile.Mainpipe)
        {
            if ($Tile.Value -eq [char]"|")
            {
                $Inside = ! $Inside
            }
            elseif ($Tile.Value -eq [char]"-")
            {
                Continue
            }
            elseif ($Tile.Value -in @([char]"F", [char]"J", [char]"7", [char]"L"))
            {
                if (! $PrevCorner)
                {
                    $PrevCorner = $Tile
                    Continue
                }
                else
                {
                    switch ("$($PrevCorner.Value),$($tile.Value)") {
                        "F,7" { continue }
                        "F,J" { $Inside = ! $Inside }
                        "L,7" { $Inside = ! $Inside }
                        "L,J" { continue }
                    }
                    $PrevCorner = $null
                }
            }
        }
        else
        {
            if ($Inside)
            { 
                $Total++
                $Tile.Value = "I"
            }
        }

    }
}

# Write-GridToScreen -Grid $Grid

Write-Host "Total inside: $Total"

# TODO:
# Find S value and update tile.



# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:01.6452595