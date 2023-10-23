@ECHO OFF
REM - Add FAST.exe directory to Windows search path ---------------------------------
ECHO * Actual Windows search path is:
ECHO * ------------------------------
ECHO * %PATH%
ECHO *
	set PATH=%PATH%D:\Mobile Desktop\FH Flensburg\2022-2023 WS\Optimus Oceanus\OpenFAST simulations;
ECHO * New Windows search path including FAST directory is:
ECHO * ----------------------------------------------------
ECHO * %PATH%
ECHO *
REM - Call FAST ---------------------------------------------------------------------
	openFAST_v3.4.1 Optimus-295-20.fst
PAUSE
EXIT /B
