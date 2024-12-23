
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

foreach ($PC1 in $Map.Keys) {
    foreach ($PC2 in $Map[$PC1]) { 
        foreach ($PC3 in $Map[$PC2]) {
            if ($PC3 -ne $PC1 -and $PC1 -in $Map[$PC3])
            {
                try
                {
                    $str = (@($PC1, $PC2, $PC3) | Sort-Object) -join ","
                    # [void]$Set.Add( (@($PC1, $PC2, $PC3) | Sort-Object) )
                    $HashTable[$str] = @($PC1, $PC2, $PC3)
                }
                catch
                {
                    # Already exists
                }
            }
        }
    }
}
#>

$Total = 0
:outer
foreach ($group in $HashTable.Values)
{
    foreach ($PC in $group)
    {
        if ($PC -like "t*")
        { 
            $Total += 1
            continue outer
        }
        
    }
}

# $total = ($output.Keys | where {$_ -like "*t*"} | Measure-Object).Count

Write-Host "Result: $Total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:02.1617333