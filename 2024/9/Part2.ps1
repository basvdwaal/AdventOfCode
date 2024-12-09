
Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\SampleInput.txt)

# ======================================================================
# ======================================================================

#region Functions
#Endregion Functions

$ExtendedArray = New-Object System.Collections.ArrayList
$id = 0
$EmptyChar = [char]"."

Write-host "Creating Array..."
For ($i = 0; $i -lt $PuzzleInput.Length; $i++)
{
    $char = $PuzzleInput[$i]
    if ($i % 2 -eq 0)
    {
        # Current character indicates file length
        For ($j = 0; $j -lt [int]::Parse($char); $j++)
        {
            $ExtendedArray.Add($id) | Out-Null
        }
        $id++
    }
    else
    {
        # Current Char indicates free space
        For ($k = 0; $k -lt [int]::Parse($char); $k++)
        {
            $ExtendedArray.Add(".") | Out-Null
        }
    }
}

Write-host "Starting defrag..."

$MaxIndex = ($ExtendedArray.Count - 1)

For ($i = ($ExtendedArray.Count - 1); $i -gt 0; $i--)
{
    if ($i % 100 -eq 0)
    {
        Write-Progress -Activity "Defragging.." -Status "$($MaxIndex - $i)/$maxIndex" -PercentComplete ($($MaxIndex - $i)/$maxIndex * 100)
    }

    # From back to front, find last element & size
    $SubArr = New-Object System.Collections.ArrayList
    $FileID = $null
    while ($ExtendedArray[$i] -ne ".")
    {
        if (!($FileID))
        {
            $FileID = $ExtendedArray[$i]
        }

        $SubArr.Add($ExtendedArray[$i]) | Out-Null

        if ($FileID -ne $ExtendedArray[$i - 1])
        {
            # Next field is a different file id so the current file ends here.
            Break
        }
        else
        {
            $i--
        }
    }

    # Write-Host $($ExtendedArray -join "|")
    $GapNeeded = $SubArr.Count

    # Find first gap that fits
    $Gap = New-Object System.Collections.ArrayList
    For ($j = 0; $j -lt $ExtendedArray.Count; $j++)
    {
        # If Current index in gap search loop >= first element of file we are moving
        if ($j -ge $i)
        {
            break
        }
        if ([char]$ExtendedArray[$j] -eq $EmptyChar)
        {
            $Gap.Add($j) | Out-Null
        }
        else
        {
            # Clear the array if we find a non-empty space
            if ($Gap) {
                $Gap.Clear()
            }
        }

        if ($Gap.Count -ge $GapNeeded)
        {
            For ($k = 0; $k -le $SubArr.Count - 1; $k++)
            {
                $ExtendedArray[$Gap[$k]] = $SubArr[$K]
            }

            for ($l = $i; $l -le ($i + $SubArr.Count) - 1; $l++)
            {
                $ExtendedArray[$l] = "."
            }

            break
        }
    }
}

$($ExtendedArray -join "|") | out-file Output.txt

$CheckSum = 0
for ($i = 0; $i -lt $ExtendedArray.Count; $i++)
{
    if ([char]$ExtendedArray[$i] -ne $EmptyChar)
    {
        $CheckSum += $i * [int]::Parse($ExtendedArray[$i])
    }
}

Write-Host "Checksum: $CheckSum"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"