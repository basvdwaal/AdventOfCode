
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions

#Endregion Functions

$script:Result = [hashtable]::Synchronized(@{})

$PuzzleInput | Foreach-Object -ThrottleLimit 200 -Parallel {
    $line = $_

    function Get-AllCombinations {
        param (
            [object[]]$inputArray,
            [string[]]$fillOptions
        )
        # Find indices of empty slots
        $emptyIndices = @(for ($i = 0; $i -lt $inputArray.Length; $i++) {
            if ($inputArray[$i] -eq "") { $i }
        })
        
        # Total number of combinations (2^number of empty slots)
        $totalCombinations = [math]::Pow($fillOptions.Length, $emptyIndices.Count)
        
        $OutputArr = @{}

        Do
        {
            $NewArr = $inputArray.Clone()
            foreach ($Index in $emptyIndices)
            {
                $NewArr[$index] = Get-Random @("+","*")
            }

            if (!($OutputArr[$newArr -join ""]))
            {
                $OutputArr[$NewArr -join ""] += $NewArr
            }
        }
        While (($OutputArr.Values).Count -lt $totalCombinations)

        return $OutputArr
    }

    Write-Host $line
    
    $solution, $line = $line -split ": "

    $EquationArr = ($line -split " ") -join "||" -split "\|"

    $PossibleEquations = Get-AllCombinations -inputArray $EquationArr -fillOptions @("+","*")

    foreach ($Equation in $PossibleEquations.Values)
    {
        $origEquation = $Equation.Clone()
        $Total = 0

        while ($Equation.Length -gt 1) {
            $Total = Invoke-Expression ($Equation[0..2] -join "")
            $StrLength = $Equation.Length -1
            $Equation = $Equation[2..$StrLength]
            $Equation[0] = $Total
        }
        
        if ($Total -eq [int64]$solution)
        {
            Write-Host "$origEquation = $solution" -ForegroundColor Green
            $ht = $using:Result
            $ht[$solution] = $origEquation
            break
        }
    }
}


<#
foreach ($line in $PuzzleInput)
{
    Write-Host $line
    
    $solution, $line = $line -split ": "

    $EquationArr = ($line -split " ") -join "||" -split "\|"
    $PossibleEquations = Get-AllCombinations -inputArray $EquationArr -fillOptions @("+","*")

    foreach ($Equation in $PossibleEquations.Values)
    {
        $origEquation = $Equation.Clone()
        $Total = 0

        while ($Equation.Length -gt 1) {
            $Total = Invoke-Expression ($Equation[0..2] -join "")
            $StrLength = $Equation.Length -1
            $Equation = $Equation[2..$StrLength]
            $Equation[0] = $Total
        }
        
        
        if ($Total -eq [int64]$solution)
        {
            Write-Host "$origEquation = $solution" -ForegroundColor Green
            $count++
            $TotalSum += $solution
            break
        }
    }
}
#>

$TotalSum = 0
foreach ($Solution in $Result.Keys)
{
    $TotalSum += $Solution
}

Write-Host "Total Sum: $TotalSum"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"