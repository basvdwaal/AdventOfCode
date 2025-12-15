
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

            if ($pos)
            {
                [void]$arr.Add($Pos)
            }
        }
        [void]$arr.Add("`r`n")
    }
    Write-Host $arr
}
#Endregion Functions


$PuzzleInput[0] = $PuzzleInput[0] -replace "S", "|"

$Grid = Convert-TextToGrid -TextLines $PuzzleInput
$count = 0

for ($y = 1; $y -lt $PuzzleInput.Count; $y++)
{
    for ($x = 0; $x -lt $PuzzleInput[0].Length; $x++)
    {
        $Symbol = $Grid[$x][$y]
        $PrevSymbol = $Grid[$x][($y - 1)]
        
        if ($symbol -eq "." -and $PrevSymbol -eq "|")
        {
            $Grid[$x][$y] = "|"
        }
        elseif ($Symbol -eq "^" -and $PrevSymbol -eq "|")
        {
            $Grid[($x - 1)][$y] = "|"
            $Grid[($x + 1)][$y] = "|"
            $count++
        }

        # Write-GridToScreen -Grid $Grid
    }
}


Write-Host "Total: $count"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.1616801