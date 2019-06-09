include_guard(DIRECTORY)

include(CMakeParseArguments)
include(CMakePrintHelpers)

set(CMAKE_SYSTEM_NAME Arduino)
set(CMAKE_C_COMPILER avr-gcc)
set(CMAKE_CXX_COMPILER avr-g++)

if (EXISTS ${CMAKE_SOURCE_DIR}/cmake/Platform/Arduino.cmake)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_LIST_DIR})
else()
    message(WARING "Platform/Arduino.cmake was not found. The toolchain might not work properly")
endif()

# Set this value if you explicitely want to specify the arduino SDK Paths
# Or if the Toolchain can't find the Arduino SDK Paths
#set(ARDUINO_SDK_PATH "" CACHE STRING "Path to the Arduino SDK")

if (UNIX)
    include(Platform/UnixPaths)
    if (APPLE)
        list(APPEND CMAKE_SYSTEM_PREFIX_PATH ~/Applications /Applications /Developer/Application /sw /opt/local)
    endif()
elseif(WIN32)
    include(Platform/WindowsPaths)
endif()

if (NOT ARDUINO_SDK)
    if (UNIX)
        file(GLOB SDK_PATH_HINTS /usr/share/arduino* /opt/local/arduino* /opt/arduino* /usr/local/share/arduino* /home/hp/Program/arduino*)
    elseif(WIN32)
        file(SDK_PATH_HINTS "C:\\Program Files\\Arduino C:\\Program Files\\Arduino")
    endif()

    list(SORT SDK_PATH_HINTS)
    list(REVERSE SDK_PATH_HINTS)
endif()

find_path(ARDUINO_SDK_PATH
        NAME lib/version.txt
        PATH_SUFFIXES share/arduino Arduino.app/Contents/Resources/Java ${ARDUINO_PATHS}
        HINTS ${SDK_PATH_HINTS}
        DOC "Arduino SDK path"
        )

function(append_path PATH)
    if (EXISTS ${PATH})
        list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${PATH}")
    else()
        message(WARNING "${PATH} doesn't exist.")
    endif()
endfunction()

if (ARDUINO_SDK_PATH)
    message(STATUS "Arduino SDK found!")
    append_path("${ARDUINO_SDK_PATH}/hardware/tools/avr")
else()
    message(FATAL_ERROR "The Arduino SDK Path could not be found! Set the 'ARDUINO_SDK_PATH' at line 18")
endif()