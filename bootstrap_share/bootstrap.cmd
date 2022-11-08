@echo off
setlocal

SET MSYS_URI="https://github.com/msys2/msys2-installer/releases/download/2022-09-04/msys2-base-x86_64-20220904.tar.xz"
SET VSCODE_URI="https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"

SET SHARE=%USERPROFILE%\Desktop\bootstrap_share
SET PORTABLE=%SHARE%\portable_mingw_vscode
SET TEMP=%SHARE%\..\temp
mkdir %TEMP%

SET MSYS=C:\msys64
SET MINGW=%MSYS%\mingw64
SET VSCODE=%PORTABLE%\vscode

SET PATH=%SHARE%;%PATH% 
SET GWPATH=%MSYS%\usr\bin;%MINGW%\bin;%PATH%
SET VSPATH=%VSCODE%\bin\;%PATH%

SET PATH=%GWPATH%
call :fetch_msys
call :install_mingw

SET PATH=%VSPATH%
call :fetch_vscode
call :install_vscode_extensions
call :portable_archive
exit /B %ERRORLEVEL%

:fetch_vscode
wget %VSCODE_URI% -O %TEMP%\vscode.zip
mkdir %VSCODE%
C:\Windows\System32\tar.exe -xf %TEMP%\vscode.zip --directory %VSCODE%
:: make it a portable install
mkdir %VSCODE%\data
exit /B 0

:install_vscode_extensions
call :install_code_extension ms-vscode.cpptools
call :install_code_extension ms-vscode.cpptools-themes
call :install_code_extension ms-vscode.cpptools-extension-pack
call :install_code_extension ms-vscode.cmake-tools
::call :install_code_extension twxs.cmake
::call :install_code_extension fougas.msys2
::call :install_code_extension shd101wyy.markdown-preview-enhanced
exit /B 0

:install_code_extension
call code --disable-gpu --install-extension %~1 --force
exit /B 0

:portable_archive
echo Creating portable archive (this might take some time)
xcopy /s /i /q /y %MINGW% %PORTABLE%\mingw64
xcopy /q /y %SHARE%\misc\*.* %PORTABLE%\
move /y %PORTABLE%\argv.json %VSCODE%\data\argv.json
move /y %PORTABLE%\vscode.cmd %VSCODE%\vscode.cmd
xcopy /s /i /q /y %SHARE%\misc\projects %PORTABLE%\projects
xcopy /s /i /q /y %SHARE%\misc\.vscode %PORTABLE%\projects\.vscode
:: too much copying but we can't move (Access denied):
exit /B 0

:fetch_msys
call :download_msys
call :extract_msys
call :msys_pgp
exit /B 0

:download_msys
wget %MSYS_URI% -O %TEMP%\msys64.tar.xz
exit /B /0

:extract_msys
echo Extracting msys...
xz.exe -d %TEMP%\msys64.tar.xz
tar -xf %TEMP%\msys64.tar --directory C:\
exit /B /0

:msys_pgp
:: pacman's check disk space seg-faults on UWP - disable it
bash.exe -c "sed -i 's/^CheckSpace/#CheckSpace/g' /etc/pacman.conf"
::start /B /WAIT sed -i 's/^CheckSpace/#CheckSpace/g' %MSYS%/etc/pacman.conf
:: "" argument to force terminal exit
call %MSYS%\msys2_shell.cmd -no-start -defterm -msys "exit"
exit /B 0

:install_mingw
pacman.exe -S --noconfirm mingw-w64-x86_64-cmake mingw-w64-x86_64-clang mingw-w64-x86_64-clang-tools-extra mingw-w64-x86_64-gdb mingw-w64-x86_64-lldb-mi
exit /B 0
