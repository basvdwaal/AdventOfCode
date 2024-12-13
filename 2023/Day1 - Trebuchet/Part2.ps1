
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

$Total = 0
[regex]$Regex = "\d"

$NumbersDict = @{
    "one" = 1
    "two" = 2
    "three" = 3
    "four" = 4
    "five" = 5
    "six" = 6
    "seven" = 7
    "eight" = 8
    "nine" = 9
    "1" = 1
    "2" = 2
    "3" = 3
    "4" = 4
    "5" = 5
    "6" = 6
    "7" = 7
    "8" = 8
    "9" = 9
}

foreach ($line in $PuzzleInput)
{

    $arr = @()
    foreach ($number in $NumbersDict.Keys)
    {
        $m = ($line | Select-String $number -AllMatches)
        if ($m)
        {
            $Indesis = $m.Matches.Index       
            foreach ($index in $Indesis)
            {
                $arr += [pscustomobject]@{
                    Index = $index
                    Value = $NumbersDict[$number]
                }
            }
        }
    }
    
    $arr = $arr | Sort-Object -Property Index
    $Total += [int]($arr[0].Value, $arr[-1].Value -join "")
    [int]($arr[0].Value, $arr[-1].Value -join "")
}

Write-Host "Total: $Total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.8549640