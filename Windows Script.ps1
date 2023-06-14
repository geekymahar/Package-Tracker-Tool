$tempFile = "temp.txt"

$fileName = "packagelist.txt"

$jsonOutput = "packagelist.json"

$finalmessage = "message.txt"

$password = "pass.txt"

$separator = ","

Remove-Item $tempFile
Remove-Item $finalmessage
Remove-Item $fileName
Remove-Item $jsonOutput

Create-Item $tempFile
Add-Content $tempFile "Package Name,Version,Installation Date,Installation Source"

# Registry 1 Search
$registry = Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall
$packagename = $registry |foreach-object {Get-ItemProperty $_.PsPath}
foreach ($name in $packagename)
{
    IF(-Not [string]::IsNullOrEmpty($name.DisplayName)) {      
        $line = $name.DisplayName+$separator+$name.DisplayVersion+$separator+$name.InstallDate+$separator+$name.InstallSource
        Write-Host $line
        Add-Content $tempFile "$line`n"        
    }
}

# Registry 2 Search
$registry = Get-ChildItem HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
$packagename = $registry |foreach-object {Get-ItemProperty $_.PsPath}
foreach ($name in $packagename)
{
    IF(-Not [string]::IsNullOrEmpty($name.DisplayName)) {      
        $line = $name.DisplayName+$separator+$name.DisplayVersion+$separator+$name.InstallDate
        Write-Host $line
        Add-Content $tempFile "$line`n"
    }
}

gc $tempFile | get-unique > $fileName

Import-Csv $fileName | ConvertTo-Json | Add-Content -Path $jsonOutput

Create-Item $password
Add-Content $password "Password: mmuMbS0NqNS8n0xz"
notepad $password

$hostname = hostname
$From = "from@outlook.com"
$To = "email@gmail.com"
$Cc = "geekymahar@gmail.com"
$Subject = "Packages list of $hostname"
$Body = "<h2>Please Check Attachment</h2><br>"
$SMTPServer = �smtp.office365.com�
$SMTPPort = �587"

Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential grazettitest@outlook.com -Attachments $jsonOutput

Remove-Item $password

Create-Item $finalmessage
Add-Content $finalmessage "ThankYou! Please Check Your Email (yogeshc@grazitti.com) Inbox/Spam Folder"

Remove-Item $fileName
Remove-Item $tempFile

notepad $finalmessage

