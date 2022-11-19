@echo off
call setEnv.bat
"C:\Program Files\Polyspace\R2019a\toolbox\shared\coder\ninja\win64\ninja.exe" -v %*
