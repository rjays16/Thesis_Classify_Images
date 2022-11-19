/*
 * _coder_colouredToGray_mex.c
 *
 * Code generation for function '_coder_colouredToGray_mex'
 *
 */

/* Include files */
#include "colouredToGray.h"
#include "_coder_colouredToGray_mex.h"
#include "colouredToGray_terminate.h"
#include "_coder_colouredToGray_api.h"
#include "colouredToGray_initialize.h"
#include "colouredToGray_data.h"

/* Variable Definitions */
static jmp_buf emlrtJBEnviron;

/* Function Declarations */
static void colouredToGray_mexFunction(int32_T nlhs, mxArray *plhs[3], int32_T
  nrhs, const mxArray *prhs[1]);

/* Function Definitions */
static void colouredToGray_mexFunction(int32_T nlhs, mxArray *plhs[3], int32_T
  nrhs, const mxArray *prhs[1])
{
  const mxArray *outputs[3];
  int32_T b_nlhs;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 1, 4,
                        14, "colouredToGray");
  }

  if (nlhs > 3) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 14,
                        "colouredToGray");
  }

  /* Call the function. */
  colouredToGray_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexAtExit(colouredToGray_atexit);
  emlrtLoadLibrary("C:\\ProgramData\\MATLAB\\SupportPackages\\R2019a\\3P.instrset\\mingw_w64.instrset\\bin\\libgomp-1.dll");

  /* Initialize the memory manager. */
  omp_init_lock(&emlrtLockGlobal);
  omp_init_nest_lock(&emlrtNestLockGlobal);

  /* Module initialization. */
  colouredToGray_initialize();
  st.tls = emlrtRootTLSGlobal;
  emlrtSetJmpBuf(&st, &emlrtJBEnviron);
  if (setjmp(emlrtJBEnviron) == 0) {
    /* Dispatch the entry-point. */
    colouredToGray_mexFunction(nlhs, plhs, nrhs, prhs);

    /* Module termination. */
    colouredToGray_terminate();
    omp_destroy_lock(&emlrtLockGlobal);
    omp_destroy_nest_lock(&emlrtNestLockGlobal);
  } else {
    omp_destroy_lock(&emlrtLockGlobal);
    omp_destroy_nest_lock(&emlrtNestLockGlobal);
    emlrtReportParallelRunTimeError(&st);
  }
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal,
                     emlrtLockerFunction, omp_get_num_procs());
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_colouredToGray_mex.c) */
