
Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'
$StartTime = Get-Date

$Stones = (Get-Content $PSScriptRoot\Input.txt) -split " " | foreach {[int]$_}

# ======================================================================
# ======================================================================

#region Functions
#Endregion Functions

$Blinks = 25

for ($i = 0; $i -lt $Blinks; $i++)
{
    Write-Progress -Activity "Counting stones.." -Status "Processing iteration $i of $Blinks" -PercentComplete (($i / $Blinks) * 100)

    # Split Array into smaller parts so it can be parralelized
    $counter = [pscustomobject] @{ Value = 0 }
    $groupSize = 1000

    $StoneGroups = $Stones | Group-Object -Property { [math]::Floor($counter.Value++ / $groupSize) }

    $jobs = $StoneGroups | foreach -AsJob -ThrottleLimit 100 -Parallel {
        Set-StrictMode -Version latest
        $ErrorActionPreference = 'Stop'
        
        $Stones = $_.Group
        for ($Index = 0; $Index -lt $Stones.Count; $Index++)
        {
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
        return $Stones
    }

    $stones = @()
    $Temp = $jobs | Receive-Job -Wait -AutoRemoveJob
    $Stones += @($Temp)
    # Write-Host $Stones

}
Write-Progress -Completed



Write-Host "Number of Stones: $($stones.Count)"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"