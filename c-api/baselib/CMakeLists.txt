cmake_minimum_required(VERSION 3.19)

project(OpenCRG VERSION 2.0.1 LANGUAGES C)

set(OPENCRG_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../cmake")
include(${OPENCRG_MODULE_PATH}/OpenCRGCompilerSettings.cmake)
include(${OPENCRG_MODULE_PATH}/OpenCRGCommonIncludes.cmake)

if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
    if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE Release CACHE STRING "Build Type")
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo MinSizeRel)
    endif()
endif()

# Embed debug information when using MSVC according to build type
if (MSVC)
    if(CMAKE_VERSION VERSION_LESS "3.25")
        message(WARNING "Debug information will not be embedded into ${PROJECT_NAME} library. CMake version 3.25 or higher required. Consider upgrading.")
    endif()
    set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<$<CONFIG:Debug,RelWithDebInfo>:Embedded>")
endif()

# Source files
set(OPENCRG_SOURCES
    src/crgContactPoint.c
    src/crgEvalenh.c
    src/crgEvalpk.c
    src/crgEvaluv2xy.c
    src/crgEvalxy2uv.c
    src/crgEvalz.c
    src/crgLoader.c
    src/crgMgr.c
    src/crgMsg.c
    src/crgOptionMgmt.c
    src/crgPortability.c
    src/crgStatistics.c
)

# Create static library
add_library(${PROJECT_NAME} STATIC ${OPENCRG_SOURCES})

# Copy target to lib and make copy with appended project version
set(OpenCRG_LIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}/lib")

add_custom_command(
    TARGET ${PROJECT_NAME}
    POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E copy "\$<TARGET_FILE:${PROJECT_NAME}>"
	    "${OpenCRG_LIB_DIR}/\$<TARGET_FILE_PREFIX:${PROJECT_NAME}>\$<TARGET_FILE_BASE_NAME:${PROJECT_NAME}>\$<TARGET_FILE_SUFFIX:${PROJECT_NAME}>"
    COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:${PROJECT_NAME}>"
	    "${OpenCRG_LIB_DIR}/$<TARGET_FILE_PREFIX:${PROJECT_NAME}>$<TARGET_FILE_BASE_NAME:${PROJECT_NAME}>.${PROJECT_VERSION}\$<TARGET_FILE_SUFFIX:${PROJECT_NAME}>"
)

# Link to compiler options and includes
target_link_libraries(${PROJECT_NAME}
    PRIVATE OpenCRGCompilerSettings OpenCRGCommonIncludes
)