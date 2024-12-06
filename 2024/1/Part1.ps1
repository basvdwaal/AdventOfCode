#$ListA = 3,4,2,1,3,3 | sort
#$ListB = 4,3,5,3,9,3 | sort

$ListA = Get-Content .\List1.txt | sort
$ListB = Get-Content .\List2.txt | sort

$TotalDistance = 0

for ($Index = 0; $index -lt $ListA.Length; $Index++)
{
    $ItemA = $ListA[$Index]
    $itemB = $ListB[$Index]

    $Distance = $itemA - $itemB

    if ($Distance -lt 0) { $Distance = $Distance * -1 }

    Write-Output "$ItemA - $ItemB = $Distance"

    $TotalDistance = $TotalDistance + $Distance
}

Write-Output "Total Distance: $TotalDistance" 

