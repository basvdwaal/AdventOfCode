
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
                ID        = "$x,$y"
                X         = $x
                Y         = $y
                Value     = $Value
                Neighbors = @()
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
    Write-Host $arr
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

# Decide initial direciton
foreach ($Direction in $Directions)
{
    $NextTile = $Grid["$($CurrentTile.X + $Direction.X),$($($CurrentTile.Y + $Direction.Y))"]
    if ($NextTile.Neighbors -contains $CurrentTile.ID)
    {
        $PreviousTile = $CurrentTile
        $CurrentTile = $NextTile
        break
    }
}

$PipeLength = 1  # Starttile + prev tile
do
{
    try
    {
        $NextTile = $grid[($CurrentTile.Neighbors -ne $PreviousTile.ID)[0]]
        
        $PipeLength++
    
        $PreviousTile = $CurrentTile
        $CurrentTile = $NextTile
    }
    catch
    {
        $_
    }
}
while ($CurrentTile.Value -ne "S")

Write-Host "Total length: $PipeLength"
Write-Host "Furthest point: $($PipeLength/2)"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:01.1210660