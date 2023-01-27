#!/usr/bin/env bash

# Download and install deps from homebrew on macos

brew update
brew install bash gnu-getopt # for CI scripts
brew install cmake
brew install boost
brew install pybind11 # also installs the dependent python version
brew install cppunit
brew install c-blosc
brew install zlib
brew install jq # for trivial parsing of brew json

# Alias python version installed by pybind11 to path
py_version=$(brew info pybind11 --json | \
    jq -cr '.[].dependencies[] | select(. | startswith("python"))')
echo "Using python $py_version"
# export for subsequent action steps (note, not exported for this env)
echo "Python_ROOT_DIR=/usr/local/opt/$py_version" >> $GITHUB_ENV
echo "/usr/local/opt/$py_version/bin" >> $GITHUB_PATH

# use gnu-getopt
echo "/usr/local/opt/gnu-getopt/bin" >> $GITHUB_PATH

LLVM_VERSION=$1
if [ "$LLVM_VERSION" == "latest" ]; then
    brew install tbb
    brew install llvm
else
    brew install tbb@2020
    brew install llvm@$LLVM_VERSION

    # Export TBB paths which are no longer installed to /usr/local (as v2020 is deprecated)
    echo "TBB_ROOT=/usr/local/opt/tbb@2020" >> $GITHUB_ENV
    echo "/usr/local/opt/tbb@2020/bin" >> $GITHUB_PATH
fi
