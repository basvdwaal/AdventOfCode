
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample2.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

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

    $Script:GridWidth = $TextLines[0].Length
    $Script:GridHeight = $TextLines.Count

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

function Write-GridToScreen
{
    param (
        [hashtable]$Grid
    )

    # Clear-Host
    $arr = New-Object System.Collections.ArrayList
    [void]$arr.Add("")
    for ($Y = 0; $Y -lt $script:GridHeight; $Y++)
    {

        for ($X = 0; $X -lt $Script:GridWidth; $X++)
        {
            $pos = $Grid[$x][$y]

            if ($pos)
            {
                if ($pos.Active)
                {
                    [void]$arr.Add("#")
                }
                else
                {
                    [void]$arr.Add(".")
                }
            }
        }
        [void]$arr.Add("`r`n")
    }
    Write-Host $arr
}


#Endregion Functions

$Grid = Convert-TextToGrid -TextLines $PuzzleInput
$NumRounds = 2025
$total = 0

# Write-host "Startgrid:"
# Write-GridToScreen -Grid $Grid
# Write-host "=========================="

for ($i = 1; $i -le $NumRounds; $i++)
{
    $PendingUpdates = foreach ($Tile in $Grid.values.values)
    {
        # We geven het hele object door plus wat de status MOET worden
        [PSCustomObject]@{
            Tile     = $Tile
            NewState = IsActiveNextRound -Tile $Tile -Grid $Grid
        }
    }

    foreach ($Update in $PendingUpdates)
    {
        $Update.Tile.Active = $Update.NewState
    }

    $TileCount = Get-ActiveTiles $Grid
    # Write-Host "Count after round $i - $Tilecount"

    # Write-GridToScreen -Grid $Grid
    # Write-host "=========================="

    $total += $TileCount

}

Write-Host $total

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:01:15.5146801