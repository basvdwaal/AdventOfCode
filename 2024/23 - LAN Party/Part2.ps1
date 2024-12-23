
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
$output = New-Object System.Collections.Generic.HashSet[string]
# $output = [System.Collections.Concurrent.ConcurrentDictionary[string, string]]::new()

#<#
#foreach ($PC1 in $Map.Keys)
$map.Keys | foreach-object -throttlelimit 50 -parallel {
    $PC1 = $_
    $dict = $using:output
    $map = $using:map
    foreach ($PC2 in $Map[$PC1])
    {
        foreach ($PC3 in $Map[$PC2])
        {
            if ($PC3 -eq $PC1)
            {
                continue
            }
            else
            {
                $PC4 = $Map[$PC3]
                if ($PC4 -eq $PC1)
                {
                    $str = (@($PC1, $PC2, $PC3) | Sort-Object) -join ","
                    try
                    {
                        [void]$dict.Add($str)

                    #     Write-Host "$PC1 : $($map[$PC1])"
                    #     Write-Host "$PC2 : $($map[$PC2])"
                    #     Write-Host "$PC3 : $($map[$PC3])"
                    }
                    catch
                    {
                        # Already exists
                    }
                }
            }
        }
    }
}
#>

Foreach ($group in $output)
{
    $PC1, $PC2, $PC3 = $group -split ","
    $List = New-Object System.Collections.ArrayList

    while 

    foreach ($PC in $map[$PC1])
    {
        if ($Map[$PC] -contains $PC2 -and ($Map[$PC] -contains $PC3)
        {
            [void]$list.Add($PC)
        }
    }
}





$Total = 0
:outer
foreach ($group in $output)
{
    foreach ($PC in $group -split ",")
    {
        if ($PC -like "t*")
        { 
            $Total+= 1
            continue outer
        }
        
    }
}

# $total = ($output.Keys | where {$_ -like "*t*"} | Measure-Object).Count

Write-Host "Result: $Total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:03.5349232