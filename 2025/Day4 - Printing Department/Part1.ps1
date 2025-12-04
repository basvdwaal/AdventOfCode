
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

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
            $Grid[$x][$y] = $chars[$x]
        }
    }

    $Script:GridWidth = $TextLines[0].Length
    $Script:GridHeight = $TextLines.Count

    return $Grid
}

#Endregion Functions

$Directions = @(
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y = 0 },
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y = 0 },
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y = 1 },
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y = -1 },
    [PSCustomObject]@{ Direction = "TopRight"; X = 1; Y = 1 },
    [PSCustomObject]@{ Direction = "TopLeft"; X = -1; Y = 1 },
    [PSCustomObject]@{ Direction = "BottomRight"; X = 1; Y = -1 },
    [PSCustomObject]@{ Direction = "BottomLeft"; X = -1; Y = -1 }
)

$grid = Convert-TextToGrid -TextLines $PuzzleInput

$Total = 0
for ($x = 0; $x -lt $grid.Count; $x++)
{
    for ($y = 0; $y -lt $grid[$x].Count; $y++)
    {
        if ($grid[$x][$y] -ne "@") { continue }
        $counter = 0
        # Write-host "$x,$y"
        foreach ($Direction in $Directions)
        {
            $Tx = $x + $Direction.X
            $Ty = $y + $Direction.y

            if (! $grid[$Tx]) { continue }
            if (! $grid[$Tx][$Ty]) { continue }

            if ($grid[$Tx][$Ty] -eq "@")
            {
                # Write-host "$Tx,$Ty -> @"
                $counter++
            }
        }

        if ($counter -lt 4)
        {
            $Total++
            # $Write-host "Total++"
        }
    }
}

Write-host "Total: $total"

# ======================================================================
# ======================================================================

Write-host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.4743046