compile: check-compiler getvalue.pas setvalue.pas
	fpc -XX -O3 -vi getvalue.pas
	fpc -XX -O3 -vi setvalue.pas


install: getvalue setvalue
	@cp -vu getvalue /usr/local/bin
	@cp -vu setvalue /usr/local/bin

remove: /usr/local/bin/getvalue
	@rm -fv /usr/local/bin/getvalue
	@rm -fv /usr/local/bin/setvalue
	@echo "Removed"

check-compiler:
	@fpc -h >/dev/null 2>&1 || (echo "ERROR: FreePascalCompiler (FPC) is required."; exit 1)
