$Txtinput = Get-Content $PSScriptRoot\Input.txt | foreach {,@($_ -split " ")}
$CountSafe = 0

:outer
foreach ($line in $Txtinput)
{
    # Determine if the array is all increasing or all decreasing.

    if ([int]$line[1] -gt [int]$line[0])
    # Increasing
    {
        for ($Index = 1; $index -lt [int]$line.Length; $Index++)
        {
            if ([int]$line[$Index] -le [int]$line[$Index - 1]) {Write-Host "$line is unsafe" -ForegroundColor Red ;continue outer }

            $Difference = [int]$line[$Index] - [int]$line[$Index - 1]
            if ($Difference -gt 3) { Write-Host "$([int]$line[$Index]) - $([int]$line[$Index - 1]) = $difference || $line is unsafe" -ForegroundColor Red ;continue outer }
        }
        # Write-Host "$line is all increasing"
    }
    else
    # Decreasing
    {
        for ($Index = 1; $index -lt [int]$line.Length; $Index++)
        {
            if ([int]$line[$Index] -ge [int]$line[$Index - 1]) { Write-Host "$line is unsafe" -ForegroundColor Red ;continue outer }

            $Difference = [int]$line[$Index -1] - [int]$line[$Index]
            if ($Difference -gt 3) { Write-Host "$([int]$line[$Index - 1]) - $([int]$line[$Index]) = $difference || $line is unsafe" -ForegroundColor Red ;continue outer }
        }
        # Write-Host "$line is all decreasing"
    }

    Write-Host "$line is safe" -ForegroundColor Green
    $CountSafe++
}

Write-Host "$CountSafe safe"