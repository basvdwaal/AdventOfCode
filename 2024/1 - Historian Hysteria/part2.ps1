# $ListA = 3,4,2,1,3,3
# $ListB = 4,3,5,3,9,3

$ListA = Get-Content .\List1.txt
$ListB = Get-Content .\List2.txt

$Sum = 0

foreach ($Item in $ListA)
{
    $Item = [int]$Item

    $NumOfAppearances = $ListB | where {$_ -eq $Item }| Measure-Object | select -ExpandProperty Count
    
    Write-Output "Item $Item appears $NumOfAppearances times for a total score of $($item * $NumOfAppearances)"

    $Sum = $Sum + ($item * $NumOfAppearances)
}

Write-Output "Total: $Sum" 