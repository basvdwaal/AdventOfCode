Set-StrictMode -Version latest

# Use a Generic List for performance instead of standard arrays
$FreshRanges = New-Object System.Collections.Generic.List[Object]

# 1. READ AND PARSE
# ======================================================================
# Ensure we handle the file path correctly
$InputPath = Join-Path $PSScriptRoot "input.txt"
if (-not (Test-Path $InputPath)) {
    Write-Error "Input file not found at $InputPath"
    exit
}

$PuzzleInput = Get-Content $InputPath

Write-Host "Reading and parsing file..." -ForegroundColor Cyan

foreach ($line in $PuzzleInput) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    # Parse "Start-End"
    $parts = $line.Split('-')
    
    # Cast to [int64] because the numbers are massive
    try {
        $Rs = [int64]$parts[0]
        $Re = [int64]$parts[1]
        
        # Add to list as a custom object or simple array
        $FreshRanges.Add(@{ Start = $Rs; End = $Re })
    }
    catch {
        # Write-Warning "Could not parse line: $line"
    }
}

$StartTime = Get-Date

# 2. SORT (Crucial Step)
# ======================================================================
# Sort by Start number. This allows us to merge in a single pass.
Write-Host "Sorting ranges..." -ForegroundColor Cyan
$SortedRanges = $FreshRanges | Sort-Object { $_.Start }

# 3. MERGE RANGES
# ======================================================================
Write-Host "Merging ranges..." -ForegroundColor Cyan

$MergedRanges = New-Object System.Collections.Generic.List[Object]

if ($SortedRanges.Count -gt 0) {
    # Initialize with the first range
    $CurrentStart = $SortedRanges[0].Start
    $CurrentEnd   = $SortedRanges[0].End

    for ($i = 1; $i -lt $SortedRanges.Count; $i++) {
        $NextStart = $SortedRanges[$i].Start
        $NextEnd   = $SortedRanges[$i].End

        # Check for Overlap OR Adjacency
        # We use ($CurrentEnd + 1) because if one range ends at 5 and next starts at 6, 
        # they are continuous integers (no gap).
        if ($NextStart -le ($CurrentEnd + 1)) {
            # Merge logic: Extend the current end if the next range goes further
            if ($NextEnd -gt $CurrentEnd) {
                $CurrentEnd = $NextEnd
            }
        }
        else {
            # Gap detected: Save the current range and start a new one
            $MergedRanges.Add(@{ Start = $CurrentStart; End = $CurrentEnd })
            $CurrentStart = $NextStart
            $CurrentEnd   = $NextEnd
        }
    }
    # Add the final range remaining in the variables
    $MergedRanges.Add(@{ Start = $CurrentStart; End = $CurrentEnd })
}

# 4. CALCULATE TOTAL
# ======================================================================
$total = [int64]0

foreach ($range in $MergedRanges) {
    # Formula: (End - Start) + 1 inclusive
    $count = ($range.End - $range.Start) + 1
    $total += $count
}

Write-Host "--------------------------------"
Write-Host "Total numbers included: $total" -ForegroundColor Green
Write-Host "Runtime: $((Get-Date) - $StartTime)"
Write-Host "--------------------------------"