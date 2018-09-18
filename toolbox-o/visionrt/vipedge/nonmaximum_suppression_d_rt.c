/*
 *  NONMAXIMUM_SUPPRESSION_D_RT Helper function for Edge block (Canny method).
 *
 *  Copyright 1995-2005 The MathWorks, Inc.
 */
#include "vipedge_rt.h"  

LIBMWVISIONRT_API void MWVIP_NonMaximum_Suppression_D(real_T *dc,
                                  real_T *dr,
                                  real_T *tmpOrMag,
                                  int_T inpRows,
                                  int_T inpCols)
{   
    int_T r,c,i;
    int_T RC_mi_1;
    real_T ratio, mag, mag1, mag2, mag3, mag4, dc_rc, dr_rc;
    real_T mag12, mag34;
    int_T inpWidth        = inpRows*inpCols;
    real_T maxMagnitude = 0;
    for (r=1; r<inpRows-1; r++)
    {
      for (c=1; c<inpCols-1; c++)
      {
        /* gradient component dc_rc and dr_rc: they are directional */
        dc_rc = dc[r+c*inpRows]; 
        dr_rc = dr[r+c*inpRows]; 

        mag  = Dnorm(dc_rc, dr_rc);

        /* get the nighboring four pixels' magnitude */

        if (fabs(dr_rc) > fabs(dc_rc))
        {
            /* The derivative along row is biggest, so gradient direction is UP-DOWN */
            ratio = fabs(dc_rc)/fabs(dr_rc);

            mag2 = Dnorm(dc[(r-1)+c*inpRows], dr[(r-1)+c*inpRows]);  
            mag4 = Dnorm(dc[(r+1)+c*inpRows], dr[(r+1)+c*inpRows]); 
            if (dc_rc*dr_rc > 0)
            {
                mag3 = Dnorm(dc[(r+1)+(c+1)*inpRows], dr[(r+1)+(c+1)*inpRows]);
                mag1 = Dnorm(dc[(r-1)+(c-1)*inpRows], dr[(r-1)+(c-1)*inpRows]);
            } 
            else
            {
                mag3 = Dnorm(dc[(r+1)+(c-1)*inpRows], dr[(r+1)+(c-1)*inpRows]);
                mag1 = Dnorm(dc[(r-1)+(c+1)*inpRows], dr[(r-1)+(c+1)*inpRows]);
            }
        } 
        else
        {
            /* The derivative along column is biggest, so gradient direction is LEFT-RIGHT */
            ratio = fabs(dr_rc)/fabs(dc_rc);

            mag2 = Dnorm(dc[r+(c+1)*inpRows], dr[r+(c+1)*inpRows]);  
            mag4 = Dnorm(dc[r+(c-1)*inpRows], dr[r+(c-1)*inpRows]); 
            if (dc_rc*dr_rc > 0)
            {
                mag3 = Dnorm(dc[(r-1)+(c-1)*inpRows], dr[(r-1)+(c-1)*inpRows]);
                mag1 = Dnorm(dc[(r+1)+(c+1)*inpRows], dr[(r+1)+(c+1)*inpRows]);
            }
            else
            {
                mag1 = Dnorm(dc[(r-1)+(c+1)*inpRows], dr[(r-1)+(c+1)*inpRows]);
                mag3 = Dnorm(dc[(r+1)+(c-1)*inpRows], dr[(r+1)+(c-1)*inpRows]);
            }
        }

        /* interpolate the surrounding discrete grid values to get the gradient  */
        /* magnitudes are calculated at the neighbourhood boundary in both       */
        /* directions perpendicular to the centre pixel                          */

        mag12 = ratio*mag1 + (1.0-ratio)*mag2;
        mag34 = ratio*mag3 + (1.0-ratio)*mag4;

        /* Non-maximal suppression means that the pixel (r,c) must have a larger */ 
        /* gradient magnitude than its neighbors in the gradient direction       */

        if ( (mag > mag12) && (mag > mag34) )  /* ratio always < 1 */
        {
            tmpOrMag[r+c*inpRows] = mag; 
        }
        /* The next two items handle special case when a tie occurs. This is a
           rare event that can happen with synthetic images. g676673 */
        else if (mag >= mag12 && mag == mag34) /* for a perfect square this corresponds 
                                                  to bottom and left edges */
        {
            tmpOrMag[r+c*inpRows] = 0;

            if ((fabs(dr_rc) > fabs(dc_rc)) && (dr[r+c*inpRows] < 0 ))      /* up-down */
            {
                tmpOrMag[r+c*inpRows] = mag;
            }
            else if ((fabs(dr_rc) < fabs(dc_rc)) && (dc[r+c*inpRows] > 0 )) /* right-left */
            {
                tmpOrMag[r+c*inpRows] = mag;
            }
            else
            {
                tmpOrMag[r+c*inpRows] = 0;
            }
        }
        else if (mag == mag12 && mag >= mag34)
        {
            if ((fabs(dr_rc) > fabs(dc_rc)) && (dr[r+c*inpRows] > 0 ))      /* up-down */
            {
                tmpOrMag[r+c*inpRows] = mag;
            }
            else if ((fabs(dr_rc) < fabs(dc_rc)) && (dc[r+c*inpRows] < 0 )) /* right-left */
            {
                tmpOrMag[r+c*inpRows] = mag;
            }
            else
            {
                tmpOrMag[r+c*inpRows] = 0;
            }
        }
        else
        {
            tmpOrMag[r+c*inpRows] = 0; 
        }
      }
    }

    /* setting the magnitude of four border pixels */
    /* leftmost column */
    for (r=0; r<inpRows; r++)
    {
         tmpOrMag[r] = Dnorm(dc[r], dr[r]);
    }
    /* rightmost column */
    RC_mi_1 = inpRows*(inpCols-1);
    for (r=0; r<inpRows; r++)
    {
         int_T idx = r+RC_mi_1;
         tmpOrMag[idx] = Dnorm(dc[idx], dr[idx]);
    }
    /* top row (exclude 1st and last- as they are done above) */
    for (c=1; c<inpCols-1; c++)
    {
         int_T idx = c*inpRows;
         tmpOrMag[idx] = Dnorm(dc[idx], dr[idx]);
    }
    /* bottom row (exclude 1st and last- as they are done above) */
    for (c=1; c<inpCols-1; c++)
    {
         int_T idx = (inpRows-1)+ c*inpRows;  
         tmpOrMag[idx] = Dnorm(dc[idx], dr[idx]);
    }

    /* find max magnitude and normalize magnitudes */
    for (i=0; i<inpWidth; i++)
    {
        if (tmpOrMag[i]>maxMagnitude)  maxMagnitude=tmpOrMag[i];
    }
    if (maxMagnitude==0) maxMagnitude = DBL_EPSILON;
    for (i=0; i<inpWidth; i++)
    {
        tmpOrMag[i] /=  maxMagnitude; /* now Magnitude is within [0 to 1]  */
    }
}

/* [EOF] nonmaximum_suppression_d_rt.c */

