
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions

function Check-IfPossible ($Pattern)
{
    # Write-Host "Checking $Pattern"
    if ($Script:Cache[$Pattern])
    {
        # Write-Host "$Pattern found in cache, returning $($Script:Cache[$Pattern])"
        return $Script:Cache[$Pattern] -eq 1 ? $true : $False
    }
        
    foreach ($Towel in $Towels)
    {
        if ($Pattern.StartsWith($Towel))
        {
            if ($Pattern -eq $Towel) { 
                # Write-Host "$Pattern equals $Towel"
                $Script:Cache[$Pattern] = 1
                return $true
            }
            
            $t = $Pattern[($Towel.Length)..($Pattern.Length - 1)] -join ""
            $res = Check-IfPossible -Pattern ($t)
            if ($res) {
                $Script:Cache[$Pattern] = 1
                return $true
            }
        }
    }
    # Write-Host "$Pattern did not match any Towel"
    $Script:Cache[$Pattern] = -1
    return $False
}


#Endregion Functions

$Towels = $PuzzleInput[0] -split ", "
$Patterns = $PuzzleInput[2..$($PuzzleInput.Length-1)]
$counter = 0
$Script:Cache = @{}

foreach ($Pattern in $Patterns) 
{
    $res = Check-IfPossible $Pattern
    if ($res)
    { 
        # Write-Host $Pattern -ForegroundColor Green
        $counter++
    }
    else
    {
        # Write-Host $Pattern -ForegroundColor Red
    }
}

Write-Host "Total possible: $counter"
# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:04.1038480