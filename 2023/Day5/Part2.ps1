
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\input.txt)

# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$Maps = [ordered]@{}
[int64[]]$nummers = $PuzzleInput[0] -replace "seeds: " -split " "

$Seeds = for ($i = 0; $i -lt $nummers.Count; $i += 2) {
    ,($nummers[$i], $nummers[$i+1])
}

$currentMapName = $null
foreach ($line in $PuzzleInput) {
    if ($line -match '([\w-]+) map:') {
        $currentMapName = $Matches[1]
        $Maps[$currentMapName] = @()
    }
    elseif ($line -match '^\d' -and $currentMapName) {
        
        $Obj = @{
            DestStart = $null;
            SourceStart = $null;
            Range = $null;
        }

        [int64]$Obj.DestStart, [int64]$obj.SourceStart, [int64]$Obj.Range = $line -split " " 
        $Maps[$currentMapName] += $Obj
    }
    elseif ([string]::IsNullOrWhiteSpace($line)) {
        $currentMapName = $null
    }
}


$LowestLocation = [int64]::MaxValue
Foreach ($SeedSet in $seeds)
{   
    $LastSeed = $SeedSet[0] + $SeedSet[1] -1
    $CurrentSeed = $SeedSet[0]
    
    while ($CurrentSeed -le $LastSeed)
    {
        # Write-Host "Starting with seed: $CurrentSeed"
        $CurrentID = $CurrentSeed
        :maptype
        foreach ($MapType in $Maps.Values)
        {
            foreach ($Map in $MapType)
            {
                if ($CurrentID -ge $map.SourceStart -and $CurrentID -lt ($map.SourceStart + $map.Range))
                {
                    # Seed in range, calculate offset
                    $Offset = $CurrentID - $map.SourceStart
                    
                    # New id = Start + offset
                    $NewId = $map.DestStart + $Offset

                    # Write-Host "Mapping $CurrentID to $newid!"
                    $CurrentID = $NewId

                    continue maptype
                }
            }

            # If no maps fit continue with current id
            # Write-Host "No match. keeping $CurrentID"
        }

        if ($CurrentID -lt $LowestLocation)
        {
            $LowestLocation = $CurrentID
        }
        $CurrentSeed++
        
        # Write-Host "Seed: $CurrentSeed. Location: $CurrentID" -ForegroundColor Green
    }
}


Write-Host "Lowest location: $LowestLocation"
# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.1053192