@echo off
title Auto MD dir by V1.0.1.0 for 2017-12-15
setlocal EnableDelayeExpansion
rem ###########################################################
set MD_number=5
for /l %%M in (1,1,%MD_number%) do (
    MD %%M
    cd %%M
    echo %cd%
    ping -n 3 127.0.0.1 >>nul
)

