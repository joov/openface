#!/usr/bin/env bash

######################################################################
# Torch install
#
# This script installs Torch7, and a few extra packages
# (penlight, optim, parallel, image).
# 
# The install is done via Luarocks, which enables package
# versions. This is the recommended method to deploy Torch,
# torch-pkg is being deprecated.
#
#    Once this script has been run once, you should be able to run
#    extra torch-rocks commands, and in particular install new packages:
#    $ torch-rocks install json
#    $ torch
#    > require 'json'
#
######################################################################

# Prefix:
PREFIX=${PREFIX-/usr/local}
echo "Installing Torch into: $PREFIX"

# On Linux, export Gfortran's path (this does something only if OpenBLAS is found)
if [[ `uname` == 'Linux' ]]; then
    export CMAKE_LIBRARY_PATH=/usr/lib/gcc/x86_64-linux-gnu:/usr/lib/gcc/x86_64-linux-gnu/4.6:$CMAKE_LIBRARY_PATH
fi

# Build and install Torch7
cd /tmp
git clone https://github.com/andresy/torch
cd torch
mkdir build; cd build
git checkout master; git pull
rm -f CMakeCache.txt
cmake .. -DWITH_ROCKS=1 -DCMAKE_INSTALL_PREFIX=$PREFIX
make
make install || sudo make install

# Install Torch7, with LuaJIT support, and extra packages
$PREFIX/bin/torch-rocks install luafilesystem ||  sudo $PREFIX/bin/torch-rocks install luafilesystem
$PREFIX/bin/torch-rocks install penlight      ||  sudo $PREFIX/bin/torch-rocks install penlight
$PREFIX/bin/torch-rocks install sys           ||  sudo $PREFIX/bin/torch-rocks install sys
$PREFIX/bin/torch-rocks install xlua          ||  sudo $PREFIX/bin/torch-rocks install xlua
$PREFIX/bin/torch-rocks install image         ||  sudo $PREFIX/bin/torch-rocks install image
$PREFIX/bin/torch-rocks install optim         ||  sudo $PREFIX/bin/torch-rocks install optim
$PREFIX/bin/torch-rocks install json          ||  sudo $PREFIX/bin/torch-rocks install json
$PREFIX/bin/torch-rocks install lua-cjson     ||  sudo $PREFIX/bin/torch-rocks install lua-cjson
$PREFIX/bin/torch-rocks install trepl         ||  sudo $PREFIX/bin/torch-rocks install trepl

# Done.
echo ""
echo "==> Torch7 has been installed successfully"
echo ""
echo "  + Extra packages have been installed as well:"
echo "     $ torch-rocks list"
echo ""
echo "  + To install more packages, do:"
echo "     $ torch-rocks search --all"
echo "     $ torch-rocks install PKG_NAME"
echo ""
echo "  + Note: on MacOS, it's a good idea to install GCC 4.6 to enable OpenMP."
echo "          You can do this by installing the GFortran bundles provided here:"
echo "          http://gcc.gnu.org/wiki/GFortranBinaries"

