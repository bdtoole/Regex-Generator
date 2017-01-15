<#
 # Reference: http://regexhero.net/reference/
 # Testing: https://regex101.com
 #>

#$inputStrings = ("T3sT", "with", "varying", "lengths")
$inputStrings = ("T3sT", "w1tH", "d1fFerent", "w0rDs")

Function Build-Regex
{
    $expressionsToTest = @(
        '^\w*$'
        ,'^[A-Za-z]*$'
        ,'^[A-Z]*$'
        ,'^[a-z]*$'
        ,'^\d*$'
    )

    $regexList = New-Object System.Collections.Generic.List[string]
    $characterSets = New-Object System.Collections.Generic.List[string]
    $repetitionList = New-Object System.Collections.Generic.List[string]
    $numOccurrences = 1

    $longestLength = ($inputStrings | Measure-Object -Maximum -Property Length).Maximum

    ForEach ($i in 0..($longestLength-1))
    {
        [string]$charSet = ""
        ForEach ($word in $inputStrings)
        {
            $charSet += $word[$i]
        }
        $characterSets.Add($charSet)
    }

    ForEach ($i in 0..($characterSets.Count-1))
    {
        [string]$regex = ""
        [bool]$valid = $TRUE

        ForEach ($expression in $expressionsToTest)
        {
            $valid = ($characterSets[$i] -cmatch $expression)
            If ($valid) { $regex = $expression }
            Else { $regex = $regex }
        }
        $regex = (($regex -split '[\^\*]')[1])
        $regexList.Add($regex)
    }

    ForEach ($i in 0..($regexList.Count-2))
    {
        If ( $regexList[$i] -ceq $regexList[$i+1] ) 
        {   
            $numOccurrences++
            $repetitionList.Add($numOccurrences)
        }
        Else
        {
            $numOccurrences = 1
            $repetitionList.Add(0)
        }
    }

    ForEach ($i in ($regexList.Count-1)..0)
    {
        If ($repetitionList[$i] -gt 1) 
        { 
            If ($repetitionList[$i] -lt $repetitionList[$i+1]) { $repetitionList.RemoveAt($i) }
            $regexList.RemoveAt($i+1)
        }
    }

    ForEach ($i in ($consolidatedRegexList.Count-1))
    {
        If ($repetitionList[$i] -gt 0) { $regexList[$i] += "{1,$($repetitionList[$i]))}" }
    }

    Write-Host ([string]::Join("",$regexList))

}

Build-Regex
