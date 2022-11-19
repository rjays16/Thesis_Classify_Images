/*
 * BlueChannel.c
 *
 * Code generation for function 'BlueChannel'
 *
 */

/* Include files */
#include <string.h>
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "colouredToGray.h"
#include "BlueChannel.h"
#include "colouredToGray_data.h"

/* Function Definitions */
void BlueChannel(const emlrtStack *sp, const uint8_T img[154587], uint8_T b
                 [51529])
{
  int32_T i2;
  int32_T i;
  uint8_T B[51529];
  int32_T j;
  int32_T b_tmp;
  jmp_buf * volatile emlrtJBStack;
  emlrtStack st;
  jmp_buf b_emlrtJBEnviron;
  boolean_T emlrtHadParallelError = false;

  /* BLUECHANNEL Summary of this function goes here */
  /*    Detailed explanation goes here */
  for (i2 = 0; i2 < 227; i2++) {
    memcpy(&B[i2 * 227], &img[i2 * 227], 227U * sizeof(uint8_T));
  }

  emlrtEnterParallelRegion(sp, omp_in_parallel());
  emlrtPushJmpBuf(sp, &emlrtJBStack);

#pragma omp parallel \
 num_threads(emlrtAllocRegionTLSs(sp->tls, omp_in_parallel(), omp_get_max_threads(), omp_get_num_procs())) \
 private(st,b_emlrtJBEnviron,j,b_tmp) \
 firstprivate(emlrtHadParallelError)

  {
    if (setjmp(b_emlrtJBEnviron) == 0) {
      st.prev = sp;
      st.tls = emlrtAllocTLS(sp, omp_get_thread_num());
      st.site = NULL;
      emlrtSetJmpBuf(&st, &b_emlrtJBEnviron);
    } else {
      emlrtHadParallelError = true;
    }

#pragma omp for nowait

    for (i = 0; i < 227; i++) {
      if (emlrtHadParallelError)
        continue;
      if (setjmp(b_emlrtJBEnviron) == 0) {
        for (j = 0; j < 227; j++) {
          b_tmp = i + 227 * j;
          b[b_tmp] = (uint8_T)muDoubleScalarRound((real_T)B[b_tmp] * 0.114);
          if (*emlrtBreakCheckR2012bFlagVar != 0) {
            emlrtBreakCheckR2012b(&st);
          }
        }

        if (*emlrtBreakCheckR2012bFlagVar != 0) {
          emlrtBreakCheckR2012b(&st);
        }
      } else {
        emlrtHadParallelError = true;
      }
    }
  }

  emlrtPopJmpBuf(sp, &emlrtJBStack);
  emlrtExitParallelRegion(sp, omp_in_parallel());
}

/* End of code generation (BlueChannel.c) */
