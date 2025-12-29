cmake_minimum_required(VERSION 3.16)

# ------------------------------------------------------------
# Project metadata
# ------------------------------------------------------------
project(Tetris
    VERSION 0.1
    LANGUAGES CXX
)

# Require C++20
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ------------------------------------------------------------
# Locate SFML (from libsfml-dev)
# ------------------------------------------------------------
find_package(SFML 2.5 COMPONENTS graphics window system REQUIRED)

# ------------------------------------------------------------
# Collect ALL .cpp files under src/ automatically
# ------------------------------------------------------------
file(GLOB_RECURSE TETRIS_SOURCES CONFIGURE_DEPENDS
    "src/*.cpp"
)

# ------------------------------------------------------------
# Main game executable
# ------------------------------------------------------------
add_executable(TetrisGame
    ${TETRIS_SOURCES}
)

# Tell the compiler where to find your header files
target_include_directories(TetrisGame
    PRIVATE
        ${CMAKE_SOURCE_DIR}/include
)

# Link SFML libraries to the game
target_link_libraries(TetrisGame
    PRIVATE
        sfml-graphics
        sfml-window
        sfml-system
)

# ------------------------------------------------------------
# Test Suite
#   - Logic tests   | Automated
#   - Visual tests  | Manual (disabled by default)
# ------------------------------------------------------------
enable_testing()

# Grab ALL test .cpp files under tests/
file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS
    "tests/*.cpp"
)

foreach(test_src ${TEST_SOURCES})
    # Get file name without extension, e.g. tests/visual/sfml.cpp -> sfml
    get_filename_component(test_name ${test_src} NAME_WE)

    # Make an executable per test file
    add_executable(${test_name}
        ${test_src}
    )

    target_include_directories(${test_name}
        PRIVATE
            ${CMAKE_SOURCE_DIR}/include
    )

    target_link_libraries(${test_name}
        PRIVATE
            sfml-graphics
            sfml-window
            sfml-system
    )

    # Register with CTest
    add_test(NAME ${test_name} COMMAND ${test_name})

    # If this test lives under tests/visual/, mark it as disabled (manual only)
    if(test_src MATCHES "/tests/visual/")
        set_tests_properties(${test_name} PROPERTIES
            DISABLED TRUE
            LABELS "visual"
        )
    else()
        # Non-visual tests are logic tests
        set_tests_properties(${test_name} PROPERTIES
            LABELS "logic"
        )
    endif()
endforeach()
