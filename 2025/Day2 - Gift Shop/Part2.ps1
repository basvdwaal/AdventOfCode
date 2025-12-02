
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$regex = [regex]"^(?<First>\d+)\k<First>+$"
$Total = 0

foreach($Range in $PuzzleInput -split ",")
{
    [int64]$Begin, [int64]$End = ($Range -split "-")

    for ($number = $begin; $number -le $end; $number++)
    {
        if ($number -match $regex)
        {
            # Write-Host "$number is fake"
            $Total += $number
        }
    }
}

write-host $Total


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:05.7948134