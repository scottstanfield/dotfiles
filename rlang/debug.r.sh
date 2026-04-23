#!/bin/bash
echo "=== R version ===" && R --version 2>&1 | head -3
echo "=== which R/Rscript ===" && which -a R && which -a Rscript
echo "=== R linked libs ===" && otool -L $(which R) 2>&1
echo "=== all libomp dylibs ===" && find /opt/homebrew /usr/local /Library -name "libomp*.dylib" 2>/dev/null
echo "=== libomp symlinks ===" && find /opt/homebrew/opt/llvm/lib -name "libomp*.dylib" 2>/dev/null || echo "no llvm/lib symlinks"
echo "=== brew llvm/libomp installed ===" && brew list | grep -E "llvm|libomp|gcc"
echo "=== brew uses libomp ===" && brew uses --installed libomp 2>&1
echo "=== brew uses llvm ===" && brew uses --installed llvm 2>&1
echo "=== rlang.so linked libs ===" && find /opt/homebrew ~/.R /Library -name "rlang.so" 2>/dev/null | xargs -I{} otool -L {} 2>/dev/null
echo "=== R library paths ===" && Rscript -e '.libPaths()' 2>&1
echo "=== Renviron ===" && cat ~/.Renviron 2>/dev/null || echo "no Renviron"
echo "=== conda envs ===" && conda env list 2>/dev/null || echo "conda not active"
echo "=== active conda env ===" && echo ${CONDA_DEFAULT_ENV:-none}
echo "=== DYLD vars ===" && env | grep -E "DYLD|OMP|KMP|LD_"
echo "=== Makevars ===" && cat ~/.R/Makevars 2>/dev/null || echo "no Makevars"
echo "=== R config openmp ===" && R CMD config CFLAGS 2>&1 && R CMD config LDFLAGS 2>&1
echo "=== pkg-config openssl ===" && pkg-config --libs --cflags openssl 2>&1
echo "=== pkg-config libxml2 ===" && pkg-config --libs --cflags libxml2 2>&1
echo "=== pkg-config libcurl ===" && pkg-config --libs --cflags libcurl 2>&1
echo "=== keg-only brew links ===" && for p in curl libxml2 openssl@3 gettext libomp; do echo "$p -> $(readlink -f /opt/homebrew/opt/$p 2>/dev/null || echo missing)"; done
