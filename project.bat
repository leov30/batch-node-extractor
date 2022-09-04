@echo off
setlocal enabledelayedexpansion
title Batch node text extractor
set /p _url="Enter Url: "
echo Will show 1st found text of the last node
echo ^<node1^>^<node2^>^<node..n^>text^</node..n^>
echo.
set /p _xpath="node1\node2\node...n: "
cls&echo Looking for the text...
set "_found=true"
for /f "delims=" %%g in ('curl -s "%_url%"') do (
	if "!_found!"=="true" (
		for /f "tokens=1 delims=\" %%h in ("!_xpath!") do (
			set "_node=%%h"&set "_found=false"
			set "_xpath=!_xpath:%%h\=!"
		)
	)
	echo "%%g" | findstr /i /c:"<!_node!>" >nul
	if !errorlevel! equ 0 (
		set "_found=true"
		for /f "tokens=3 delims=<>" %%h in ("%%g") do set "_text=%%h"
		if "!_node!"=="!_xpath!" goto :finish
	)
)
:finish
if "%_text%"=="" (echo Text not found)else (echo %_text%)
pause&exit
