
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions
#Endregion Functions

$ExtendedArray = New-Object System.Collections.ArrayList
$id = 0
$EmptyChar = [char]"."

For ($i = 0; $i -lt $PuzzleInput.Length; $i++)
{
    $char = $PuzzleInput[$i]
    if ($i % 2 -eq 0)
    {
        # Current character indicates file length
        For ($j = 0; $j -lt [int]::Parse($char); $j++)
        {
            $ExtendedArray.Add($id)
        }
        $id++
    }
    else
    {
        # Current Char indicates free space
        For ($k = 0; $k -lt [int]::Parse($char); $k++)
        {
            $ExtendedArray.Add(".")
        }
    }
}

$UpdatedArrayLength = $ExtendedArray.Count
for ($i = 0; $i -lt ($UpdatedArrayLength - 1); $i++)
{
    try
    {
        While ([char]$ExtendedArray[-1] -eq $EmptyChar)
        {
            $ExtendedArray.RemoveAt($ExtendedArray.Count - 1)
        }

        if ([char]$ExtendedArray[$i] -eq $EmptyChar)
        {
            $ExtendedArray[$i] = $ExtendedArray[-1]
            $ExtendedArray.RemoveAt($ExtendedArray.Count - 1)
            $UpdatedArrayLength = $ExtendedArray.Count
        }
    }
    catch
    {
        # Index out of bounds error because we remove dots at the end of the array but still try to iterate over them.
        break
    }

}

$CheckSum = 0
for ($i = 0; $i -lt $ExtendedArray.Count; $i++)
{
    $CheckSum += $i * [int]::Parse($ExtendedArray[$i])
}

Write-Host "Checksum: $CheckSum"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
