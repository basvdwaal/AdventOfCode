
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

$($ExtendedArray -join "|")

Write-host "Starting defrag..."

$MaxIndex = ($ExtendedArray.Count - 1)
$LastIndex = @{}

For ($i = ($ExtendedArray.Count - 1); $i -gt 0; $i--)
{
    if ([char]$ExtendedArray[$i] -eq $EmptyChar)
    {
        continue
    }
    
    if ($i % 100 -eq 0)
    {
        Write-Progress -Activity "Defragging.." -Status "$($MaxIndex - $i)/$maxIndex" -PercentComplete ($($MaxIndex - $i)/$maxIndex * 100)
    }

    # From back to front, find last element & size
    $FileSize = 0
    $FileID = $null
    while ($ExtendedArray[$i] -ne ".")
    {
        if (!($FileID))
        {
            $FileID = $ExtendedArray[$i]
        }

        $FileSize++

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
    # Find first gap that fits
    $Gap = 0
    
    if (! ($LastIndex.Keys -contains $FileSize))
    {
        $LastIndex[$FileSize] = 0
    }

    $ArrayLength = $ExtendedArray.Count
    For ($j = $LastIndex[$FileSize];  $j -lt $ArrayLength; $j++)
    {
        # If Current index in gap search loop >= first element of file we are moving
        if ($j -ge $i)
        {
            break
        }
        if ([char]$ExtendedArray[$j] -eq $EmptyChar)
        {
            $Gap++ 
        }
        else
        {
            $Gap = 0
        }

        if ($Gap -eq $FileSize)
        {
            For ($k = $j - $Gap + 1; $k -le $j; $k++)
            {
                $ExtendedArray[$k] = $FileID
                
            }

            for ($l = $i; $l -le ($i + $FileSize) - 1; $l++)
            {
                $ExtendedArray[$l] = "."
            }

            $LastIndex[$FileSize] = $j
            $($ExtendedArray -join "|")
            break
        }
    }
    
}

Write-Progress -Activity "Defragging.." -Completed

$($ExtendedArray -join "|") # | out-file Output.txt

$CheckSum = 0
for ($i = 0; $i -lt $ExtendedArray.Count; $i++)
{
    if ([char]$ExtendedArray[$i] -ne $EmptyChar)
    {
        Write-Host "$i * $([int]::Parse($ExtendedArray[$i])) = $($i * [int]::Parse($ExtendedArray[$i]))"
        $CheckSum += $i * [int]::Parse($ExtendedArray[$i])
    }
}

Write-Host "Checksum: $CheckSum"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"