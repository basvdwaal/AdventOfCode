Set-StrictMode -Version latest

function Convert-TextToGrid {
    param (
        [string[]]$TextLines
    )

    # Resultaat grid
    $grid = @()
    $gridHashtable = @{}

    for ($y = 0; $y -lt $TextLines.Count; $y++) {
        $line = $TextLines[$y]
        for ($x = 0; $x -lt $line.Length; $x++) {
            $letter = $line[$x]
            $obj = [PSCustomObject]@{
                X      = $x
                Y      = $y
                Letter = $letter
            }
            $grid += $obj

            $key = "$x,$y"
            $gridHashtable[$key] = $obj
        }
    }

    return $grid, $gridHashtable
}

$Directions = @(
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y =  0},
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y =  0},
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y =  1},
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y =  -1},
    [PSCustomObject]@{ Direction = "TopRight"; X = 1; Y =  1},
    [PSCustomObject]@{ Direction = "TopLeft"; X = -1; Y =  1},
    [PSCustomObject]@{ Direction = "BottomRight"; X = 1; Y =  -1},
    [PSCustomObject]@{ Direction = "BottomLeft"; X = -1; Y =  -1}
)

$count = 0

Write-Host "Generating grid.."
$grid, $gridHashtable = Convert-TextToGrid -TextLines (Get-Content $PSScriptRoot\Input.txt)

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
# Convert-GridToStringArray -Grid $grid

Write-Host "Starting Search.."
foreach ($StartPoint in $grid) {
    if ($StartPoint.Letter -eq 'X') {
        # Write-Host "Found starting point ($($StartPoint.X),$($StartPoint.Y))"
        foreach ($Direction in $Directions)
        {
            $Point2 = $gridHashtable["$($StartPoint.X + $Direction.X),$($StartPoint.Y + $Direction.Y)"]
            if ($Point2 -and $Point2.Letter -eq 'M')
            {
                $Point3 = $gridHashtable["$($Point2.X + $Direction.X),$($Point2.Y + $Direction.Y)"]
                if ($Point3 -and $Point3.Letter -eq 'A')
                {
                    $Point4 = $gridHashtable["$($Point3.X + $Direction.X),$($Point3.Y + $Direction.Y)"]
                    if ($Point4 -and $Point4.Letter -eq 'S')
                    {
                        # Write-Host "Found XMAS: ($($Startpoint.X),$($Startpoint.Y)) to ($($Point4.X),$($Point4.Y))"
                        $count++
                    }
                }
            }

        }
    }
}
Write-Host "Count: $count"
