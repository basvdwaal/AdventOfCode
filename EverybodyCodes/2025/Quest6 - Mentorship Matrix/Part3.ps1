
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample3.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input3.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions

$LT = @{
    [char]'a' = [char]'A'
    [char]'b' = [char]'B'
    [char]'c' = [char]'C'
}


#Endregion Functions

$Offset = 1000
$modifier = 10

$Arr = ($PuzzleInput * $modifier).ToCharArray() 
$total = 0

for ($i = 0; $i -lt $Arr.Count; $i++)
{
    # Skip mentors
    if ($Arr[$i] -ceq 'A' -or $Arr[$i] -ceq [char]'B' -or $Arr[$i] -ceq [char]'C') { continue }
    
    # Determine slice
    $startIndex = [System.Math]::Max(0, $i - $offset)
    $endIndex = [System.Math]::Min($Arr.Length - 1, $i + $offset)


    # $length = $endIndex - $startIndex + 1
    # $subArr = New-Object char[] $length

    # 4. Voer de high-speed kopieeractie uit
    #    Syntaxis: [array]::Copy(sourceArray, sourceIndex, destinationArray, destinationIndex, length)
    # [array]::Copy($Arr, $startIndex, $subArr, 0, $length)


    $SubArr = $Arr[$startIndex..$endIndex]

    # Loop over $SubArr and count occurences of MentorType
    $MentorType = $LT[$arr[$i]]
    # $count = 0

    $temp = ($SubArr -ceq $MentorType)
    # $temp = $SubArr | where { $_ -eq $MentorType}
    $total += $temp.count


    # foreach ($Person in $SubArr)
    # {
    #     if ($person -eq $MentorType) { $count++ }
    # }
    # $total += $count

    # $groups = $SubArr| Group-Object 
    # $Type = $groups | where { $_.Name -ceq $LT.($Arr[$i]) }
    # $total += $Type.Count
    
}

write-host "Total: $total"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"