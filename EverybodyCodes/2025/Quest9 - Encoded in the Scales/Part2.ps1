
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample2.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input2.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================


#region Functions

function Check-PossibleParent ([char[]]$Child, [char[]]$Father, [char[]]$Mother)
{

    
    
    for ($i = 0; $i -lt $Child.Count; $i++)
    {
        $symbol = $Child[$i]
        if ($symbol -ne $Father[$i] -and $symbol -ne $Mother[$i])
        {
            return $false
        }
    }
    return $true
}


function Get-ParentLikeness ([char[]]$Child, [char[]]$Parent)
{
    $count = 0
    for ($i = 0; $i -lt $Child.Count; $i++)
    {
        if ($Parent[$i] -eq $Child[$i]) {$count++}
    }

    return $count
}


#Endregion Functions

$Total = 0

# Convert input to dict
$DNADict = @{}
foreach ($line in $PuzzleInput)
{
    [int]$Id, [char[]]$DNA = $line -split ":" 
    $DNADict[$Id] = $DNA
}


# Find parents for each child
$ParentsDict = @{}

:child
foreach ($Child in $PuzzleInput)
{
    $ChildId, $Child = $Child -split ":" 
    foreach ($Mother in $PuzzleInput)
    {
        $MotherId, $Mother = $Mother -split ":" 
        if ($ChildId -eq $MotherId) { continue }
        
        foreach ($Father in $PuzzleInput)
        {
            $FatherId, $Father = $Father -split ":" 
            if ($ChildId -eq $FatherId) { continue }

            if (Check-PossibleParent -Child $Child -Father $Father -Mother $Mother)
            {
                $ParentsDict[[int]$ChildId] = @([int]$FatherId, [int]$MotherId)
                continue child
            }
        }
    }
}


# Compare each child against both parents and add
foreach ($key in $ParentsDict.Keys)
{
    $Parents = $ParentsDict[$key]
    $Child = $DNADict[$key]
    $Likeness = 0
    foreach ($ParentId in $Parents)
    {
        $Parent = $DNADict[$ParentId]
        $Res = Get-ParentLikeness -Child $Child -Parent $Parent
        if ($Likeness) { $Likeness *= $Res } 
        else { $Likeness = $Res }
    }

    $Total += $Likeness

}

Write-Host "Total: $Total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:17.9708319