@echo off
set file=Y:\
set number=999999999999999999999999999999999999999999999999999
set sleep=1
for /L %%n in ( 1,1,%number% ) do (
::cd %file%
del Y:\1.txt
del Y:\2.txt
del Y:\3.txt
del Y:\4.txt
echo The %%n
ping 127.0.0.1 -n %sleep% > nul
)