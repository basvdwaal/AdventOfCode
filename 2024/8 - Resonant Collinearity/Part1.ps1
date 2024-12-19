
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

    $Script:GridWidth = $line.Length
    $Script:GridHeight = $TextLines.Count

    return $grid
}

function Write-GridToScreen {
    param (
        [hashtable]$Grid
    )

    for ($Y = 0; $Y -lt $script:GridHeight; $Y++)
    {
        $arr = New-Object System.Collections.ArrayList       
        for ($X = 0; $X -le $Script:GridHeight; $X++)
        {
            $pos = $Grid["$x,$y"]
            
            if ($pos)
            {
                $arr.Add($pos.Letter) | Out-Null
            }
        }
        Write-Host $arr
    }
}

#Endregion Functions

$Grid = Convert-TextToGrid -TextLines $PuzzleInput

# Create Lookup Table by letter
$LetterLookupTable = @{}
foreach ($Item in $Grid.Values)
{
    if ($item.Letter -eq '.') { continue }
    
    if ($LetterLookupTable[$Item.Letter])
    {
        $LetterLookupTable[$Item.Letter] += $Item
    }
    else
    {
        $LetterLookupTable[$Item.Letter] = @($Item)
    }
}


$Antinodes = @{}

# Write-GridToScreen -Grid $Grid 

foreach ($Letter in $LetterLookupTable.Keys)
{
    $Positions = $LetterLookupTable[$Letter]

    foreach ($Pos in $Positions)
    {
        Write-Host ""
        $OtherPos = $Positions | where {$_ -ne $Pos}

        foreach ($OPos in $OtherPos)
        {
            $DistX = $OPos.X - $Pos.X
            $DistY = $OPos.Y - $Pos.Y

            $Distance = "($DistX,$DistY)"

            Write-Host "Distance ($($Pos.X),$($Pos.Y)) to ($($OPos.X),$($OPos.Y)): $Distance"

            $Antinode = [PSCustomObject]@{
                X = $Pos.X - $DistX
                Y = $Pos.Y - $DistY
            }
                
            if ($Antinode.X -lt 0 -or $Antinode.X -ge $Script:GridWidth -or $Antinode.Y -lt 0 -or $Antinode.Y -ge $Script:GridHeight )
            {
                Write-Host "Antinode: $Antinode out of bounds" -ForegroundColor Yellow
            }
            else
            {
                Write-Host "Antinode: $Antinode" -ForegroundColor Green
                
                if (! ($Antinodes["$($Antinode.X),$($Antinode.Y)"]))
                {
                    $Antinodes["$($Antinode.X),$($Antinode.Y)"] += $Antinode
                }
            }
        }
    }

    Write-Host "==="
}

Write-Host "Antinodes: $($Antinodes.Values.Count)"









# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"