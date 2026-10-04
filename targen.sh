#!/usr/bin/env bash

UNCOMPRESSED="${TARGEN_DIR:-lib415}"

# Clean old contents if they exist (the dir itself may be a mount point)
mkdir -p "${UNCOMPRESSED}"
find "${UNCOMPRESSED}" -mindepth 1 -delete

# Fetch the relevant directories we need
cp -r "${ANTLR_INS}" "${UNCOMPRESSED}/antlr4-install"

export LLVM_TARGET="${UNCOMPRESSED}/llvm-install"

cp -r "${MLIR_INS}" "${LLVM_TARGET}"

