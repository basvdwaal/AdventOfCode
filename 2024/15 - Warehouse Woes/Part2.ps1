
Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'
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

    for ($y = 0; $y -lt $TextLines.Count; $y++)
    {
        $line = $TextLines[$y]
        $x = 0
        foreach ($letter in $line.ToCharArray())
        {
            If ($letter -eq [char]"#") {$t = "##"}
            elseif ($letter -eq [char]"O") { $t = "[]" }
            elseif ($letter -eq [char]".") { $t = ".." }
            elseif ($letter -eq [char]"@") { $t = "@." }

            $obj = [PSCustomObject]@{
                X      = $x
                Y      = $y
                Letter = $t[0]
            }
            $Grid["$x,$y"] = $obj
            $x++

            $obj = [PSCustomObject]@{
                X      = $x
                Y      = $y
                Letter = $t[1]
            }
            $Grid["$x,$y"] = $obj
            $x++
        }
    }

    $Script:GridWidth = $line.Length * 2
    $Script:GridHeight = $TextLines.Count

    return $Grid
}

function Write-GridToScreen {
    param (
        [hashtable]$Grid,
        $Rx,
        $Ry
    )

    $Gridsize = 20
    $arr = New-Object System.Collections.ArrayList
    [void]$arr.Add("")
    for ($Y = $Ry - ($Gridsize/2); $Y -le ($Ry + ($Gridsize/2)); $Y++)
    {
        for ($X = $Rx - ($Gridsize/2); $X -le ($Rx + ($Gridsize/2)); $X++)
        {
            $pos = $Grid["$x,$y"]
            if ($pos)
            {
                [void]$arr.Add($pos.Letter)
            }
        }
        [void]$arr.Add("`r`n")
    }
    # Clear-Host
    Write-Host $arr
}

function Get-RelevantBoxes {
    param (
        $Bx, $By,
        $D
    )

    # Add Current box to array
    # $Boxes = New-Object System.Collections.ArrayList
    # [void]$Boxes.Add(@($Bx,$By))
    $Boxes = @()
    $Boxes += , @($Bx,$By)

    if ($script:Grid["$Bx,$By"].Letter -eq "[")
    {
        # [void]$Boxes.Add( @(($Bx + 1),$By) )
        $Boxes += , @(($Bx + 1),$By)
    }
    else
    {
        # [void]$Boxes.Add( @(($Bx - 1),$By) )
        $Boxes += , @(($Bx - 1),$By)
    }

    # Check the next layer of boxes
    $CurrentLayer = $Boxes.Clone()
    foreach ($half in $CurrentLayer)
    {
        try
        {
            $Nx = $half[0] + $D.x
            $Ny = $half[1] + $D.y

            if ($Script:Grid["$Nx,$Ny"].Letter -in @("[","]"))
            {
                # [void]$Boxes.add( (Get-RelevantBoxes $Nx $Ny $D) )
                $t = Get-RelevantBoxes $Nx $Ny $D
                $Boxes += @($t)
            }
            elseif ($Script:Grid["$Nx,$Ny"].Letter -eq "#")
            {
                $script:MoveIsPossible = $false
            }
        }
        catch
        {
            $_
        }
    }

    return $Boxes
}

function Move-BoxesLeftRight {
    param (
        $Nx, $Ny, $D
    )
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
    while ($script:Grid["$Cx,$Cy"].Letter -in @("[","]") )

    if ($script:Grid["$Cx,$Cy"].Letter -eq "#") # Wall after boxes
    {
        # Do nothing
        # Write-Host "Skipping $($D.Direction) because there is a wall after the boxes"
        return $false
    }
    elseif ($script:Grid["$Cx,$Cy"].Letter -eq ".") # Free space after boxes
    {
        # Move entire stack of boxes
        while ($Q.Count -gt 0)
        {
            $Ix, $Iy = $Q.Pop()
            if ($D.direction -eq "Left")
            {
                switch ($script:Grid["$Ix,$Iy"].Letter)
                {
                    "." { $script:Grid["$Ix,$Iy"].Letter = "[" }
                    "[" { $script:Grid["$Ix,$Iy"].Letter = "]" }
                    "]" { $script:Grid["$Ix,$Iy"].Letter = "[" }
                }
            }
            else
            {
                switch ($script:Grid["$Ix,$Iy"].Letter)
                {
                    "." { $script:Grid["$Ix,$Iy"].Letter = "]" }
                    "[" { $script:Grid["$Ix,$Iy"].Letter = "]" }
                    "]" { $script:Grid["$Ix,$Iy"].Letter = "[" }
                }
            }

        }
    }
    return $true
}

function Move-BoxesUpDown {
    param (
        $Nx, $Ny, $D
    )

    $script:MoveIsPossible = $true
    # Get all relevant box halves for the current direction
    $Boxes = Get-RelevantBoxes $Nx $Ny $D
    
    if ($MoveIsPossible)
    {
        [array]::Reverse($Boxes)
        foreach ($Boxhalf in $Boxes | select -Unique)
        {
            
        try {
            $Bx = $Boxhalf[0]
            $By = $Boxhalf[1]
            
            $Letter = $Script:Grid["$Bx,$By"].Letter
            
            $BNx = $Boxhalf[0] + $D.x
            $BNy = $Boxhalf[1] + $D.y

            $Script:Grid["$BNx,$BNy"].Letter = $Letter
            $Script:Grid["$Bx,$By"].Letter = "."

            # Write-GridToScreen -Grid $Script:Grid
        }
        catch {
            $_
        }
        }
        return $true
    }
    else
    {
        # Do nothing
        # Write-Host "Skipping $($D.Direction) because there is a wall after the boxes"
        return $false
    }
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

# Write-GridToScreen $Grid $Rx $Ry

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
    elseif ($Grid["$Nx,$Ny"].Letter -in @("[","]")) # Box
    {
        if ($D.Direction -eq "Right" -or $D.Direction -eq "Left")
        {
            $result = Move-BoxesLeftRight $Nx $Ny $D
        }
        else
        {
            $result = Move-BoxesUpDown $Nx $Ny $D
        }

        if ($result)
        {
            # Update grid for the robot
            $script:Grid["$Nx,$Ny"].Letter = "@"
            $script:Grid["$Ox,$Oy"].Letter = "."

            # Update robot
            $Rx, $Ry = $Nx, $Ny
        }
    }
    else
    {
        Write-Error "Unknown case!"
    }

    # Write-GridToScreen $Grid $Rx $Ry
    # $null = Read-host " "
}

# Write-GridToScreen -Grid $Grid

$Total = 0
foreach ($Box in $Grid.Values | where Letter -eq "[")
{
    $Total += ($Box.Y * 100 + $Box.X)
}

Write-Host "Total: $Total"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.7852781