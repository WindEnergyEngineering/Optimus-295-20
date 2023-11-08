@ECHO OFF
REM - Add FAST.exe directory to Windows search path ---------------------------------
ECHO * Actual Windows search path is:
ECHO * ------------------------------
ECHO * %PATH%
ECHO *
	set PATH=%PATH%d:\Mobile Desktop\HS Flensburg\2023-2024 WS\Optimus\OpenFAST_simulations;
ECHO * New Windows search path including FAST directory is:
ECHO * ----------------------------------------------------
ECHO * %PATH%
ECHO *
REM - Call FAST ---------------------------------------------------------------------
	openfast_v3-41_X64 OPT-20-295-Monopile.fst
PAUSE
EXIT /B
