$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions

function Print-StateToScreen {
    param (
        $Robots
    )
    Clear-Host

    for ($j = 0; $j -lt $AreaHeight; $j++)    
    {
        for ($i = 0; $i -lt $AreaWidth; $i++)
        {
            if ($script:RPos["$i,$j"])
            {
                $n = $script:RPos["$i,$j"]
                Write-Host $n -NoNewline -ForegroundColor ("Red", "Green" | Get-random)
            }
            else
            {
                Write-Host "." -NoNewline 
            }
        }
        Write-Host "`r`n" -NoNewline
    }
}

#Endregion Functions

$Seconds = 100000
$AreaWidth = 101
$AreaHeight = 103

$script:Mx = ($AreaWidth - 1) / 2
$script:My = ($AreaHeight - 1) / 2
$Robots = @()
$script:RPos = @{}

$Id = 0
foreach ($Line in $PuzzleInput)
{
    [int]$Rx, [int]$Ry, [int]$Dx, [int]$Dy = $Line -replace "p=","" -replace "v=","" -split " " -split ","

    $Robots += [pscustomobject]@{
        Id = $Id
        x = $Rx
        y = $Ry
        dx = $Dx
        dy = $Dy
    }
    $Id++

    if ($script:RPos["$Rx,$Ry"])
    {
        $script:RPos["$Rx,$Ry"]++
    }
    else
    {
        $script:RPos["$Rx,$Ry"] = 1
    }
}

# Print-StateToScreen $Robots


for ($i = 0; $i -lt $Seconds; $i++)
{
    if ($i % 10000 -eq 0)
    {
        Write-Host $i
    }
    
    $script:RPos = @{}
    foreach ($R in $Robots)
    {
        $R.x += $R.dx
        $R.y += $R.dy

        if ($R.x -lt 0) { $R.x = $AreaWidth + $R.x }
        if ($R.y -lt 0) { $R.y = $AreaHeight + $R.y }
    
        if ($R.x -ge $AreaWidth ) { $R.x = $R.x - $AreaWidth }
        if ($R.y -ge $AreaHeight) { $R.y = $R.y - $AreaHeight }

        if ($RPos["$($R.x),$($R.y)"])
        {
            $RPos["$($R.x),$($R.y)"]++
        }
        else
        {
            $RPos["$($R.x),$($R.y)"] = 1
        }
    }
    
    if ($RPos.Values -notcontains 2)
    {
        Print-StateToScreen $Robots
        Write-host $i
        break
    }
    
}


# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:25.9756860