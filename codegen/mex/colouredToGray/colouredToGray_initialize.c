/*
 * colouredToGray_initialize.c
 *
 * Code generation for function 'colouredToGray_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "colouredToGray.h"
#include "colouredToGray_initialize.h"
#include "_coder_colouredToGray_mex.h"
#include "colouredToGray_data.h"

/* Function Definitions */
void colouredToGray_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (colouredToGray_initialize.c) */
