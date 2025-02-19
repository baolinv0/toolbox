/*
 *  OPTICALFLOW_HS_C_RT runtime function for Optical Flow Block
 *  (Horn & Schunck method).
 *
 *  Copyright 1995-2005 The MathWorks, Inc.
 */
#include "vipopticalflow_rt.h"

LIBMWVISIONRT_API void MWVIP_OpticalFlow_HS_C( const real32_T  *inImgA,
                                        const real32_T  *inImgB,
                                        creal32_T  *outVel,
                                        real32_T  *buffCprev, /* length nRows */
                                        real32_T  *buffCnext,
                                        real32_T  *buffRprev, /* length nCols */
                                        real32_T  *buffRnext,
                                        real32_T  *gradCC,
                                        real32_T  *gradRC,
                                        real32_T  *gradRR,
                                        real32_T  *gradCT,
                                        real32_T  *gradRT,
                                        real32_T  *alpha,
                                        real32_T  *velBufCcurr,
                                        real32_T  *velBufCprev,
                                        real32_T  *velBufRcurr,
                                        real32_T  *velBufRprev,
                                        const real32_T  *lambda,
                                        boolean_T useMaxIter,
                                        boolean_T useAbsVelDiff,
                                        const int32_T *maxIter,
                                        const real32_T  *maxAllowableAbsDiffVel,
                                        int_T  inRows,
                                        int_T  inCols)
{
    const int_T inSize  = inRows*inCols;
    real32_T *outVelC    = (real32_T *)outVel; 
    real32_T *outVelR    = (outVelC + inSize);
    const int_T bytesPerInpCol = inRows * sizeof( real32_T );

    int_T i, j;

	int_T prevCol;
	const int_T endCol = (inCols-1)*inRows;

    int_T numIter;
	real32_T maxAbsVelDiff=0;

    MWVIP_SobelDerivative_HS_R( inImgA,
                                inImgB,
                                outVelC,/* tmpGradC */
                                outVelR,/* tmpGradR */
                                buffCprev,
                                buffCnext,
                                buffRprev,
                                buffRnext,
                                gradCC,
                                gradRC,
                                gradRR,
                                gradCT,
                                gradRT,
                                alpha,
                                lambda,
                                inRows,
                                inCols);

    /* set initial motion vector to zero */
    memset(outVelC, 0, sizeof(real32_T)*inSize);
    memset(outVelR, 0, sizeof(real32_T)*inSize);
    
    /* Gauss-Seidel iterative solution for Optical Flow constraint equation */
    numIter = 1;
    do
    {
        int_T ij = 0;
        int_T ijM1, ijP1, ijMinRows, ijPinRows;
        
        real32_T *velBufCcurrT, *velBufCprevT = NULL, *velBufRcurrT, *velBufRprevT = NULL;

		maxAbsVelDiff = 0;
        velBufCcurrT = velBufCcurr;
        velBufCprevT = velBufCprev;
        velBufRcurrT = velBufRcurr;
        velBufRprevT = velBufRprev;

        for( j = 0; j < inCols; j++ )
        {
  		    prevCol = (j-1)*inRows;/* it is used only when j>0 */
            for( i = 0; i < inRows; i++ )  /* scanning along column */
            {
                real32_T avgVelC, avgVelR;
				real32_T absVelDiffC, absVelDiffR;

                /* at each iteration we need to use the velocity of the previous iteration
                 * (we need velocity of 4 neighboring pixels from prev iteration)
                 * that's why we can't store the velocity at each iteration to output.
                 * we need to maintain temporary line buffers at each iteration
                 */

                /* mask for computing avg velocity (for prev iteration) (init vel=0):
                 * here (i,j) th element (in 2D) means ==> (ij) th element (in 1D)
                 *
                 *
                 *                                1
                 *                              (i-1,j)
                 *                              = ij-1
                 *
                 *       
                 *                   1            0            1
                 *             (i,j-1)          (i,j)        (i,j+1)
                 *             =ij-inRows       = ij         =ij+inRows
                 *
                 *          
                 *                                1
                 *                             (i+1,j)
                 *                             = ij+1
                 */
                ijM1 = (i==0)          ? ij : ij-1;
                ijP1 = (i==(inRows-1)) ? ij : ij+1;

                ijMinRows = (j==0)          ? ij : ij-inRows;
                ijPinRows = (j==(inCols-1)) ? ij : ij+inRows;
 

                avgVelC = (outVelC[ijM1]      +
                           outVelC[ijP1]      +
						   outVelC[ijMinRows] +
                           outVelC[ijPinRows]) / 4;
                avgVelR = (outVelR[ijM1]      +
                           outVelR[ijP1]      +
                           outVelR[ijMinRows] +
                           outVelR[ijPinRows]) / 4;

                velBufCcurrT[i] = avgVelC -
                    (gradCC[ij] * avgVelC +
                     gradRC[ij] * avgVelR + gradCT[ij]) * alpha[ij];

                velBufRcurrT[i] = avgVelR -
                    (gradRC[ij] * avgVelC +
                     gradRR[ij] * avgVelR + gradRT[ij]) * alpha[ij];

                /* compute max(vel diff along row, vel diff along col) for this frame */
                if(useAbsVelDiff)
                {
                    
					absVelDiffC   = (real32_T)fabsf(outVelC[ij] - velBufCcurrT[i]);
                    absVelDiffR   = (real32_T)fabsf(outVelR[ij] - velBufRcurrT[i]);
                    maxAbsVelDiff = MAX( MAX(absVelDiffC,absVelDiffR), maxAbsVelDiff );
                }
                ij++;
            }

            /* 
			 * since we are done scanning this column, we save velocity buffer content 
			 * of the previous column to output. 
			 */
            if( j > 0 )/* skip first column */
            {
                memcpy( &outVelC[prevCol], velBufCprevT, bytesPerInpCol);
                memcpy( &outVelR[prevCol], velBufRprevT, bytesPerInpCol);
            }

            /* switch the next and prev velocity buffers */
            {
                real32_T *tmpBuff;
                /* column velocity buffers */
                tmpBuff      = velBufCcurrT;
                velBufCcurrT = velBufCprevT;
                velBufCprevT = tmpBuff;
                /* row velocity buffers */
                tmpBuff      = velBufRcurrT;
                velBufRcurrT = velBufRprevT;
                velBufRprevT = tmpBuff;

            }
        }

        /* copy the last column of velocity (j=inCols) to output */ 
        memcpy( &outVelC[endCol], velBufCprevT, bytesPerInpCol);
        memcpy( &outVelR[endCol], velBufRprevT, bytesPerInpCol);
    }
	while (!(  ( useMaxIter && (numIter++ == maxIter[0]) )  
		  ||   ( useAbsVelDiff && (maxAbsVelDiff < maxAllowableAbsDiffVel[0]) ))); 
    
    /* copy velocity to output port in complex form */
    memcpy(gradCC, outVelC, inSize*sizeof(real32_T));
    memcpy(gradRR, outVelR, inSize*sizeof(real32_T));
    for( i = 0; i < inSize; i++ )
    {
        outVel[i].re = gradCC[i];
        outVel[i].im = gradRR[i];
    }
}

/* [EOF] opticalflow_hs_c_rt.c */
