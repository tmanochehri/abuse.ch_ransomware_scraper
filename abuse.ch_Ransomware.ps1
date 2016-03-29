﻿#set the maximum amount of items to import from each website
$ItemMax = 200000
$Count = 0
$Path_32 = "C:\Program Files (x86)\LogRhythm\LogRhythm Job Manager\config\list_import\"
$Path_64 = "C:\Program Files\LogRhythm\LogRhythm Job Manager\config\list_import\"
$IPOutputFileName = "abuse.ch_ransom_IP.txt"
$URLOutputFileName = "abuse.ch_ransom_URL.txt"
$DomOutputFileName = "abuse.ch_ransom_Domain.txt"


if ((Test-Path -path $Path_32)){
	$IPFilePath = $Path_32 + $IPOutputFileName
	$URLFilePath = $Path_32 + $URLOutputFileName
	$DomFilePath = $Path_32 + $DomOutputFileName
}

if ((Test-Path -path $Path_64)){
	$IPFilePath = $Path_64 + $IPOutputFileName
	$URLFilePath = $Path_64 + $URLOutputFileName
	$DomFilePath = $Path_64 + $DomOutputFileName

}
else  {
    $path = Get-Location
    $IPFilePath = "$path\" + "$IPOutputFileName"
    $URLFilePath = "$path\" + "$URLOutputFileName"
    $DomFilePath = "$path\" + "$DomOutputFileName"
}

######################
#Ignoring SSL trust relationship within this PS script only
$netAssembly = [Reflection.Assembly]::GetAssembly([System.Net.Configuration.SettingsSection])
if($netAssembly) {
    $bindingFlags = [Reflection.BindingFlags] "Static,GetProperty,NonPublic"
    $settingsType = $netAssembly.GetType("System.Net.Configuration.SettingsSectionInternal")
    $instance = $settingsType.InvokeMember("Section", $bindingFlags, $null, $null, @())
        if($instance) {
            $bindingFlags = "NonPublic","Instance"
            $useUnsafeHeaderParsingField = $settingsType.GetField("useUnsafeHeaderParsing", $bindingFlags)
            if($useUnsafeHeaderParsingField) {
                $useUnsafeHeaderParsingField.SetValue($instance, $true)
            }
        }
}

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
######################

$IPURL = "https://ransomwaretracker.abuse.ch/downloads/RW_IPBL.txt"
$URLURL = "https://ransomwaretracker.abuse.ch/downloads/RW_URLBL.txt"
$DomURL = "https://ransomwaretracker.abuse.ch/downloads/RW_DOMBL.txt"

$IPblocklist = New-Object Net.WebClient
$IPblocklist.DownloadString($IPURL) > tempFeodoIP.txt

#checks for blank text file and exits the program if the file is blank
Get-Content tempFeodoIP.txt | Measure-Object -word
if ($word -eq 0){
    Break
    }
    
#Get-Content will put each individual line in the text file as an individual object which sets up the "if" loop below.
$IPblocklist = Get-Content tempFeodoIP.txt

# removes temp blocklist text file
Remove-Item tempFeodoIP.txt

$IPblocklist | ForEach-Object{
     if( $_ -match "^[^#]" -and $ItemMax -gt 0 ){
    
        #decrement count to limit the amount of objects in final text file
        $ItemMax = $ItemMax - 1
        
        #increase counter to count number of items on webpage
        $Count = $Count +1
        
    	## remove trailing text
    	Foreach-Object {$_ -replace " # .*\b", ""} |
    	
    	Sort-Object | out-file $IPFilePath -append } # End of the if statement
    
}


####################################
#Now do all the same stuff for URLs#
####################################
$ItemMax = 200000
$Count = 0

$URLblocklist = New-Object Net.WebClient
$URLblocklist.DownloadString($URLURL) > tempFeodoURL.txt

#checks for blank text file and exits the program if the file is blank
Get-Content tempFeodoURL.txt | Measure-Object -word
if ($word -eq 0){
    Break
    }
    
#Get-Content will put each individual line in the text file as an individual object which sets up the "if" loop below.
$URLblocklist = Get-Content tempFeodoURL.txt

# removes temp blocklist text file
Remove-Item tempFeodoURL.txt

$URLblocklist | ForEach-Object{
     if( $_ -match "^[^#]" -and $ItemMax -gt 0 ){
    
        #decrement count to limit the amount of objects in final text file
        $ItemMax = $ItemMax - 1
        
        #increase counter to count number of items on webpage
        $Count = $Count +1
        
    	## remove trailing text
    	Foreach-Object {$_ -replace " # .*\b", ""} |
    	
    	Sort-Object | out-file $URLFilePath -append } # End of the if statement
    
}

####################################
#Now do all the same stuff for Domains#
####################################
$ItemMax = 200000
$Count = 0

$Domblocklist = New-Object Net.WebClient
$Domblocklist.DownloadString($DomURL) > tempFeodoDom.txt

#checks for blank text file and exits the program if the file is blank
Get-Content tempFeodoDom.txt | Measure-Object -word
if ($word -eq 0){
    Break
    }
    
#Get-Content will put each individual line in the text file as an individual object which sets up the "if" loop below.
$Domblocklist = Get-Content tempFeodoDom.txt

# removes temp blocklist text file
Remove-Item tempFeodoDom.txt

$Domblocklist | ForEach-Object{
     if( $_ -match "^[^#]" -and $ItemMax -gt 0 ){
    
        #decrement count to limit the amount of objects in final text file
        $ItemMax = $ItemMax - 1
        
        #increase counter to count number of items on webpage
        $Count = $Count +1
        
    	## remove trailing text
    	Foreach-Object {$_ -replace " # .*\b", ""} |
    	
    	Sort-Object | out-file $DomFilePath -append } # End of the if statement
    
}
