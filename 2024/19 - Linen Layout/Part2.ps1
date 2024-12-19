
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions

function Check-IfPossible ($Pattern)
{
    # Write-Host "Checking $Pattern"
    #$s = $Script:Cache[$Pattern]
    #if ($s -eq $null) { $s = -1}
    #if ($s -gt -1)
    if ($null -ne $Script:Cache[$Pattern])
    {
        # Write-Host "$Pattern found in cache, returning $($Script:Cache[$Pattern])"
        return $Script:Cache[$Pattern]
    }

    $options = 0
    foreach ($Towel in $Towels)
    {
        if ($Pattern.StartsWith($Towel))
        {

            if ($Pattern -eq $Towel) {
                # Write-Host "$Pattern equals $Towel" -ForegroundColor Green
                $options += 1
            }
            # Write-Host "$Pattern starts with $Towel"
            try
            {
                $t = $Pattern[($Towel.Length)..($Pattern.Length - 1)] -join ""
            }
            catch
            {
                continue
            }
            $options += Check-IfPossible -Pattern ($t)
            # Write-Host "continuing with $pattern"
        }
        else
        {
            # Write-Host "Skipping $towel"
        }
    }
    $Script:Cache[$Pattern] = $options
    # Write-Host "returning $Options"
    return $options
}


#Endregion Functions

$Towels = $PuzzleInput[0] -split ", "
$Patterns = $PuzzleInput[2..$($PuzzleInput.Length-1)]
[Int64]$counter = 0
$Script:Cache = @{}

foreach ($Pattern in $Patterns)
{
    $res = Check-IfPossible $Pattern
    if ($res)
    {
        # Write-Host "Pattern: $pattern - Count: $res"
        $counter += $res
    }
    else
    {
        # Write-Host $Pattern -ForegroundColor Red
    }
}

Write-Host "Total possibilities: $counter"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:29.3558061