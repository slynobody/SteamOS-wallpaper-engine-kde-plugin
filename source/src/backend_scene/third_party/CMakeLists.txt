set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)

add_subdirectory(glad)

add_library (eigen INTERFACE)
add_library (Eigen3::Eigen ALIAS eigen)
target_include_directories(eigen INTERFACE Eigen)

add_subdirectory(nlohmann EXCLUDE_FROM_ALL)

set(SPIRV_REFLECT_STATIC_LIB ON)
set(SPIRV_REFLECT_EXECUTABLE OFF)
set(SPIRV_REFLECT_BUILD_TESTS OFF)
set(SPIRV_REFLECT_EXAMPLES OFF)
add_subdirectory(SPIRV-Reflect EXCLUDE_FROM_ALL)

set(SKIP_GLSLANG_INSTALL ON)
set(ENABLE_GLSLANG_BINARIES OFF)
set(ENABLE_SPVREMAPPER OFF)
set(ENABLE_GLSLANG_JS OFF)
set(ENABLE_HLSL OFF)
set(ENABLE_OPT OFF)
add_subdirectory(glslang EXCLUDE_FROM_ALL)
