
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample2.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================


#region Functions

function Check-IsLetterPairvalid ([array]$Letters, $Rules)
{

    # Get the relevant rule by first letter
    [char[]]$Rule = $Rules[$Letters[0]]

    # Check if the second letter matches the possible options
    if ($Letters[1] -cin $Rule) 
    {
        return $null
    }
    else
    {
        
        return "$($Letters[0]) > $($Rule -join ',')"
    }
}


#Endregion Functions

$Names = $PuzzleInput[0] -split ","

$RulesInput = $PuzzleInput[2..($PuzzleInput.Length -1)]
$Rules = @{}
foreach ($Rule in $RulesInput)
{
    $Rules[[char]$Rule[0]] = ($Rule -replace " " -split ">")[1] -split ","
}

$Total = 0

:NameLoop
for ($Ni = 0; $Ni -lt $Names.Count; $Ni++)
{
    $name = $Names[$Ni]
    for ($i = 0; $i -lt $name.Length -1; $i++)
    {
        $Letters = @([char]$name[$i], [char]$name[$i + 1])
        if ($rule = Check-IsLetterPairvalid $Letters $Rules)
        {
            Write-Host "[$Name] $($Letters -join '') do not match rule $rule!"  -ForegroundColor Yellow
            continue NameLoop
        }
    }

    # If no early exit, name is valid
    Write-Host "[$($Ni + 1): $Name] matches all rules!" -ForegroundColor Green 
    $total += $Ni + 1
}

write-host "Total: $total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"