@ECHO OFF

:loop
IF NOT "%1"=="" (
  IF "%1"=="-reposDir" (
    SET reposDir=%2
    SHIFT
  )
  IF "%1"=="-r" (
    SET reposDir=%2
    SHIFT
  )
  SHIFT
  GOTO :loop
)

IF "%reposDir%"=="" (
  ECHO Please speify path to directory with repos via -r or -reposDir option
  EXIT /B
)

rem // Save current directory and change to target directory
pushd %reposDir%
rem // Save value of CD variable (current directory)
set reposDir=%CD%
rem // Restore original directory
popd

if ERRORLEVEL 1 EXIT /B
set currentDir=%CD%

docker run --rm -it ^
-v "%reposDir%":/app/repos ^
-v "%currentDir%/parser-out":/app/logs ^
-v "%currentDir%/parser-out":/app/results ^
--env-file=.env ^
--network=gitlean_webnet ^
gitlean/parser

:theend
