VBCC=vbcc_src
VBCC_SOURCE=vbcc0_9fP1.tar.gz
VASM_SOURCE=vasm.tar.gz
VLINK_SOURCE=vlink.tar.gz

rm -r bin

tar -xf ${VBCC}/${VBCC_SOURCE}
tar -xf ${VBCC}/${VASM_SOURCE}
tar -xf ${VBCC}/${VLINK_SOURCE}

cd vbcc && mkdir bin && TARGET=m68k make && cd ..
cd vasm && CPU=m68k SYNTAX=mot make && cd ..
cd vlink && make && cd ..

mkdir bin
cp vbcc/bin/dtgen vbcc/bin/vbccm68k vbcc/bin/vc vbcc/bin/vprof bin/
cp vasm/vasmm68k_mot vasm/vobjdump bin/
cp vlink/vlink bin/

rm -r vbcc
rm -r vasm
rm -r vlink