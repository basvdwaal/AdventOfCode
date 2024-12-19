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

$count = 0

Write-Host "Generating grid.."
$Grid = Convert-TextToGrid -TextLines (Get-Content $PSScriptRoot\Input.txt)

Write-Host "Starting Search.."

foreach ($StartPoint in $Grid.Values) {
    if ($StartPoint.Letter -eq 'A') {
        # Write-Host "Found starting point ($($StartPoint.X),$($StartPoint.Y))"

        $TopLeftCoords = "$($StartPoint.X - 1),$($StartPoint.Y - 1)"
        $TopRightCoords = "$($StartPoint.X + 1),$($StartPoint.Y - 1)"
        $BottomLeftCoords = "$($StartPoint.X - 1),$($StartPoint.Y + 1)"
        $BottomRightCoords = "$($StartPoint.X + 1),$($StartPoint.Y + 1)"

        if (!($Grid[$TopLeftCoords] -and $Grid[$BottomRightCoords] -and $Grid[$TopRightCoords] -and $Grid[$BottomLeftCoords])) { continue }

        if (
            ($Grid[$TopLeftCoords].Letter -eq 'M' -and $Grid[$BottomRightCoords].Letter -eq 'S' -and $Grid[$TopRightCoords].Letter -eq 'M' -and $Grid[$BottomLeftCoords].Letter -eq 'S') -or `
            ($Grid[$TopLeftCoords].Letter -eq 'S' -and $Grid[$BottomRightCoords].Letter -eq 'M' -and $Grid[$TopRightCoords].Letter -eq 'S' -and $Grid[$BottomLeftCoords].Letter -eq 'M') -or `
            ($Grid[$TopLeftCoords].Letter -eq 'M' -and $Grid[$BottomRightCoords].Letter -eq 'S' -and $Grid[$TopRightCoords].Letter -eq 'S' -and $Grid[$BottomLeftCoords].Letter -eq 'M') -or `
            ($Grid[$TopLeftCoords].Letter -eq 'S' -and $Grid[$BottomRightCoords].Letter -eq 'M' -and $Grid[$TopRightCoords].Letter -eq 'M' -and $Grid[$BottomLeftCoords].Letter -eq 'S') 
        )
        {
            $count++
        }

    }
}
Write-Host "Count: $count"

Write-Host "Runtime: $((Get-Date) - $StartTime)"