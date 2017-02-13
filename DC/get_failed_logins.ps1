## This will get all failed logins for the last hour on the current machine.
## Run this on a DC for useful output

$Date= Get-date
$filedate= Get-date -format "MMMd-HH-mm"
New-Item -ItemType Directory -Force -Path C:\htmlreport
$Report='c:\htmlreport\' +$filedate +'.html'

$HTML=@"
<title>Event
Logs Report</title>
<style>

BODY{background-color :#FFFFF}

TABLE{Border-width:thin;border-style:
solid;border-color:Black;border-collapse: collapse;}
TH{border-width:
1px;padding: 1px;border-style: solid;border-color:
black;background-color: ThreeDShadow}
TD{border-width:
1px;padding: 0px;border-style: solid;border-color:
black;background-color: Transparent}
</style>
"@

$eventsDC=Get-Eventlog security -InstanceId 4625 -After (Get-Date).AddHours(-1) |
   Select TimeGenerated,ReplacementStrings |
   % {
 New-Object PSObject -Property @{
     
Source_Computer = $_.ReplacementStrings[13]
     
UserName = $_.ReplacementStrings[5]
     
IP_Address = $_.ReplacementStrings[19]
     
Date = $_.TimeGenerated
   
}
   }
   
$eventsDC |
ConvertTo-Html -Property Source_Computer,UserName,IP_Address,Date -head $HTML -body "<H2>Gernerated On $Date</H2>"| Out-File $Report -Append
