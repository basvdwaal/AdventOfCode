
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample3.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input3.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions


$Numbers = [System.Collections.ArrayList]($PuzzleInput -split "," | foreach {[int]$_})

# $Sorted = $Numbers  | select -Unique |Sort-Object -Descending

$Numbers | Group-Object | Sort-Object -Property Count -Descending |select -first 1

# $count = 0
# foreach ($number in $sorted) 
# {
#     $index = $numbers.IndexOf($number)
#     $numbers.RemoveAt($index)
#     $count++
# }


# write-host ($Numbers -join ",")
# write-host ($Sorted -join ",")


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.2487426