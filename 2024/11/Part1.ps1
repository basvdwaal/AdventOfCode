
Set-StrictMode -Version latest
$StartTime = Get-Date

$Stones = (Get-Content $PSScriptRoot\Input.txt) -split " " | foreach {[int]$_}

# ======================================================================
# ======================================================================

#region Functions

class Stone
{
    [int64] $Value
    [int] $Blinks

    Stone([int64]$Value, [int]$Blinks) {
        $this.Init(@{Value = $Value; Blinks = $Blinks })
    }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }

    [string] ToString() {
        return "$($this.Value),$($this.Blinks)"
    }
}

$Script:LookupTable = @{}

function Calculate-NumberOfStones
{
    param
    (
        $stone 
    )

    if ($Stone.Blinks -eq $script:Blinks)
    {
        return 1
    }

    if ($Script:LookupTable[$($Stone.ToString())])
    {
        return $Script:LookupTable[$($Stone.ToString())]
    }

    if ($stone.Value -eq 0)
    {
        $NewStone = [Stone]::new(1,$($Stone.Blinks + 1))
        $Count = Calculate-NumberOfStones -stone $NewStone
        $Script:LookupTable[$($NewStone.ToString())] = $count
        Return $Count
    }
    elseif ($stone.Value.ToString().Length % 2 -eq 0)
    {
        $stoneStr = $Stone.Value.ToString()
        $MidIndex = (($stoneStr.length)/2)
        $Stone1 = [Stone]::new([int]($stoneStr[0..($MidIndex -1)] -join ""),$Stone.Blinks)
        $Stone2 = [Stone]::new([int]($stoneStr[$midindex..($stoneStr.length-1)] -join ""),$Stone.Blinks)
        
        $Stone1.Blinks++
        $Count1 = Calculate-NumberOfStones -stone $stone1
        $Script:LookupTable[$($Stone1.ToString())] = $Count1

        $Stone2.Blinks++
        $Count2 = Calculate-NumberOfStones -stone $stone2
        $Script:LookupTable[$($Stone2.ToString())] = $Count2

        return ($Count1 + $Count2)
    }
    else
    {
        $NewStone = [Stone]::new($stone.Value * 2024,$($Stone.Blinks + 1))
        $Count = Calculate-NumberOfStones -stone $NewStone
        $Script:LookupTable[$($NewStone.ToString())] = $count
        Return $Count
    }
}
#Endregion Functions

$TotalStones = 0

$Script:Blinks = 25
foreach ($Stone in $Stones)
{
    $TotalStones += Calculate-NumberOfStones -stone ([Stone]::new($Stone,0))
}

# $LookupTable
Write-Host "Number of Stones: $TotalStones"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"