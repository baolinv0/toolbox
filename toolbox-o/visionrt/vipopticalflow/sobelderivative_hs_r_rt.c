/*
 *  SOBELDERIVATIVE_HS_R_RT runtime function for Optical Flow Block
 *  It computes derivative of input image using Sobel convolution mask.
 *
 *  Copyright 1995-2008 The MathWorks, Inc.
 */
#include "vipopticalflow_rt.h"  

LIBMWVISIONRT_API void MWVIP_SobelDerivative_HS_R( const real32_T  *inImgA,
                                            const real32_T  *inImgB,
                                                real32_T  *tmpGradC,
                                                real32_T  *tmpGradR,
                                                real32_T  *buffCprev,/* nRows */
                                                real32_T  *buffCnext,
                                                real32_T  *buffRprev,/* nCols */
                                                real32_T  *buffRnext,
                                                real32_T  *gradCC,
                                                real32_T  *gradRC,
                                                real32_T  *gradRR,
                                                real32_T  *gradCT,
                                                real32_T  *gradRT,
                                                real32_T  *alpha,
                                                const real32_T  *lambda,
                                                int_T  inRows,
                                                int_T  inCols)
{
    int_T i, j, ij;
    int_T im1=0,ip1=0,jm1=0,jp1=0,jp1TimesR=0;

	/* since we are switching the buffer pointers, we use temporary pointer variable */
	real32_T *buffCprevT = buffCprev;
	real32_T *buffCnextT = buffCnext;
	real32_T *buffRprevT = buffRprev;
	real32_T *buffRnextT = buffRnext;

    real32_T gradC, gradR, gradT;
    real32_T tmp;
    const real32_T *inImgAt;

  /********************* Scanning along row *************************/
  /* step-1.1 : populate column buffer */
    /* all elements in first column (first and last elements repeated) */
    for( i = 0; i < inRows; i++ )
    {
       im1 = (i==0)          ? 0 : i-1;
       ip1 = (i==(inRows-1)) ? i : i+1;
       buffCprevT[i] = GETAPLUS2BPLUSC(inImgA[im1],
                                      inImgA[i],
                                      inImgA[ip1] );
    }

    /* for the first column, buffCprevT = buffCnextT */
    for( i = 0; i < inRows; i++ )   buffCnextT[i] = buffCprevT[i];
 
  /* step-1.2: use the column buffer to compute horizontal gradient */
  /*           also update the column buffer                        */

    for( j = 0; j < inCols; j++ )
    {
        jp1 = (j==(inCols-1)) ? j : j+1;
        jp1TimesR = jp1*inRows;
        for( i = 0; i < inRows; i++ )
        {   /* row scan */
            im1 = (i==0) ? 0 : i-1;
            ip1 = (i==(inRows-1)) ? i : i+1;
            tmp = GETAPLUS2BPLUSC(inImgA[im1 + jp1TimesR],
                                  inImgA[i   + jp1TimesR],
                                  inImgA[ip1 + jp1TimesR]);
            tmpGradC[i+j*inRows] = (buffCprevT[i] - tmp ) * DIV_BY_EIGHT_SGL;
            buffCprevT[i] = tmp;
        }

        /* switch the next and prev column buffers */
        {
            real32_T *tmpBuff = buffCprevT;
            buffCprevT = buffCnextT;
            buffCnextT = tmpBuff;
        }
    }
  /********************* Scanning along column *************************/
  /* step-2.1 : populate row buffer */
    /* all elements in first column (first and last elements repeated) */
    inImgAt = inImgA;
    for( j = 0; j < inCols; j++ )
    {
        int_T negInRows  = (j==0)          ? 0 : -inRows;
        int_T plusInRows = (j==(inCols-1)) ? 0 : inRows;
        buffRprevT[j] = GETAPLUS2BPLUSC(inImgAt[negInRows],
                                       inImgAt[0],   /* inImgAt[0]=inImgA[j*inRows] */
                                       inImgAt[plusInRows] );
        inImgAt += inRows;
    }

    /* for the first row, buffRprevT = buffRnextT*/
    for( j = 0; j < inCols; j++ )   buffRnextT[j] = buffRprevT[j];
 
 /* step-2.2: use the row buffer to compute horizontal gradient */
 /*           also update the row buffer                        */

    for( i = 0; i < inRows; i++ )
    {
        ip1 = (i==(inRows-1)) ? i : i+1;
        for( j = 0; j < inCols; j++ ) 
        {   /* column scan */
            jm1  = (j==0) ? 0 : j-1;
            jp1  = (j==(inCols-1)) ? j : j+1;
            tmp = GETAPLUS2BPLUSC(inImgA[ip1 + jm1*inRows],
                                  inImgA[ip1 + j*inRows],
                                  inImgA[ip1 + jp1*inRows]);
            tmpGradR[i+j*inRows] = (buffRprevT[j] - tmp ) * DIV_BY_EIGHT_SGL;
            buffRprevT[j] = tmp;
        }

        /* switch the next and prev row buffers */
        {
            real32_T *tmpBuff = buffRprevT;
            buffRprevT = buffRnextT;
            buffRnextT = tmpBuff;
        }
    }
  /*******************COMPUTE OTHER GRADIENT VALUES*******************/

    for( ij = 0; ij < inRows*inCols; ij++ )
    {
        gradT = (real32_T) (inImgB[ij] - inImgA[ij]);
        gradR = tmpGradR[ij]; 
        gradC = tmpGradC[ij];

        gradCC[ij] = gradC * gradC;
        gradRC[ij] = gradC * gradR;
        gradRR[ij] = gradR * gradR;
        gradCT[ij] = gradC * gradT;
        gradRT[ij] = gradR * gradT;

        alpha[ij] = 1 / (lambda[0] + gradCC[ij] + gradRR[ij]);
    }
}
/* [EOF] sobelderivative_hs_d_rt.c */
