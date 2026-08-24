cmake_minimum_required(VERSION 3.19)

project(OpenCRGDemo LANGUAGES C)

if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
    if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE Release CACHE STRING "Build Type")
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo MinSizeRel)
    endif()
endif()

add_subdirectory(Curvature)
add_subdirectory(EvalOptions)
add_subdirectory(EvalXYnUV)
add_subdirectory(EvalZ)
add_subdirectory(GlobalOrigin)
add_subdirectory(Reader)
add_subdirectory(Simple)