cmake_minimum_required(VERSION 3.19)

project(crgGlobalOrigin LANGUAGES C)

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/OpenCRGBuildDemoExecutable.cmake)
opencrg_build_demo_executable (${PROJECT_NAME})