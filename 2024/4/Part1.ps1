Set-StrictMode -Version latest

function Convert-TextToGrid {
    param (
        [string[]]$TextLines
    )

    # Resultaat grid
    $grid = @()

    for ($y = 0; $y -lt $TextLines.Count; $y++) {
        $line = $TextLines[$y]
        for ($x = 0; $x -lt $line.Length -1; $x++) {
            $letter = $line[$x]
            $grid += [PSCustomObject]@{
                X      = $x
                Y      = $y
                Letter = $letter
            }
        }
    }

    return $grid
}

function Check-SurroundingCoords {
    param (
        $StartingCoords,
        $LetterToFind
    )

    $arr = @()
    for ($y = $StartingCoords.Y - 1; $y -lt $StartingCoords.Y + 2; $y++)
    {
        Write-Host "Checking Y=$y"
        for ($x = $StartingCoords.X - 1; $x -lt $StartingCoords.X + 2; $x++)
        {
            Write-Host "Checking X=$X"
            $Item = $grid | where {$_.X -eq $x -and $_.Y -eq $Y}
            if ($item -and $Item.Letter -eq $LetterToFind)
            {
                $arr += $Item
                Write-Host "Found Letter $($item.Letter)"
            }
        }
    }

    if (($arr | Measure-Object).Count -gt 0)
    {
        return $arr
    }
    else
    {
        return $false
    }
}

$SampleInput = @"
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"@ -split "`n"


$Script:grid = Convert-TextToGrid -TextLines $SampleInput

foreach ($Item in $grid)
{
    if ($Item.Letter -eq 'X' -or $Item.Letter -eq 'S')
    {
        if ($Item.Letter -eq 'X') {$WordToFind = 'XMAS'}
        elseif ($Item.Letter -eq 'S') {$WordToFind = 'SAMX'}

        $LetterToFind = ($word -replace $Item.Letter, '')[0]
        Write-Host "Found $($item.Letter) on X=$($item.X),Y=$($item.Y), finding $LetterToFind"

        # Check surrounding grid coords for the next letter
        [array]$res = Check-SurroundingCoords -StartingCoords $Item -LetterToFind $LetterToFind
        foreach ($seconditem in $res)
        {
            Write-Host "Found $($seconditem.Letter) on X=$($seconditem.X),Y=$($seconditem.Y)"






        }
    }
}