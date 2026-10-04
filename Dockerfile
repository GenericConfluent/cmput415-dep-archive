FROM ubuntu:24.04

# Mimic Github Runner Structure
ENV WORK_DIR="/home/runner/work"
RUN groupadd -g 10001 runner && \
    useradd -m -u 10001 -g runner runner && \
    mkdir "${WORK_DIR}"

WORKDIR "${WORK_DIR}"

# Install build dependencies
RUN apt update && \
    apt install -y build-essential pkg-config uuid-dev openjdk-17-jre git cmake ninja-build python3-pip python3-dev

# Install Antlr4
ENV ANTLR_INS="${WORK_DIR}/antlr4-install"

# cp LICENSE.txt? Right. Of course. I shoud have known.
RUN mkdir -p "${ANTLR_INS}" && \
    git clone https://github.com/antlr/antlr4.git && \
    cd antlr4 && \
    git checkout 4.13.2 && \
    cp LICENSE.txt runtime/Cpp/ && \
    cmake -G Ninja -S ./runtime/Cpp/ \
        -DCMAKE_BUILD_TYPE=RELEASE \
        -DCMAKE_INSTALL_PREFIX="${ANTLR_INS}" \
        -B build/ && \
    cd build/ && \
    ninja install -j$(nproc) && \
    rm -r "${WORK_DIR}/antlr4"

# Install MLIR
# WARN: DO NOT MERGE LAYERS. ITS BRUTAL.
ENV MLIR_INS="${WORK_DIR}/llvm-install"
ENV MLIR_DIR="${MLIR_INS}/lib/cmake/mlir/"
ENV PATH="${MLIR_INS}/bin:$PATH" 

# Fetch LLVM
RUN git clone https://github.com/llvm/llvm-project.git && \
    cd llvm-project && \
    git checkout llvmorg-23.1.1 && \
    cmake -G Ninja llvm \
        -DLLVM_ENABLE_PROJECTS=mlir \
        -DLLVM_BUILD_EXAMPLES=ON \
        -DLLVM_TARGETS_TO_BUILD="Native" \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_ENABLE_ASSERTIONS=ON \
        -DCMAKE_INSTALL_PREFIX="${MLIR_INS}" \
        -B build/

# Perform the Build
RUN cd llvm-project/build && \
    ninja install -j$(nproc) && \
    rm -r "${WORK_DIR}/llvm-project"

# Remove Bloat to Shrink Image Size
RUN rm -r "${MLIR_INS}/examples" && \
    cd "${MLIR_INS}/bin" && \
    find . ! -name 'llc' \
        ! -name 'lli' \
        ! -name 'clang' \
        -type f -exec rm -f {} +

# Install Dragon Runner
RUN git clone https://github.com/cmput415/Dragon-Runner.git && \
    cd Dragon-Runner && \
    pip install --break-system-packages . && \
    cd ~ && \
    rm -r "${WORK_DIR}/Dragon-Runner"

