
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample2.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

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


$Fishbones = @()

foreach ($line in $PuzzleInput)
{
    $Id, $str = $line -split ":"
    $InputArr = New-Object System.Collections.ArrayList
    $inputArr.AddRange([int[]]($str -split ",")) | Out-Null

    $Fishbone = @()
    foreach ($Number in $InputArr)
    {
        $Fishbone = Add-NumberToFishbone -number $Number -Fishbone $Fishbone
    }

    $total = ""
    foreach ($row in $Fishbone)
    {
        $total = "$total$($row.spine)"
    }

    $Fishbones += [PSCustomObject]@{
        ID = $Id
        Quality = [int64]$total
    }
}

[int64]$Highest = ($Fishbones | Sort-Object -Property Quality | select -Last 1).Quality
[int64]$Lowest = ($Fishbones | Sort-Object -Property Quality | select -First 1).Quality

Write-Host "Difference $($Highest - $Lowest)"



# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.1916875