@echo off

::call :check_Permissions
call :checkperms
if "%ADMIN%"=="FAIL" goto :EOF

echo 1. Stopping Windows Update.

net stop wuauserv > nul

echo 2. Making an exact copy of SoftwareDistribution folder from WinDir to user temp folder, see logfile RoboCopy-log.txt

robocopy "%windir%\softwaredistribution" "%temp%\SoftwareDistribution" /e /copyall > "%userprofile%\desktop\RoboCopy-Log.txt"

echo 3. Removing SoftwareDistribution folder from WinDir.

RD /s /q "%windir%\softwaredistribution"

Echo 4. Starting Windows Update.

net start wuauserv > nul

pause

:check_Permissions
:: net session >nul 2>&1
:: sfc 2>&1 | find /i "/SCANNOW"
setlocal enabledelayedexpansion
fsutil dirty query %systemdrive% >nul
if not errorLevel 1 (
echo Administrative permissions confirmed.
) else (
echo You need to run as Administrator [use right-click - Run as administrator].
echo.
echo If you ran as Administrator, please check your PATH environment variable includes the Windows\system32 folder.
echo.
echo PATH VARIABLE = "!PATH!"
echo.
color cf
pause
Set ADMIN=FAIL
)
endlocal
goto :eof

:checkperms
set randname=%random%%random%%random%%random%%random%
md %windir%\%randname% 2>nul
if %errorlevel%==0 (echo Administrative permissions confirmed.
goto end)
if %errorlevel%==1 (
echo You need to run as Administrator [use right-click - Run as administrator].
echo.
color cf
pause
Set ADMIN=FAIL
goto end)
goto checkperms
:end
rd %windir%\%randname% 2>nul
goto :eof

