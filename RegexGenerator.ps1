<#
 # Reference: http://regexhero.net/reference/
 # Testing: https://regex101.com
 #>

#$inputStrings = ("T3sT", "with", "varying", "lengths")
$inputStrings = ("T3sT", "w1tH", "d1fFerent", "w0rDs")

Function Build-Regex
{
    # Expression order from broad to narrow
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
    
    # Iterate through list of input strings and build character set array
    ForEach ($i in 0..($longestLength-1))
    {
        [string]$charSet = ""
        ForEach ($word in $inputStrings) { $charSet += $word[$i] }
        $characterSets.Add($charSet)
    }

    # Iterate through character set array and build the list of regular expressions for each set of characters
    ForEach ($i in 0..($characterSets.Count-1))
    {
        [string]$regex = ""
        [bool]$valid = $TRUE

        # For each expression, we use regular expressions to determine which regular expression is appropriate
        # We set $regex to $expression if there's a regular expression match, otherwise we use the previous $regular expression
        # Else statement not actually necessary, but left in for readability purposes
        ForEach ($expression in $expressionsToTest)
        {
            $valid = ($characterSets[$i] -cmatch $expression)
            If ($valid) { $regex = $expression }
            Else { $regex = $regex }
        }
        $regex = (($regex -split '[\^\*]')[1])
        $regexList.Add($regex)
    }

    # Build array to hold the number of occurrences of each set of characters
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
            $repetitionList.Add(1)
        }
    }

    # Remove repeated regular expressions
    ForEach ($i in ($regexList.Count-1)..0)
    {
        If ($repetitionList[$i] -gt 1) 
        { 
            If ($repetitionList[$i] -lt $repetitionList[$i+1]) { $repetitionList.RemoveAt($i) }
            $regexList.RemoveAt($i+1)
        }
    }

    # Compare final regular expression list to array containing the number of occurrences and append the quantifier when necessary
    ForEach ($i in ($consolidatedRegexList.Count-1))
    {
        If ($repetitionList[$i] -gt 1) { $regexList[$i] += "{1,$($repetitionList[$i])}" }
    }

    # Output regular expression array as a character string
    Write-Host ([string]::Join("",$regexList))

}

Build-Regex
