#!/bin/bash
LOG="./debug.log"
BUILD="../edk2-staging/Build/RiscVVirtQemu/DEBUG_GCC5/RISCV64/"
PEINFO="peinfo/peinfo"

cat ${LOG} | grep Loading | grep -i DxeCore | while read LINE; do
    BASE="`echo ${LINE} | cut -d " " -f4`"
    NAME=DxeCore.efi
    ADDR="`${PEINFO} ${BUILD}/${NAME} | grep -A 5 text | grep VirtualAddress | cut -d " " -f2`"
    TEXT="`python3 -c "print(hex(${BASE} + ${ADDR}))"`"
    SYMS="`echo ${NAME} | sed -e "s/\.efi/\.debug/g"`"
    echo "add-symbol-file ${BUILD}/${SYMS} ${TEXT}"
done

cat ${LOG} | grep Loading | grep -i efi | while read LINE; do
    BASE="`echo ${LINE} | cut -d " " -f4`"
    NAME="`echo ${LINE} | cut -d " " -f6 | tr -d "[:cntrl:]"`"
    ADDR="`${PEINFO} ${BUILD}/${NAME} | grep -A 5 text | grep VirtualAddress | cut -d " " -f2`"
    TEXT="`python3 -c "print(hex(${BASE} + ${ADDR}))"`"
    SYMS="`echo ${NAME} | sed -e "s/\.efi/\.debug/g"`"
    echo "add-symbol-file ${BUILD}/${SYMS} ${TEXT}"
done
