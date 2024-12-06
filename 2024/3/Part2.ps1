# $InputString = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
$InputString = Get-Content $PSScriptRoot\input.txt -Raw
$regex = [regex]"mul\(([\d]+),([\d]+)\)|do\(\)|don't\(\)"

$list = $regex.Matches($InputString)
$res = 0

$Process = $true

foreach ($match in $list)
{
    if ($Match.Value -eq 'do()') 
    {
        $Process = $true
        Write-Host "Set Process to True"
    }
    elseif ($Match.Value -eq 'don''t()') 
    {
        $Process = $false
        Write-Host "Set Process to False"
    }
    else
    {
        if ($Process)
        {
            [int]$Num1 = $match.Groups[1].Value
            [int]$Num2 = $match.Groups[2].Value
        
            Write-Host "$Num1 * $Num2 = $($Num1 * $Num2)"
            $res += ($Num1 * $Num2)
        }
        else
        {
            Write-Host "Skipping $($match.Value)"   
        }
    }
}

Write-Host $res