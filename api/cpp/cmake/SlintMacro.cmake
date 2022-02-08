# Copyright © SixtyFPS GmbH <info@sixtyfps.io>
# SPDX-License-Identifier: (GPL-3.0-only OR LicenseRef-SixtyFPS-commercial)

function(SLINT_TARGET_SOURCES target)
    foreach (it IN ITEMS ${ARGN})
        get_filename_component(_SLINT_BASE_NAME ${it} NAME_WE)
        get_filename_component(_SLINT_ABSOLUTE ${it} REALPATH BASE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

        if(CMAKE_GENERATOR STREQUAL "Ninja")
            # this code is inspired from the llvm source
            # https://github.com/llvm/llvm-project/blob/a00290ed10a6b4e9f6e9be44ceec367562f270c6/llvm/cmake/modules/TableGen.cmake#L13

            file(RELATIVE_PATH _SLINT_BASE_NAME_REL ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}/${_SLINT_BASE_NAME})

            add_custom_command(
                OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${_SLINT_BASE_NAME}.h
                COMMAND Slint::slint-compiler ${_SLINT_ABSOLUTE}
                    -o ${_SLINT_BASE_NAME_REL}.h  --depfile ${_SLINT_BASE_NAME_REL}.d
                    --style ${SLINT_STYLE}
                DEPENDS Slint::slint-compiler ${_SLINT_ABSOLUTE}
                COMMENT "Generating ${_SLINT_BASE_NAME}.h"
                DEPFILE ${CMAKE_CURRENT_BINARY_DIR}/${_SLINT_BASE_NAME}.d
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
            )
        else(CMAKE_GENERATOR STREQUAL "Ninja")
            get_filename_component(_SLINT_DIR ${_SLINT_ABSOLUTE} DIRECTORY )
            file(GLOB ALL_SLINTS "${_SLINT_DIR}/*.slint")
            add_custom_command(
                OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${_SLINT_BASE_NAME}.h
                COMMAND Slint::slint-compiler ${_SLINT_ABSOLUTE}
                    -o ${CMAKE_CURRENT_BINARY_DIR}/${_SLINT_BASE_NAME}.h
                    --style ${SLINT_STYLE}
                DEPENDS Slint::slint-compiler ${_SLINT_ABSOLUTE} ${ALL_SLINTS}
                COMMENT "Generating ${_SLINT_BASE_NAME}.h"
            )
        endif(CMAKE_GENERATOR STREQUAL "Ninja")

        target_sources(${target} PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/${_SLINT_BASE_NAME}.h)
    endforeach()
    target_include_directories(${target} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
endfunction()