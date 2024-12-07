#Requires -Version 7.0
Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\SampleInput.txt)

# ======================================================================
# ======================================================================


#region Functions
function Convert-TextToGrid {
    param (
        [string[]]$TextLines
    )

    $Grid = @{}

    for ($y = 0; $y -lt $TextLines.Count; $y++) {
        $line = $TextLines[$y]
        for ($x = 0; $x -lt $line.Length; $x++) {
            $obj = [PSCustomObject]@{
                X      = $x
                Y      = $y
                Letter = $line[$x]
            }
            $Grid["$x,$y"] = $obj
        }
    }

    $GridWidth = $line.Length
    $gridHeight = $TextLines.Count

    # Return Width and Height -1 so they match the coords of the last item
    return $grid, ($GridWidth - 1), ($gridHeight - 1)
}

function Get-NewDirection {
    param
    (
        [PSCustomObject]
        $CurrentDirection
    )

    $CurrentIndex = $Directions.IndexOf($CurrentDirection)
    $NewIndex = $CurrentIndex + 1

    # If NewIndex is out of bonds, we manually 'overflow'
    if ($NewIndex -lt 4)
    {
        Return $Directions[$NewIndex]
    }
    else
    {
        Return $Directions[0]
    }
}

function Write-GridToScreen {
    param (
        [hashtable]$Grid,
        [PSCustomObject]$CurrentPos,
        [PSCustomObject]$Direction
    )

    $Gridsize = 20

    Clear-Host
    for ($Y = $CurrentPos.Y - ($Gridsize/2); $Y -le ($CurrentPos.Y + ($Gridsize/2)); $Y++)
    {
        $arr = New-Object System.Collections.ArrayList       
        for ($X = $CurrentPos.X - ($Gridsize/2); $X -le ($CurrentPos.X + ($Gridsize/2)); $X++)
        {
            $pos = $Grid["$x,$y"]
            
            if ($pos)
            {
                $arr.Add($pos.Letter) | Out-Null
            }
        }
        Write-Host $arr
    }

    Start-Sleep -Milliseconds 20
}

function Move-AlongPath {
    param
    (
        $Grid,
        $StartPos,
        $Direction
    )

    $WalkedTiles = New-Object System.Collections.ArrayList
    $CurrentPos = [PSCustomObject]@{X = $StartPos.X; Y =  $StartPos.Y; Direction = $Direction.Direction}
    $WalkedTiles += $CurrentPos

    While ($CurrentPos.X -gt $LeftBoundary -and $CurrentPos.X -lt $RightBoundary -and $CurrentPos.Y -gt $TopBoundary -and $CurrentPos.y -lt $LowerBoundary)
    {
        if ($WalkedTiles.Count -gt 10000)
        {
            Write-Host "Loop detected!"
            $Script:LoopCount++
            Break
        }
        
        $NewPos = [PSCustomObject]@{X = $CurrentPos.X + $Direction.X; Y = $CurrentPos.Y + $Direction.Y; Direction = $Direction.Direction}
        # Check for obstacle at new position
        if ($Grid["$($NewPos.X),$($NewPos.Y)"].Letter -eq '#')
        {
            $Direction = Get-NewDirection -CurrentDirection $Direction
        }
        else
        {   
            $Grid["$($CurrentPos.X),$($CurrentPos.Y)"] = [PSCustomObject]@{X = $CurrentPos.X;Y = $CurrentPos.Y; Letter = 'X' }
            $Grid["$($NewPos.X),$($NewPos.Y)"] = [PSCustomObject]@{X = $NewPos.X;Y = $NewPos.Y; Letter = $Direction.Icon }
    
            $CurrentPos = $NewPos
            # Write-Host "Moved to ($($NewPos.X),$($NewPos.Y))"
            # Write-GridToScreen -Grid $Grid -CurrentPos $CurrentPos -Direction $Direction
            
            $WalkedTiles += $NewPos
        }
    }

    return $WalkedTiles
}

#Endregion Functions

$Directions = @(
    [PSCustomObject]@{ Direction = "Up"; X = 0; Y =  -1; Icon = '^'},
    [PSCustomObject]@{ Direction = "Right"; X = 1; Y =  0; Icon = '>'},
    [PSCustomObject]@{ Direction = "Down"; X = 0; Y =  1; Icon = 'v'},
    [PSCustomObject]@{ Direction = "Left"; X = -1; Y =  0; Icon = '<'}
)

$Grid, $a, $b = Convert-TextToGrid -TextLines $PuzzleInput
$TopBoundary = 0
$RightBoundary = $a
$LowerBoundary = $b
$LeftBoundary = 0
$StartPos = $Grid.Values | where {$_.Letter -eq '^'}

$LoopCount = 0

$processedItems = [hashtable]::Synchronized(@{
    Lock    = [System.Threading.Mutex]::new()
    Counter = 0
})

if (Test-Path $PSScriptRoot\DefaultRoute.cli.xml)
{
    $WalkedTiles = Import-Clixml $PSScriptRoot\DefaultRoute.cli.xml
}
else
{
    # Start direction is Up
    $Direction = $Directions[0]
    
    # Find boundaries of the playfield

    Write-Host "StartDir: $($Direction.Direction)"
    Write-Host "StartPos: ($($StartPos.X),$($StartPos.Y))"
    
    $WalkedTiles = Move-AlongPath -StartPos $StartPos -Direction $Direction -Grid $Grid
    $WalkedTiles | Export-Clixml -Path $PSScriptRoot\DefaultRoute.cli.xml
}

# foreach ($Tile in $WalkedTiles[1..$($WalkedTiles.Count-1)])
$LoopCount = $WalkedTiles[1..$($WalkedTiles.Count-1)] | ForEach-Object -ThrottleLimit 10 -Parallel {
    Set-StrictMode -Version latest
    $ErrorActionPreference = 'Stop'

    $TopBoundary = 0
    $RightBoundary = $using:RightBoundary
    $LowerBoundary = $using:LowerBoundary
    $LeftBoundary = 0

    $Directions = $using:Directions

    Write-Warning "Starting tile.. $(Get-Date -Format "HH:mm:ss")"
    
    function Move-AlongPath {
        param
        (
            $Grid,
            $StartPos,
            $Direction
        )
    
        $WalkedTiles = 0
        $CurrentPos = [PSCustomObject]@{X = $StartPos.X; Y =  $StartPos.Y; Direction = $Direction.Direction}
        While ($CurrentPos.X -gt $LeftBoundary -and $CurrentPos.X -lt $RightBoundary -and $CurrentPos.Y -gt $TopBoundary -and $CurrentPos.y -lt $LowerBoundary)
        {
            if ($WalkedTiles -gt 10000)
            {
                # bring the local variable to this scope
                $ref = $using:processedItems
                # lock this thread until I can write
                if ($ref['Lock'].WaitOne()) {
                    # when I can write, update the value
                    $ref['Counter']++
                    # and realease this lock so others threads can write
                    $ref['Lock'].ReleaseMutex()
                }
            }
            
            $NewPos = [PSCustomObject]@{X = $CurrentPos.X + $Direction.X; Y = $CurrentPos.Y + $Direction.Y; Direction = $Direction.Direction}
            # Check for obstacle at new position
            if ($Grid["$($NewPos.X),$($NewPos.Y)"].Letter -eq '#')
            {
                $Direction = Get-NewDirection -CurrentDirection $Direction
            }
            else
            {   
                $Grid["$($CurrentPos.X),$($CurrentPos.Y)"] = [PSCustomObject]@{X = $CurrentPos.X;Y = $CurrentPos.Y; Letter = 'X' }
                $Grid["$($NewPos.X),$($NewPos.Y)"] = [PSCustomObject]@{X = $NewPos.X;Y = $NewPos.Y; Letter = $Direction.Icon }
        
                $CurrentPos = $NewPos
                # Write-Host "Moved to ($($NewPos.X),$($NewPos.Y))"
                # Write-GridToScreen -Grid $Grid -CurrentPos $CurrentPos -Direction $Direction
                
                $WalkedTiles++
            }
        }
    }

    function Get-NewDirection {
        param
        (
            [PSCustomObject]
            $CurrentDirection
        )
    
        $CurrentIndex = $Directions.IndexOf($CurrentDirection)
        $NewIndex = $CurrentIndex + 1
    
        # If NewIndex is out of bonds, we manually 'overflow'
        if ($NewIndex -lt 4)
        {
            Return $Directions[$NewIndex]
        }
        else
        {
            Return $Directions[0]
        }
    }

    try
    {
        $Tile = $_
        $Grid = $using:Grid

        $GridPos = $Grid["$($tile.X),$($tile.Y)"] 

        $GridPos.Letter = '#'
        $NewGrid = $Grid
        $NewGrid["$($tile.X),$($tile.Y)"] = $GridPos

        $Direction = $using:Directions | where {$_.Direction -eq $Tile.Direction}

        # Write-Host "Starting path $Index"
        # $PathStartTime = Get-Date
        Move-AlongPath -Grid $NewGrid -StartPos $Using:Startpos -Direction $Direction
        # Write-Host "Path runtime: $((Get-Date) - $PathStartTime)"
        # Write-Host "Total steps: $($WalkedTilesNewPath.Count)"
        # ($Script:Results).Add("$($tile.X),$($tile.Y)", $res)
        # $Index++
    }
    catch
    {
        Write-Warning $_
    }
    Write-Information "Tile finished"
}

Write-Host "Infinite loops: $($processedItems['Counter'])"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"