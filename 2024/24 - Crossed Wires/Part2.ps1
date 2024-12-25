
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

# [array]::Reverse($ExpectedOutput)

$OutputGates = $Gates | where { $_.Output -like "z*" } | Sort-Object -Property Output -Descending

# Ltrim the expected output to match the number of output gates
$ExpectedOutput = $ExpectedOutput[($ExpectedOutput.Length - $OutputGates.Length)..($ExpectedOutput.Length - 1)]

for ($i = $OutputGates.Length - 1; $i -ge 0; $i--)
{
    $Queue = [System.Collections.Queue]::new()
    $OutputWire = $OutputGates[$i].Output

    # Get the Gate that procudes the output and check if we have the required inputs
    $Queue.Enqueue($OutputWire)

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

    if ($Wires[$OutputWire] -ne $ExpectedOutput[$i])
    {
        Write-Host "Expected: $($ExpectedOutput[$i]) Actual: $($Wires[$OutputWire])" -ForegroundColor Red
    }
    else
    {
        Write-Host "Expected: $($ExpectedOutput[$i]) Actual: $($Wires[$OutputWire])" -ForegroundColor Green
    }
}

$Output = ""
foreach ($Wire in ($Wires.Keys | where {$_ -like "z*"} | Sort -Descending))
{
    $Output += [string]$Wires[$Wire]
}
Write-Host "InputX          : $InputX"
Write-Host "InputY          : $InputY"
Write-Host "Expected output : $($ExpectedOutput -join '')"
Write-Host "Actual output   : $Output"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 
