
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\input.txt)

# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$Total = 0
foreach ($Line in $PuzzleInput)
{
    # Master Array to hold all sub arrays
    $MasterArr = @(, [int[]]@($Line -split " "))
    $MAIndex = 0
    
    do
    {
        $Arr = $MasterArr[$MAIndex]
        $NewArr = @()
        $Zero = $true
        for ($Index = 0; $Index -lt $Arr.count -1; $Index++)
        {
            $Num1 = $Arr[$Index]
            $Num2 = $Arr[$Index + 1]

            $dif = $Num2 - $Num1
            $NewArr += $dif

            if ($dif -ne 0) {$Zero = $false}
        }
        $MAIndex++
        $MasterArr += , $NewArr

    }
    until ($Zero -eq $true)
    
    
    # Iterate over the arrays in the reverse order and append one element by following: Last element in current array + last element in previous array
    # Last array is all 0s so we can skip that one.
    $Step = 0

    for ($i = $MasterArr.Length - 2; $i -ge 0; $i--)
    {
        $arr = $MasterArr[$i]

        $FirstElement = $Arr[0]
        $NewElement = $FirstElement - $Step
        $Arr = ,$NewElement + $Arr
        $Step = $NewElement

        $MasterArr[$i] = $Arr
    }

    $Total += $NewElement

    # for ($i = 0; $i -lt $MasterArr.Count; $i++)
    # {
    #     $arr = $MasterArr[$i]
    #     $String = $arr -join "   "
    #     $Spacer = "  " * $i
    #     Write-Host "$spacer$string"
    # }
    # Write-host ""
}

Write-Host "Total: $total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.2084648