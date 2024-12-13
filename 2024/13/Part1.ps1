
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt -Raw) -split "`r`n`r`n"
$Clawmachines = @()

foreach ($Item in $PuzzleInput)
{
    $item = $item -split "`r`n" 
    $Clawmachines += [PSCustomObject]@{
        ButtonA = [System.Collections.Generic.List[int]]($Item[0] -replace "Button A: X\+","" -replace " Y\+","" -split ",")
        ButtonB = [System.Collections.Generic.List[int]]($Item[1] -replace "Button B: X\+","" -replace " Y\+","" -split ",")
        Prize = [System.Collections.Generic.List[int]]($Item[2] -replace "Prize: X=","" -replace " Y=","" -split ",")
    }
}
# ======================================================================
# ======================================================================

$TotalCost = 0
$MachineID = 0
$MachineCosts = @{}

foreach ($ClawMachine in $Clawmachines)
{
    for ($i = 0; $i -le 100; $i++)
    {
        $TimesB = [int](($ClawMachine.Prize[0] - ($i * $ClawMachine.ButtonA[0])) / $ClawMachine.ButtonB[0])
        if ($TimesB -lt 0 -or $TimesB -gt 100)
        {
            continue
        }

        if (($i * $Clawmachine.ButtonA[0] + $TimesB * $ClawMachine.ButtonB[0]) -eq $ClawMachine.Prize[0] -and `
        ($i * $Clawmachine.ButtonA[1] + $TimesB * $ClawMachine.ButtonB[1]) -eq $ClawMachine.Prize[1])
        {
            $Cost = 3*$i + $TimesB
            # Write-Host "$MachineID : (A: $i, B: $TimesB, Cost: $Cost)"

            if ($MachineCosts[$MachineID])
            {
                if ($MachineCosts[$MachineID] -gt $Cost)
                {
                    $MachineCosts[$MachineID] = $Cost
                }
            }
            else
            {
                $MachineCosts[$MachineID] = $Cost
            }
        }
    }
    
    if (! ($MachineCosts[$MachineID]))
    {
        # Write-Host "$MachineID : Machine not possible"
    }

    $MachineID++
}

foreach ($Machine in $MachineCosts.Values){
    $TotalCost += $Machine
}

Write-Host "Total Cost: $Totalcost"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.1850828