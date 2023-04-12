if(NOT TARGET benchmark::benchmark)

    add_library(
        benchmark::benchmark
        STATIC
        IMPORTED
    )

    set_target_properties(
        benchmark::benchmark
        PROPERTIES
        INTERFACE_COMPILE_DEFINITIONS
            BENCHMARK_STATIC_DEFINE
        INTERFACE_INCLUDE_DIRECTORIES
            "${CMAKE_CURRENT_LIST_DIR}/include"
    )

    if(MSVC)
        set_target_properties(
            benchmark::benchmark
            PROPERTIES
            IMPORTED_LOCATION
                "${CMAKE_CURRENT_LIST_DIR}/lib/benchmark.lib"
            IMPORTED_LOCATION_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/lib/benchmarkd.lib"
        )
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set_target_properties(
            benchmark::benchmark
            PROPERTIES
            IMPORTED_LOCATION
                "${CMAKE_CURRENT_LIST_DIR}/lib/libbenchmark.a"
            IMPORTED_LOCATION_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/lib/libbenchmarkd.a"
        )
    endif()

endif()

if(NOT TARGET benchmark::benchmark_main)

    add_library(
        benchmark::benchmark_main
        STATIC
        IMPORTED
    )

    set_target_properties(
        benchmark::benchmark_main
        PROPERTIES
        INTERFACE_LINK_LIBRARIES
            benchmark::benchmark
    )

    if(MSVC)
        set_target_properties(
            benchmark::benchmark_main
            PROPERTIES
            IMPORTED_LOCATION
                "${CMAKE_CURRENT_LIST_DIR}/lib/benchmark_main.lib"
            IMPORTED_LOCATION_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/lib/benchmark_maind.lib"
        )
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set_target_properties(
            benchmark::benchmark_main
            PROPERTIES
            IMPORTED_LOCATION
                "${CMAKE_CURRENT_LIST_DIR}/lib/benchmark_main.a"
            IMPORTED_LOCATION_DEBUG
                "${CMAKE_CURRENT_LIST_DIR}/lib/benchmark_maind.a"
        )
    endif()

endif()
