@echo off
rem ***********************************************************************
rem This hapiDevSetup.bat sets the user environment for running Node.js
rem servers and npm package manager.  Additionally this batch will create
rem a new hapi project based on Hypertherm's hapi development instance.
rem
rem Optional Arguments:
rem 	-new=YourNewProjectName
rem		-prj=YourExistingProject
rem
rem Change History:
rem 
rem		2017.11.03	Jeffrey Page	Created this batch file.
rem
rem
rem
rem
rem   Color Chart
rem   0 = Black       8 = Gray
rem   1 = Blue        9 = Light Blue
rem   2 = Green       A = Light Green
rem   3 = Aqua        B = Light Aqua
rem   4 = Red         C = Light Red
rem   5 = Purple      D = Light Purple
rem   6 = Yellow      E = Light Yellow
rem   7 = White       F = Bright White
rem
rem ***********************************************************************

rem Set my screen color to black background and green text
color 0A

rem Set Oracle Instant Client Package SDK environment vars
set OCI_LIB_DIR = C:\oracle\instantclient\sdk\lib\msvc
set OCI_INC_DIR = C:\oracle\instantclient\sdk\include
set OCI_INCLUDE_DIR = C:\oracle\instantclient\sdk\include

rem read_params and set them to local vars
:read_params
if not %1/==/ (
    if not "%__var%"=="" (
        if not "%__var:~0,1%"=="-" (
            endlocal
            goto read_params
        )
        endlocal & set %__var:~1%=%~1
    ) else (
        setlocal & set __var=%~1
    )
    shift
    goto read_params
)

rem Start in Node.js directory
cd /d "C:\Program Files\nodejs\"

rem Ensure this Node.js and npm are first in the PATH
set "PATH=%APPDATA%\npm;%~dp0;C:\Python27\;C:\oracle\instantclient\;%PATH%"

setlocal enabledelayedexpansion
pushd "%~dp0"

rem Figure out the Node.js version.
set print_version=node.exe -p -e "process.versions.node + ' (' + process.arch + ')'"
for /F "usebackq delims=" %%v in (`%print_version%`) do set version=%%v

rem Print message.
if exist npm.cmd (
  echo Your environment has been set up for using Node.js !version! and npm.
) else (
  echo Your environment has been set up for using Node.js !version!.
)

popd
endlocal

rem Make sure a hapi_root exists
if exist %HOMEDRIVE%%HOMEPATH%\hapi_root\NUL goto HAPI_ROOT
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root"
:HAPI_ROOT
cd /d "%HOMEDRIVE%%HOMEPATH%\hapi_root"
  
rem if -prj
if not "%prj%"=="" (
    cd /d "%HOMEDRIVE%%HOMEPATH%\hapi_root\%prj%"
    goto ALLDONE
)

rem if -new
if not "%new%"=="" (
  if exist %HOMEDRIVE%%HOMEPATH%\hapi_root\%new%\NUL goto NOTNEW
  echo Creating new project %new%
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%"
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%\lib"
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%\lib\modules"
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%\lib\modules\atr"
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%\lib\modules\b2b"
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%\lib\modules\htr"
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%\lib\modules\mto"
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%\lib\modules\ops"
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%\lib\modules\otc"  
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%\lib\modules\pdm"
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%\lib\modules\ptm"
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%\lib\modules\ptp"
  mkdir "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%\lib\templates"
  cd /d "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%"
  echo { > package.json
  echo "name": "%new%",  >> package.json
  echo "version": "1.0.0", >> package.json
  echo "description": "Add a description of the %new% module", >> package.json
  echo "main": "index.js", >> package.json
  echo "scripts": { >> package.json
  echo   "test": "%new%_testme" >> package.json
  echo }, >> package.json
  echo "repository": { >> package.json
  echo   "type": "git", >> package.json
  echo   "url": "%new%" >> package.json
  echo }, >> package.json
  echo "author": "Hypertherm Associate", >> package.json
  echo "license": "ISC", >> package.json
  echo "dependencies": { >> package.json
  echo   "hapi": "*", >> package.json
  echo   "hapi-plugin-oracledb": "^3.0.3", >> package.json
  echo   "vision": "^4.1.1", >> package.json
  echo   "request": "*", >> package.json
  echo   "handlebars": "*", >> package.json
  echo   "lodash.filter": "*", >> package.json
  echo   "lodash.take": "*" >> package.json
  echo } >> package.json
  echo } >> package.json
  npm install
)
goto ALLDONE
:NOTNEW
echo %new% already exisits... Going there now.
cd /d "%HOMEDRIVE%%HOMEPATH%\hapi_root\%new%"
goto ALLDONE

:ALLDONE
set new=
set prj=
color 0A
cd

