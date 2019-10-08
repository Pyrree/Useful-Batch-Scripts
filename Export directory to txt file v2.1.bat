@echo off
goto :scriptstart
REM ######################      BLOCK 0 = DEBUG OPTIONS         ######################
:debugactive
@echo on
SET debug=pause
goto :scriptstart


REM ######################      BLOCK 1 = Initial question      ######################
:scriptstart
SET /P Source= Copy and paste the link of the folder you want exported as a text file:

if /I "%Source%" EQU "DEBUG" goto :debugactive
%debug%
cls

:advsearchq
set /P c=Make an advanced search[Y/N]?:
%debug%
cls
if /I "%c%" EQU "Y" goto :yesadv
if /I "%c%" EQU "N" goto :simplesearch
goto :advsearchq


REM ######################      BLOCK 2 = Simple qestion      ######################

:simplesearch

:simpleq1
set /P qsubdir=Do you want to include subdirectories[Y/N]?:
%debug%
cls
if /I "%qsubdir%" EQU "Y" SET SUBDIR=/s
if /I "%qsubdir%" EQU "Y" goto :simpleq2
if /I "%qsubdir%" EQU "N" SET SUBDIR=
if /I "%qsubdir%" EQU "N" goto :simpleq2
goto :simpleq1

:simpleq2
SET /p Save= Type the link to where the file will be saved:
%debug%
cls
SET /p Export= Choose a name for the file:
%debug%
cls

dir /b %SUBDIR% "%source%" > "%save%\%export%.txt"
%debug%
cls
Echo      #####################################################################################
Echo                    File "%export%.txt" successfully saved in "%save%"
Echo      #####################################################################################
pause
exit
pause
exit



REM ######################      BLOCK 3 = Advanced question      ######################


:yesadv

:advq1
set /P qsubdir=Do you want to include subdirectories?[Y/N]:
%debug%
cls
if /I "%qsubdir%" EQU "Y" SET subdir=/s
if /I "%qsubdir%" EQU "Y" goto :advq2
if /I "%qsubdir%" EQU "N" SET subdir=
if /I "%qsubdir%" EQU "N" goto :advq2
goto :advq1


:advq2
set /P qbare=Use bare format? this excludes heading, file sizes and summary [Y/N]:
%debug%
cls
if /I "%qbare%" EQU "Y" SET bare=/b
if /I "%qbare%" EQU "Y" goto :advq3
if /I "%qbare%" EQU "N" SET bare=
if /I "%qbare%" EQU "N" goto :advq3
goto :advq2


:advq3
set /P qfiletype=Search for specific filetypes?[Y/N]:
%debug%
cls
if /I "%qfiletype%" EQU "Y" goto :filetypelist
if /I "%qfiletype%" EQU "N" goto :advq4
goto :advq3


:filetypelist
ECHO Type each filetype like this *.txt *.png (You need to include the * and . before each and every filetype)
set /P filetype=Add filetypes:
%debug%
cls
goto :selectedfiletypes

:selectedfiletypes
ECHO You have added the following filetypes
ECHO %filetype%

set /P confirmfiletypes=To continue type Y, to repeat question "Search for specific filetypes" type N [Y/N]:
%debug%
cls
if /I "%confirmfiletypes%" EQU "Y" goto :advq4
if /I "%confirmfiletypes%" EQU "N" goto :advq3
goto :selectedfiletypes

:advq4
set /P qsortlist=Do you wish to sort the list in a specific order?[Y/N]:
%debug%
cls
if /I "%qsortlist%" EQU "Y" goto :sortlistchoice
if /I "%qsortlist%" EQU "N" goto :advq5
goto :adv4

:sortlistchoice
ECHO Choose sort opion, start with the prefix to reverse order.
Echo Example: -N
Echo ----------------
Echo (N) By name, alphabetic
Echo (E) By extension, alphabetic
Echo (G) Group directories first
Echo (S) By size, smallest first
Echo (D) By date/time, oldest first
ECHO - Prefix to reverse order
Echo ----------------
set /P sortletter=Enter letter(plus prefix if nessesary):
%debug%
set sortO=/O:%sortletter%
%debug%
cls
goto :selectedsortorder

:selectedsortorder
ECHO You have chosen the following sort order letter.
ECHO %sortletter%

set /P confirmsortorder=To continue type Y, to repeat question about sort order type N [Y/N]:
%debug%
cls
if /I "%confirmsortorder%" EQU "Y" goto :advq5
if /I "%confirmsortorder%" EQU "N" goto :advq4
goto :selectedsortorder

:advq5
SET /p Save= Type the link to where the file will be saved:
%debug%
cls
SET /p Export= Choose a name for the file:
%debug%
cls
goto :printvariable

:printvariable
cls
@Echo off
Echo #####################################
Echo #             Summary               #
Echo #-----------------------------------#
Echo # Source destination:               #
Echo # %source% 
Echo #-----------------------------------#
Echo # Export Destination:
Echo # %save%
Echo #-----------------------------------#
Echo # Export Filename:
Echo # %export%.txt
Echo #-----------------------------------#
Echo # Use bare format:
Echo # %qbare%
Echo #-----------------------------------#
Echo # Sort parameter:
Echo # %sortO%
Echo #-----------------------------------#
Echo # Sub directories:
Echo # %qsubdir%
Echo #-----------------------------------#
Echo # Filetype(s) to seach for:
Echo # %filetype%
Echo #-----------------------------------#
Echo # Command that will run             #
Echo # "%source%" %filetype% %subdir% %bare% %sortO% "%save%\%export%.txt"
Echo #####################################
Pause
cls
if /I "%debug%" EQU "pause" @Echo on
goto :runscript

:runscript
ECHO."%source%"| FIND /I "\\">Nul && ( 
  net use z: "%source%"
  Z:
  cd "%source:~2%"
  Echo Creating text file "%export%.txt", if you can read this message, this could take a while...
  dir %filetype% %subdir% %bare% %sortO% > "%save%\%export%.txt"
  cls
Echo      #####################################################################################
Echo                    File "%export%.txt" successfully saved in "%save%"
Echo      #####################################################################################
pause
Echo unmounting temporary Z: ...
net use Z: /delete
pause
goto :eof
) || (
  %source:~0,2%
  cd "%source:~2%"
  Echo Creating text file "%export%.txt", if you can read this message, this could take a while...
 dir %filetype% %subdir% %bare% %sortO% > "%save%\%export%.txt"
 cls
Echo      #####################################################################################
Echo                    File "%export%.txt" successfully saved in "%save%"
Echo      #####################################################################################
pause
goto :eof
)

:eof
