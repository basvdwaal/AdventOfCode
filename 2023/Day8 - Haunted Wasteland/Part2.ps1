
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\input.txt)

# ======================================================================
# ======================================================================

$Instructions, $null, $Lines = $PuzzleInput

$Instructions = $Instructions.ToCharArray()


#region Functions

function Get-GreatestCommonDivisor {
  [alias('gcd')]
  param(
    [Parameter(Mandatory=$true)]
    [bigint[]]$Numbers
  )

  if ($Numbers.Count -lt 2) {
    throw "At least two numbers are required."
  }

  # Sort the numbers and initialize the GCD calculation with the first two
  $a = $Numbers[0]
  $b = $Numbers[1]
  
  # If there are more than two numbers, loop through the rest
  for ($i = 2; $i -lt $Numbers.Count; $i++) {
      $a = Get-GreatestCommonDivisor -Numbers @($a, $Numbers[$i])
  }

  # Implement the Euclidean algorithm
  while ($b -ne 0) {
    $StepsArremp = $b
    $b = $a % $b
    $a = $StepsArremp
  }
  return $a
}

#Endregion Functions

$Nodes = @{}

foreach ($Line in $Lines)
{
    $Line -match "([A-Z1-9]{3}) = \(([A-Z1-9]{3}), ([A-Z1-9]{3})\)" | Out-Null

    $Nodes[$Matches[1]] = [PSCustomObject]@{
        [char]"L" = $Matches[2]
        [char]"R" = $Matches[3]
    }
}

$Startnodes = $nodes.Keys | where { $_ -like '*A' }
$StepsArr = @()

Foreach ($node in $Startnodes)
{
    $CurrentNode = $node
    $Steps = 0
    $break = $false
    do
    {
        for ($Index = 0; $Index -lt $Instructions.Count; $Index++) {
            $NextStep = $Instructions[$Index]
            
            $NextNode = $Nodes[$CurrentNode].$NextStep
            $CurrentNode = $NextNode
            $Steps++

            if ($CurrentNode -like "*Z")
            {
                $StepsArr += $Steps
                $break = $true
                break
            }
        }
    }
    until ($break -eq $true)
}

$1 = $StepsArr[0] * $StepsArr[1] / (Get-GreatestCommonDivisor $StepsArr[0], $StepsArr[1])
$2 = $1 * $StepsArr[2] / (Get-GreatestCommonDivisor $1, $StepsArr[2])
$3 = $2 * $StepsArr[3] / (Get-GreatestCommonDivisor $2, $StepsArr[3])
$4 = $3 * $StepsArr[4] / (Get-GreatestCommonDivisor $3, $StepsArr[4])
$5 = $4 * $StepsArr[5] / (Get-GreatestCommonDivisor $4, $StepsArr[5])

Write-Host "Steps: $5"

#region Oude oplossing
# $Startnodes = $nodes.Keys | where { $_ -like '*A' }
# $NumberOfNodes = $StartNodes.Count
#
# $CurrentNodes = $Startnodes
# $Steps = 0
#
# do 
# {
#     for ($Index = 0; $Index -lt $Instructions.Count; $Index++)
#     {
#         $Instruction = $Instructions[$Index]
#
#         $NextNodes = @()
#         # Execute each instruction for all nodes
#         foreach ($node in $CurrentNodes)
#         {
#             $NextNodes += $Nodes[$Node].$Instruction
#         }
#         $CurrentNodes = $NextNodes
#         $Steps++
#     }
# }
# until
# ( 
#     ($CurrentNodes | where { $_ -like '*Z' } | measure ).Count -eq $NumberOfNodes
# )
#endregion Oude oplossing

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.5768115
