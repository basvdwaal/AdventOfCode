
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = Get-Content $PSScriptRoot\Input.txt -Raw

# ======================================================================
# ======================================================================

#region Functions
function Convert-TextToGrid {
    param (
        [string[]]$TextLines
    )

    # Resultaat grid
    $Grid = @{}

    for ($y = 0; $y -lt $TextLines.Count; $y++) {
        $line = $TextLines[$y]
        for ($x = 0; $x -lt $line.Length; $x++) {
            $letter = $line[$x]
            $obj = [PSCustomObject]@{
                X      = $x
                Y      = $y
                Letter = $letter
            }
            $Grid["$x,$y"] = $obj
        }
    }

    $Script:GridWidth = $line.Length
    $Script:GridHeight = $TextLines.Count

    return $Grid
}

function Write-GridToScreen {
    param (
        [hashtable]$Grid
    )

    Clear-Host
    $arr = New-Object System.Collections.ArrayList
    [void]$arr.Add("")
    for ($Y = 0; $Y -lt $script:GridHeight; $Y++)
    {
        
        for ($X = 0; $X -le $Script:GridHeight; $X++)
        {
            $pos = $Grid["$x,$y"]

            if ($pos)
            {
                [void]$arr.Add($pos.Letter)
            }
        }
        [void]$arr.Add("`r`n")
    }
    Write-Host $arr
}

#Endregion Functions

$Moves = @{
    [char]">" = [PSCustomObject]@{ Direction = "Right"; X = 1; Y =  0}
    [char]"<" = [PSCustomObject]@{ Direction = "Left"; X = -1; Y =  0}
    [char]"v" = [PSCustomObject]@{ Direction = "Down"; X = 0; Y =  1} # Reversed due to the assignment!
    [char]"^" = [PSCustomObject]@{ Direction = "Up"; X = 0; Y =  -1} # Reversed due to the assignment!
}


$Split = $PuzzleInput -split "`r`n`r`n"
$Grid = Convert-TextToGrid ($Split[0] -split "`r`n")
$PuzzleInput = ($Split[1] -replace "`r`n", "").ToCharArray()

$Rx = ($Grid.Values | where Letter -eq "@").x
$Ry = ($Grid.Values | where Letter -eq "@").y

# Write-GridToScreen -Grid $Grid

# $null = Read-host "Press any key to start"

foreach ($Move in $PuzzleInput)
{
    $D = $Moves[$Move]
    $Ox, $Oy = $Rx, $Ry

    $Nx = $Rx + $D.x
    $Ny = $Ry + $D.y

    if ($Grid["$Nx,$Ny"].Letter -eq "#") # Wall
    {
        # Do nothing
        # Write-Host "Skipping $($D.Direction) because there is a wall"
        Continue
    }
    elseif ($Grid["$Nx,$Ny"].Letter -eq ".") # Empty space
    {
        # Update grid for the robot
        $Grid["$Nx,$Ny"].Letter = "@"
        $Grid["$Ox,$Oy"].Letter = "."

        # Update robot
        $Rx, $Ry = $Nx, $Ny
    }
    elseif ($Grid["$Nx,$Ny"].Letter -eq "O") # Box
    {
        $Q = New-Object System.Collections.Stack
        $Q.Push( @($Nx,$Ny) )

        $Cx = $Nx
        $Cy = $Ny
        # Check the next space(s) to see if we can move the box
        do
        {
            $Cx = $Cx + $D.x
            $Cy = $Cy + $D.y
            $Q.Push( @($Cx,$Cy) )
        }
        while ($Grid["$Cx,$Cy"].Letter -eq "O" )

        if ($Grid["$Cx,$Cy"].Letter -eq "#") # Wall after boxes
        {
            # Do nothing
            # Write-Host "Skipping $($D.Direction) because there is a wall after the boxes"
            continue
        }
        elseif ($Grid["$Cx,$Cy"].Letter -eq ".") # Free space after boxes
        {
            # Move entire stack of boxes
            while ($Q.Count -gt 0)
            {
                $Ix, $Iy = $Q.Pop()
                $Grid["$Ix,$Iy"].Letter = "O"
            }

            # Update grid for the robot
            $Grid["$Nx,$Ny"].Letter = "@"
            $Grid["$Ox,$Oy"].Letter = "."

            # Update robot
            $Rx, $Ry = $Nx, $Ny
        }
    }
    else
    {
        Write-Error "Unknown case!"
    }

    # Write-GridToScreen -Grid $Grid
    # $null = Read-host " "
}

# Write-GridToScreen -Grid $Grid

$Total = 0
foreach ($Box in $Grid.Values | where Letter -eq "O")
{
    $Total += ($Box.Y * 100 + $Box.X)
}

Write-Host "Total: $Total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.4422923