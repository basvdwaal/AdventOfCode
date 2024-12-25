
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt -Raw) -split "`r`n`r`n"

# ======================================================================
# ======================================================================

#region Functions
function Get-LockHeight
{
    param (
        [string[]]$TextLines
    )

    $Values = New-Object System.Collections.SortedList

    :outer
    for ($x = 0; $x -lt $TextLines[0].Length; $x++)
    {
        for ($y = 0; $y -lt $TextLines.Count; $y++)
        {
            if ($TextLines[$y][$x] -eq ".")
            {
                $Values[$x] = $y - 1 # Subtract 1 to get the height of the lock 
                continue outer
            }
        }
    }

    return $Values
}

function Get-KeyHeight
{
    param (
        [string[]]$TextLines
    )

    $Values = New-Object System.Collections.SortedList

    :outer
    for ($x = 0; $x -lt $TextLines[0].Length; $x++)
    {
        for ($y = $TextLines.Count - 1; $y -ge 0; $y--)
        {
            if ($TextLines[$y][$x] -eq ".")
            {
                $Values[$x] = ($TextLines.Count - 1) - $y - 1 # Subtract 1 to get the height of the key 
                continue outer
            }
        }
    }

    return $Values
}


#Endregion Functions

$Locks = [System.Collections.ArrayList]::new()
$Keys = [System.Collections.ArrayList]::new()

# Parse each key/lock into the proper format and add these to an array
foreach ($Puzzle in $PuzzleInput)
{
    $Lines = $Puzzle -split "`r`n"
    
    if ($Lines[0][0] -eq ".")
    {
        # Puzzle is a key
        [void]$Keys.Add( (Get-KeyHeight $Lines) )
    }
    else
    {
        # Puzzle is a lock
        [void]$Locks.Add( (Get-LockHeight $Lines) )
    }
}


# Compare each key with each lock to see if it fits
$total = 0

foreach ($Lock in $Locks)
{
    :keys
    foreach ($Key in $Keys)
    {
        foreach ($Index in $key.Keys)
        {
            if ($Key[$Index] + $lock[$Index] -gt 5) 
            {
                # If the sum of the key and lock height is greater than 5 the key wont fit
                # Write-Host "Key: $($key.Values) Lock: $($lock.Values)" -ForegroundColor Red
                continue keys
            }
        }

        # Write-Host "Key: $($key.Values) Lock: $($lock.Values)" -ForegroundColor Green
        $total++
    }
}

Write-Host "Total: $total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:01.3132499