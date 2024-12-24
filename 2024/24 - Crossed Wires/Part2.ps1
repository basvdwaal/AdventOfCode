
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#Region Input Parsing 
$SplitMark = $PuzzleInput.IndexOf("")

$Wires = @{}
$Gates = [System.Collections.ArrayList]::new()

$regex = [regex]::new("(?<Wire1>\w{3}) (?<Operator>XOR|OR|AND) (?<Wire2>\w{3}) -> (?<Output>\w{3})")
$Queue = [System.Collections.Queue]::new()

foreach ($wire in $PuzzleInput[ 0..($SplitMark - 1) ])
{
    $t = $wire -split ": "
    $Wires[$t[0]] = $t[1]
}

foreach ($Gate in $PuzzleInput[ ($SplitMark + 1)..($PuzzleInput.Count - 1) ])
{
    if ($Gate -match $regex)
    {
        [void]$Gates.Add([PSCustomObject]@{
            Wire1 = $Matches.Wire1
            Operator = $Matches.Operator
            Wire2 = $Matches.Wire2
            Output = $Matches.Output
        })
    }
    else
    {
        Write-Host "Error: $Gate"
    }
}

#EndRegion Input Parsing 

# Expected output
$InputX = ""
foreach ($Wire in ($Wires.Keys | where {$_ -like "x*"} | Sort -Descending))
{
    $InputX += [string]$Wires[$Wire]
}

$InputY = ""
foreach ($Wire in ($Wires.Keys | where {$_ -like "y*"} | Sort -Descending))
{
    $InputY += [string]$Wires[$Wire]
}

$ExpectedOutput = [Convert]::ToString(([Convert]::ToInt64($InputX, 2) + [Convert]::ToInt64($InputY, 2)), 2) -split "" | where {$_ -ne ""}
[array]::Reverse($ExpectedOutput)

$OutputGates = $Gates | where { $_.Output -like "z*" } | Sort-Object -Property Output

for ($i = 0; $i -lt $ExpectedOutput.Count; $i++)
{
    $Queue = [System.Collections.Queue]::new()

    # Get the Gate that procudes the output and check if we have the required inputs
    $Queue.Enqueue($OutputGates[$i].Output)

    While ($Queue.Count -gt 0)
    {
        $Wire = $Queue.Dequeue()
        $Gate = $Gates | where { $_.Output -eq $Wire }

        $Wire1 = $Wires[$Gate.Wire1]
        $Wire2 = $Wires[$Gate.Wire2]
        
        if (! $wire1 -or ! $Wire2)
        {
            if (! $Wire1) { $Queue.Enqueue($Gate.Wire1) }
            if (! $Wire2) { $Queue.Enqueue($Gate.Wire2) }
            $Queue.Enqueue($Gate.Output)
        }
        
        switch ($Gate.Operator)
        {
            "AND" { $Wires[$Gate.Output] = $Wire1 -band $Wire2 }
            "OR" { $Wires[$Gate.Output] = $Wire1 -bor $Wire2 }
            "XOR" { $Wires[$Gate.Output] = $Wire1 -bxor $Wire2 }
        }
    }

    $Gate = $OutputGates[$i]
    if ($Gate.output -eq "z")
    {
        $Wires[$Gate.Output] = $ExpectedOutput[$i]
    }
    else
    {
        switch ($Gate.Operator)
        {
            "AND" { $Wires[$Gate.Output] = $Wire1 -band $Wire2 }
            "OR" { $Wires[$Gate.Output] = $Wire1 -bor $Wire2 }
            "XOR" { $Wires[$Gate.Output] = $Wire1 -bxor $Wire2 }
        }
    }

}

$Output = ""
foreach ($Wire in ($Wires.Keys | where {$_ -like "z*"} | Sort -Descending))
{
    $Output += [string]$Wires[$Wire]
}

$Output = [Convert]::ToInt64($Output, 2)

Write-Host "Output: $Output"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.0670576



switch ($Gate.Operator)
{
    "AND" { $Wires[$Gate.Output] = $Wire1 -band $Wire2 }
    "OR" { $Wires[$Gate.Output] = $Wire1 -bor $Wire2 }
    "XOR" { $Wires[$Gate.Output] = $Wire1 -bxor $Wire2 }
}