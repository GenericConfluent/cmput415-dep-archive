#!/usr/bin/env bash

UNCOMPRESSED="${TARGEN_DIR:-lib415}"

# Clean old contents if they exist (the dir itself may be a mount point)
mkdir -p "${UNCOMPRESSED}"
find "${UNCOMPRESSED}" -mindepth 1 -delete

# Fetch the relevant directories we need
cp -r "${ANTLR_INS}" "${UNCOMPRESSED}/antlr4-install"

export LLVM_TARGET="${UNCOMPRESSED}/llvm-install"

cp -r "${MLIR_INS}" "${LLVM_TARGET}"

# Sourceable environment setup
cat > "${UNCOMPRESSED}/env.sh" <<'ENV'
LIB415_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ANTLR_INS="${LIB415_DIR}/antlr4-install"
export MLIR_INS="${LIB415_DIR}/llvm-install"
export ANTLR_JAR="${ANTLR_INS}/bin/antlr-4.13.0-complete.jar"
export MLIR_DIR="${MLIR_INS}/lib/cmake/mlir/"
export PATH="${MLIR_INS}/bin:${PATH}"
export CLASSPATH="${ANTLR_JAR}${CLASSPATH:+:${CLASSPATH}}"
ENV
