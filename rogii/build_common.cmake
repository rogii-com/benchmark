if(NOT DEFINED ROOT OR NOT DEFINED ARCH)
    message(
        FATAL_ERROR
        "Assert: ROOT = ${ROOT}; ARCH = ${ARCH}"
    )
endif()

set(
    BUILD
    0
)

if(DEFINED ENV{BUILD_NUMBER})
    set(
        BUILD
        $ENV{BUILD_NUMBER}
    )
endif()

set(
    TAG
    ""
)

if(DEFINED ENV{TAG})
    set(
        TAG
        "$ENV{TAG}"
    )
else()
    find_package(
        Git
    )

    if(Git_FOUND)
        execute_process(
            COMMAND
                ${GIT_EXECUTABLE} rev-parse --short HEAD
            OUTPUT_VARIABLE
                TAG
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        set(
            TAG
            "_${TAG}"
        )
    endif()
endif()

include(
    "${CMAKE_CURRENT_LIST_DIR}/version.cmake"
)

set(
    BUILD_PATH
    "${CMAKE_CURRENT_LIST_DIR}/../build"
)

set(
    PACKAGE_NAME
    "${ROGII_PKG_NAME}-${ROGII_PKG_VERSION}-${ARCH}-${BUILD}${TAG}"
)

set(
    CMAKE_INSTALL_PREFIX
    ${ROOT}/${PACKAGE_NAME}
)

file(
    MAKE_DIRECTORY
    "${BUILD_PATH}"
)
 
execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -G Ninja -DBENCHMARK_DOWNLOAD_DEPENDENCIES=OFF -DBENCHMARK_ENABLE_TESTING=OFF -DBENCHMARK_INSTALL_DOCS=OFF -DCMAKE_DEBUG_POSTFIX=d -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DARCH=${ARCH} ..
    WORKING_DIRECTORY
        "${BUILD_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" --build . --target install
    WORKING_DIRECTORY
        "${BUILD_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -G Ninja -DBENCHMARK_DOWNLOAD_DEPENDENCIES=OFF -DBENCHMARK_ENABLE_TESTING=OFF -DBENCHMARK_INSTALL_DOCS=OFF -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -DARCH=${ARCH} ..
    WORKING_DIRECTORY
        "${BUILD_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" --build . --target install
    WORKING_DIRECTORY
        "${BUILD_PATH}"
)

file(
    COPY
        "${CMAKE_CURRENT_LIST_DIR}/package.cmake"
    DESTINATION
        "${CMAKE_INSTALL_PREFIX}"
)

file(
    REMOVE_RECURSE
    "${BUILD_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -E tar cf "${PACKAGE_NAME}.7z" --format=7zip -- "${PACKAGE_NAME}"
    WORKING_DIRECTORY
        "${ROOT}"
)
