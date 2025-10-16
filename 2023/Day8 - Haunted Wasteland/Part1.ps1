
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\input.txt)

# ======================================================================
# ======================================================================

$Instructions, $null, $Lines = $PuzzleInput

$Instructions = $Instructions.ToCharArray()


#region Functions



#Endregion Functions

$Nodes = @{}

foreach ($Line in $Lines)
{
    $Line -match "([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)" | Out-Null

    $Nodes[$Matches[1]] = [PSCustomObject]@{
        [char]"L" = $Matches[2]
        [char]"R" = $Matches[3]
    }
}

$CurrentNode = "AAA"
$Steps = 0

do 
{
    for ($Index = 0; $Index -lt $Instructions.Count; $Index++) {
        $NextStep = $Instructions[$Index]
        
        $NextNode = $Nodes[$CurrentNode].$NextStep
        $CurrentNode = $NextNode
        $Steps++
    }
}
until ( $CurrentNode -eq "ZZZ" )

Write-Host "Steps: $steps"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.3390224