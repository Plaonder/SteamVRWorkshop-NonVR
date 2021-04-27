@ECHO OFF

SET /P_addonname= Please enter your addon name: 
echo Starting SteamVR Tools...
"game\bin\win64\steamtours.exe" -addon %_inputname% -sw -tools -toolsvr -novr -vconsole -noasserts -nopassiveasserts -dev -devcomp -nop4
pause