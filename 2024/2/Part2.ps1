$Txtinput = Get-Content $PSScriptRoot\Input.txt | foreach {,@($_ -split " ")}
$CountSafe = 0

function DetermineIfSafe ([array]$line)
{
    if ([int]$line[1] -gt [int]$line[0])
    # Increasing
    {
        for ($Index = 1; $index -lt [int]$line.Length; $Index++)
        {
            if ([int]$line[$Index] -le [int]$line[$Index - 1]) { return $false }

            $Difference = [int]$line[$Index] - [int]$line[$Index - 1]
            if ($Difference -gt 3) { ;return $false }
        }
    }
    else
    # Decreasing
    {
        for ($Index = 1; $index -lt [int]$line.Length; $Index++)
        {
            if ([int]$line[$Index] -ge [int]$line[$Index - 1]) { return $false }

            $Difference = [int]$line[$Index -1] - [int]$line[$Index]
            if ($Difference -gt 3) { return $false }
        }
    }
    return $true
}


:outer
foreach ($line in $Txtinput)
{
    # Determine if the array is all increasing or all decreasing.
    $safe = DetermineIfSafe $line
    if ($safe)
    {
        # Write-Host "$line is safe" -ForegroundColor Green
        $CountSafe++
    }
    else
    {
        $safe = $false
        for ($Index = 0; $Index -lt $line.Count; $Index++) {
            [System.Collections.ArrayList]$arrayList = $line
            $arrayList.RemoveAt($Index)
            if (DetermineIfSafe $arrayList)
            {
                Write-Host "$line is safe after dampening. $($line[$index]) at $index removed" -ForegroundColor Yellow
                $safe = $true
                break
            }
        }

        if ($safe)
        {
            $CountSafe++
        }
        else
        {
            # Write-Host "$line is unsafe!" -ForegroundColor Red
        }
    }
}

Write-Host "========================================================================================" 
Write-Host "$CountSafe safe"