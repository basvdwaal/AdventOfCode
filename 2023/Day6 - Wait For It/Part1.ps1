
Set-StrictMode -Version latest
$StartTime = Get-Date

# Sample input
# 
# $PuzzleInput = @(
#     @(7,9),
#     @(15,40),
#     @(30,200)    
# )

# ======================================================================
# ======================================================================

#region Functions

#Endregion Functions

$TotalRecords = $null

Foreach ($race in $PuzzleInput)
{
    $Time, $Record, $null = $race
    $RecordCounter = 0

    Foreach ($HoldTime in 0..$Time)
    {
        $MoveTime = $Time - $HoldTime
        $Distance = $MoveTime * $HoldTime  # Holdtime is equal to the speed

        if ($Distance -gt $Record)
        {
            $Colour = 'Green'
            $RecordCounter++

        }
        else
        {
            $Colour = 'white'
        }
        # Write-Host "Holdtime: $HoldTime. Distance: $Distance" -ForegroundColor $colour
    }
    # Write-Host "Number of records: $RecordCounter"

    if (! $TotalRecords)
    {
        $TotalRecords = $RecordCounter
    }
    else
    {
        $TotalRecords = $TotalRecords * $RecordCounter    
    }

}

Write-Host "Total: $TotalRecords"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0028417