
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\Input.txt)

# ======================================================================
# ======================================================================

#region Functions

$Script:RegA = 117440
$Script:RegB = 0
$Script:RegC = 0
$Script:Out = New-Object System.Collections.ArrayList

$Instructions = 0,3,5,4,3,0


function Get-ComboOperand ($Operand)
{
    switch ($Operand)
    {
        0 { return 0 }
        1 { return 1 }
        2 { return 2 }
        3 { return 3 }
        4 { return $Script:RegA }
        5 { return $Script:RegB }
        6 { return $Script:RegC }
        7 { Write-Host "Should not appear!"; return $null }
        Default { Write-Host "Unknown Operand!"; return $null }
    }
}


function adv ($Operand)  # Opcode 0 - Devide RegA by 2 ^ combo Operand
{
    $Script:RegA = [math]::Floor( $Script:RegA / [math]::Pow(2, $Operand) )
}

function bxl ($Operand)  # Opcode 1 - bitwise XOR of RegB and Literal Operand
{
    $Script:RegB = $Script:RegB -bxor $Operand
}

function bst ($Operand)  # Opcode 2 - Combo operand % 8, keep last 3 bits
{
    $Script:RegB = $Operand % 8

    #TODO fix 3 bits part
}

function jnz ($Operand, $index)  # Opcode 3 - if not 0, jump
{
    if ($Script:RegA -eq 0) { return ($index += 2) }
    return $Operand
}

function bxc ()  # Opcode 4 - bitwise XOR of RegB and RegC
{
    $Script:RegB = $Script:RegB -bxor $Script:RegC
}

function out ($Operand)  # Opcode 5 - Combo operand % & -> output (comma separated)
{
    $script:out += $Operand % 8
}

function bdv ($Operand)  # Opcode 6 - Devide RegA by 2 ^ combo Operand and stored in RegB
{
    $Script:RegB = [math]::Floor( $Script:RegA / [math]::Pow(2, $Operand) )
}

function cdv ($Operand)  # Opcode 7 - Devide RegA by 2 ^ combo Operand and stored in RegC
{
    $Script:RegC = [math]::Floor( $Script:RegA / [math]::Pow(2, $Operand) )
}

#Endregion Functions


for ($i = 0; $i -lt $Instructions.Count; ) 
{
    try
    {
        $instr = $Instructions[$i]
        $Operand = $Instructions[$i + 1]
        switch ($instr)
        {
            0 { adv (Get-ComboOperand $Operand); $i += 2 }
            1 { bxl $Operand; $i += 2 }
            2 { bst (Get-ComboOperand $Operand); $i += 2 }
            3 { $i = jnz $Operand $i; }
            4 { bxc; $i += 2 }
            5 { out (Get-ComboOperand $Operand); $i += 2 }
            6 { bdv (Get-ComboOperand $Operand); $i += 2 }
            7 { cdv (Get-ComboOperand $Operand); $i += 2 }
        }
    }
    catch
    {
        $_
    }
}

$Script:Out -join ","



# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"