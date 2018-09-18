/*
*  AYUV_READLINE_RT runtime function for VIPBLKS Read Binary File block
*
*  Copyright 1995-2007 The MathWorks, Inc.
*/
#include "vipfileread_rt.h"
#include <stdio.h>

LIBMWVISIONRT_API boolean_T MWVIP_AYUV_ReadLine(void *fptrDW,
							 uint8_T *portAddr_0,
							 uint8_T *portAddr_1,
							 uint8_T *portAddr_2,
							 uint8_T *portAddr_3,
							 int32_T   *numLoops,
							 boolean_T *eofflag, 
							 int_T rows, 
							 int_T cols)
{
	int_T j;
    FILE **fptr = (FILE **) fptrDW;
	byte_T *portAddr0 = (byte_T *)portAddr_0;
	byte_T *portAddr1 = (byte_T *)portAddr_1;
	byte_T *portAddr2 = (byte_T *)portAddr_2;
	byte_T *portAddr3 = (byte_T *)portAddr_3;

	int_T rowsj = 0;
    for (j=0; j < cols; j++) {
        fread(&portAddr3[rowsj], 1, 1, fptr[0]);
        fread(&portAddr0[rowsj], 1, 1, fptr[0]);
        fread(&portAddr1[rowsj], 1, 1, fptr[0]);
        fread(&portAddr2[rowsj], 1, 1, fptr[0]);
        if (feof(fptr[0])) {
            numLoops[0]--;
            rewind(fptr[0]);
            eofflag[0] = 1;
            return 0;
        }
        rowsj += rows;
    }
    return 1;
}

/* [EOF] ayuv_readline_rt.c */
