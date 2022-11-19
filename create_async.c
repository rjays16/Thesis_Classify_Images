#include "mex.h"
 #include <windows.h>
 #include <stdio.h>
 #include <process.h>
 #include <string.h>
 /*These global variables will be accessible to both threads and will exist
*in the MEX function through multiple calls to the MEX function */
 static unsigned Counter;
 static HANDLE hThread=NULL;
 /*The second thread should not try to communicate with MATLAB at all. 
*This includes the use of mexPrintf, which attempts to print to the
*MATLAB command window. */
 unsigned __stdcall SecondThreadFunc( void* pArguments ) {
     /* loop for 20 seconds */
     while ( Counter < 20 ) {
         Counter++;
         Sleep( 1000L );
     }
     _endthreadex( 0 );
     return 0;
 }
 void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[]) {
     unsigned threadID;
     char *cmd;
     /*  check for proper number of arguments */
     if(nrhs!=1)
         mexErrMsgTxt("One input required.");
     /* check to make sure the first input argument is a string */
     if (!mxIsChar(prhs[0]))
         mexErrMsgTxt("Input must be a string.");
     /* get command from first input */
     cmd = mxArrayToString(prhs[0]);
     /* if command is "Init", start the thread, otherwise wait for thread
      * to complete */
     if (!strcmp(cmd,"Init")) {
         /* make sure thread was not started using "mex locked" state */
         if (mexIsLocked())
             mexErrMsgTxt("Thread already initialized.");
         /* lock thread so that no-one accidentally clears function */
         mexLock();
         /* Create the second thread. */
         mexPrintf( "Creating second thread...\n" );
         Counter = 0;
         hThread = (HANDLE)_beginthreadex( NULL, 0, &SecondThreadFunc, NULL, 0, &threadID );
     }
     else {
         /* make sure that the thread was started using "mex locked" status*/
         if (!mexIsLocked())
             mexErrMsgTxt("Thread not initialized yet."); /*This function will return control to MATLAB*/
         /* wait for thread to finish and get result */
         WaitForSingleObject( hThread, INFINITE );
         mexPrintf( "Counter should be 20; it is-> %d\n", Counter );
         /* Destroy the thread object, free memory, and unlock mex. */
         CloseHandle( hThread );
         mexUnlock();
     }
     return;
 }
