
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample3.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input3.txt)

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

function Get-MismatchMask ([char[]]$Child, [char[]]$Parent)
{
    # We gebruiken [uint64] (long) omdat dit 64 bits heeft, 
    # ruim voldoende for de DNA-lengte (die ~30 is).
    [uint64]$mask = 0
    
    # We moeten de index bijhouden
    for ($i = 0; $i -lt $Child.Length; $i++)
    {
        if ($Child[$i] -ne $Parent[$i])
        {
            # Zet de i-de bit op 1.
            # We casten 1 naar [uint64] zodat de shift-operatie (-shl) 
            # correct werkt voorbij de 31e bit.
            $mask = $mask -bor ([uint64]1 -shl $i)
        }
    }
    return $mask
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

<#
# Find parents for each child
$ParentsDict = @{}
Write-Host "Finding parents.."

$IDs = [int[]]$DNADict.Keys

:child
foreach ($ChildId in $IDs)
{
    foreach ($MotherId in $IDs)
    {
        if ($ChildId -eq $MotherId) { continue }
        
        foreach ($FatherID in $IDs)
        {
            if ($ChildId -eq $FatherId) { continue }
            
            if (Check-PossibleParent -Child $DNADict[$ChildId] -Father $DNADict[$FatherID] -Mother $DNADict[$MotherId])
            {
                $ParentsDict[[int]$ChildId] = (@([int]$FatherId, [int]$MotherId) | sort) 
                continue child
            }
        }
    }
}

#>


Write-Host "Initializing connections graph..."
$Conns = @{} # Dit wordt onze Adjacency List
foreach ($Id in $DragonDuckIDs)
{
    # Maak een lege lijst voor de "buren" van elke dragonduck
    $Conns[$Id] = New-Object System.Collections.Generic.List[int]
}

Write-Host "Finding all connections (optimized)..."

:child # <-- Belangrijk label!
foreach ($ChildId in $DragonDuckIDs)
{
    $ChildDNA = $DNADict[$ChildId]

    # STAP 1 (per kind): Bouw de O(N) lijst met masks voor DIT kind
    $ChildMasks = @{} 
    foreach ($ParentId in $DragonDuckIDs)
    {
        if ($ChildId -eq $ParentId) { continue }
        $ChildMasks[$ParentId] = Get-MismatchMask -Child $ChildDNA -Parent $DNADict[$ParentId]
    }
    
    # STAP 2 (per kind): Vind EEN PAAR
    $PossibleParentIDs = $ChildMasks.Keys

    foreach ($MotherId in $PossibleParentIDs)
    {
        $Mask_M = $ChildMasks[$MotherId]

        foreach ($FatherId in $PossibleParentIDs)
        {
            # Optimalisatie: check (Ma, Pa) maar niet (Pa, Ma) of (Ma, Ma)
            if ($MotherId -ge $FatherId) { continue } 
            
            $Mask_F = $ChildMasks[$FatherId]
            
            if (($Mask_M -band $Mask_F) -eq 0)
            {
                # GEVONDEN! Dit is een geldige connectie.
                # Sla de connectie in 2 richtingen op.
                $Conns[$ChildId].Add($MotherId)
                $Conns[$ChildId].Add($FatherId)
                
                $Conns[$MotherId].Add($ChildId)
                $Conns[$FatherId].Add($ChildId)
                
                # DE OPTIMALISATIE:
                # We hebben een paar, stop met zoeken voor dit kind.
                continue child 
            }
        }
    }
}

# Assuming there are no loops, for each child go up the tree using a BFS and check for other kids and parents
$BiggestFamily = 0
$BiggestFamilySum = 0
$BezochteLeden = New-Object System.Collections.Generic.HashSet[int]

Write-Host "Building family trees.."

# We moeten over ALLE dragonducks itereren als startpunt
foreach ($StartMemberId in $DragonDuckIDs)
{
    # Als we dit lid al in een eerdere familie hebben gevonden, sla over
    if ($StartMemberId -in $BezochteLeden) { continue }
    
    # Begin een nieuwe familie
    $Family = New-Object System.Collections.Generic.HashSet[int]
    $Queue = New-Object System.Collections.Queue
    
    # Voeg het startlid toe aan de queue, familie en bezoek-lijst
    $Queue.Enqueue($StartMemberId)
    $BezochteLeden.Add($StartMemberId) | Out-Null
    $Family.Add($StartMemberId) | Out-Null

    # Start de BFS
    while ($Queue.Count -gt 0)
    {
        $Member = $Queue.Dequeue()
        
        # Loop door alle buren (kinderen EN ouders) van dit lid
        foreach ($Neighbor in $Conns[$Member])
        {
            # Als we deze buur nog niet hebben bezocht...
            if (-not $BezochteLeden.Contains($Neighbor))
            {
                # Voeg 'm toe aan alle lijsten
                $BezochteLeden.Add($Neighbor) | Out-Null
                $Family.Add($Neighbor) | Out-Null
                $Queue.Enqueue($Neighbor)
            }
        }
    } # Einde BFS while-loop
    
    # Nu is de $Family-set compleet voor deze component
    $NumMembers = $Family.Count
    
    if ($NumMembers -gt $BiggestFamily)
    {
        # ($Family | measure -Sum).Sum is iets sneller
        $SumOfIDs = ($Family | Measure-Object -Sum).Sum
        $BiggestFamily = $NumMembers
        $BiggestFamilySum = $SumOfIDs
    }
} # Einde foreach ($StartMemberId in $DragonDuckIDs)

Write-Host "Total: $BiggestFamilySum"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"