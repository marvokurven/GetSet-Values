@echo off

if [%1]==[install] goto install

:check-compiler
fpc -h >nul
if errorlevel 0 (goto compile) else goto error

:compile
fpc -XX -O3 -vi getvalue.pas
fpc -XX -O3 -vi getvalue.pas
goto end

:error
echo "ERROR: FreePascal Compiler is required. "
echo "You can find it at freepascal.org"
goto end

:install
copy setvalue.exe %systemroot%\system32
copy getvalue.exe %systemroot%\system32
goto end

:end
