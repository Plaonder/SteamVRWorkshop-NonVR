@echo off
SET /P_addonname= Please enter your addon name: 
SET addonpath=content\steamtours_addons\

echo Checking for the Steam Directory..
echo.

:: Steam directory check
:: Getting Steam path from registry
for /f "usebackq tokens=1,2,*" %%i in (`reg query "HKCU\Software\Valve\Steam" /v "SteamPath"`) do set "steampath=%%~k"
:: Replacing "/"'s with "\" in some cases
set steampath=%steampath:/=\%
:: Testing common paths
if not exist "%steampath%\steam.exe" (
	if not exist "%ProgramFiles(x86)%\steam\steam.exe" (
		if not exist "C:\Games\steam\steam.exe" (
			goto DontRunTools
		)
		if not exist "%ProgramFiles%\steam\steam.exe" (
			goto DontRunTools
		) else (
			set "steampath=%ProgramFiles%\steam"
		)
	) else set "steampath=%ProgramFiles(x86)%\steam"
)
IF exist "%steampath%" ( echo Found steam directory! Continuing... ) ELSE ( GOTO DontRunTools )
echo.

IF exist "%steampath%\steamapps\common\SteamVR\" ( SET "steamvr_dir=%steampath%\steamapps\common\SteamVR\" ) ELSE ( SET /P steamvr_dir=Couldn't find SteamVR tools! Please check you have SteamVR installed or specify the directory now:  )

echo Checking if addon exists...
echo.
if not exist "%steamvr_dir%\tools\steamvr_environments\content\steamtours_addons\%_addonname%" (
	echo ERROR: Did not find the addon folder. Did you enter the addon name correctly/created the addon?
	echo.
	goto DontRunTools
)
if exist "%steamvr_dir%\tools\steamvr_environments\content\steamtours_addons\%_addonname%" (
	echo Found the addon folder! Continuing...
	echo.
	goto :RunTools
)

:RunTools
echo Starting SteamVR Tools...
echo.
cd "%steamvr_dir%"
set steamtourspath=tools\steamvr_environments\game\bin\win64\steamtours.exe
echo Have fun! Can't wait to see what you create.
"%steamvr_dir%\%steamtourspath%" -addon %_addonname% -sw -tools -toolsvr -novr -vconsole -noasserts -nopassiveasserts -dev -devcomp -nop4

 
:DontRunTools
pause

:HaveFun
pause