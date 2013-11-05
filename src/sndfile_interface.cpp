/** Matlab interface to libsndfile
 *
 * This interface accepts Matlab calls (to the mexFunction function) with
 * a method paramater, and appropriately dispatches to the libsndfile
 * method.
 *
 * This file makes use of the class_handle example to interface to the
 * sndfile c++ object.
 *
 * The method names and corresponding values are given in sndfile_interface.hpp
 *
 * v0.1 2013-11-05
 *
 * Copyright (c) 2013, Zebb Prime
 * License information appended to source.
 */

#include <mex.h>
#include <sndfile.hh>
#include "class_handle.hpp"
#include "sndfile_interface.hpp"

/* mex-interface for the libsndfile library using the c++ interface */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{	
  if( nrhs < 1 )
    mexErrMsgTxt("Interface requires at least one input.\n");
  
  SndfileHandle *snfi = NULL;
  
  double cout;
  
  // Switch to the appropriate command
  switch( (int)mxGetScalar( prhs[0] ) )
  {
    /* Create a new SndfileHandle object */
    case SFI_CMD_NEW:
      // Check parameters
      if( nlhs != 1 ) mexErrMsgTxt("NEW: One output expected");
      if( nrhs != 6 ) mexErrMsgTxt("NEW: 6 input parameters expected");
      char fname[2048];
      if( mxGetString( prhs[1], fname, 2048 ) )
        mexErrMsgTxt("NEW: Error extracting filename.");
      plhs[0] = convertPtr2Mat<SndfileHandle>(
        new SndfileHandle ( fname, (int)mxGetScalar( prhs[2] ),
          (int)mxGetScalar( prhs[3] ), (int)mxGetScalar( prhs[4] ),
          (int)mxGetScalar( prhs[5] ) )      
        );
      break;
    
    /* Delete the SndfileHandle object */
    case SFI_CMD_DEL:
      // Destroy the C++ object
      destroyObject<SndfileHandle>(prhs[1]);
      break;
      
    /* Read from the file */  
    case SFI_CMD_READ:
      if( nrhs != 3 ) mexErrMsgTxt("READ: 3 input parameters expected");
      if( nlhs > 2 ) mexErrMsgTxt("READ: Too many output arguments");
      // Retrieve class instance
      snfi = convertMat2Ptr<SndfileHandle>(prhs[1]);
      
      plhs[0] = mxCreateDoubleMatrix( snfi->channels(), mxGetScalar(prhs[2]), mxREAL );
      cout = snfi->read( (double *)mxGetPr( plhs[0] ), (int)( snfi->channels() * mxGetScalar(prhs[2]) ) );
      if( nlhs==2 ) plhs[1] = mxCreateDoubleScalar( cout );
      break;
    
    /* Write to the file */  
    case SFI_CMD_WRITE:
      if( nrhs != 3 ) mexErrMsgTxt("WRITE: 3 input parameters expected");
      if( nlhs > 1 ) mexErrMsgTxt("WRITE: Too many output arguments");
      // Retrieve class instance
      snfi = convertMat2Ptr<SndfileHandle>(prhs[1]);
      
      switch( mxGetClassID(prhs[2]) )
      {
        case mxINT16_CLASS:
          cout = (double)snfi->write( (short *)mxGetPr( prhs[2] ), mxGetNumberOfElements( prhs[2] ) );
          break;
        case mxINT32_CLASS:
          cout = (double)snfi->write( (int *)mxGetPr( prhs[2] ), mxGetNumberOfElements( prhs[2] ) );
          break;
        case mxSINGLE_CLASS:
          cout = (double)snfi->write( (float *)mxGetPr( prhs[2] ), mxGetNumberOfElements( prhs[2] ) );
          break;
        case mxDOUBLE_CLASS:
          cout = (double)snfi->write( (double *)mxGetPr( prhs[2] ), mxGetNumberOfElements( prhs[2] ) );
          break;
        default:
          mexErrMsgTxt("WRITE: Unsupported input data type");
      }
      
      snfi->writeSync();
      if( nlhs == 1 ) plhs[0] = mxCreateDoubleScalar( cout );
      break;
    
    /* Seek in the file */  
    case SFI_CMD_SEEK:
      if( nrhs != 2 ) mexErrMsgTxt("SEEK: 2 input parameters expected");
      if( nlhs > 1 ) mexErrMsgTxt("SEEK: Too many output arguments");
      // Retrieve class instance
      snfi = convertMat2Ptr<SndfileHandle>(prhs[1]);
      
      cout = (double)snfi->seek( (int)mxGetScalar(prhs[2]), (int)mxGetScalar(prhs[3]) );
      if( nlhs == 1 ) plhs[0] = mxCreateDoubleScalar( cout );
      break;
    
    /* Issue command to the Soundfile backend */  
    case SFI_CMD_COMMAND:
      mexErrMsgTxt("COMMAND: Unimplemented");
      // Retrieve class instance
      snfi = convertMat2Ptr<SndfileHandle>(prhs[1]);
      break;
      
    /* Retrieve the error status of the file */  
    case SFI_CMD_ERROR:
      if( nrhs != 2 ) mexErrMsgTxt("ERROR: 2 input parameters expected");
      if( nlhs > 1 ) mexErrMsgTxt("ERROR: Too many output arguments");
      // Retrieve class instance
      snfi = convertMat2Ptr<SndfileHandle>(prhs[1]);
      
      plhs[0] = mxCreateDoubleScalar( (double)snfi->error() );
      break;
    
    /* Retrieve the error status of the file as a string */  
    case SFI_CMD_STRERR:
      if( nrhs != 2 ) mexErrMsgTxt("STRERR: 2 input parameters expected");
      if( nlhs > 1 ) mexErrMsgTxt("STRERR: Too many output arguments");
      // Retrieve class instance
      snfi = convertMat2Ptr<SndfileHandle>(prhs[1]);
      
      plhs[0] = mxCreateString( snfi->strError() );
      break;
      
    /* Get the number of frames in the file */  
    case SFI_CMD_FRAMES:
      if( nrhs != 2 ) mexErrMsgTxt("FRAMES: 2 input parameters expected");
      if( nlhs > 1 ) mexErrMsgTxt("FRAMES: Too many output arguments");
      // Retrieve class instance
      snfi = convertMat2Ptr<SndfileHandle>(prhs[1]);
      
      plhs[0] = mxCreateDoubleScalar( (double)snfi->frames() );
      break;
    
    /* Get the format code of the file */
    case SFI_CMD_FORMAT:
      if( nrhs != 2 ) mexErrMsgTxt("FORMAT: 2 input parameters expected");
      if( nlhs > 1 ) mexErrMsgTxt("FORMAT: Too many output arguments");
      // Retrieve class instance
      snfi = convertMat2Ptr<SndfileHandle>(prhs[1]);
      
      plhs[0] = mxCreateDoubleScalar( (double)snfi->format() );
      break;
    
    /* Get the number of channels in the file */
    case SFI_CMD_CHANNELS:
      if( nrhs != 2 ) mexErrMsgTxt("CHANNELS: 2 input parameters expected");
      if( nlhs > 1 ) mexErrMsgTxt("CHANNELS: Too many output arguments");
      // Retrieve class instance
      snfi = convertMat2Ptr<SndfileHandle>(prhs[1]);
      
      plhs[0] = mxCreateDoubleScalar( (double)snfi->channels() );
      break;
      
    /* Get the sample rate of the file */
    case SFI_CMD_RATE:
      if( nrhs != 2 ) mexErrMsgTxt("RATE: 2 input parameters expected");
      if( nlhs > 1 ) mexErrMsgTxt("RATE: Too many output arguments");
      // Retrieve class instance
      snfi = convertMat2Ptr<SndfileHandle>(prhs[1]);
      
      plhs[0] = mxCreateDoubleScalar( (double)snfi->samplerate() );
      break;
      
    /* Unknown command, return an error */  
    default:
      mexErrMsgTxt("Unknown or unimplemented command.");
  }
  
  return;
}

/*
Copyright (c) 2013, Zebb Prime
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are 
met:

    * Redistributions of source code must retain the above copyright 
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in 
      the documentation and/or other materials provided with the distribution
      
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
*/