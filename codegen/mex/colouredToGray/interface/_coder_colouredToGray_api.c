/*
 * _coder_colouredToGray_api.c
 *
 * Code generation for function '_coder_colouredToGray_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "colouredToGray.h"
#include "_coder_colouredToGray_api.h"
#include "colouredToGray_data.h"

/* Function Declarations */
static uint8_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId))[154587];
static uint8_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[154587];
static uint8_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *img,
  const char_T *identifier))[154587];
static const mxArray *emlrt_marshallOut(const uint8_T u[51529]);

/* Function Definitions */
static uint8_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId))[154587]
{
  uint8_T (*y)[154587];
  y = c_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
  static uint8_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[154587]
{
  uint8_T (*ret)[154587];
  static const int32_T dims[3] = { 227, 227, 3 };

  emlrtCheckBuiltInR2012b(sp, msgId, src, "uint8", false, 3U, dims);
  ret = (uint8_T (*)[154587])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static uint8_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *img,
  const char_T *identifier))[154587]
{
  uint8_T (*y)[154587];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(img), &thisId);
  emlrtDestroyArray(&img);
  return y;
}
  static const mxArray *emlrt_marshallOut(const uint8_T u[51529])
{
  const mxArray *y;
  const mxArray *m0;
  static const int32_T iv0[2] = { 0, 0 };

  static const int32_T iv1[2] = { 227, 227 };

  y = NULL;
  m0 = emlrtCreateNumericArray(2, iv0, mxUINT8_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m0, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m0, iv1, 2);
  emlrtAssign(&y, m0);
  return y;
}

void colouredToGray_api(const mxArray * const prhs[1], int32_T nlhs, const
  mxArray *plhs[3])
{
  uint8_T (*r)[51529];
  uint8_T (*g)[51529];
  uint8_T (*b)[51529];
  uint8_T (*img)[154587];
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  r = (uint8_T (*)[51529])mxMalloc(sizeof(uint8_T [51529]));
  g = (uint8_T (*)[51529])mxMalloc(sizeof(uint8_T [51529]));
  b = (uint8_T (*)[51529])mxMalloc(sizeof(uint8_T [51529]));

  /* Marshall function inputs */
  img = emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "img");

  /* Invoke the target function */
  colouredToGray(&st, *img, *r, *g, *b);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*r);
  if (nlhs > 1) {
    plhs[1] = emlrt_marshallOut(*g);
  }

  if (nlhs > 2) {
    plhs[2] = emlrt_marshallOut(*b);
  }
}

/* End of code generation (_coder_colouredToGray_api.c) */
