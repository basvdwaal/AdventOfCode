# $InputString = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
$InputString = Get-Content $PSScriptRoot\input.txt -Raw
$regex = [regex]"mul\(([\d]+),([\d]+)\)"

$list = $regex.Matches($InputString)
$res = 0

foreach ($match in $list)
{
    [int]$Num1 = $match.Groups[1].Value
    [int]$Num2 = $match.Groups[2].Value

    Write-Host "$Num1 * $Num2 = $($Num1 * $Num2)"
    $res += ($Num1 * $Num2)
}

Write-Host $res