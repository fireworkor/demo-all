::这个脚本之前是用来删除腾讯游戏扫盘程序的,效果不好，代码可以跑，可参考
while true; do
  if [ -d "C:\Program Files\AntiCheatExpert" ]; then
    sc stop "AntiCheatExpert Service"
    sc delete "AntiCheatExpert Service"
    rd /S /Q "C:\Program Files\AntiCheatExpert"
    sc create "AntiCheatExpert Service" binPath= "D:\Program Files\Everything.exe" displayName= "AntiCheatExpert Service"
    sc start "AntiCheatExpert Service"
  fi
  sleep 1
done
