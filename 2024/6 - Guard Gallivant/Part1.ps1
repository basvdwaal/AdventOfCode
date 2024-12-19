Set-StrictMode -Version latest
$StartTime = Get-Date

#region Functions
function Convert-TextToGrid {
    param (
        [string[]]$TextLines
    )

    $Grid = @{}

    for ($y = 0; $y -lt $TextLines.Count; $y++) {
        $line = $TextLines[$y]
        for ($x = 0; $x -lt $line.Length; $x++) {
            $obj = [PSCustomObject]@{
                X      = $x
                Y      = $y
                Letter = $line[$x]
            }
            $Grid["$x,$y"] = $obj
        }
    }

    $GridWidth = $line.Length
    $gridHeight = $TextLines.Count

    # Return Width and Height -1 so they match the coords of the last item
    return $grid, ($GridWidth - 1), ($gridHeight - 1)
}

function Convert-GridToStringArray {
    param (
        [array]$Grid
    )

    # Bepaal de maximale Y-coördinaat om het aantal rijen te weten
    $maxY = ($Grid | Measure-Object -Property Y -Maximum).Maximum

    # Maak een array voor de output
    $result = @()

    for ($y = 0; $y -le $maxY; $y++) {
        # Selecteer alle items in de huidige rij
        $rij = $Grid | Where-Object { $_.Y -eq $y } | Sort-Object X

        # Maak een string van de letters in de rij
        $result += ($rij | ForEach-Object { $_.Letter }) -join ''
    }
    return $result
}

function Write-GridToScreen {
    param (
        [hashtable]$Grid,
        [PSCustomObject]$CurrentPos,
        [PSCustomObject]$Direction
    )

    $Gridsize = 20

    Clear-Host
    for ($Y = $CurrentPos.Y - ($Gridsize/2); $Y -le ($CurrentPos.Y + ($Gridsize/2)); $Y++)
    {
        $arr = New-Object System.Collections.ArrayList       
        for ($X = $CurrentPos.X - ($Gridsize/2); $X -le ($CurrentPos.X + ($Gridsize/2)); $X++)
        {
            $pos = $Grid["$x,$y"]
            
            if ($pos)
            {
                $arr.Add($pos.Letter) | Out-Null
            }
        }
        Write-Host $arr
    }

    Write-Host "Steps: $TotalWalked"
    Start-Sleep -Milliseconds 20
}

function Get-NewDirection {
    param
    (
        [PSCustomObject]
        $CurrentDirection
    )

    $CurrentIndex = $Directions.IndexOf($CurrentDirection)
    $NewIndex = $CurrentIndex + 1

    # If NewIndex is out of bonds, we manually 'overflow'
    if ($NewIndex -lt 4)
    {
        Return $Directions[$NewIndex]
    }
    else
    {
        Return $Directions[0]
    }
}

#Endregion Functions
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)



$Grid, $a, $b = Convert-TextToGrid -TextLines $PuzzleInput

$Directions = @(
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y =  -1; Icon = '^'},
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y =  0; Icon = '>'},
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y =  1; Icon = 'v'},
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y =  0; Icon = '<'}
)

# Start direction is Up
$Direction = $Directions[0]
$StartPos = $Grid.Values | where {$_.Letter -eq '^'}

# Find boundaries of the playfield
$TopBoundary = 0
$RightBoundary = $a
$LowerBoundary = $b
$LeftBoundary = 0

Write-Host "StartDir: $($Direction.Direction)"
Write-Host "StartPos: ($($StartPos.X),$($StartPos.Y))"

$CurrentPos = [PSCustomObject]@{X = $StartPos.X; Y =  $StartPos.Y}

$TotalWalked = 1
$WalkedTiles = New-Object System.Collections.ArrayList
$WalkedTiles += $CurrentPos

While ($CurrentPos.X -gt $LeftBoundary -and $CurrentPos.X -lt $RightBoundary -and $CurrentPos.Y -gt $TopBoundary -and $CurrentPos.y -lt $LowerBoundary)
{
    $NewPos = [PSCustomObject]@{X = $CurrentPos.X + $Direction.X; Y = $CurrentPos.Y + $Direction.Y}
    # Check for obstacle at new position
    if ($Grid["$($NewPos.X),$($NewPos.Y)"].Letter -eq '#')
    {
        # Write-Host "Obstacle reached, turning.."
        $Direction = Get-NewDirection -CurrentDirection $Direction
        # Write-Host "New direction: $($Direction.Direction)"
    }
    else
    {   
        $Grid["$($CurrentPos.X),$($CurrentPos.Y)"] = [PSCustomObject]@{X = $CurrentPos.X;Y = $CurrentPos.Y; Letter = 'X' }
        $Grid["$($NewPos.X),$($NewPos.Y)"] = [PSCustomObject]@{X = $NewPos.X;Y = $NewPos.Y; Letter = $Direction.Icon }

        $CurrentPos = $NewPos
        # Write-Host "Moved to ($($NewPos.X),$($NewPos.Y))"
        # Write-GridToScreen -Grid $Grid -CurrentPos $CurrentPos -Direction $Direction
        
        # Convert-GridToStringArray -Grid $Grid.Values
        
        $WalkedTiles += $NewPos
        $TotalWalked++
    }
}


Write-Host "Total Walked: $TotalWalked"
Write-Host "Distinct Walked: $(($WalkedTiles | Group-Object -Property X, Y | Measure-Object).Count)"

Write-Host "Runtime: $((Get-Date) - $StartTime)"