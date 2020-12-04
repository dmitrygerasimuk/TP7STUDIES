#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while assembling $1"; exit 1; }
DoExitLink ()
{ echo "An error occurred while linking $1"; exit 1; }
OFS=$IFS
IFS="
"
/usr/bin/ld /usr/lib/crt1.o       -x -multiply_defined suppress -L. -o time `cat link.res` -pagezero_size 0x10000
if [ $? != 0 ]; then DoExitLink ; fi
IFS=$OFS
