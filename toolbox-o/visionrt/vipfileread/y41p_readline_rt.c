/*
*  Y41P_READLINE_RT runtime function for VIPBLKS Read Binary File block
*
*  Copyright 1995-2007 The MathWorks, Inc.
*/
#include "vipfileread_rt.h"
#include <stdio.h>

LIBMWVISIONRT_API boolean_T MWVIP_Y41P_ReadLine(void *fptrDW,
							 uint8_T *portAddr_0,
							 uint8_T *portAddr_1,
							 uint8_T *portAddr_2,
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

	int_T rowsj2 = 0;
	int_T rowsj8 = 0;
	int_T rows2 = 2*rows;
	int_T rows3 = 3*rows;
	int_T rows4 = 4*rows;
	int_T rows5 = 5*rows;
	int_T rows6 = 6*rows;
	int_T rows7 = 7*rows;
	int_T rows8 = 8*rows;

    for (j=0; j < cols; j++) {
        fread(&portAddr1[rowsj2], 1, 1, fptr[0]);
        fread(&portAddr0[rowsj8], 1, 1, fptr[0]);
        fread(&portAddr2[rowsj2], 1, 1, fptr[0]);
        fread(&portAddr0[rowsj8]+rows, 1, 1, fptr[0]);
        fread(&portAddr1[rowsj2]+rows, 1, 1, fptr[0]);
        fread(&portAddr0[rowsj8+rows2], 1, 1, fptr[0]);
        fread(&portAddr2[rowsj2+rows], 1, 1, fptr[0]);
        fread(&portAddr0[rowsj8+rows3], 1, 1, fptr[0]);
        fread(&portAddr0[rowsj8+rows4], 1, 1, fptr[0]);
        fread(&portAddr0[rowsj8+rows5], 1, 1, fptr[0]);
        fread(&portAddr0[rowsj8+rows6], 1, 1, fptr[0]);
        fread(&portAddr0[rowsj8+rows7], 1, 1, fptr[0]);
        if (feof(fptr[0])) {
            numLoops[0]--;
            rewind(fptr[0]);
            eofflag[0] = 1;
            return 0;
        }
		rowsj2 += rows2;
		rowsj8 += rows8;
    }
    return 1;
}

/* [EOF] y41p_readline_rt.c */
