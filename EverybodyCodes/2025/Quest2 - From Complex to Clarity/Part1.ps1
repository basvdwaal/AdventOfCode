
Set-StrictMode -Version latest
$StartTime = Get-Date

# $PuzzleInput = (Get-Content $PSScriptRoot\sample.txt)
$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions

class Complex
{
    [int]$X
    [int]$Y

    # Constructor
    Complex([int]$x, [int]$y)
    {
        $this.X = $x
        $this.Y = $y
    }

    Complex([string]$string)
    {
        $this.X, $this.Y = $string.Replace('[', '').Replace(']', '') -split ","
    }

    # Optellen
    # [X1,Y1] + [X2,Y2] = [X1 + X2, Y1 + Y2]
    static [Complex] op_Addition([Complex]$1, [Complex]$2)
    {
        $newX = $1.X + $2.X
        $newY = $1.Y + $2.Y
        return [Complex]::new($newX, $newY)
    }

    # Vermendigvuldingen
    # [X1,Y1] * [X2,Y2] = [X1 * X2 - Y1 * Y2, X1 * Y2 + Y1 * X2]
    static [Complex] op_Multiply([Complex]$1, [Complex]$2)
    {
        $newX = ($1.X * $2.X) - ($1.Y * $2.Y)
        $newY = ($1.X * $2.Y) + ($1.Y * $2.X)
        return [Complex]::new($newX, $newY)
    }

    # Delen
    # [X1,Y1] / [X2,Y2] = [X1 / X2, Y1 / Y2]
    static [Complex] op_Division([Complex]$1, [Complex]$2)
    {
        $newX = [math]::Floor( $1.X / $2.X )
        $newY = [math]::Floor( $1.Y / $2.Y )
        return [Complex]::new($newX, $newY)
    }
    
    [string] ToString()
    {
        return "[$($this.X),$($this.Y)]"
    }
}


#Endregion Functions

$Result = [Complex]::new("[0,0]")
$A = [Complex]::new(($PuzzleInput -split "=")[1])


$Result = $Result * $Result
$Result = $Result / [Complex]::new(10,10)
$Result = $Result + $A
Write-host "After Cycle 1: $($Result.ToString())"

$Result = $Result * $Result
$Result = $Result / [Complex]::new(10,10)
$Result = $Result + $A
Write-host "After Cycle 2: $($Result.ToString())"

$Result = $Result * $Result
$Result = $Result / [Complex]::new(10,10)
$Result = $Result + $A
Write-host "After Cycle 3: $($Result.ToString())"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.3277670