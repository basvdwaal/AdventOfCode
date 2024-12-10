
Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions
#Endregion Functions

$ExtendedArray = New-Object System.Collections.ArrayList
$id = 0

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

# Write-Host $($ExtendedArray -join "|")

Write-host "Starting defrag..."

$LastIndex = @{}

For ($i = ($ExtendedArray.Count - 1); $i -ge 0; $i--)
{
    if ($i % 300 -eq 0)
    {
        Write-Progress -Activity "Defragging.." -Status $i -PercentComplete ($i/($ExtendedArray.Count - 1) * 100)
    }
    
    if ($ExtendedArray[$i] -eq ".")
    {
        continue
    }

    if ($LastIndex[1] -gt $i)
    {
        # No empty spaces left where we can move files to
        break
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
        if ($ExtendedArray[$j] -eq ".")
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
            
            # Write-Host $($ExtendedArray[0..50] -join "|")
            break
        }
    }
    
}

Write-Progress -Activity "Defragging.." -Completed

[int64]$TotalSum = 0
for ($i = 0; $i -lt $ExtendedArray.Count; $i++)
{
    if ($ExtendedArray[$i] -ne ".")
    {
        [Int64]$CheckSum = $i * [int]::Parse($ExtendedArray[$i])
        $TotalSum += $CheckSum
    }
}

Write-Host "Checksum: $TotalSum"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:23.8023160