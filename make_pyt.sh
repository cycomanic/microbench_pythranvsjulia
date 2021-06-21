#!/bin/bash

pythran -O3 -ffast-math -mfpmath=sse -march=native -funroll-loops -fwhole-program -fopenmp -std=c++14 -fno-math-errno -w -fvisibility=hidden -fno-wrapv -DUSE_XSIMD -DNDEBUG -finline-limit=100000 eval_exp.py
