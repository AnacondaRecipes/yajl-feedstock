#!/bin/bash
set -ex

EXTRA_CMAKE_ARGS=""
if [[ `uname` == "Darwin" ]]; then
  EXTRA_CMAKE_ARGS="${EXTRA_CMAKE_ARGS} -DCMAKE_MACOSX_RPATH=ON"
fi

# Isolate the build.
mkdir -p Build-${PKG_NAME}
cd Build-${PKG_NAME} || exit 1

# Generate the build files.
echo "Generating the build files."

cmake .. -G"Ninja" ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=${PREFIX} \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
      -DCMAKE_EXE_LINKER_FLAGS="-Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib" \
      ${EXTRA_CMAKE_ARGS} ${SRC_DIR}

# Build.
echo "Building..."
ninja -j${CPU_COUNT} || exit 1

# Perform tests.
#  echo "Testing..."
#  ninja test || exit 1
#  path_to/test || exit 1
#  ctest -VV --output-on-failure || exit 1

# Installing
echo "Installing..."
ninja install || exit 1

# Error free exit!
echo "Error free exit!"
exit 0
