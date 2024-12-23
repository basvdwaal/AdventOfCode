
using namespace System.Collections  # Used for ArrayList

Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions
#Endregion Functions

$Map = @{}
foreach ($line in $PuzzleInput)
{
    $PC1, $PC2 = $Line -split "-"
    if ($Map[$PC1])
    {
        if ($Map[$PC1] -contains $PC2) { continue }
        $Map[$PC1] += $PC2
    }
    else
    {
        $Map[$PC1] = @($PC2)
    }

    if ($Map[$PC2])
    {
        if ($Map[$PC2] -contains $PC1) { continue }
        
        $Map[$PC2] += $PC1
    }
    else
    {
        $Map[$PC2] = @($PC1)
    }
}
$HashTable = @{}

function search($Node, $RequiredNodes)
{
    $key = ($RequiredNodes | Sort-Object) -join ","
    if ($HashTable[$key]) { return }
    $HashTable[$key] = $RequiredNodes

    :outer
    foreach ($Neighbor in $Map[$Node])
    {
        if ($Neighbor -in $RequiredNodes) { continue }

        foreach ($query in $RequiredNodes)
        {
            if ($Neighbor -notin $Map[$query]) { continue outer }
        }
        [void]$RequiredNodes.add($Neighbor)
        search $Neighbor $RequiredNodes
        $RequiredNodes.remove($Neighbor)
    }
    search $Neighbor $RequiredNodes
}

foreach ($PC in $Map.Keys) {
    search $PC ([arraylist]@($PC))
}

$t = $HashTable.Keys | Sort-Object -Property Length -Descending | Select-Object -First 1
$t = $t -split "," | Sort-Object
Write-Host ($t -join ",")

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:04:50.7050500   :)