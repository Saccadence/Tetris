#!/usr/bin/env bash

echo "Running all tests..."

shopt -s nullglob  # so tests/*.cpp expands to nothing if no matches

# Compiler and flags
CXX=g++
CXXFLAGS="-Wall -Wextra -std=c++20"
LINK_FLAGS=(-lsfml-graphics -lsfml-window -lsfml-system)

# Collect all test sources
test_sources=(tests/*.cpp)

if ((${#test_sources[@]} == 0)); then
    echo "No .cpp tests found in ./tests"
    exit 0
fi

for test_source in "${test_sources[@]}"; do
    if [[ -f "$test_source" ]]; then
        echo "--- Running $test_source ---"

        # Strip path and .cpp → executable name
        exec_name=$(basename "$test_source" .cpp)

        # Compile
        if ! $CXX $CXXFLAGS "$test_source" -o "$exec_name" "${LINK_FLAGS[@]}"; then
            echo "--- COMPILE FAILED: $test_source ---"
            echo
            continue
        fi

        # Run
        "./$exec_name"
        status=$?

        if [[ $status -eq 0 ]]; then
            echo "--- PASSED $test_source ---"
            # Auto-remove executable on success unless KEEP_BINARIES=1
            if [[ "${KEEP_BINARIES:-0}" != "1" ]]; then
                rm -f -- "$exec_name"
            else
                echo "KEEP_BINARIES=1 → keeping '$exec_name'."
            fi
        else
            echo "--- FAILED $test_source (exit code $status) ---"
            echo "Keeping '$exec_name' for debugging."
        fi

        echo
    fi
done

echo "All tests finished."
