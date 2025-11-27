# simulate-events.ps1
Write-Host "Simulating failed logon event (ID 4625)..."
for ($i = 1; $i -le 3; $i++) {
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c net use \\localhost\IPC$ /user:baduser wrongpass$i" -NoNewWindow
    Start-Sleep -Seconds 2
}
Write-Host "Done. Check Sentinel after ~5 mins."
