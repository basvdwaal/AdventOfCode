
Set-StrictMode -Version latest

$PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
# $PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions
function Convert-TextToGrid
{
    param (
        [string[]]$TextLines
    )

    $Grid = @{}
    
    $width = $TextLines[0].Length
    0..($width - 1) | ForEach-Object { $Grid[$_] = @{} }

    for ($y = 0; $y -lt $TextLines.Count; $y++)
    {
        $chars = $TextLines[$y].ToCharArray() 

        for ($x = 0; $x -lt $chars.Count; $x++)
        {
            $Grid[$x][$y] = [PSCustomObject]@{
                X    = $x
                Y    = $y
                Active = if ($chars[$x] -eq "#") { $true} else { $false }
                Neighbors = @(
                    @( ($x + 1) , ($y + 1) ),
                    @( ($x - 1) , ($y + 1) ),
                    @( ($x + 1) , ($y - 1) ),
                    @( ($x - 1) , ($y - 1) )
                )
            }
        }
    }

    return $Grid
}

function IsActiveNextRound ($Tile, $Grid)
{
    $ActiveNeighbors = 0

    foreach ($Neighbor in $Tile.Neighbors)
    {
        if ($Grid[$Neighbor[0]])
        {
            if ($NT = $Grid[$Neighbor[0]][$Neighbor[1]])
            {
                $ActiveNeighbors += $NT.Active
            }
        }
    }

    $ActiveNeighbors += $Tile.Active

    if ($ActiveNeighbors % 2 -eq 0)
    {
        return $true
    }
}

function Get-ActiveTiles ($Grid)
{
    $Count = 0
    Foreach ($Tile in $Grid.Values.Values)
    {
        if ($Tile.Active) { $Count++ }
    }
    return $Count
}


#Endregion Functions

$Grid = Convert-TextToGrid -TextLines $PuzzleInput
$NumRounds = 10
$total = 0

for ($i = 1; $i -le $NumRounds; $i++)
{
    $NewGrid = @{}

    foreach ($Tile in $Grid.values.values)
    {
        if (! $NewGrid.Item($Tile.X))
        {
            $NewGrid[$Tile.X] = @{}
        }
        
        $NewGrid[$Tile.X][$tile.Y] = $Tile
        $tile.Active = IsActiveNextRound -Tile $Tile -Grid $Grid
    }

    $Grid = $NewGrid

    $TileCount = Get-ActiveTiles $Grid
    Write-Host "Count after round $i - $Tilecount"

    $total += $TileCount

}

Write-Host $total



# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"