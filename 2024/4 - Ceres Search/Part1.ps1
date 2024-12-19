Set-StrictMode -Version latest
$StartTime = Get-Date

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
            }
            $Grid["$x,$y"] = $obj
        }
    }

    return $Grid
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
$Grid = Convert-TextToGrid -TextLines (Get-Content $PSScriptRoot\Input.txt)

Write-Host "Starting Search.."
foreach ($StartPoint in $Grid.Values) {
    if ($StartPoint.Letter -eq 'X') {
        # Write-Host "Found starting point ($($StartPoint.X),$($StartPoint.Y))"
        foreach ($Direction in $Directions)
        {
            $Point2 = $Grid["$($StartPoint.X + $Direction.X),$($StartPoint.Y + $Direction.Y)"]
            if ($Point2 -and $Point2.Letter -eq 'M')
            {
                $Point3 = $Grid["$($Point2.X + $Direction.X),$($Point2.Y + $Direction.Y)"]
                if ($Point3 -and $Point3.Letter -eq 'A')
                {
                    $Point4 = $Grid["$($Point3.X + $Direction.X),$($Point3.Y + $Direction.Y)"]
                    if ($Point4 -and $Point4.Letter -eq 'S')
                    {
                        Write-Host "Found XMAS: ($($Startpoint.X),$($Startpoint.Y)) to ($($Point4.X),$($Point4.Y))"
                        $count++
                    }
                }
            }

        }
    }
}
Write-Host "Count: $count"

Write-Host "Runtime: $((Get-Date) - $StartTime)"