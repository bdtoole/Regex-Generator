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
