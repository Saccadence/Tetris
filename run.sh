#!/bin/bash

SOURCE_FILE="./main.cpp"
# Extract the executable name without the extension
EXEC_NAME=$(basename "$SOURCE_FILE" .cpp)

# Compile the C++ program
echo "Compiling $SOURCE_FILE..."
g++ "$SOURCE_FILE" -o "$EXEC_NAME"

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful. Running $EXEC_NAME..."
    ./"$EXEC_NAME"
else
    echo "Compilation failed."
fi
