if(NOT TARGET OpenCRGCompilerSettings)
    add_library(OpenCRGCompilerSettings INTERFACE)

    # Set C11 Standard for target
    target_compile_features(OpenCRGCompilerSettings INTERFACE c_std_11)

    set_target_properties(OpenCRGCompilerSettings PROPERTIES
        C_STANDARD_REQUIRED ON
        C_EXTENSIONS OFF
    )

    # Set warning flags
    target_compile_options(OpenCRGCompilerSettings INTERFACE
        $<$<C_COMPILER_ID:MSVC>:/W4 /wd4996>
        $<$<NOT:$<C_COMPILER_ID:MSVC>>:-Wall -Wextra>
    )

    # Link to libm if unix-like
    if(UNIX AND NOT APPLE)
        target_link_libraries(OpenCRGCompilerSettings INTERFACE m)
    endif()
endif()