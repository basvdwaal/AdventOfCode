
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions

function Increment-TernaryNumber {
    param (
        [array]$Number
    )
    
    for ($i = 0; $i -lt $Number.Length; $i++)
    {
        if ($Number[$i] -eq '0')
        { 
            $Number[$i] = '1'
            if ($i -ne 0)
            {
                foreach ($t in 0..($I-1))
                {
                    $Number[$t] = '0'
                }
            }
            break
        }

        if ($Number[$i] -eq '1')
        { 
            $Number[$i] = '2'
            if ($i -ne 0)
            {
                foreach ($t in 0..($I-1))
                {
                    $Number[$t] = '0'
                }
            }
            break
        }
    }
    return $Number
}


function Parse-Equation {
    param (
        [object[]]$inputArray,
        [int64]$solution
    )
    
    # Write-Host "$solution : $inputArray"

    $AmountOfOperations = $inputArray.Length -1
    $totalCombinations = [math]::Pow(3, $AmountOfOperations)
    $Tenary = ('0' * $AmountOfOperations).ToCharArray()

    foreach ($j in 0..($totalCombinations-1))
    {
        $TempArr = $inputArray.Clone()
        [int64]$res, [array]$TempArr = $TempArr

        for ($i = 0; $i -lt $inputArray.Length - 1;$i++)
        {
            if ($Tenary[$i] -eq '0')
            {
                $res += $TempArr[0]
            }
            elseif ($Tenary[$i] -eq '1')
            {
                $res *= $TempArr[0]
            }
            elseif ($Tenary[$i] -eq '2')
            {
                $res = "$res$($TempArr[0])"
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
            $Tenary = Increment-TernaryNumber -Number $Tenary
            continue
        }

        if ($res -eq $solution)
        {
            # Write-Host "Solution found: $Tenary" -ForegroundColor Green
            $script:Sum += $solution
            return
        }
        $Tenary = Increment-TernaryNumber -Number $Tenary
    }
}

#Endregion Functions

[int64]$Sum = 0

foreach ($line in $PuzzleInput)
{
    $solution, $line = $line -split ": "

    $EquationArr = [int[]]($line -split " ")
    Parse-Equation -inputArray $EquationArr -solution $solution
}

Write-Host "Total Sum: $Sum"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:04:21.5309597