param(
    $lqFullPath = $Env:APPDATA + "\npm\lq.cmd",
    $lqQuery = "espansoBlocksQuery",
    $logseqGraph = "",
    $queryOutputToJsonClojure = "QueryOutputToJson.clj",
    $espansoQueriesJson = "espansoQueries.json",
    $espansoMatchOutputDir = $Env:APPDATA + "\espanso\match\"
)   

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Set-Location -Path $dir

$processOptions = @{
    FilePath = $lqFullPath 
    ArgumentList = "q " + $lqQuery + " --graph """ + $logseqGraph + """ | bb  --stream " +  $queryOutputToJsonClojure + " > " +  $espansoQueriesJson
    RedirectStandardError = "Errors.log"
    RedirectStandardOutput = "Output.log"
    Wait = $true
}
Start-Process @processOptions

$PsJson = Get-Content $espansoQueriesJson -Raw -Force
Write-Output $PsJson

$PsArray = @($PsJson | ConvertFrom-Json)

$EspansoRules = @()
$EspansoFiles = @{}

foreach ($i in $PsArray)
{
    $rule = @{regex="";form="";label=""} 
    $filename = "logseq.yml" #default filename
    $attHash = $i[0].'block/properties-text-values'
    $rule.regex = $attHash.'espanso-regex'
    $rule.label = $attHash.'espanso-label'
    $rule.form = $attHash.'espanso-replace' -replace "``(.*)``", '$1'  # Remove the single quotes around the value
    
    if($rule.form -eq ""){
        # Split the string by newline characters
        $lines = $i[1] -split "`n"

        # Remove the first and last lines
        $lines = $lines[1..($lines.Length - 2)]

        # Join the remaining lines back into a single string
        $newStr = $lines -join "`n"

        # Output the modified string
        $rule.form =  $newStr.Replace("`n", " `n")
    }

    $EspansoRules += $rule

    if($attHash.'espanso-filename') {
        $filename = $attHash.'espanso-filename'
        if(!$filename.EndsWith('.yml')){
            $filename = $filename + ".yml"
        }
    }
    if($EspansoFiles.ContainsKey($filename)){
        $EspansoFiles[$filename] += $rule
    }else {
        $EspansoFiles[$filename] = @()
        $EspansoFiles[$filename] += $rule
    }
}

foreach ($file in $EspansoFiles.Keys)
{
    $EspansoRulesMatches = @{'matches' = $EspansoFiles[$file]}
    $fullFilePath = [System.String]::Concat($espansoMatchOutputDir,$file)
    $y = $EspansoRulesMatches | ConvertTo-Yaml
    $y = $y -replace "(?<=: )'(.*)'", '$1'  # Remove the single quotes around the value
    $y | Out-File -Encoding ascii $fullFilePath
}
