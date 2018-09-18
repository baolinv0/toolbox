/*
*  YVYU_WRITELINE_RT runtime function for VIPBLKS Write Binary File block
*
*  Copyright 1995-2007 The MathWorks, Inc.
*/
#include "vipfilewrite_rt.h"
#include <stdio.h>

LIBMWVISIONRT_API void MWVIP_YVYU_WriteLine(void *fptrDW,
							 const byte_T *portAddr0,
							 const byte_T *portAddr1,
							 const byte_T *portAddr2,
							 int_T rows, 
							 int_T cols)
{
    int_T j;
    FILE **fptr = (FILE **) fptrDW;

	int_T rowsj = 0;
	int_T rowsj2 = 0;
	int_T rows2 = 2*rows;
    for (j=0; j < cols; j++) {
        fwrite(&portAddr0[rowsj2], 1, 1, fptr[0]);
        fwrite(&portAddr2[rowsj], 1, 1, fptr[0]);
        fwrite(&portAddr0[rowsj2+rows], 1, 1, fptr[0]);
        fwrite(&portAddr1[rowsj], 1, 1, fptr[0]);
		rowsj  += rows;
		rowsj2 += rows2;
    }
}

/* [EOF] yvyu_writeline_rt.c */
