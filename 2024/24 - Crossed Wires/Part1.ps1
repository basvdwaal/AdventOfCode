
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

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

foreach ($Gate in $Gates)
{
    $Queue.Enqueue($Gate)
}

While ($Queue.Count -gt 0)
{
    $Gate = $Queue.Dequeue()
    $Wire1 = $Wires[$Gate.Wire1]
    $Wire2 = $Wires[$Gate.Wire2]

    # If we don't have the values for the wires, put the gate back in the queue
    if ($null -eq $Wire1 -or $null -eq $Wire2)
    {
        $Queue.Enqueue($Gate)
        continue
    }

    switch ($Gate.Operator)
    {
        "AND" { $Wires[$Gate.Output] = $Wire1 -band $Wire2 }
        "OR" { $Wires[$Gate.Output] = $Wire1 -bor $Wire2 }
        "XOR" { $Wires[$Gate.Output] = $Wire1 -bxor $Wire2 }
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