/*
 *  EDGECANNY_USERTH_D_RT Helper function for Edge block (Canny method).
 *
 *  Copyright 1995-2005 The MathWorks, Inc.
 */
#include "vipedge_rt.h"  

static void TrackNonRecursive_UD ( boolean_T *edge, 
                                real_T  *tmpOrMag,
                                int16_T   *stackR,
                                int16_T   *stackC,
                                int16_T   *stackP,
                                int16_T   *stackQ,
                                int_T      r, 
                                int_T      c, 
                                real_T     lowTh, 
                                int_T      inpRows, 
                                int_T      inpCols
                               )
{
    int_T p,q,R,C,P,Q;
    int_T stackIdx            = -1;
    int_T stackMaxLength      = (inpRows*inpCols);
    int_T init                = 1;
    boolean_T prevIsStackDecr = 0;
    boolean_T IsStackIncr     = 1; 
    boolean_T IsStackDecr     = 0; 
    
   while ((stackIdx>=0 && stackIdx < stackMaxLength) || init)
   {  
   /* stackIdx < stackMaxLength this avoids stack overflow;           */
   /* if stack goes beyond this maxLength, the routine quits and this */
   /* will give wrong result */
    
    /*********** init and stack increment stage **********/
    if (IsStackIncr)
    {
        R = init? r : stackR[stackIdx] + stackP[stackIdx]; /* Iold+p; */
        C = init? c : stackC[stackIdx] + stackQ[stackIdx]; /* Jold+q; */

        IsStackIncr = 0;

        if (edge[R+C*inpRows] == 0) 
        {
            edge[R+C*inpRows] = 1;  
                
            for (p= -1; p<=1; p++)  
            {
                for(q= -1; q<=1; q++)   
                {
                    if (p==0 && q==0) continue;
                    if (isInRange(R+p, C+q, inpRows, inpCols) && 
                        tmpOrMag[(R+p)+(C+q)*inpRows] >= lowTh)
                    {
                        stackIdx++;
                        stackR[stackIdx] = (int16_T)R; /* Iold+p; */
                        stackC[stackIdx] = (int16_T)C; /* Jold+q; */

                        stackP[stackIdx] = (int16_T)p; 
                        stackQ[stackIdx] = (int16_T)q; 

                        IsStackIncr=1;  
                        prevIsStackDecr=0;
                            
                        break;
                    }
                }  
                if (IsStackIncr) break;   
            } 
        }
        if  (init)
           init=0;
        else
           if (IsStackIncr==0) IsStackDecr=1;
    }
    /*********** stack decrement stage **********/
    else if (IsStackDecr)
    {
        int_T skip_num_iter, count=0;  

        R = stackR[stackIdx]; 
        C = stackC[stackIdx]; 
        P = stackP[stackIdx];
        Q = stackQ[stackIdx];

        skip_num_iter = 3*(P+1)+ (Q+1);
        for (p= -1; p<=1; p++)  
        {
            for(q= -1; q<=1; q++,count++)   
            {
                if (count>skip_num_iter)
                {
                    if (p==0 && q==0) {continue;}
                    if (!prevIsStackDecr && isInRange(R+p, C+q, inpRows, inpCols) && 
                        tmpOrMag[(R+p)+(C+q)*inpRows] >= lowTh)
                    {
                        stackR[stackIdx] = (int16_T)R; /* R+p; */
                        stackC[stackIdx] = (int16_T)C; /* C+q; */

                        stackP[stackIdx] = (int16_T)p; 
                        stackQ[stackIdx] = (int16_T)q; 

                        IsStackDecr=0;  
                        IsStackIncr=1;
                        prevIsStackDecr=0;

                        break;
                    }
                }

            } 
            if (IsStackIncr) break; 
        } 
        if (IsStackDecr) 
        {
            stackIdx--;
            prevIsStackDecr=1;
        }
    }

   }
}

static void HysteresisThresholding_UD (boolean_T *edge, 
                                    real_T  *tmpOrMag,
                                    int16_T   *stackR,
                                    int16_T   *stackC,
                                    int16_T   *stackP,
                                    int16_T   *stackQ,
                                    real_T     highTh, 
                                    real_T     lowTh, 
                                    int_T      inpRows, 
                                    int_T      inpCols)
{
    /* Hysteresis is used to track along the remaining pixels that have not      */
    /* been suppressed. Hysteresis uses two thresholds and if the magnitude      */
    /* is below the first threshold, it is set to zero (made a nonedge). If      */
    /* the magnitude is above the high threshold, it is made an edge. And if     */
    /* the magnitude is between the 2 thresholds, then it is set to zero unless  */
    /* there is a path from this pixel to a pixel with a gradient above T2.      */

    int_T r,c;
    
    memset(edge,0,inpRows*inpCols*sizeof(boolean_T));

    for (r=0; r<inpRows; r++)
      for (c=0; c<inpCols; c++)
        if (tmpOrMag[r+c*inpRows] >= highTh)
             TrackNonRecursive_UD (edge,tmpOrMag,stackR,stackC,stackP,stackQ,
                                r, c, lowTh, inpRows,inpCols);
}


LIBMWVISIONRT_API void MWVIP_EdgeCanny_userTh_D(
    const real_T  *inpImg,
    const real_T  *gauss1D,
    const real_T  *dgauss1D,
          real_T  *cFiltered,  /* DWork same size as image */
          real_T  *rFiltered,  /* DWork same size as image */
         boolean_T  *outEdge,
          real_T  *tmpOrMag,   /* DWork same size as image */
    const real_T  *ThreshCanny,
          int_T  inpRows,
          int_T  inpCols,
          int_T  halfFiltLen)
{
    real_T lowTh  = ThreshCanny[0]; 
    real_T highTh = ThreshCanny[1];
    int16_T *stackR;
    int16_T *stackC;
    int16_T *stackP;
    int16_T *stackQ;
    const int_T quarterFiltLen = halfFiltLen/2;
    const int_T inpWidth       = inpRows*inpCols;
    int_T r,c;
    
    /* step-1: filter input image along row and along column with Gaussian filter */
    MWVIP_RC_Gaussian_Smoothing_D(inpImg,gauss1D,cFiltered,rFiltered,inpRows,inpCols,halfFiltLen);

    /* step-2: filter smoothed image along column with the derivative of Gaussian filter */
    MWVIP_C_Derivative_Image_D(cFiltered,dgauss1D,tmpOrMag,inpRows,inpCols,halfFiltLen);
    memcpy((byte_T *)cFiltered,(byte_T *)tmpOrMag,inpWidth*sizeof(real_T));

    /* step-3: filter smoothed image along row with the derivative of Gaussian filter */
    MWVIP_R_Derivative_Image_D(rFiltered,dgauss1D,tmpOrMag,inpRows,inpCols,halfFiltLen);
    memcpy((byte_T *)rFiltered,(byte_T *)tmpOrMag,inpWidth*sizeof(real_T));

    /* step-4: get the magnitude of cFilt and rFilt with non-maximum suppression */
    MWVIP_NonMaximum_Suppression_D(cFiltered,rFiltered,tmpOrMag,inpRows,inpCols); 

    /* step-5: Hysteresis thresholding of edge pixels */
    stackR = (int16_T *)cFiltered;
    stackC = (int16_T *)rFiltered;
    stackP = &stackR[inpWidth];
    stackQ = &stackC[inpWidth];

    HysteresisThresholding_UD (outEdge,tmpOrMag,stackR,stackC,stackP,stackQ,
                            highTh,lowTh,inpRows,inpCols);

    /* step-6: Take care of border pixels */
    for (r=0; r<quarterFiltLen; r++)
      for (c=0; c<inpCols; c++)
        outEdge[r+c*inpRows] = 0; 

    for (r=inpRows-1; r>inpRows-1-quarterFiltLen; r--)
      for (c=0; c<inpCols; c++)
        outEdge[r+c*inpRows] = 0; 

    for (r=0; r<inpRows; r++)
      for (c=0; c<quarterFiltLen; c++)
        outEdge[r+c*inpRows] = 0; 

    for (r=0; r<inpRows; r++)
      for (c=inpCols-quarterFiltLen-1; c<inpCols; c++)
        outEdge[r+c*inpRows] = 0; 
}

/* [EOF] edgecanny_userth_d_rt.c */
