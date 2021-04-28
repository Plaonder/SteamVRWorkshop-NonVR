@echo off
echo This will startup the SteamVR Workshop tools without needing VR enabled. Enter your addon name and we're off!
echo.
echo If this script is unable to find the SteamVR folder everytime you run it,
echo Change customgamepath below in the code to your directory.
echo.

:: If you don't want to put in your directory everytime you want to run, paste your SteamVR directory here after the equals sign
SET customgamepath=Q:\Games\SteamLibrary\steamapps\common\SteamVRh

SET /P_addonname= Please enter your addon name: 
SET addonpath=content\steamtours_addons\
echo.
echo Checking for the Steam Directory..

:: Steam directory check
for /f "usebackq tokens=1,2,*" %%i in (`reg query "HKCU\Software\Valve\Steam" /v "SteamPath"`) do set "steampath=%%~k"
set steampath=%steampath:/=\%
if not exist "%steampath%\steam.exe" (
	if not exist "%ProgramFiles(x86)%\steam\steam.exe" (
		if not exist "%ProgramFiles%\steam\steam.exe" (
			goto SteamUninstalled
		) else (
			set "steampath=%ProgramFiles%\steam"
		)
	) else set "steampath=%ProgramFiles(x86)%\steam"
)
IF exist "%steampath%" ( echo Found steam directory! Continuing... ) ELSE ( GOTO SteamUninstalled )

:: Setting the SteamVR directory depending if you have a custom game path set or not
IF exist "%steampath%\steamapps\common\SteamVR\" (
	SET "steamvr_dir=%steampath%\steamapps\common\SteamVR\"
	echo.
	goto CheckForAddons
) ELSE ( 
	:: If it can't find the tools folder inside the custom game path
	:: Check for the tools folder for a little more assurance that this is the actual folder
	:: Still easy to break but whatever
	if not exist "%customgamepath%\tools\" ( 
		echo.
		echo ERROR: Couldn't find SteamVR tools!
		SET /P input_steamvr_dir= Is SteamVR installed? Input the directory of SteamVR if its on another drive: 
		goto CheckInputtedDirectory
		
	) else if exist "%customgamepath%\tools\" (
		:: If it does find the tools folder inside the custom game path
		SET steamvr_dir=%customgamepath%
		echo.
		echo Custom directory found!
		echo Using custom directory...
		echo.
		goto CheckForAddons
	)
)

:: Check the inputted directory seen previously
:CheckInputtedDirectory
:: Checking if the inputted directory worked
IF NOT EXIST "%input_steamvr_dir%\tools" (
	echo.
	echo ERROR: Inputted directory did not work.
	:: If it did not work give the user a little tip on how to put the correct directory
	echo Make sure to put a directory like this: "D:\SteamLibrary\steamapps\common\SteamVR"
	goto End
)
IF EXIST "%input_steamvr_dir%\tools" (
	echo Directory worked! Continuing...
	SET steamvr_dir=%input_steamvr_dir%
	echo.
	goto CheckForAddons
)

:CheckForAddons
echo Checking if your addon exists...
:: If it cannot find the addon folder from the addon name inputted, throw an error and end the script
if not exist "%steamvr_dir%\tools\steamvr_environments\content\steamtours_addons\%_addonname%" (
	echo.
	echo ERROR: Did not find the addon folder. Did you enter the addon name correctly/created the addon?
	pause
	goto End
)
:: If it does find the addon folder from the addon name inputted, continue to RunTools
if exist "%steamvr_dir%\tools\steamvr_environments\content\steamtours_addons\%_addonname%" (
	echo Found the addon folder! Continuing...
	goto RunTools
)

:RunTools
echo.
echo Starting SteamVR Tools...
set steamtourspath=tools\steamvr_environments\game\bin\win64\steamtours.exe
echo Have fun! Can't wait to see what you create.
:: This actually runs the tools. If anyone has any ideas for launch options or found a launch option that's causing a problem please let me know.
"%steamvr_dir%\%steamtourspath%" -addon %_addonname% -sw -tools -toolsvr -novr -vconsole -noasserts -nopassiveasserts -dev -devcomp -nop4
goto HaveFun

:: Just a lil goodbye message :D
:HaveFun
echo Goodbye!
goto End

:: If steam is not installed then throw an error message
:SteamUninstalled
echo.
echo ERROR: Is Steam installed on this computer? Could not find the Steam directory.
pause
goto End

:End
echo.
echo.
echo Ending the script...
pause