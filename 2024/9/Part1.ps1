
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions
#Endregion Functions

$ExtendedArray = New-Object System.Collections.ArrayList
$id = 0

For($i = 0;$i -lt $PuzzleInput.Length;$i++)
{
    $char = $PuzzleInput[$i]
    if ($i % 2 -eq 0) 
    {
        # Current character indicates file length
        # $ExtendedArray.Add([string]$id * [int]::Parse($char)) | Out-Null

        # $ExtendedArray.Add(
        #     [PSCustomObject]@{
        #         Id = $id
        #         Length = [int]::Parse($char)
                
        #     }
        # ) | Out-Null
        
        For($j = 0;$j -lt [int]::Parse($char);$j++)
        {
            $ExtendedArray.Add($id) | Out-Null
        }
        $id++
    }
    else
    {
        # Current Char indicates free space
        # $ExtendedArray.Add(
        #     [PSCustomObject]@{
        #         Id = "."
        #         Length = [int]::Parse($char)
                
        #     }
        # ) | Out-Null
        For($k = 0;$k -lt [int]::Parse($char);$k++)
        {
            $ExtendedArray.Add(".") | Out-Null
        }
    }
}

# Convert the Array into a single digit array
# [System.Collections.ArrayList]$ExtendedArray = ($ExtendedArray -join "").ToCharArray()
# Write-Host ($ExtendedArray -join "")

$UpdatedArrayLength = $ExtendedArray.Count
for ($i = 0; $i -lt ($UpdatedArrayLength - 1); $i++)
{
    try
    {
        While ($ExtendedArray[-1] -eq '.')
        {
            $ExtendedArray.RemoveAt($ExtendedArray.Count - 1)
        }

        if ($ExtendedArray[$i] -eq '.')
        {
            $ExtendedArray[$i] = $ExtendedArray[-1]
            $ExtendedArray.RemoveAt($ExtendedArray.Count - 1)
            $UpdatedArrayLength = $ExtendedArray.Count
            # Write-Host ($ExtendedArray -join "")
        }
    }
    catch
    {
        $_
    }

}

$CheckSum = 0
for ($i = 0; $i -lt $ExtendedArray.Count; $i++)
{
    # Write-Host "$i * $($ExtendedArray[$i]) = $($i * [int]::Parse($ExtendedArray[$i]))"
    $CheckSum += $i * [int]::Parse($ExtendedArray[$i])
}

Write-Host "Checksum: $CheckSum"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"