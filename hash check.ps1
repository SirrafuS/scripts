#empty the destination folder completely without confirmation (confirm:false + recurse
Get-ChildItem -path "\\win10\c$\users\t.melikyan\Desktop\Destination\*" -Force | %{Remove-Item -Recurse $_.FullName -Confirm:$false}

Copy-Item -recurse -force -Path "C:\Users\t.melikyan.ARGE16\Desktop\Source\*" -Destination "\\win10\c$\users\t.melikyan\Desktop\Destination\" -PassThru
$folderA = "C:\Users\t.melikyan.ARGE16\Desktop\Source\"
$folderB = "\\win10\c$\users\t.melikyan\Desktop\Destination\"

remove-item -Recurse -force -path "C:\Users\t.melikyan.ARGE16\Desktop\hash\*"

$hashA = "C:\Users\t.melikyan.ARGE16\Desktop\hash\hashofA.txt"
$hashB = "C:\Users\t.melikyan.ARGE16\Desktop\hash\hashofB.txt"

# -file to get only list of files (otherwise folders will be listed in $folderA and $folderB vars
# as the output is files, each of them gets piped simultaneously with get-filehash
# after that it will be piped as a stream of values with property Hash and appends outputted to file mentioned in var
Get-ChildItem $folderA -Recurse -file | Get-FileHash -Algorithm MD5 | Select -ExpandProperty Hash >> $hashA
Get-ChildItem $folderB -Recurse -file | Get-FileHash -Algorithm MD5 | Select -ExpandProperty Hash >> $hashB

$result = Compare-Object -ReferenceObject(Get-Content $hashB) -DifferenceObject(Get-Content $hashA)

while($true)
{
    if($result -eq $null)
    {        
        Write-Host "Hashes match, exiting" -ForegroundColor Green
        $SMTP = "smtp.gmail.com"
        $From = "arge.mgmt@gmail.com"
        $To = "arge.mgmt@gmail.com"
        $Subject = "Copy finished"
        $Body = "All is well"
        $Email = New-Object Net.Mail.SmtpClient($SMTP, 587)
        $Email.EnableSsl = $true
        $Email.Credentials = New-Object System.Net.NetworkCredential("arge.mgmt@gmail.com", "Arg@20@)");
        $Email.Send($From, $To, $Subject, $Body)
        break
    }
    else{
        Write-Host "Hashes don't match, trying again..." -ForegroundColor Red
        $SMTP = "smtp.gmail.com"
        $From = "arge.mgmt@gmail.com"
        $To = "arge.mgmt@gmail.com"
        $Subject = "Copy finished"
        $Body = "there were issues, script was restarted"
        $Email = New-Object Net.Mail.SmtpClient($SMTP, 587)
        $Email.EnableSsl = $true
        $Email.Credentials = New-Object System.Net.NetworkCredential("arge.mgmt@gmail.com", "Arg@20@)");
        $Email.Send($From, $To, $Subject, $Body)
    }
}