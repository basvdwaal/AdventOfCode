
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
            if ($chars[$x] -eq ".")
            {
                $Grid[$x][$y] = [Int64]0
            }
            elseif ($chars[$x] -eq "S")
            {
                $Grid[$x][$y] = [Int64]1
            }
            else
            {
                $Grid[$x][$y] = $chars[$x]
            }
        }
    }

    $Script:GridWidth = $TextLines[0].Length
    $Script:GridHeight = $TextLines.Count

    return $Grid
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

            if ($pos -eq 0)
            {
                $pos = "."
            }
            [void]$arr.Add($Pos)
        }
        [void]$arr.Add("`r`n")
    }
    Write-Host $arr
}
#Endregion Functions


$Grid = Convert-TextToGrid -TextLines $PuzzleInput

for ($y = 1; $y -lt $PuzzleInput.Count; $y++)
{
    for ($x = 0; $x -lt $PuzzleInput[0].Length; $x++)
    {
        $Symbol = $Grid[$x][$y]
        $PrevSymbol = $Grid[$x][($y - 1)]
        
        if ($symbol.GetType() -eq [Int64] -and $PrevSymbol.GetType() -eq [Int64]) 
        {
            $Grid[$x][$y] += $PrevSymbol
        }
        elseif ($Symbol -eq "^" -and $PrevSymbol.GetType() -eq [Int64])
        {
            $Grid[($x - 1)][$y] += $PrevSymbol
            $Grid[($x + 1)][$y] += $PrevSymbol
        }

        # Write-GridToScreen -Grid $Grid
    }

    # $null
}

$output = @()

foreach ($col in $Grid.Values)
{
    $output += $col[($PuzzleInput.Count - 1)]
}

$Total = $output | Measure-Object -Sum | select -ExpandProperty sum

Write-Host "Total: $Total"

# ======================================================================
# ======================================================================
Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.3325545