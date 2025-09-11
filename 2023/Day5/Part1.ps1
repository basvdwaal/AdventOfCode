
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\input.txt)

# ======================================================================
# ======================================================================

#region Functions



#Endregion Functions

$Maps = [ordered]@{}
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
        
        $Obj = @{
            DestStart = $null;
            SourceStart = $null;
            Range = $null;
        }

        [int64]$Obj.DestStart, [int64]$obj.SourceStart, [int64]$Obj.Range = $line -split " " 
        $Maps[$currentMapName] += $Obj
    }
    elseif ([string]::IsNullOrWhiteSpace($line)) {
        # Een lege regel reset de huidige map.
        $currentMapName = $null
    }
}


$locations = @()
Foreach ($Seed in $seeds)
{    
    Write-Host "Starting with seed: $seed"
    $CurrentID = [int64]$Seed
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

    $locations += $CurrentID
    
    # Write-Host "Seed: $seed. Location: $CurrentID" -ForegroundColor Green
}


$locations | sort | select -first 1
# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.1053192