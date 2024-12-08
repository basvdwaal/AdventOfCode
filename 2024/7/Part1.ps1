
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions

# function GenerateCombinations {
#     param (
#         [object[]]$inputArray,
#         [string[]]$fillOptions
#     )
#     # Find indices of empty slots
#     $emptyIndices = @(for ($i = 0; $i -lt $inputArray.Length; $i++) {
#         if ($inputArray[$i] -eq $null) { $i }
#     })
    
#     # Total number of combinations (2^number of empty slots)
#     $totalCombinations = [math]::Pow($fillOptions.Length, $emptyIndices.Count)
    
#     # Generate all combinations
#     for ($i = 0; $i -lt $totalCombinations; $i++) {
#         # Convert index to the appropriate base for fill options
#         $currentCombination = $i
#         $pattern = @()
#         for ($j = 0; $j -lt $emptyIndices.Count; $j++) {
#             $pattern += $fillOptions[$currentCombination % $fillOptions.Length]
#             $currentCombination = [math]::Floor($currentCombination / $fillOptions.Length)
#         }
        
#         # Clone the original array
#         $newArray = $inputArray.Clone()
        
#         # Fill the empty slots with the current pattern
#         for ($k = 0; $k -lt $emptyIndices.Count; $k++) {
#             $newArray[$emptyIndices[$k]] = $pattern[$k]
#         }
        
#         # Output the modified array as a string
#         $newArray -join ''
#     }
# }

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

#Endregion Functions

$count = 0
$TotalSum = 0

foreach ($line in $PuzzleInput)
{
    # Add + to each operation
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

Write-Host "Total Sum: $TotalSum"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 01:27:37.2396985 :')