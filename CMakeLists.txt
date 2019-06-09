# The next line might not always work. In case the cmake toolchain file is not
# included, in spite of the next line, add
# -DCMAKE_TOOLCHAIN_FILE=cmake/arduinoToolchain.cmake
# to the command line/ Cmake options
# (This issue occured to me, running this code on CLion 2019)
set(CMAKE_TOOLCHAIN_FILE cmake/arduinoToolchain.cmake)

cmake_minimum_required(VERSION 3.11)

if (${CMAKE_VERSION} VERSION_GREATER 3.11)
    cmake_policy(VERSION 3.11)
endif()

project(ArduinoExampleProject C CXX ASM)

add_executable(${PROJECT_NAME} examples/blink/blink.cpp)

include_directories(${PROJECT_NAME} ${ARDUINO_SDK_PATH}/hardware/arduino/avr/cores/arduino)