
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions

function Print-StateToScreen {
    param (
        $Rx,
        $Ry,
        $Dx,
        $Dy,
        $Ox,
        $Oy
    )
    Clear-Host

    Write-Host "# " -NoNewline
    for ($i = 0; $i -lt $AreaWidth; $i++)
    {
        Write-Host "$i " -NoNewline
    }
    Write-Host "`r`n" -NoNewline
    
    for ($j = 0; $j -lt $AreaHeight; $j++)    
    {
        Write-Host "$j " -NoNewline
        for ($i = 0; $i -lt $AreaWidth; $i++)
        {
            if ($i -eq $Rx -and $j -eq $Ry)
            {
                Write-Host "R " -NoNewline -ForegroundColor Blue
            }
            elseif ($i -eq $Ox -and $j -eq $Oy)
            {
                Write-Host "R " -NoNewline -ForegroundColor Red
            }
            else
            {
                if ($i -eq $Mx -or $j -eq $My)
                {
                    Write-Host "+ " -NoNewline 
                }
                else
                {
                    Write-Host ". " -NoNewline 
                }
            }
        }
        Write-Host "`r`n" -NoNewline
    }
    Write-Host "$Ox,$Oy + $Dx,$Dy = $Rx,$Ry"
}

#Endregion Functions



$Seconds = 100
$AreaWidth = 101
$AreaHeight = 103




$Quadrants = @{
    "TopLeft" = 0
    "TopRight" = 0
    "BottomLeft" = 0
    "BottomRight" = 0
}

$script:Mx = ($AreaWidth - 1) / 2
$script:My = ($AreaHeight - 1) / 2
$Fpos = @()

foreach ($Line in $PuzzleInput)
{
    [int]$Rx, [int]$Ry, [int]$Dx, [int]$Dy = $Line -replace "p=","" -replace "v=","" -split " " -split ","

    # Write-Host "Start: $Rx,$Ry"
    # Write-Host "Direction: $Dx,$Dy"

    for ($i = 0; $i -lt $Seconds; $i++)
    {
        $Ox = $Rx
        $Oy = $Ry
        
        $Rx += $Dx
        $Ry += $Dy

        if ($Rx -lt 0) { $Rx = $AreaWidth + $Rx }
        if ($Ry -lt 0) { $Ry = $AreaHeight + $Ry }

        if ($Rx -ge $AreaWidth ) { $Rx = $Rx - $AreaWidth }
        if ($Ry -ge $AreaHeight) { $Ry = $Ry - $AreaHeight }

        # Print-StateToScreen $Rx $Ry $Dx $Dy $Ox $Oy
        
        
    }

    # Print-StateToScreen $Rx $Ry $Dx $Dy $Ox $Oy

    $Fpos += ,@($Rx,$Ry)

    if ($Rx -lt $Mx -and $Ry -lt $My)
    {
        $Quadrants["TopLeft"]++
    }
    elseif ($Rx -gt $Mx -and $Ry -lt $My)
    {
        $Quadrants["TopRight"]++
    }
    elseif ($Rx -lt $Mx -and $Ry -gt $My)
    {
        $Quadrants["BottomLeft"]++
    }
    elseif ($Rx -gt $Mx -and $Ry -gt $My)
    {
        $Quadrants["BottomRight"]++
    }
}

Write-Host $Quadrants

$total = $null
foreach ($Value in $Quadrants.Values)
{
    if ($total)
    {
        $total *= $Value
    }
    else
    {
        $total = $Value
    }
}

Write-Host "Total: $Total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.1935661