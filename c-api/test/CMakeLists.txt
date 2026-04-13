cmake_minimum_required(VERSION 3.19)

project(OpenCRGTest LANGUAGES C)

if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
    if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE Release CACHE STRING "Build Type")
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo MinSizeRel)
    endif()
endif()

add_subdirectory(Dump)
add_subdirectory(MemTest)
add_subdirectory(MultiCp)
add_subdirectory(MultiRead)
add_subdirectory(PerfTest)
add_subdirectory(Scan)
add_subdirectory(Verify)
