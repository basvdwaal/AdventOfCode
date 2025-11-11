
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample2.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$A = $PuzzleInput.ToCharArray() | where {$_ -eq [char]"A" -or $_ -eq [char]"a"}
$B = $PuzzleInput.ToCharArray() | where {$_ -eq [char]"B" -or $_ -eq [char]"b"}
$C = $PuzzleInput.ToCharArray() | where {$_ -eq [char]"C" -or $_ -eq [char]"c"}


$Pairs = 0





# for each student
for ($i = 0; $i -lt $A.Count; $i++)
{
    if ($A[$i] -ceq [char]'A') { continue }  # Skip mentors

    # For each of the previous positions, count the number of mentors
    for ($j = 0; $j -lt $i; $j++)
    {
        if ($A[$j] -ceq [char]'A')
        {
            $Pairs++
        }
    }
}

# for each student
for ($i = 0; $i -lt $B.Count; $i++)
{
    if ($B[$i] -ceq [char]'B') { continue }  # Skip mentors

    # For each of the previous positions, count the number of mentors
    for ($j = 0; $j -lt $i; $j++)
    {
        if ($B[$j] -ceq [char]'B')
        {
            $Pairs++
        }
    }
}

# for each student
for ($i = 0; $i -lt $C.Count; $i++)
{
    if ($C[$i] -ceq [char]'C') { continue }  # Skip mentors

    # For each of the previous positions, count the number of mentors
    for ($j = 0; $j -lt $i; $j++)
    {
        if ($C[$j] -ceq [char]'C')
        {
            $Pairs++
        }
    }
}


write-host "Pairs: $pairs"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"