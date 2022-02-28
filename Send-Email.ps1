# Get domain controllers list
$DCs = Get-ADDomainController -Filter *
 
# Define timeframe for report (default is last 8 hours)
$startDate = (get-date).AddHours(-8)
 
# Store group membership changes events from the security event logs in an array.
foreach ($DC in $DCs){
$events = Get-Eventlog -LogName Security -ComputerName $DC.Hostname -after $startDate | where {$_.eventID -eq 4728 -or $_.eventID -eq 4729}}
 
# Loop through each stored event; print all changes to security global group members with when, who, what details.
 
  foreach ($e in $events){
    # Member Added to Group
 
    if (($e.EventID -eq 4728 )){
     $variable1 = write-Output "Group: "$e.ReplacementStrings[2] "`tAction: Member added `tWhen: "$e.TimeGenerated "`tWho: "$e.ReplacementStrings[6] "`tAccount added: "$e.ReplacementStrings[0] | Out-String
    }
    # Member Removed from Group
    if (($e.EventID -eq 4729 )) {
     $variable2 = write-Output "Group: "$e.ReplacementStrings[2] "`tAction: Member removed `tWhen: "$e.TimeGenerated "`tWho: "$e.ReplacementStrings[6] "`tAccount removed: "$e.ReplacementStrings[0] | Out-String
    }}

$SMTP = "smtp.gmail.com"
$From = "arge.mgmt@gmail.com"
$To = "arge.mgmt@gmail.com"
$Subject = "Security Groups has been changed in last 8 hours"
$Body = $variable1, $variable2
$Email = New-Object Net.Mail.SmtpClient($SMTP, 587)
$Email.EnableSsl = $true
$Email.Credentials = New-Object System.Net.NetworkCredential("arge.mgmt@gmail.com", "Arg@20@)");
$Email.Send($From, $To, $Subject, $Body)