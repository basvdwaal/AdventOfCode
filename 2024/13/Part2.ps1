
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt -Raw) -split "`r`n`r`n"
$Clawmachines = New-Object System.Collections.ArrayList

foreach ($Item in $PuzzleInput)
{
    $item = $item -split "`r`n" 

    $Ax, $Ay = ($Item[0] -replace "Button A: X\+","" -replace " Y\+","" -split ",")
    $Bx, $By = ($Item[1] -replace "Button B: X\+","" -replace " Y\+","" -split ",")
    $Px, $Py = ($Item[2] -replace "Prize: X=","" -replace " Y=","" -split ",")

    [int64]$Px += 10000000000000
    [int64]$Py += 10000000000000

    [void]$Clawmachines.Add(@($Ax, $Ay, $Bx, $By, $Px, $Py))
}
# ======================================================================
# ======================================================================

$TotalCost = 0

foreach ($ClawMachine in $Clawmachines)
{
    [int64]$Ax, [int64]$Ay, [int64]$Bx, [int64]$By, [int64]$Px, [int64]$Py = $Clawmachine
    
    $Nb = ($Ax * $Py - $Ay * $Px) / ($Ax * $By - $Ay * $Bx)
    $Na = ($Px - $Bx * $Nb) / $Ax

    try
    {
        [Int64]::Parse($Na.ToString()) | Out-Null
        [Int64]::Parse($Nb.ToString()) | Out-Null
        $TotalCost += 3 * $Na + $Nb
    }
    catch
    {
        continue
    }
}

Write-Host "Total Cost: $Totalcost"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0350174