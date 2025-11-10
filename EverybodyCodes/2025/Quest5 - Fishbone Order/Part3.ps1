
Set-StrictMode -Version latest

# $PuzzleInput = (Get-Content $PSScriptRoot\sample3.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input3.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

class Sword : System.IComparable {
    [array] $Fishbone
    [int] $Id
    [int64] $Quality
    [string[]] $Scores

    Sword([int] $Id, [int[]] $numbers) {
        
        $this.Id = $Id

        # Construct the fishbone
        :Numbers
        foreach ($Number in $numbers)
        {
            foreach ($Row in $this.Fishbone)
            {
                if (! $Row.left -and $number -lt $row.Spine)
                {
                    $Row.left = $number
                    continue Numbers
                }

                if (! $Row.right -and $number -gt $row.Spine)
                {
                    $Row.right = $number
                    continue Numbers
                }
            }

            $this.Fishbone += [PSCustomObject]@{
                Left  = $null
                Spine = $Number
                Right = $null 
            }
        }

        # Calculate the Quality and Score per level
        $total = ""
        foreach ($row in $this.Fishbone)
        {
            $total = "$total$($row.spine)"
            $LevelScore = "$($Row.Left)$($Row.Spine)$($row.Right)"
            $this.Scores += $LevelScore
        }
        $this.Quality = $total
    }

    [int] CompareTo($otherSword)
    {
        if ($this.Quality -gt $otherSword.Quality) { return 1 }
        if ($this.Quality -lt $otherSword.Quality) { return -1 }
        if ($this.Quality -eq $otherSword.Quality)
        {
            # Only works if both swords have the same amount of rows
            for ($i = 0; $i -lt $this.Scores.Count; $i++)
            {
                if ([int]$this.Scores[$i] -gt [int]$otherSword.Scores[$i]) { return 1 }
                elseif ([int]$this.Scores[$i] -lt [int]$otherSword.Scores[$i]) { return -1 }

            }

            # All Scores equal, compare Id
            If ($this.Id -gt $otherSword.Id) { return 1 }
            elseif ($this.Id -lt $otherSword.Id) { return -1 }
            elseif ($this.Id -eq $otherSword.Id) { return 0 }  # Not sure why, but sort-object seems to compare it against itself??
            else { throw "Unknown error"}
        }

        return $null
    }
}

#Endregion Functions


$Swords = @()

foreach ($line in $PuzzleInput)
{
    $Id, $str = $line -split ":"
    $InputArr = New-Object System.Collections.ArrayList
    $inputArr.AddRange([int[]]($str -split ",")) | Out-Null

    $Swords += [Sword]::new($id, $InputArr)
}

$swords = $swords | Sort-Object -Descending

$total = 0
for ($i = 0; $i -lt $swords.Count; $i++)
{
    $total += ($i + 1) * $Swords[$i].Id 
}

Write-Host "Total: $total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.3442650