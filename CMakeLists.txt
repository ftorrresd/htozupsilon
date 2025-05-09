# Require CMake 3.15+ (matching scikit-build-core) Use new versions of all
# policies up to CMake 3.27
cmake_minimum_required(VERSION 3.15...3.27)

# Scikit-build-core sets these values for you, or you can just hard-code the
# name and version.
project(
  ${SKBUILD_PROJECT_NAME}
  VERSION ${SKBUILD_PROJECT_VERSION}
  LANGUAGES CXX)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

message(STATUS "Looking for ROOT")
find_package(ROOT REQUIRED COMPONENTS RIO)
message(STATUS "ROOT ${ROOT_VERSION} found at ${ROOT_BINDIR}")

execute_process(COMMAND root-config --incdir OUTPUT_VARIABLE ROOT_INCLUDE_DIR OUTPUT_STRIP_TRAILING_WHITESPACE)
separate_arguments(ROOT_INCLUDE_DIR)

# LCG base dir
set(LCG_BASE /cvmfs/sft.cern.ch/lcg/views/LCG_107a/x86_64-el9-gcc14-opt)

# Find the module development requirements (requires FindPython from 3.17 or
# scikit-build-core's built-in backport)
find_package(Python REQUIRED COMPONENTS Interpreter Development.Module)
find_package(pybind11 CONFIG REQUIRED)

# root compiler options
execute_process(COMMAND root-config --cflags OUTPUT_VARIABLE ROOT_CFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
separate_arguments(ROOT_CFLAGS)

# root linker options
execute_process(COMMAND root-config --ldflags OUTPUT_VARIABLE ROOT_LDFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
separate_arguments(ROOT_LDFLAGS)

# root libs
execute_process(COMMAND root-config --libs OUTPUT_VARIABLE ROOT_LIBS OUTPUT_STRIP_TRAILING_WHITESPACE)
separate_arguments(ROOT_LIBS)

add_compile_options(${ROOT_CFLAGS} -fdiagnostics-color=always -MD -MP -O3 -Wall -march=native -pthread -m64 -ffloat-store -g)
add_link_options(
    ${ROOT_LDFLAGS}
    ${ROOT_LIBS}
    -L${LCG_BASE}/lib
    -L${LCG_BASE}/lib64
    -lLHAPDF
    -lfmt
    -lz
    -lstdc++fs
    -lcorrectionlib
    -L/cvmfs/sft.cern.ch/lcg/views/LCG_107a/x86_64-el9-gcc14-opt/lib
    -L/cvmfs/sft.cern.ch/lcg/views/LCG_107a/x86_64-el9-gcc14-opt/lib64
)

# Add a library using FindPython's tooling (pybind11 also provides a helper like this)
python_add_library(_core MODULE src/main.cpp WITH_SOABI)
target_include_directories(_core
    PRIVATE
        ${CMAKE_SOURCE_DIR}/include
        ${ROOT_INCLUDE_DIR}
        ${LCG_BASE}/include
        ${LCG_BASE}/lib/python3.11/site-packages/pybind11/include

)
target_link_libraries(_core PRIVATE pybind11::headers)

# This is passing in the version as a define just as an example
target_compile_definitions(_core PRIVATE VERSION_INFO=${PROJECT_VERSION})

# The install directory is the output (wheel) directory
install(TARGETS _core DESTINATION htozupsilon)


