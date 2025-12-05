
Set-StrictMode -Version latest

$PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
# $PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================


$total = 0
$FreshRanges = @()

Foreach ($line in $PuzzleInput)
{
    
    $FreshRanges += ,@($Rs,$Re)
        
    # Stop after the ranges
    if ($line -eq '') { break }

}

# Iterate over the ranges untill we can't compress anymore
do 
{
    $Didsomething = $false
    :outer
    foreach ($Range1 in $FreshRanges)
    {
        foreach ($Range2 in $FreshRanges)
        {
            # check if a range lies within another range
            if ($Rs -gt $Range2[0] -and $Re -lt $Range2[1])
            {
                Write-Host "Range $Rs - $Re lies within $($Range2[0]) - $($Range2[1])!"
                $FreshRanges.Remove($Range1[0],$Range1[1])
                $Didsomething = $true
                continue outer
            }
            
            # Check if a range completely overlaps
            if ($Rs -lt $Range2[0] -and $Re -gt $Range2[1])
            {
                Write-Host "Range $($Range2[0]) - $($Range2[1]) lies within $Rs - $Re! Expanding range.."
                $Range2[0] = $Rs
                $Range2[1] = $Re
                $Didsomething = $true
                continue outer
            }
    
            # Check partial overlaps
            if ($Rs -lt $Range2[0] -and ($Re -gt $Range2[1] -and $Re -le $Range2[1]) )
            {
                Write-Host "Range $Rs - $Re partially overlaps with range $($Range2[0]) - $($Range2[1])! Expanding range.."
                $Range2[0] = $Rs
                continue outer
            }
    
            if (($Rs -ge $Range2[0] -and $Rs -le $Range2[1]) -and $Re -gt $Range2[1])
            {
                Write-Host "Range $Rs - $Re partially overlaps with range $($Range2[0]) - $($Range2[1])! Expanding range.."
                $Range2[1] = $Re
                continue outer
            }
        }
    }
} while ( $Didsomething -eq $true )
    
Write-host "Total: $total"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"