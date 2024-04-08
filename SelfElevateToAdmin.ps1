$addToAdminScriptPath = "C:\Scripts\AddToAdmins.ps1"
$addToAdminScriptContent = @"
Add-LocalGroupMember -Group "Administrators" -Member "$username"
"@
if (-not (Test-Path "C:\Scripts")) {
    New-Item -Path "C:\Scripts" -ItemType Directory
}
Set-Content -Path $addToAdminScriptPath -Value $addToAdminScriptContent
$taskName = "AddTempUserToAdmins"
$action = New-ScheduledTaskAction -Execute "Powershell.exe" -Argument "-NoLogo -WindowStyle Hidden -File `"$addToAdminScriptPath`""
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
Register-ScheduledTask -TaskName $taskName -Action $action -Principal $principal | Start-ScheduledTask
Write-Host "Scheduled task $taskName created and started. It will add $username to the Administrators group."
Start-Sleep -Seconds 10
Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
Write-Host "Scheduled task $taskName removed."
