
Set-StrictMode -Version latest
Add-Type -AssemblyName System.Collections

$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

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
                Number    = $null
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
                if ($pos.Number)
                {
                    [void]$arr.Add($pos.Number)
                }
                else
                {
                    [void]$arr.Add($pos.Value)
                }
            }
        }
        [void]$arr.Add("`r`n")
    }
    # Write-Host $arr
}


#Endregion Functions

$Grid = Convert-TextToGrid -TextLines $PuzzleInput

# # # # # # # # # # # # # # # # # #
# Step 1                          # 
# Find empty space                #
# # # # # # # # # # # # # # # # # # 

# Start with the Rows
$EmptyRowIndexes = @()
:Rowloop
for ($RowIndex = 0; $RowIndex -lt $GridHeight; $RowIndex++) {
    for ($ColumnIndex = 0; $ColumnIndex -lt $GridWidth; $ColumnIndex++) {
        $tile = $Grid["$ColumnIndex,$RowIndex"]
        if ($Tile.Value -eq "#")
        {
            # We found a galaxy, this means the row isnt empty.
            Continue Rowloop
        }
    }
    # If we make it to the end, row is empty
    $EmptyRowIndexes += $RowIndex
}

# The same for the Columns
$EmptyColumnIndexes = @()
:Columnloop
for ($ColumnIndex = 0; $ColumnIndex -lt $GridWidth; $ColumnIndex++) {
    for ($RowIndex = 0; $RowIndex -lt $GridHeight; $RowIndex++) {
        $tile = $Grid["$ColumnIndex,$RowIndex"]
        if ($Tile.Value -eq "#")
        {
            # We found a galaxy, this means the Column isnt empty.
            Continue Columnloop
        }
    }
    # If we make it to the end, Column is empty
    $EmptyColumnIndexes += $ColumnIndex
}

$Galaxies = $Grid.Values | Where Value -eq "#" | sort -Property Y, X

# Assign an id to the galaxies for easier debugging
# foreach ($Galaxy in $Galaxies)
# {
#     $Galaxy.Number = $Galaxies.IndexOf($Galaxy) + 1
# }

# Write-GridToScreen -Grid $Grid

$Combinations = New-Object System.Collections.ArrayList

for ($i = 0; $i -lt $Galaxies.Count; $i++) {
    for ($j = $i + 1; $j -lt $Galaxies.Count; $j++) {
        $combinations.Add( @($Galaxies[$i], $Galaxies[$j]) ) | Out-Null
    }
}

$Total = 0

foreach ($Combination in $Combinations)
{
    $Start, $End = $Combination

    # Calculate the distance between each pair with the Manhattan Distance calculation
    $Distance = [Math]::Abs($Start.X - $End.X) + [Math]::Abs($Start.Y - $End.Y)
    # Write-Host "Distance between $($start.Number) ($($Start.X),$($Start.Y)) and $($end.Number) ($($End.X),$($End.Y)) = $Distance"

    # Check if we have crossed an empty row or Column and add those to the distance
    foreach ($Row in $EmptyRowIndexes)
    {
        # The index of the Row is equal to the X coordinate of the tiles. We check both ways because the X of the End tile can be lower then the X of the Start tile.
        if ( ($Row -gt $Start.Y -and $row -lt $End.Y) -or
             ($Row -gt $End.Y -and $row -lt $Start.Y) 
        )
        {
            $Distance += 999999
            # Write-Host "Row $Row is in between $($Start.Y) and $($End.Y)"
        }
        else
        {
            # Write-Host "Row $Row is NOT in between $($Start.Y) and $($End.Y)"
        }
    }

    # The same for the Columns
    foreach ($Column in $EmptyColumnIndexes)
    {
        if ( ($Column -gt $Start.X -and $Column -lt $End.X) -or
             ($Column -gt $End.X -and $Column -lt $Start.X) 
        )
        {
            $Distance += 999999
            # Write-Host "Column $Column is in between $($Start.X) and $($End.X)"
        }
        else
        {
            # Write-Host "Column $Column is NOT in between $($Start.X) and $($End.X)"
        }
    }

    # Write-Host "Total distance between $($start.Number) and $($end.Number) = $Distance"

    $Total += $Distance
    # Write-Host "======================"
}

Write-Host "Total: $total"
# Write-GridToScreen $Grid

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:01.4725797