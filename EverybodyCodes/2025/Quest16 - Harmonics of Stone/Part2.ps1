
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample2.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

# Create a list and append 0 to match index with step
$list = [int[]]0
$list += [int[]]($PuzzleInput -split ",") 
$Instructions = @()

for ($i = 0; $i -lt $list.Count; $i++)
{
    if ($list[$i] -gt 0)
    {
        $Instructions += $I
        for ($j = 0; $j -lt $list.Count; $j++)
        {
            # Subtract one every $i ste
            if ($j % $i -eq 0)
            {
                $list[$j]--
            }
        }
    }
    elseif ($list[$i] -lt 0)
    {
        Write-Host "Logic error found: $i is below 0!"
        break
    }
}

$total = $Instructions[0]
foreach ($i in $Instructions[1..($Instructions.Length -1)])
{
    $total *= $i
}

Write-Host $total

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0007246