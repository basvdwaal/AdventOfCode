function Increment-TernaryNumber {
    param (
        [array]$Number
    )
    
    for ($i = 0; $i -lt $Number.Length; $i++)
    {
        if ($Number[$i] -eq '0')
        { 
            $Number[$i] = '1'
            if ($i -ne 0)
            {
                foreach ($t in 0..($I-1))
                {
                    $Number[$t] = '0'
                }
            }
            break
        }

        if ($Number[$i] -eq '1')
        { 
            $Number[$i] = '2'
            if ($i -ne 0)
            {
                foreach ($t in 0..($I-1))
                {
                    $Number[$t] = '0'
                }
            }
            break
        }
    }
    return $Number
}

$t = @('0','0','0','0')
Write-Host $t
foreach ($i in 0..81)
{
    $t = Increment-TernaryNumber -Number $t
    $s = $t.Clone()
    [array]::Reverse($s)
    Write-Host $s
}