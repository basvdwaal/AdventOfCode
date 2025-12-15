
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

# Use a Generic List for performance instead of standard arrays
$FreshRanges = New-Object System.Collections.Generic.List[Object]
foreach ($line in $PuzzleInput)
{
    if ([string]::IsNullOrWhiteSpace($line)) { break }

    $parts = $line.Split('-')
    
    $FreshRanges.Add(@{ 
            Start = [int64]$parts[0]
            End   = [int64]$parts[1]
        })
}

$SortedRanges = $FreshRanges | Sort-Object { $_.Start }

$MergedRanges = New-Object System.Collections.Generic.List[Object]

# Initialize with the first range
$CurrentStart = $SortedRanges[0].Start
$CurrentEnd = $SortedRanges[0].End

for ($i = 1; $i -lt $SortedRanges.Count; $i++)
{
    $NextStart = $SortedRanges[$i].Start
    $NextEnd = $SortedRanges[$i].End

    # Check for Overlap OR Adjacency
    # We use ($CurrentEnd + 1) because if one range ends at 5 and next starts at 6, 
    # they are continuous integers (no gap).
    if ($NextStart -le ($CurrentEnd + 1))
    {
        # Merge logic: Extend the current end if the next range goes further
        if ($NextEnd -gt $CurrentEnd)
        {
            $CurrentEnd = $NextEnd
        }
    }
    else
    {
        # Gap detected: Save the current range and start a new one
        $MergedRanges.Add(@{ Start = $CurrentStart; End = $CurrentEnd })
        $CurrentStart = $NextStart
        $CurrentEnd = $NextEnd
    }
}

# Add the final range remaining in the variables
$MergedRanges.Add(@{ Start = $CurrentStart; End = $CurrentEnd })

$total = [int64]0

foreach ($range in $MergedRanges)
{
    $count = ($range.End - $range.Start) + 1
    $total += $count
}
    
Write-host "Total: $total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"