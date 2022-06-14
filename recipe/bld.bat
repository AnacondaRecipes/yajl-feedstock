:: cmd
@echo ON

set LIB=%LIBRARY_LIB%;%LIB%
set LIBPATH=%LIBRARY_LIB%;%LIBPATH%
set INCLUDE=%LIBRARY_INC%;%INCLUDE%;%RECIPE_DIR%


echo "Building %PKG_NAME%."

:: Isolate the build.
rmdir /Q /S build
mkdir build
cd build
if errorlevel 1 exit 1


:: Generate the build files.
echo "Generating the build files..."
cmake .. -G"Ninja" %CMAKE_ARGS% ^
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
::  echo "Testing..."
::  ninja test
::  path_to\test
::  ctest -VV --output-on-failure
::  if errorlevel 1 exit 1

:: Install.
:: ninja install
echo "Installing..."
ninja install
if errorlevel 1 exit /b 1


:: Error free exit.
echo "Error free exit!"
exit 0
