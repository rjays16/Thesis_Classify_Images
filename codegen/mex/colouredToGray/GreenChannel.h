/*
 * GreenChannel.h
 *
 * Code generation for function 'GreenChannel'
 *
 */

#ifndef GREENCHANNEL_H
#define GREENCHANNEL_H

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "omp.h"
#include "colouredToGray_types.h"

/* Function Declarations */
extern void GreenChannel(const emlrtStack *sp, const uint8_T img[154587],
  uint8_T g[51529]);

#endif

/* End of code generation (GreenChannel.h) */
