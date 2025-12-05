
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$total = 0
$Fresh = @()
:outer
Foreach ($line in $PuzzleInput)
{

    if ($line -like "*-*")
    {
        $Begin, $End = [int64[]]($line -split "-")
        $Fresh += ,@($Begin,$end)
    }
    elseif ($line -eq '') { continue }
    else
    {
        $id = [int64]::Parse($line)

        foreach ($Range in $Fresh)
        {
            if ($Id -ge $Range[0] -and $id -le $Range[1] )
            {
                $total++
                continue outer
            }
        }
    }
}

Write-host "Total: $total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.1177826