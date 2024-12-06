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

$count = 0

Write-Host "Generating grid.."
$grid, $gridHashtable = Convert-TextToGrid -TextLines (Get-Content $PSScriptRoot\Input.txt)

Write-Host "Starting Search.."
foreach ($StartPoint in $grid) {
    if ($StartPoint.Letter -eq 'A') {
        Write-Host "Found starting point ($($StartPoint.X),$($StartPoint.Y))"

        $TopLeftCoords = "$($StartPoint.X - 1),$($StartPoint.Y - 1)"
        $TopRightCoords = "$($StartPoint.X + 1),$($StartPoint.Y - 1)"
        $BottomLeftCoords = "$($StartPoint.X - 1),$($StartPoint.Y + 1)"
        $BottomRightCoords = "$($StartPoint.X + 1),$($StartPoint.Y + 1)"

        if (!($gridHashtable[$TopLeftCoords] -and $gridHashtable[$BottomRightCoords] -and $gridHashtable[$TopRightCoords] -and $gridHashtable[$BottomLeftCoords])) { continue }

        if (
            ($gridHashtable[$TopLeftCoords].Letter -eq 'M' -and $gridHashtable[$BottomRightCoords].Letter -eq 'S' -and $gridHashtable[$TopRightCoords].Letter -eq 'M' -and $gridHashtable[$BottomLeftCoords].Letter -eq 'S') -or `
            ($gridHashtable[$TopLeftCoords].Letter -eq 'S' -and $gridHashtable[$BottomRightCoords].Letter -eq 'M' -and $gridHashtable[$TopRightCoords].Letter -eq 'S' -and $gridHashtable[$BottomLeftCoords].Letter -eq 'M') -or `
            ($gridHashtable[$TopLeftCoords].Letter -eq 'M' -and $gridHashtable[$BottomRightCoords].Letter -eq 'S' -and $gridHashtable[$TopRightCoords].Letter -eq 'S' -and $gridHashtable[$BottomLeftCoords].Letter -eq 'M') -or `
            ($gridHashtable[$TopLeftCoords].Letter -eq 'S' -and $gridHashtable[$BottomRightCoords].Letter -eq 'M' -and $gridHashtable[$TopRightCoords].Letter -eq 'M' -and $gridHashtable[$BottomLeftCoords].Letter -eq 'S') 
        )
        {
            $count++
        }

    }
}
Write-Host "Count: $count"
