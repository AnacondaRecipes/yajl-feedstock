set LIB=%LIBRARY_LIB%;%LIB%
set LIBPATH=%LIBRARY_LIB%;%LIBPATH%
set INCLUDE=%LIBRARY_INC%;%INCLUDE%;%RECIPE_DIR%

:: cmd
echo "Building %PKG_NAME%."

:: Generate the build files.
echo "Generating the build files..."
cmake -G "Ninja" ^
      -D CMAKE_BUILD_TYPE=Release ^
      -D CMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -D CMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
      %SRC_DIR%
if errorlevel 1 exit /b 1

:: Build.
echo "Building..."
ninja -j%CPU_COUNT% -v
if errorlevel 1 exit /b 1

:: Perform tests.
::echo "Testing..."
ctest -VV --output-on-failure
if errorlevel 1 exit /b 1 

:: Install.
:: ninja install
echo "Installing..."
ninja install
if errorlevel 1 exit /b 1


:: Error free exit.
echo "Error free exit!"
exit 0
