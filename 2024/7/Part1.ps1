
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions

function Increment-BinaryNumber {
    param (
        [array]$Binary
    )
    
    for ($i = 0; $i -lt $Binary.Length; $i++)
    {
        if ($Binary[$i] -eq '0')
        { 
            $Binary[$i] = '1'
            if ($i -ne 0)
            {
                foreach ($t in 0..($I-1))
                {
                    $Binary[$t] = '0'
                }
            }
            break
        }
    }

    return $Binary
}


function Get-Validity {
    param (
        [object[]]$inputArray,
        [int64]$solution
    )
    
    Write-Host "$solution : $inputArray"

    $AmountOfOperations = $inputArray.Length -1
    $totalCombinations = [math]::Pow(2, $AmountOfOperations)
    $binary = ('0' * $AmountOfOperations).ToCharArray()

    foreach ($j in 0..($totalCombinations-1))
    {
        $TempArr = $inputArray.Clone()
        # We start with the first index and then add or multiply with the now first index
        [int64]$res, [array]$TempArr = $TempArr

        for ($i = 0; $i -lt $inputArray.Length - 1;$i++)
        {
            if ($Binary[$i] -eq '0')
            {
                $res += $TempArr[0]
            }
            elseif ($Binary[$i] -eq '1')
            {
                $res *= $TempArr[0]
            }
            else
            {
                Write-host "?????"
            }

            if ($TempArr.Length -gt 1)
            {
                $TempArr = $TempArr[1..($TempArr.Length - 1)]
            }
        }

        # Early exit of this solution if it is no longer feasible
        if ($res -gt $solution)
        {
            # Write-Host "Exiting early as $res > $solution"
            $binary = Increment-BinaryNumber -Binary $binary
            continue
        }

        if ($res -eq $solution)
        {
            Write-Host "Solution found: $binary" -ForegroundColor Green
            $script:Sum += $solution
            return
        }
        $binary = Increment-BinaryNumber -Binary $binary
    }
}

#Endregion Functions

[int64]$Sum = 0

foreach ($line in $PuzzleInput)
{
    # Add + to each operation
    # Write-Host $line
    
    $solution, $line = $line -split ": "

    $EquationArr = [int[]]($line -split " ")
    Get-Validity -inputArray $EquationArr -solution $solution

    # foreach ($Equation in $PossibleEquations.Values)
    # {
    #     $origEquation = $Equation.Clone()
    #     $Total = 0

    #     while ($Equation.Length -gt 1) {
    #         $Total = Invoke-Expression ($Equation[0..2] -join "")
    #         $StrLength = $Equation.Length -1
    #         $Equation = $Equation[2..$StrLength]
    #         $Equation[0] = $Total
    #     }
        
        
    #     if ($Total -eq [int64]$solution)
    #     {
    #         Write-Host "$origEquation = $solution" -ForegroundColor Green
    #         $count++
    #         $TotalSum += $solution
    #         break
    #     }
    # }
}

Write-Host "Total Sum: $Sum"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 01:27:37.2396985 :')