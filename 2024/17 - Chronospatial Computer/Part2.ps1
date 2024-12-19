# https://github.com/hyperneutrino/advent-of-code/blob/main/2024/day17p2.py
Set-StrictMode -Version latest
$StartTime = Get-Date

# ======================================================================
# ======================================================================

<#
2,4 -> $RegB = $RegA % 8
1,3 -> $RegB = $RegB -bxor 3 
7,5 -> $RegC = [math]::Floor( $RegA / [math]::Pow(2, $RegB) )
1,5 -> $RegB = $RegB -bxor 5
0,3 -> $RegA = [math]::Floor( $RegA / 8 )
4,1 -> $RegB = $RegB -bxor $RegC
5,5 -> $out += $RegB % 8
3,0 -> Loop while A != 0
#>

# Program: 2,4,1,3,7,5,1,5,0,3,4,1,5,5,3,0
#          

# 8, 64, 512, 4096, 32768, 262144, 2097152, 16777216 -> (0-8) * 8 = 6,6,6,6,6, etc gevolgd door 2 eindcijfers
# 16777216 -> 6,6,6,6,6,6,6,7,7, 16777217 -> 7,6,6,6,6,6,6,7,7, 16777218 -> 5,6,6,6,6,6,6,7,7


# for ([int64]$i = 64; $i -le 127; $i++) 
# {
#     $RegA = $i
#     $RegB = 0
#     $RegC = 0
#     $out = @()

#     if($i % 100000 -eq 0)
#     {
#         Write-Host $i
#     }

#     while ($RegA -ne 0)
#     {
#         $RegB = $RegA % 8 # 1 cijfer
#         $RegB = $RegB -bxor 3 # 0:3, 1:2, 2:1, 3:0, 4:7, 5:6, 6:5, 7:4
#         $RegC = [math]::Floor( $RegA / [math]::Pow(2, $RegB) ) # RegA / 1|2|4|8|16|32|64|128 -> Groot nummber
#         $RegB = $RegB -bxor 5 # 0:5, 1:4, 2:7, 3:6, 4:1, 5:0, 6:3, 7:2
#         $RegA = [math]::Floor( $RegA / 8 ) # 
#         $RegB = $RegB -bxor $RegC
#         $out += $RegB % 8  # 1 cijfer
#     }
    
#     Write-Host "$i : $($out -join ",")"
    
#     # if ($out -join "," -eq "2,4,1,3,7,5,1,5,0,3,4,1,5,5,3,0")
#     # {
#     #     Write-Host "Start value for A: $i"
#     #     break
#     # }
# }


function calculate ($a, $b) {
    $RegA = $a
    $RegB = $b
    $RegC = 0
    $out = @()

    while ($RegA -ne 0)
    {
        # $RegB = $RegA % 8 # 1 cijfer
        $RegB = $RegB -bxor 3 # 0:3, 1:2, 2:1, 3:0, 4:7, 5:6, 6:5, 7:4
        $RegC = [math]::Floor( $RegA / [math]::Pow(2, $RegB) ) # RegA / 1|2|4|8|16|32|64|128 -> Groot nummber
        $RegB = $RegB -bxor 5 # 0:5, 1:4, 2:7, 3:6, 4:1, 5:0, 6:3, 7:2
        $RegA = [math]::Floor( $RegA / 8 ) # 
        $RegB = $RegB -bxor $RegC
        $out += $RegB % 8  # 1 cijfer
    }
    
    Write-Host "$a, $b : $($out -join ",")"
}

# function combo ($Operand)
# {
#     switch ($Operand)
#     {
#         0 { return 0 }
#         1 { return 1 }
#         2 { return 2 }
#         3 { return 3 }
#         4 { return $Script:RegA }
#         5 { return $Script:RegB }
#         6 { return $Script:RegC }
#     }
# }
$program = 2,4,1,3,7,5,1,5,0,3,4,1,5,5,3,0


function find ($target, $ans)
{
    Write-Host $target.Length
    if (! $Target) {return $ans}
    foreach ($t in @(0..8)){
        $A = ([math]::Floor( $ans / [math]::Pow(2,-$t) )) + $t
        $B = 0
        $C = 0
        $Output = $null
        
        function combo ($Operand) {
            switch ($Operand)
            {
                0 { return 0 }
                1 { return 1 }
                2 { return 2 }
                3 { return 3 }
                4 { return $A }
                5 { return $B }
                6 { return $C }
            }
        }

        for ($pointer = 0; $pointer -lt ($program.count - 2); $pointer += 2)
        {
            try
            {
                $ins = $program[$pointer]
                $operand = $program[($pointer + 1)]

                if ($ins -eq 0) {}
                elseif ($ins -eq 1) {
                    $b = $b -bxor $operand
                }
                elseif ($ins -eq 2) {
                    $b = (combo $operand) -band (8 - 1)
                    # (combo $operand) % 8
                    # (combo $operand) -band (8 - 1)
                }
                elseif ($ins -eq 4) {
                    $b = $b -bxor $C
                }
                elseif ($ins -eq 5) {
                    $Output = combo($operand) -band (8 - 1)
                }
                elseif ($ins -eq 6) {
                    $B = [math]::Floor( $A / [math]::Pow(2, (combo $operand ) ) )
                }
                elseif ($ins -eq 7) {
                    $C = [math]::Floor( $A / [math]::Pow(2, (combo $operand ) ) )
                }

                if ($Output -eq $target[-1])
                {
                    $sub = find -target $target[0..$($target.Length-2)] -ans $A
                    if (! $sub) {continue}
                    return $sub
                }
            }
            catch
            {
                $_
            }
        }
    }
}


find -target $program -ans 0



# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"