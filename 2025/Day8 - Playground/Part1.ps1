
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions

function Get-Distance ($PointA, $PointB)
{
    # Calculate Euclidean distance

    $XDif = $PointA[0] - $PointB[0]
    $YDif = $PointA[1] - $PointB[1]
    $ZDif = $PointA[2] - $PointB[2]

    # return [Math]::Sqrt( ($XDif * $XDif) + ($YDif * $YDif) + ($ZDif * $ZDif) )
    # Ignore the Square root since the actual distance doesnt matter, only the order
    return ( ($XDif * $XDif) + ($YDif * $YDif) + ($ZDif * $ZDif) )
}


#Endregion Functions

$Points = @()
foreach ($point in $PuzzleInput)
{
    $Points += ,@($point -split ",")
}

$DistList = New-Object System.Collections.Generic.HashSet[pscustomObject]

foreach ($Startpoint in $Points)
{
    foreach ($Targetpoint in $Points)
    {
        if ($Startpoint -eq $Targetpoint) { $continue }

        $Distance = Get-Distance -PointA $Startpoint -PointB $Targetpoint
        [void]$DistList.Add(
            [PSCustomObject]@{
                Start = $Startpoint
                End = $Targetpoint
                Distance = $Distance
            }
        )
    }
}


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"



# https://ssojet.com/data-structures/implement-disjoint-set-in-powershell/