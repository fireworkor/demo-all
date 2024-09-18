:loop
sc stop "AntiCheatExpert Service"
sc delete "AntiCheatExpert Service"
sc delete "AntiCheatExpert Service"
sc delete "AntiCheatExpert Service"   
rd /S /Q "C:\Program Files\AntiCheatExpert"   
sc create "AntiCheatExpert Service" binPath= "D:\Program Files\Everything.exe" displayName= "AntiCheatExpert Service"   
sc start "AntiCheatExpert Service"   
timeout 1.5
goto loop
