
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample3.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input3.txt)

$StartTime = Get-Date

$ErrorActionPreference = 'break'
# ======================================================================
# ======================================================================

#region Functions

$LT = @{
    [char]'a' = [char]'A'
    [char]'b' = [char]'B'
    [char]'c' = [char]'C'
}


#Endregion Functions

function calculate($Str, $Offset)
{
    $Arr = $Str.ToCharArray()
    $total = 0

    $Counts = @{
        [char]'A' = 0
        [char]'B' = 0
        [char]'C' = 0
    }

    [System.Collections.ArrayList]$slice = $arr[0..$offset]

    foreach ($Letter in $slice)
    {
        if ($Letter -cin [char]'A', [char]'B', [char]'C')
        {
            $Counts[$Letter] += 1
        }
    }


    for ($i = 0; $i -lt $Arr.Count; $i++)
    {
        $Letter = [char]$Arr[$i]
        if ($Letter -cin [char]'a', [char]'b', [char]'c')
        {
            $total += $Counts[$LT[$Letter]]
        }

        # Extend slice by 1 if we can. Also update counts dict if letter is a capital
        if ($i + ($Offset + 1) -lt $arr.Length)
        {   
            $NextLetter = [char]$arr[$i + ($offset + 1)]
            $slice.add($NextLetter) | Out-Null
            if ($NextLetter -cin [char]'A', [char]'B', [char]'C')
            {
                $Counts[$NextLetter] += 1
            }
        }
        
        # Remove first letter from slice if minimum length has been reached.
        if ($i -ge $Offset)
        {
            $PrevLetter = [char]$slice[0]
            if ($PrevLetter -cin [char]'A', [char]'B', [char]'C')
            {
                $Counts[$PrevLetter] -= 1
            }
            $slice.RemoveAt(0)
        }
    }

    return $total
}

$offset = 1000

$One = calculate -str $PuzzleInput -Offset $offset
$Two = calculate -str ($PuzzleInput * 2) -Offset $offset

$total = $one + ($Two - $one) * 999

write-host "Total: $total"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:02:20.0960542
# Runtime (Optimized): 00:00:00.3971510