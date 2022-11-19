/*
 * _coder_colouredToGray_info.c
 *
 * Code generation for function '_coder_colouredToGray_info'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "colouredToGray.h"
#include "_coder_colouredToGray_info.h"

/* Function Definitions */
mxArray *emlrtMexFcnProperties(void)
{
  mxArray *xResult;
  mxArray *xEntryPoints;
  const char * fldNames[6] = { "Name", "NumberOfInputs", "NumberOfOutputs",
    "ConstantInputs", "FullPath", "TimeStamp" };

  mxArray *xInputs;
  const char * b_fldNames[4] = { "Version", "ResolvedFunctions", "EntryPoints",
    "CoverageInfo" };

  xEntryPoints = emlrtCreateStructMatrix(1, 1, 6, fldNames);
  xInputs = emlrtCreateLogicalMatrix(1, 1);
  emlrtSetField(xEntryPoints, 0, "Name", emlrtMxCreateString("colouredToGray"));
  emlrtSetField(xEntryPoints, 0, "NumberOfInputs", emlrtMxCreateDoubleScalar(1.0));
  emlrtSetField(xEntryPoints, 0, "NumberOfOutputs", emlrtMxCreateDoubleScalar
                (3.0));
  emlrtSetField(xEntryPoints, 0, "ConstantInputs", xInputs);
  emlrtSetField(xEntryPoints, 0, "FullPath", emlrtMxCreateString(
    "C:\\Users\\Allan Condiman\\Desktop\\Thesis 2\\colouredToGray.m"));
  emlrtSetField(xEntryPoints, 0, "TimeStamp", emlrtMxCreateDoubleScalar
                (737803.56915509258));
  xResult = emlrtCreateStructMatrix(1, 1, 4, b_fldNames);
  emlrtSetField(xResult, 0, "Version", emlrtMxCreateString(
    "9.6.0.1214997 (R2019a) Update 6"));
  emlrtSetField(xResult, 0, "ResolvedFunctions", (mxArray *)
                emlrtMexFcnResolvedFunctionsInfo());
  emlrtSetField(xResult, 0, "EntryPoints", xEntryPoints);
  return xResult;
}

const mxArray *emlrtMexFcnResolvedFunctionsInfo(void)
{
  const mxArray *nameCaptureInfo;
  const char * data[9] = {
    "789ced5a4f53da40148f1d75fa7feca5d7da4e6f9d318a6540a707e48f602b8a08d6c17674495613ddecc62458e0526ffd0a3df4c0c7e8b1c74ea7e7f6d4afd0"
    "8fe034212ca4b43b80601870df0c2c6fdfe4fddefef2b2ef650761622d3d2108c27dfbe38c07f3425deeb98330d3186f087f4bbb7da231de6cd3a94c0993c2c5",
    "fbd675d4fea9314a045bb06cb90a5231dc28694568d80a061a6cba9189a66280ad5c458782014d82cea05cb71caa08e6540dae138f92526d455bf5989a8a6372"
    "7ec714289d6c9734c150cc56b8c8ab081e7e6a8cf54f76c9cf0b063f338d396adf4bbc8d2d8b79131aa6b88210c0b33182655503588c43f3c422ba9853a0a99a",
    "b301512288940c28e748d2009539cd1bef01239ee92ee36d1fa9dc6ade6947c2118aa733fc75cbcf6d061ee587dab3508e290063885cbdd37abbc59f62e24fd5"
    "e74a2ab6c21ebc8f7de2859978ee1cb5f7920f2d6ee634fff220f246f8f073c5dfbcf33bcf87875766f8eb36cf1e32f0689e51fb46500261f83cbd08d3c14c78",
    "27517dbd4552c9561c990e389de21018ba5ffef9f3eacdafa79141e5d703061ee585daa186f635cbaebfe6be02915eaff08ef4bb7fb70b2b0e2a14eff325f1a8"
    "af9d0e78d4beb7b6be5b4f898c418e0ca0cd3abd87296608aa983a90a0980dcc2f2c01d12204154959b47912915a143560215014896e8aff50e7547a1ff3e5d7",
    "efef3ff8fe7e45787eedef99a8bc5d2e5494d585f56ae0a5123ac35bf1507c7cf6f7af8cebbbe55166f8a73c52fbd53ccf8f25a26904ef4bce4b89e95dd70123"
    "ee81e6e3f966b31e9c33fc75cbe323061ee591da2522db0bb79b6a686080e654335a5291b586edd73f68a8d2d0fafa7ef3e89089e7ce517baf79642ac07ed313",
    "ebb435be9f35064aa2d84ea2cf75e29b70c1ebc4a8d789778568be5a2d2ba14dbd9448046252300bc2515e27789db0259219db3a31dda6b7e29976ef2b291511"
    "e475a2d3ba789d182e1eaf1383f15f635c7fbdcffb970676de7f978147f9a1f6a40121f69cf80febbda0d627de3213cf9da3f65ef2c1cb8d9b0d7ee6c317c8cf",
    "fd477f1f5fd4d3190dc782bb59eb959288ca05103b8ea7f83e3ebecfad234ff8f9ff25f1a82f7efe7f657875b92e78fcfc7f30fe6b8cebaf77bfbe3cb07efd0e"
    "038ff243ed515482de3fe88c6abfbec4c473e7a8bd977cf07043cbbe8ff9707ec4fbf5d1dfc7cbc7a75bf0249f0f2553e5eae9f1593eb8b859e0e72e63fcdc3a",
    "c2fb75deafff7fa4c2fb757ff078bfde9fff3f11c6c98c", "" };

  nameCaptureInfo = NULL;
  emlrtNameCaptureMxArrayR2016a(data, 12408U, &nameCaptureInfo);
  return nameCaptureInfo;
}

/* End of code generation (_coder_colouredToGray_info.c) */
