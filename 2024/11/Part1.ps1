
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
        $Value,
        $Blinks
    )

    if ($Blinks -eq $script:Blinks)
    {
        return 1
    }

    if ($Script:LookupTable["$Value,$Blinks"])
    {
        return $Script:LookupTable["$Value,$Blinks"]
    }

    if ($Value -eq 0)
    {
        $Count = Calculate-NumberOfStones -Value 1 -Blinks ($Blinks + 1)
        $Script:LookupTable["$Value,$Blinks"] = $count
        Return $Count
    }
    elseif ($Value.ToString().Length % 2 -eq 0)
    {
        $stoneStr = $Value.ToString()
        $MidIndex = (($stoneStr.length)/2)
        $Value1 = [int]($stoneStr[0..($MidIndex -1)] -join "")
        $Value2 = [int]($stoneStr[$midindex..($stoneStr.length-1)] -join "")
        
        $Count1 = Calculate-NumberOfStones -Value $Value1 -Blinks ($Blinks + 1)
        $Script:LookupTable["$Value1,$Blinks"] = $Count1

        $Count2 = Calculate-NumberOfStones -Value $Value2 -Blinks ($Blinks + 1)
        $Script:LookupTable["$Value2,$Blinks"] = $Count2

        return ($Count1 + $Count2)
    }
    else
    {
        $Count = Calculate-NumberOfStones -Value ($Value * 2024) -Blinks ($Blinks + 1)
        $Script:LookupTable["$Value,$Blinks"] = $count
        Return $Count
    }
}
#Endregion Functions

$TotalStones = 0

$Script:Blinks = 25
foreach ($Stone in $Stones)
{
    $TotalStones += Calculate-NumberOfStones -Value $Stone -Blinks 0
}

# $LookupTable
Write-Host "Number of Stones: $TotalStones"


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"