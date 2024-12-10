
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

$LineIndex = 0

:Line
foreach ($Line in $LinesToCheck)
{
    Write-Progress -Activity "Sorting.." -Status "$LineIndex/$($LinesToCheck.Count)"
    $Swapped = $false
    for ($Index = 0; $Index -lt $Line.Length; $Index++) 
    {
        $Page = $Line[$Index]
        foreach ($Rule in $Rules)
        {
            if ($Page -eq $Rule[0] -and $Rule[1] -in $line)
            {
                $Index2 = $Line.IndexOf($Rule[1])
                if ($Index -gt $Index2)
                {
                    # Swap places for both of the array
                    $Line[$Index2] = $Page
                    $Line[$Index]  = $rule[1]

                    # Go over the entire line again
                    $Index = 0

                    $swapped = $true
                }
            }
        }
    }
    # Write-Host "$Line" -ForegroundColor Green
    
    # Only update the total if pages have been swapped
    if ($Swapped)
    {
        $total += $($line[[int](($line.count -1) /2)])
    }
    $LineIndex++
}
Write-Progress -Activity "Sorting.." -Completed

Write-Host "Total: $Total"




# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:36.9596146