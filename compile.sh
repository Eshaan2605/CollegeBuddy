#!/bin/bash
# compile.sh - Compiles and runs CollegeBuddy CCRM
set -e
SRC_DIR="src"
OUT_DIR="out"
MAIN="edu.ccrm.cli.Main"

echo "[1/3] Cleaning output directory..."
rm -rf ""
mkdir -p ""

echo "[2/3] Compiling Java sources..."
find "" -name "*.java" | xargs javac -d ""

echo "[3/3] Running application..."
java -cp "" ""
