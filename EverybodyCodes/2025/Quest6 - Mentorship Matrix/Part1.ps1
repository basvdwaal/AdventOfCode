
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$Sw = $PuzzleInput.ToCharArray() | where {$_ -eq [char]"A" -or $_ -eq [char]"a"}

$Pairs = 0
# for each student
for ($i = 0; $i -lt $Sw.Count; $i++)
{
    if ($Sw[$i] -ceq [char]'A') { continue }  # Skip mentors

    # For each of the previous positions, count the number of mentors
    for ($j = 0; $j -lt $i; $j++)
    {
        if ($Sw[$j] -ceq [char]'A')
        {
            $Pairs++
        }
    }
}

write-host "Pairs: $pairs"
# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"