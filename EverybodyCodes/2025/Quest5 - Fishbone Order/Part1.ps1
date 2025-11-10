
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions

function Add-NumberToFishbone ([int]$number, [array]$Fishbone)
{
    # Check all segments of the spine, starting from the top.
    # If your number is less than the one on the spine segment and the left side of the segment is free - place it on the left.
    # If your number is greater than the one on the spine segment and the right side of the segment is free - place it on the right.
    # If no suitable place is found at any segment, create a new spine segment from your number and place it as the last one.

    foreach ($Row in $Fishbone)
    {
        if (! $Row.left -and $number -lt $row.Spine)
        {
            $Row.left = $number
            return $Fishbone
        }

        if (! $Row.right -and $number -gt $row.Spine)
        {
            $Row.right = $number
            return $Fishbone
        }
    }

    $Fishbone += [PSCustomObject]@{
        Left  = $null
        Spine = $Number
        Right = $null 
    }

    return $Fishbone
}

#Endregion Functions

$Id, $str = $PuzzleInput -split ":"
$InputArr = New-Object System.Collections.ArrayList
$inputArr.AddRange([int[]]($str -split ",")) | Out-Null

$Fishbone = @()
foreach ($Number in $InputArr)
{
    $Fishbone = Add-NumberToFishbone -number $Number -Fishbone $Fishbone
}

$Fishbone

$total = ""
foreach ($row in $Fishbone)
{
    $total = "$total$($row.spine)"
}

Write-host "Spine: $total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0066587