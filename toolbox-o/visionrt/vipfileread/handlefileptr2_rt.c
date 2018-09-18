/*
* HANDLEFILEPTR2_RT runtime function for VIPBLKS Read Binary File block
*
*  Copyright 1995-2007 The MathWorks, Inc.
*/
#include "vipfileread_rt.h"
#include <stdio.h>

LIBMWVISIONRT_API void MWVIP_handleFilePtr2(void *fptrDW,
							  int32_T   *numLoops,
							  boolean_T *eofflag)
{
    FILE **fptr = (FILE **) fptrDW;
	byte_T temp;
    if (!fread(&temp, 1, 1, fptr[0])) {
        numLoops[0]--;
        rewind(fptr[0]);
        eofflag[0] = 1;
    } else {
        fseek(fptr[0], -1L, SEEK_CUR);
    }
}

/* [EOF] handlefileptr2_rt.c */
