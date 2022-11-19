/*
 * colouredToGray_terminate.c
 *
 * Code generation for function 'colouredToGray_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "colouredToGray.h"
#include "colouredToGray_terminate.h"
#include "_coder_colouredToGray_mex.h"
#include "colouredToGray_data.h"

/* Function Definitions */
void colouredToGray_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void colouredToGray_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (colouredToGray_terminate.c) */
