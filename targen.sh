#!/usr/bin/env bash

export UNCOMPRESSED="c415darch"

# Clean old if it exists
rm -r "${UNCOMPRESSED}"
mkdir -p "${UNCOMPRESSED}"

# Fetch the relevant directories we need
cp -r "${ANTLR_INS}" "${UNCOMPRESSED}/antlr4-install"

# FIXME: We may need more than just lib and include.
export LLVM_TARGET="${UNCOMPRESSED}/llvm-build"
mkdir "${LLVM_TARGET}"
cp -r "${MLIR_INS}/lib" "${LLVM_TARGET}"
cp -r "${MLIR_INS}/include" "${LLVM_TARGET}"

tar -czvf c415arch.tar.gz "${UNCOMPRESSED}"

