
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

$Total = 0
[regex]$Regex = "\d"
foreach ($line in $PuzzleInput)
{
    $Numbers = $line.ToCharArray() -match $Regex
    $Total += [int]($Numbers[0], $Numbers[-1] -join "")
}

Write-Host "Total: $Total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0316936