
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
                # Write-Host "$Pattern equals $Towel"
                $options += 1
                return $options
            }
            
            $t = $Pattern[($Towel.Length)..($Pattern.Length - 1)] -join ""
            $options += Check-IfPossible -Pattern ($t)
        }
    }
    $Script:Cache[$Pattern] = $options

    return $options
}


#Endregion Functions

$Towels = $PuzzleInput[0] -split ", "
$Patterns = $PuzzleInput[2..$($PuzzleInput.Length-1)]
[Int64]$counter = 0
$Script:Cache = @{}
$Script:Count = @{}

foreach ($Pattern in $Patterns) 
{
    $res = Check-IfPossible $Pattern
    if ($res)
    { 
        # Write-Host "Patter: $pattern - Count: $res"
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