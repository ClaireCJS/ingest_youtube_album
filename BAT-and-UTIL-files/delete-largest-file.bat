@echo off

set maxSize=0
set largestFile=


for %%G in (*.*) do (
    set fileSize=%%~zG
    if %fileSize% GT %maxSize% (
        set /A maxSize=%fileSize%
        set largestFile=%%G
    )
)

if "%largestFile%"=="" (%COLOR_ERROR% %+ echo Largest file not found! %+ goto :END)

echo.
echo.
%COLOR_IMPORTANT% %+ echo The largest file is: %largestFile%
%COLOR_WARNING%   %+ echo ** Delete the largest file?
%COLOR_REMOVAL%   
if exist "\recycled\%largestFile%" (%COLOR_UNIMPORTANT %+ *del "\recycled\%largestFile%" %+ %COLOR_REMOVAL%)
set UNDOCOMMAND=mv \recycled\"%largestFile%" .
del "%largestFile%" %* 



:END