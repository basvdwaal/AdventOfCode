
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions

function Check-IfPossible ($Pattern)
{
    if ($Script:Cache[$Pattern])
    {
        return $Script:Cache[$Pattern]
    }
        
    foreach ($Towel in $Towels)
    {
        if ($Pattern.StartsWith($Towel))
        {
            if ($Pattern -eq $Towel) { 
                $Script:Cache[$Pattern] = $true
                return $true
            }
            
            $t = $Pattern[($Towel.Length)..($Pattern.Length - 1)] -join ""
            $res = Check-IfPossible -Pattern ($t)
            if ($res) {
                $Script:Cache[$Pattern] = $true
                return $true
            }
        }
    }
    $Script:Cache[$Pattern] = $false
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
        Write-Host $Pattern -ForegroundColor Green
        $counter++
    }
    else
    {
        Write-Host $Pattern -ForegroundColor Red
    }
}

Write-Host "Total possible: $counter"
# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"