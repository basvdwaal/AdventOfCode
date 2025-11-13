
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample3.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input3.txt)

$StartTime = Get-Date

$ErrorActionPreference = 'Break'
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

function Test-Name ($Name, $Rules)
{
    for ($i = 0; $i -lt $name.Length -1; $i++)
    {
        $Letters = @([char]$name[$i], [char]$name[$i + 1])
        if ($rule = Check-IsLetterPairvalid $Letters $Rules)
        {
            # Write-Host "$Name - $($Letters -join '') do not match rule $rule!"  -ForegroundColor Yellow
            Return $false
        }
    }

    # If no early exit, name is valid
    # Write-Host "$Name matches all rules!" -ForegroundColor Green 
    return $true
}


#Endregion Functions

$Names = $PuzzleInput[0] -split ","

$RulesInput = $PuzzleInput[2..($PuzzleInput.Length -1)]
$Rules = @{}
foreach ($Rule in $RulesInput)
{
    $Rules[[char]$Rule[0]] = ($Rule -replace " " -split ">")[1] -split ","
}

$validnames = @()

for ($Ni = 0; $Ni -lt $Names.Count; $Ni++)
{
    $name = $Names[$Ni]
    if (Test-Name -name $Name -Rules $Rules)
    {
        $validnames += $name
    }
}


# Use a stack to iterate through all possible names
$stack = New-Object System.Collections.Stack
$GeneratedNames = [System.Collections.Generic.HashSet[string]]::new()
$Total = 0

foreach ($name in $validnames)
{
    Write-Host "Starting with: $name"
    $stack.Push($name)

    while ($stack.Count -gt 0)
    {
        $N = $stack.Pop()

        if ($N.Length -gt 10)
        {
            continue
        }

        # Write-host "Checking $N"
        # Get relevant rule for last letter
        $Letters = $Rules[$N[-1]]
        # Write-host "letters: $Letters"

        # Add all options to the stack
        foreach ($Letter in $Letters)
        {
            $NextName = $N + $letter
            $stack.Push($NextName)
            if ($NextName.Length -ge 7)
            {
                # $total++
                $GeneratedNames.add($NextName) | Out-Null
            }
        }
    }
}



# Sanity check code
# foreach ($Name in $Test)
# {
#     Test-Name -name $Name -Rules $Rules | Out-Null
# }

# $total = $GeneratedNames | select -Unique | Measure-Object | select -ExpandProperty Count
$Total = $GeneratedNames.Count
write-host "Total: $total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:21.3055679