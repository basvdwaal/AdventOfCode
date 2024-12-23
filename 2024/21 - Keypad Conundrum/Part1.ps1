
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions
#Endregion Functions


$KeypadDirections = @{
    "A" = @{
        "A" = ""
        "0" = "<"
        "1" = "^<<"
        "2" = "^<"
        "3" = "^"
        "4" = "^^<<"
        "5" = "^^<"
        "6" = "^^"
        "7" = "^^^<<"
        "8" = "^^^<"
        "9" = "^^^"
    }
    "0" = @{
        "A" = ">"
        "0" = ""
        "1" = "^<"
        "2" = "^"
        "3" = "^>"
        "4" = "^^<"
        "5" = "^^"
        "6" = "^^>"
        "7" = "^^^<"
        "8" = "^^^"
        "9" = "^^^>"
    }
    "1" = @{
        "A" = ">>v"
        "0" = ">v"
        "1" = ""
        "2" = ">"
        "3" = ">>"
        "4" = "^"
        "5" = "^>"
        "6" = "^>>"
        "7" = "^^"
        "8" = "^^>"
        "9" = "^^>>"
    }
    "2" = @{
        "A" = ">v"
        "0" = "v"
        "1" = "<"
        "2" = ""
        "3" = ">"
        "4" = "^<"
        "5" = "^"
        "6" = "^>"
        "7" = "^^<"
        "8" = "^^"
        "9" = ">^^"
    }
    "3" = @{
        "A" = "v"
        "0" = "v<"
        "1" = "<<"
        "2" = "<"
        "3" = ""
        "4" = "^<<"
        "5" = "^<"
        "6" = "^"
        "7" = "^^<<"
        "8" = "^^<"
        "9" = "^^"
    }
    "4" = @{
        "A" = ">>VV"
        "0" = ">V"
        "1" = "v"
        "2" = "v>"
        "3" = "v>>"
        "4" = ""
        "5" = ">"
        "6" = ">>"
        "7" = "^"
        "8" = "^>"
        "9" = "^>>"
    }
    "5" = @{
        "A" = ">vv"
        "0" = "vv"
        "1" = "v<"
        "2" = "v"
        "3" = "v>"
        "4" = "<"
        "5" = ""
        "6" = ">"
        "7" = "^<"
        "8" = "^"
        "9" = "^>"
    }
    "6" = @{
        "A" = "vv"
        "0" = "vv<"
        "1" = "v<<"
        "2" = "v<"
        "3" = "v"
        "4" = "<<"
        "5" = "<"
        "6" = ""
        "7" = "^<<"
        "8" = "^<"
        "9" = "^"
    }
    "7" = @{
        "A" = ">>vvv"
        "0" = ">vvv"
        "1" = "vv"
        "2" = ">vv"
        "3" = ">>vv"
        "4" = "v"
        "5" = ">v"
        "6" = ">>v"
        "7" = ""
        "8" = ">"
        "9" = ">>"
    }
    "8" = @{
        "A" = ">vvv"
        "0" = "vvv"
        "1" = "vv<"
        "2" = "vv"
        "3" = "vv>"
        "4" = "v<"
        "5" = "v"
        "6" = "v>"
        "7" = "<"
        "8" = ""
        "9" = ">"
    }
    "9" = @{
        "A" = "vvv"
        "0" = "vvv<"
        "1" = "<<vv"
        "2" = "<vv"
        "3" = "vv"
        "4" = "<<v"
        "5" = "<v"
        "6" = "v"
        "7" = "<<"
        "8" = "<"
        "9" = ""
    }
}

$MovementDict = @{
    "A" = @{
        "A" = ""
        "^" = "<"
        "<" = "v<<"
        "v" = "<v"
        ">" = "v"
    }
    "^" = @{
        "A" = ">"
        "^" = ""
        "<" = "v<"
        "v" = "v"
        ">" = "v>>"
    }
    "<" = @{
        "A" = ">>^"
        "^" = ">^"
        "<" = ""
        "v" = ">"
        ">" = ">>"
    }
    "v" = @{
        "A" = ">^"
        "^" = "^"
        "<" = "<"
        "v" = ""
        ">" = ">"
    }
    ">" = @{
        "A" = "^"
        "^" = "<^"
        "<" = "<<"
        "v" = "<"
        ">" = ""
    }
}

$StartLetter = "A"
$OutputR1 = ""
$Total = 0
foreach ($Code in $PuzzleInput)
{
    if ($Code[0] -eq "#") {continue}

    Write-Host $Code
    # Final robot
    $OutputR1 = ""
    $StartLetter = "A"
    foreach ($Letter in $Code.GetEnumerator()) 
    {
        $Letter = [string]$Letter
        $Movement = $KeypadDirections[$StartLetter][$Letter]

        # Write-Host "$StartLetter -> $letter = $Movement"

        $OutputR1 += $Movement + "A"
        $StartLetter = $Letter
    }
    Write-Host $OutputR1
    
    # Robot 2
    $OutputR2 = ""
    $StartLetter = "A"
    foreach ($Letter in $OutputR1.GetEnumerator())
    {
        $Letter = [string]$Letter
        $Movement = $MovementDict[$StartLetter][$Letter] 

        # Write-Host "$StartLetter -> $letter = $Movement"

        $OutputR2 += $Movement + "A"
        $StartLetter = $Letter
    }
    Write-Host $OutputR2

    # Robot 3
    $OutputR3 = ""
    $StartLetter = "A"
    foreach ($Letter in $OutputR2.GetEnumerator())
    {
        $Letter = [string]$Letter
        $Movement = $MovementDict[$StartLetter][$Letter]

        # Write-Host "$StartLetter -> $letter = $Movement"

        $OutputR3 += $Movement + "A"
        $StartLetter = $Letter
    }
    Write-Host $OutputR3

    Write-Host "$code : $($OutputR3.Length) * $($Code -replace 'A', '')"
    $Total += ($OutputR3.Length * [int]($Code -replace "A", ""))

    Write-Host "====================================="
}

Write-Host $Total

# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# 264266 -> Too high