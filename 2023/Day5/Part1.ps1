
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content .\sample.txt)

# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$Maps = @{}
$null, $Seeds = $PuzzleInput[0] -split " "

$currentMapName = $null
foreach ($line in $PuzzleInput) {
    if ($line -match '([\w-]+) map:') {
        # Een nieuwe map is gevonden. Sla de naam op en maak een lege lijst voor de items.
        $currentMapName = $Matches[1]
        $Maps[$currentMapName] = @()
    }
    # Check of de regel met een getal begint EN we een actieve map hebben
    elseif ($line -match '^\d' -and $currentMapName) {
        # Voeg de getallen (als een array) toe aan de lijst van de huidige map
        $numbers = $line.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
        $Maps[$currentMapName] += ,$numbers # De komma zorgt ervoor dat het als één array-item wordt toegevoegd
    }
    elseif ([string]::IsNullOrWhiteSpace($line)) {
        # Een lege regel reset de huidige map.
        $currentMapName = $null
    }
}

$FullMaps = @{}
Foreach ($Map in $Maps)
{
    Foreach ($line in $Map)
    {
        $SourceStart, $DestStart, $Length = $line -split " "
        for ($i = 0;$i -lt $Length; $i++)
        {
            $Fullmap[]$SourceStart
        }
    }
}



# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"