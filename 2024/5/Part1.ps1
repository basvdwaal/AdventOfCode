
Set-StrictMode -Version latest
$StartTime = Get-Date

$Rules = New-Object System.Collections.ArrayList
$LinesToCheck = New-Object System.Collections.ArrayList
Get-Content $PSScriptRoot\Rules.txt | foreach {$Rules.Add(@($_ -split "\|"))} | Out-Null
$LinesStr = (Get-Content $PSScriptRoot\Lines.txt)
foreach ($line in $LinesStr)
{
    $arr = $line -split ","
    $LinesToCheck.Add($arr) | Out-Null
}
# ======================================================================
# ======================================================================

#region Functions
#Endregion Functions

$Total = 0
:Line
foreach ($Line in $LinesToCheck)
{
    for ($Index = 0; $Index -lt $Line.Length; $Index++) 
    {
        $Page = $Line[$Index]
        foreach ($Rule in $Rules)
        {
            if ($Page -eq $Rule[0] -and $Rule[1] -in $line)
            {
                if ($Index -gt $Line.IndexOf($Rule[1]))
                {
                    # Write-Host "$Line" -ForegroundColor Red
                    continue Line
                }
            }
        }
    }
    # Write-Host "$Line" -ForegroundColor Green
    $total += $($line[[int](($line.count -1) /2)])
}

Write-Host "Total: $Total"




# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:01.1742524