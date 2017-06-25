@FOR /f "tokens=*" %%i IN ('docker-machine env') DO @%%i
for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set NetworkIP=%%a
for /f %%a in ('cd') do set Dir=%%a
set Dir=%Dir::\=\%
set Dir=//%Dir:\=/%
set Dir=%Dir://D=//d%
docker run --rm -v %Dir%:/project --env BASEURL="http://%NetworkIP%:3000/" mrsheepuk/protractor