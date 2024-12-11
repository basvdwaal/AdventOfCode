
Set-StrictMode -Version latest
$StartTime = Get-Date

$Stones = (Get-Content $PSScriptRoot\Input.txt) -split " " | foreach {[int]$_}

# ======================================================================
# ======================================================================

#region Functions
#Endregion Functions

for ($i = 0; $i -lt 25; $i++)
{
    Write-Progress -Activity "Outer Loop Progress" -Status "Processing iteration $i of 25" -PercentComplete (($i / 25) * 100)

    for ($Index = 0; $Index -lt $Stones.Count; $Index++)
    {
        Write-Progress -Activity "Inner Loop Progress" -Status "Processing stone $Index of $($Stones.Count - 1)" -PercentComplete (($Index / $Stones.Count) * 100) -Id 1

        if ($Stones[$Index] -eq 0)
        {
            $Stones[$Index] = 1
        }
        elseif($Stones[$Index].ToString().Length % 2 -eq 0)
        {
            $stoneStr = $Stones[$Index].ToString()
            $midindex = (($stoneStr.length)/2)
            $Stones[$Index] = [int]($stoneStr[0..($midindex-1)] -join "")
            $Stone2 = [int]($stoneStr[$midindex..($stoneStr.length-1)] -join "")

            if ($Index -ne $stones.Count -1)
            {
                $Stones = $Stones[0..$Index] + @($Stone2) + $Stones[($Index+1)..($Stones.Count -1)]
            }
            else
            {
                $Stones = $Stones + @($Stone2)
            }

            # Skip the just added element
            $Index++
        }
        else 
        {
            $Stones[$Index] *= 2024
        }
    }
    Write-Host $Stones
}


Write-Host "Number of Stones: $($stones.Count)"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"