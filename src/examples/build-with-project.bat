@ECHO OFF
REM
REM Sample script used to obfuscate python source files with prroject
REM
REM There are several advantages to manage obfuscated scripts by project:
REM
REM   * Increment build, only updated scripts are obfuscated since last build
REM   * Filter scripts, for example, exclude all the test scripts
REM   * More convenient command to manage obfuscated scripts
REM

SETLOCAL

REM TODO:
SET PYTHON=C:\Python34\python.exe

REM TODO: Where to find pyarmor.py
SET PYARMOR_PATH=C:\Python34\Lib\site-packages\pyarmor

REM TODO: Absolute path in which all python scripts will be obfuscated
SET SOURCE=%PYARMOR_PATH%\examples\simple
REM TODO: Entry script filename, must be relative to %SOURCE%
SET ENTRY_SCRIPT=queens.py

REM For package, uncomment the following lines
rem SET SOURCE=%PYARMOR_PATH%\examples\testpkg\mypkg
rem SET PKGNAME=mypkg
rem SET ENTRY_SCRIPT=__init__.py

REM TODO: output path for saving project config file, and obfuscated scripts
SET PROJECT=%PYARMOR_PATH%\examples\armor-project

REM TODO: Filter the source files, exclude all the scripts in test
rem SET PROJECT_FILTER=global-include *.py, prune test

REM TODO: If generate new license for obfuscated scripts, uncomment next line
rem SET LICENSE_CODE=any-identify-string

REM Extra information for new license, uncomment the corresponding lines as your demand
REM They're useless if LICENSE_CODE is not set
rem SET LICENSE_EXPIRED_DATE=--expired 2019-01-01
rem SET LICENSE_HARDDISK_SERIAL_NUMBER=--bind-disk SF210283KN
rem SET LICENSE_MAC_ADDR=--bind-mac 70:38:2a:4d:6f
rem SET LICENSE_IPV4_ADDR=--bind-ipv4 192.168.121.101

REM TODO: Comment next line if do not try to test obfuscated project
SET TEST_OBFUSCATED_PROJECT=1

REM Set PKGNAME if it's a package
REM It doesn't work
rem IF "%ENTRY_SCRIPT%" == "__init__.py" (
rem   ECHO.
rem   FOR %%i IN ( %SOURCE% ) DO SET PKGNAME=%%~ni%
rem   ECHO Package name is %PKGNAME%
rem   ECHO.
rem )

REM Check Python
%PYTHON% --version 
IF NOT ERRORLEVEL 0 (
  ECHO.
  ECHO Python doesn't work, check value of variable PYTHON
  ECHO.
  GOTO END
)

REM Check Pyarmor
IF NOT EXIST "%PYARMOR_PATH%\pyarmor.py" (
  ECHO.
  ECHO No pyarmor found, check value of variable PYARMOR_PATH
  ECHO. 
  GOTO END
)

REM Check Source
IF NOT EXIST "%SOURCE%" (
  ECHO.
  ECHO No %SOURCE% found, check value of variable SOURCE
  ECHO. 
  GOTO END
)

REM Check entry script
IF NOT EXIST "%SOURCE%\%ENTRY_SCRIPT%" (
  ECHO.
  ECHO No %ENTRY_SCRIPT% found, check value of variable ENTRY_SCRIPT
  ECHO. 
  GOTO END
)

REM Create a project
ECHO.
CD /D %PYARMOR_PATH%
%PYTHON% pyarmor.py init --src=%SOURCE% --entry=%ENTRY_SCRIPT% %PROJECT%
IF NOT ERRORLEVEL 0 GOTO END
ECHO.

REM Change to project path, there is a convenient script pyarmor.bat
CD /D %PROJECT%

REM Filter source files by config project filter
IF DEFINED PROJECT_FILTER (
  CALL pyarmor.bat config --manifest "%PROJECT_FILTER%"
  IF ERRORLEVEL 1 GOTO END
)

REM Obfuscate scripts by command build
ECHO.
CALL pyarmor.bat build
IF NOT ERRORLEVEL 0 GOTO END
ECHO.

REM Generate new license if any
IF DEFINED LICENSE_CODE (

  CALL pyarmor.bat licenses %LICENSE_EXPIRED_DATE% %LICENSE_HARDDISK_SERIAL_NUMBER% %LICENSE_MAC_ADDR% %LICENSE_IPV4_ADDR% %LICENSE_CODE%
  IF ERRORLEVEL 1 GOTO END
  
  REM Overwrite default license with this license
  ECHO.  
  IF DEFINED PKGNAME (
    ECHO Copy new license to %PROJECT%\dist
    COPY licenses\%LICENSE_CODE%\license.lic %PROJECT%\dist
  ) ELSE (
    ECHO Copy new license to %PROJECT%\dist\%PKGNAME%
    COPY licenses\%LICENSE_CODE%\license.lic %PROJECT%\dist\%PKGNAME%
  )
  ECHO.

)

REM Test obfuscated project if 
IF "%TEST_OBFUSCATED_PROJECT%" == "1"  IF DEFINED ENTRY_SCRIPT (
  SETLOCAL 
  
  IF DEFINED PKGNAME (
    REM Test package
    ECHO Prepare to import obfuscated package, run 
    ECHO   python -c "import %PKGNAME%"
    ECHO.
    PAUSE

    CD /D %PROJECT%\dist
    %PYTHON% -c "import %PKGNAME%"
    ECHO.
    ECHO Import obfuscated package %PKGNAME% finished.
    ECHO.    
  ) ELSE (  
    REM Test app
    ECHO Prepare to run obfuscated script %PROJECT%\dist\%ENTRY_SCRIPT%
    PAUSE
    
    CD /D %PROJECT%\dist
    %PYTHON% %ENTRY_SCRIPT%
  )
  
  ENDLOCAL
)

:END

ENDLOCAL
PAUSE

