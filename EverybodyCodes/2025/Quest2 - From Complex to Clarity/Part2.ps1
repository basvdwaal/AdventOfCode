
Set-StrictMode -Version latest

$PuzzleInput = (Get-Content $PSScriptRoot\input2.txt)
# $PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

$StartTime = Get-Date
# ======================================================================
# ======================================================================

#region Functions

class Complex
{
    [Int64]$X
    [Int64]$Y

    # Constructor
    Complex([Int64]$x, [Int64]$y)
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
        $newX = [math]::Truncate( $1.X / $2.X )
        $newY = [math]::Truncate( $1.Y / $2.Y )
        return [Complex]::new($newX, $newY)
    }
    
    [string] ToString()
    {
        return "[$($this.X),$($this.Y)]"
    }
}

function Test-ShouldPointBeEngraved-slow ([Complex]$point, [switch]$verbose)
{
    $result = [Complex]::new(0,0)
    $DivisionObj = [Complex]::new(100000,100000)
    
    foreach ($i in 1..100)
    {
        $Result = $Result * $Result
        $Result = $Result / $DivisionObj
        $Result = $Result + $point

        if ($result.X -gt 1000000 -or $result.X -lt -1000000 -or
            $result.Y -gt 1000000 -or $result.Y -lt -1000000 )
        {
            if ($verbose)
            {
                Write-Host "Returning False after $i cycles" -ForegroundColor Cyan
                Write-Host "Current R value: $($result.ToString())" -ForegroundColor Cyan
            }
            
            Return $false
        }
    }
    if ($verbose)
    {
        Write-Host "Returning True after $i cycles" -ForegroundColor Cyan
        Write-Host "Current R value: $($result.ToString())" -ForegroundColor Cyan
    }
    Return $true
}

function Test-ShouldPointBeEngraved ([Int64]$pX, [Int64]$pY, [switch]$verbose)
{
    [Int64]$zX = 0
    [Int64]$zY = 0
    
    foreach ($i in 1..100)
    {
        # 1. Z = Z * Z
        # $newX = ($zX * $zX) - ($zY * $zY)
        # $newY = ($zX * $zY) + ($zY * $zX)  -> wat 2 * $zX * $zY is
        [Int64]$zX_new = ($zX * $zX) - ($zY * $zY)
        [Int64]$zY_new = 2 * $zX * $zY

        # 2. Z = Z / Div(100000)
        $zX = [math]::Truncate( $zX_new / 100000 )
        $zY = [math]::Truncate( $zY_new / 100000 )

        # 3. Z = Z + C (het punt $pX, $pY)
        $zX = $zX + $pX
        $zY = $zY + $pY

        if ($zX -gt 1000000 -or $zX -lt -1000000 -or
            $zY -gt 1000000 -or $zY -lt -1000000 )
        {
            if ($verbose)
            {
                Write-Host "Returning False after $i cycles" -ForegroundColor Cyan
                Write-Host "Current R value: $($result.ToString())" -ForegroundColor Cyan
            }
            
            Return $false
        }
    }
    if ($verbose)
    {
        Write-Host "Returning True after $i cycles" -ForegroundColor Cyan
        Write-Host "Current R value: $($result.ToString())" -ForegroundColor Cyan
    }
    Return $true
}

#Endregion Functions

$A = [Complex]::new(($PuzzleInput -split "=")[1])
$FinalPoint = $A + [Complex]::new(1000, 1000)
$PointsToEngrave = 0

for ($pX = $A.X; $pX -le $FinalPoint.X; $pX += 10)
{
    for ($pY = $A.Y; $pY -le $FinalPoint.Y; $pY += 10)
    {
        if (Test-ShouldPointBeEngraved $pX $pY)
        {
            $PointsToEngrave++
        }
    }
}

Write-Host "Total points to engrave: $PointsToEngrave"

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:11.8317291