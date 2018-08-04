VBCC_SOURCE=http://server.owl.de/~frank/tags/vbcc0_9fP1.tar.gz
VASM_SOURCE=http://sun.hasenbraten.de/vasm/release/vasm.tar.gz
VLINK_SOURCE=http://sun.hasenbraten.de/vlink/release/vlink.tar.gz

curl -O $VBCC_SOURCE
curl -O $VASM_SOURCE
curl -O $VLINK_SOURCE

tar -xf ${VBCC_SOURCE##*/}
tar -xf ${VASM_SOURCE##*/}
tar -xf ${VLINK_SOURCE##*/}

cd vbcc && mkdir bin && TARGET=m68k make && cd ..
cd vasm && CPU=m68k SYNTAX=mot make && cd ..
cd vlink && make && cd ..

mkdir bin
cp vbcc/bin/dtgen vbcc/bin/vbccm68k vbcc/bin/vc vbcc/bin/vprof bin/
cp vasm/vasmm68k_mot vasm/vobjdump bin/
cp vlink/vlink bin/

rm ${VBCC_SOURCE##*/}
rm ${VASM_SOURCE##*/}
rm ${VLINK_SOURCE##*/}

rm -r vbcc
rm -r vasm
rm -r vlink
