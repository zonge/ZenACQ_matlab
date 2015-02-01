@echo off
mode con: cols=70 lines=30
prompt $g
cls
echo Firmware HEX version : %1
setlocal EnableDelayedExpansion
set count=0
for /f %%a in (COM.cfg) do (
set /A count+=1
set val=%%a
set port[!count!]=%%a
)
del COM.cfg
for /L %%i in (1,1,%count%) do (
lpc21isp -control -controlswap -controlinv %1 !port[%%i]! 230400 14745
)
echo. 2>done.fir
exit
