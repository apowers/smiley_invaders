@echo off
if "%1"=="/?" goto help
if "%1"=="?" goto help
if "%1"=="" goto help
if "%2"=="" goto help
if "%1"=="black" color 0 %2 
if "%1"=="red" color 1 %2 
if "%1"=="green" color 2 %2 
if "%1"=="yellow" color 3 %2 
if "%1"=="blue" color 4 %2 
if "%1"=="magenta" color 5 %2 
if "%1"=="cyan" color 6 %2 
if "%1"=="white" color 7 %2 
if "%2"=="black" color %1 0 
if "%2"=="red" color %1 1 
if "%2"=="green" color %1 2 
if "%2"=="yellow" color %1 3 
if "%2"=="blue" color %1 4 
if "%2"=="magenta" color %1 5 
if "%2"=="cyan" color %1 6 
if "%2"=="white" color %1 7 
rem if "%1"=<"0" goto help
rem if "%1"=>"9" goto help
rem if "%2"=<"0" goto help
rem if "%2"=>"9" goto help

prompt=$p$g$e[3%1;4%2;2m

echo on
cls
@echo DONE
@echo off
goto quit

:help
echo.
echo COLOR [foreground] [background]
echo 0=black
echo 1=red
echo 2=green
echo 3=yellow
echo 4=blue
echo 5=magenta
echo 6=cyan
echo 7=white
echo.

:err
echo use "COLOR /?" for help
echo.

:quit
