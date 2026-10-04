@echo off


@rem select code page with utf-8 support CP_UTF8
chcp 65001 > NUL 2> NUL

setlocal EnableDelayedExpansion

where /Q cl.exe || (
	set __VSCMD_ARG_NO_LOGO=1
	for /f "tokens=*" %%i in ('"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath') do set VS=%%i
	if "!VS!" equ "" (
		echo ERROR: MSVC installation not found
		exit /b 1
	)
	call "!VS!\Common7\Tools\vsdevcmd.bat" -arch=x64 -host_arch=x64 || exit /b 1
)

if "%VSCMD_ARG_TGT_ARCH%" neq "x64" (
	if "%ODIN_IGNORE_MSVC_CHECK%" == "" (
		echo ERROR: please run this from MSVC x64 native tools command prompt, 32-bit target is not supported!
		exit /b 1
	)
)

pushd %~dp0

rem call build_shared.bat
rem if %errorlevel% neq 0 goto end_of_build
rem if %release_mode% EQU 0 odin run examples/demo -resource:%iconrc% -- Hellope World
rem del *.obj > NUL 2> NUL

call msbuild\build.bat

msbuild build.recipe /l:FileLogger,Microsoft.Build.Engine;logfile=build.log

:end_of_build
popd
