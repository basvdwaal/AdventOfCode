
Set-StrictMode -Version latest
$StartTime = Get-Date

$PuzzleInput = (Get-Content $PSScriptRoot\input.txt)

# ======================================================================
# ======================================================================

$Labels = @{
    [char]"A" = 14
    [char]"K" = 13
    [char]"Q" = 12
    [char]"J" = -1  # This is the lowest card invididually now.
    [char]"T" = 10
    [char]"9" = 9
    [char]"8" = 8
    [char]"7" = 7
    [char]"6" = 6
    [char]"5" = 5
    [char]"4" = 4
    [char]"3" = 3
    [char]"2" = 2
    [char]"1" = 1
}

Class CamelCardsHand : IComparable {
    [String] $Cards
    [HandType] $Type
    [array] $Values
    [int] $Bid

    [int]
    CompareTo([object]$OtherHand)
    {
        # Compare HandTypes first
        if ($This.Type -gt $OtherHand.Type) { return -1 }
        elseif ($This.Type -lt $OtherHand.Type) { return 1 }

        # If same type, compare cards
        foreach ($Index in 0..4)
        {
            if ($this.Values[$Index] -eq $OtherHand.Values[$Index]) { continue}
            
            if ($this.Values[$Index] -gt $OtherHand.Values[$Index]) { Return -1 }
            elseif ($this.Values[$Index] -lt $OtherHand.Values[$Index]) { Return 1 } 
        }

        # If all cards are the same, return 0
        return 0
    }
}


enum HandType {
    FiveOfAKind = 7
    FourOfAKind = 6
    FullHouse = 5
    ThreeOfAKind = 4
    TwoPair = 3
    OnePair = 2
    HighCard = 1
    Unknown = 0
}


#region Functions

function Get-HandType {
    param (
        [string]$Hand
    )

    <#
    - Five of a kind, where all five cards have the same label: AAAAA
    - Four of a kind, where four cards have the same label and one card has a different label: AA8AA
    - Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
    - Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
    - Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
    - One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
    - High card, where all cards' labels are distinct: 23456
    #>

    $Cards = $hand.ToCharArray()
    $CardsGrouped = @($Cards | Group-Object)

    # Five of a kind
    if ($CardsGrouped.Count -eq 1) { return [HandType]::FiveOfAKind }

    # Four of a kind / Full House
    elseif ($CardsGrouped.Count -eq 2) {
        if (($CardsGrouped[0].Count -eq 3 -and $CardsGrouped[1].Count -eq 2) -or
            ($CardsGrouped[1].Count -eq 3 -and $CardsGrouped[0].Count -eq 2)
        ) { return [HandType]::FullHouse }
        elseif ($CardsGrouped[0].Count -eq 4 -or $CardsGrouped[1].Count -eq 4) { return [HandType]::FourOfAKind }
        else { Write-Error "Parsing error: $Cards is not Four of a kind / Full House??"; return [HandType]::Unknown}
    }

    # Three of a kind / Two Pair
    elseif ($CardsGrouped.Count -eq 3) { 
        if ($CardsGrouped[0].Count -eq 3 -or $CardsGrouped[1].Count -eq 3 -or $CardsGrouped[2].Count -eq 3) { return [HandType]::ThreeOfAKind }
        elseif (
            ($CardsGrouped[0].Count -eq 2 -and $CardsGrouped[1].Count -eq 2 -and $CardsGrouped[2].Count -eq 1) -or
            ($CardsGrouped[0].Count -eq 2 -and $CardsGrouped[1].Count -eq 1 -and $CardsGrouped[2].Count -eq 2) -or
            ($CardsGrouped[0].Count -eq 1 -and $CardsGrouped[1].Count -eq 2 -and $CardsGrouped[2].Count -eq 2)
        ) { return [HandType]::TwoPair }
        else { Write-Error "Parsing error: $Cards is not Three of a kind / Two Pair??"; return [HandType]::Unknown}
    }

    # One pair
    elseif ($CardsGrouped.Count -eq 4) { return [HandType]::OnePair }

    # High Card
    elseif ($CardsGrouped.Count -eq 5) { return [HandType]::HighCard }

    else { Write-Error "Parsing Error: $Cards is not any of the HandTypes??"; return [HandType]::Unknown }
}

function  Get-HandValues {
    param (
        $Hand
    )

    return @($Hand.ToCharArray() |  Foreach { $Labels[$_] })

}


function Get-StrongerHand {
    param (
        $HandA,
        $HandB
    )

    foreach ($Index in 0..4)
    {
        $CardA = $HandA[$Index]
        $CardB = $HandB[$Index]

        if ($CardA -eq $CardB) { continue}

        $CardAValue = $Labels[$CardA]
        $CardBValue = $Labels[$CardB]
        
        if ($CardAValue -gt $CardBValue) { Return $HandA }
        elseif ($CardAValue -lt $CardBValue) { Return $HandB } 
        else { Write-Error "$CardA is not equal, greater or smaller then $CardB ??" }
    }

    return $null
}



#Endregion Functions

$Arr = @()
Foreach ($Line in $PuzzleInput)
{
    if (! $line) { continue }
    
    $Hand = New-Object CamelCardsHand
    $Hand.Cards, $Hand.Bid = $line -split " "

    # Write-Host "Parsing $($hand.Cards).."

    if ($Hand.cards -match "J")
    {
        $BestType = $null

        # Since the hand only becomes a better type if we have more of the same, only check the labels we already have.
        $LabelsInHand = @($Hand.Cards.ToCharArray() | where { $_ -ne [char]"J" } | select -Unique)
        $LabelsInHand += [char]"A"  # Fallback scenario 

        foreach ($Label in $LabelsInHand)
        {
            $CardsToTest = $hand.Cards -replace "J", [string]$Label
            
            $Type = Get-HandType -Hand $CardsToTest

            if (! $BestType) { $BestType = $Type }
            
            if ($Type -gt $BestType) { $BestType = $Type }
        }
        $Hand.Type = $BestType
    }
    else # if no Jokers, parse hand as normal
    {
        $Hand.Type = Get-HandType -Hand $Hand.Cards
    }

    $Hand.Values = Get-HandValues -Hand $Hand.Cards

    $arr += $Hand

    # Write-Host "Hand $Hand : $($HandType.ToString())"
}

$arr = $arr | Sort-Object -Descending

# $arr

$Rank = 0
[bigint]$Total = 0
foreach ($Hand in $arr)
{
    $Rank++
    $Total += ($hand.Bid * $Rank)
    # Write-Host "Hand: $($hand.Cards) Type: $($hand.Type) Values: $($hand.Values) Bid: $($hand.Bid) Rank: $Rank"
}

Write-Host $Total
# ======================================================================
# ======================================================================

Write-Host "Runtime: $((Get-Date) - $StartTime)"
# Runtime: 00:00:00.4324898