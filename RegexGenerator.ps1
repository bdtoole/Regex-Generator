<#
 # Reference: http://regexhero.net/reference/
 #>

#$inputStrings = ("T3st", "with", "varying", "lengths")
$inputStrings = ("T3sT", "w1tH", "d1fFerent", "w0rDs")

Function Build-Regex
{
    $regexList = New-Object System.Collections.Generic.List[string]

    [System.Collections.Generic.List[string]]$characterSets = Get-Character-Sets $inputStrings
    
    $optional = $False

    ForEach ($i in 0..($characterSets.Count-1))
    {
        [string]$regex = Get-Regex-For-Character-Set $characterSets[$i]

        If ($i -gt 0 -and $characterSets[$i].Length -lt $characterSets[$i-1].Length)
        {
            $optional = $True
        }

        If ($optional) { $regex += '?' }

        $regexList.Add($regex)
    }

    Consolidate-Regex $regexList
}

Function Get-Character-Sets
{
    Param(
    [System.Collections.Generic.List[string]]$stringList
    )

    $characterSets = New-Object System.Collections.Generic.List[string]

    $longestLength = ($stringList | Measure-Object -Maximum -Property Length).Maximum

    ForEach ($i in 0..($longestLength-1))
    {
        [string]$charSet = ""
        ForEach ($word in $stringList)
        {
            $charSet += $word[$i]
        }
        $characterSets.Add($charSet)
    }

    return $characterSets
}

Function Get-Regex-For-Character-Set
{
    Param(
    [string]$set
    )

    [string]$return = ""
    [bool]$valid = $TRUE

    $expressionsToTest = @(
        '^\w*$'
       ,'^[A-Za-z]*$'
       ,'^[A-Z]*$'
       ,'^[a-z]*$'
       ,'^\d*$'
    )

    ForEach ($expression in $expressionsToTest)
    {
        $valid = ($set -cmatch $expression)
        If ($valid) { $return = $expression }
        Else { $return = $return }
    }
    Return ($return -split '[\^\*]')[1]
}

Function Consolidate-Regex
{
    Param(
    [System.Collections.Generic.List[string]]$regexList
    )

    $consolidatedRegexList = $regexList

    Write-Host $regexList

    ForEach ($i in ($regexList.Count-1)..0)
    {
    
        Write-Host $i $regexList[$i] $regexList[$i-1]
        If ($i -gt 0 -and $regexList[$i] -eq $regexList[$i-1])
        {
            If ($regexList[$i] -ceq $regexList[$i-1])
            {
                $consolidatedRegexList[$i-1] = $consolidatedRegexList[$i-1]+"*"
                $consolidatedRegexList.RemoveAt($i)
            }
            ElseIf ($regexList[$i] -eq "[A-Z]")
            {
                $consolidatedRegexList[$i-1] = "[A-Za-z]*"
                $consolidatedRegexList.RemoveAt($i)
            }
        }
    }

    Write-Host $consolidatedRegexList
    
}

Build-Regex
