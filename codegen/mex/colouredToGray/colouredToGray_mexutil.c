/*
 * colouredToGray_mexutil.c
 *
 * Code generation for function 'colouredToGray_mexutil'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "colouredToGray.h"
#include "colouredToGray_mexutil.h"
#include "colouredToGray_data.h"

/* Function Definitions */
emlrtCTX emlrtGetRootTLSGlobal(void)
{
  return emlrtRootTLSGlobal;
}

void emlrtLockerFunction(EmlrtLockeeFunction aLockee, const emlrtConstCTX aTLS,
  void *aData)
{
  omp_set_lock(&emlrtLockGlobal);
  emlrtCallLockeeFunction(aLockee, aTLS, aData);
  omp_unset_lock(&emlrtLockGlobal);
}

/* End of code generation (colouredToGray_mexutil.c) */
