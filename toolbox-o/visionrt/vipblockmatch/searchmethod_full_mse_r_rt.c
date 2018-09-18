/*
 *  SEARCHMETHOD_FULL_MSE_R_RT Helper function for Block Matching block.
 *
 *  Copyright 1995-2008 The MathWorks, Inc.
 */
#include "vipblockmatch_rt.h"  

LIBMWVISIONRT_API void MWVIP_SearchMethod_Full_MSE_R(const real32_T *blkCS, const real32_T *blkPB, /* CS = current image (smaller block), PB = previous image (bigger block) */
                                             int_T rowsImgCS,   int_T rowsImgPB,  
                                             int_T blkCSWidthX, int_T blkCSHeightY,  
                                             int_T blkPBWidthX, int_T blkPBHeightY,  
                                             int_T *xIdx,       int_T *yIdx)
{
    real32_T minVal= MAX_real32_T;   
    int_T xEnd = blkPBWidthX  - blkCSWidthX  +1; /* 2*maxDX+1 */
    int_T yEnd = blkPBHeightY - blkCSHeightY +1; /* 2*maxDY+1 */
    int_T x,y, c1,r1;

    xIdx[0]=0;
    yIdx[0]=0;

    for (x=0; x<xEnd;x++)
    {
      int_T rowOffsetAll =   x*rowsImgPB; 
      for (y=0; y<yEnd; y++) 
      {
         const real32_T *otherBlock = &blkPB[rowOffsetAll+y]; /* searchRegion */
         real32_T mysum=0;
         for (c1=0; c1<blkCSWidthX;c1++)
         {
            int_T rowOffsetCS =  c1*rowsImgCS;
            int_T rowOffsetPB =  c1*rowsImgPB;
            for (r1=0; r1<blkCSHeightY; r1++) 
            {
               real32_T dist = blkCS[rowOffsetCS+r1] - otherBlock[rowOffsetPB+r1]; 
               mysum += dist*dist;
            }
         }
        
        if (mysum<minVal)
        {
              minVal=mysum;
              xIdx[0]=x;
              yIdx[0]=y;
        }
      }
    }
}

/* [EOF] searchmethod_full_mse_r_rt.c */
