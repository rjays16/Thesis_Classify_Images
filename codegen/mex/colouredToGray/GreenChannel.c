/*
 * GreenChannel.c
 *
 * Code generation for function 'GreenChannel'
 *
 */

/* Include files */
#include <string.h>
#include "mwmathutil.h"
#include "rt_nonfinite.h"
#include "colouredToGray.h"
#include "GreenChannel.h"
#include "colouredToGray_data.h"

/* Function Definitions */
void GreenChannel(const emlrtStack *sp, const uint8_T img[154587], uint8_T g
                  [51529])
{
  int32_T i1;
  int32_T i;
  uint8_T G[51529];
  int32_T j;
  int32_T g_tmp;
  jmp_buf * volatile emlrtJBStack;
  emlrtStack st;
  jmp_buf b_emlrtJBEnviron;
  boolean_T emlrtHadParallelError = false;

  /* GREENCHANNEL Summary of this function goes here */
  /*    Detailed explanation goes here */
  for (i1 = 0; i1 < 227; i1++) {
    memcpy(&G[i1 * 227], &img[i1 * 227], 227U * sizeof(uint8_T));
  }

  emlrtEnterParallelRegion(sp, omp_in_parallel());
  emlrtPushJmpBuf(sp, &emlrtJBStack);

#pragma omp parallel \
 num_threads(emlrtAllocRegionTLSs(sp->tls, omp_in_parallel(), omp_get_max_threads(), omp_get_num_procs())) \
 private(st,b_emlrtJBEnviron,j,g_tmp) \
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
          g_tmp = i + 227 * j;
          g[g_tmp] = (uint8_T)muDoubleScalarRound((real_T)G[g_tmp] * 0.587);
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

/* End of code generation (GreenChannel.c) */
