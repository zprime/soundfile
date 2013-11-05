/** 
 * Method values for the sndfile_interface.cpp files.
 *
 * v0.1 2013-11-05
 *
 * Copyright (c) 2013, Zebb Prime
 * License information appended to source.
 */

#ifndef _SNDFILE_INTERFACE_HPP_
#define _SNDFILE_INTERFACE_HPP_
/* Table of commands */
enum
{
  SFI_CMD_NEW      = 0x00,    /* Constructor (needs to always be 0) */
  SFI_CMD_DEL      = 0x01,    /* Destructor */
  SFI_CMD_READ     = 0x02,    /* Read from the file */
  SFI_CMD_WRITE    = 0x03,    /* Write to the file */
  SFI_CMD_SEEK     = 0x04,    /* Seek to a point in the file */
  SFI_CMD_COMMAND  = 0x05,    /* Command the sndfile backend */
  SFI_CMD_ERROR    = 0x06,    /* Retrieve error code of backend */
  SFI_CMD_STRERR   = 0x07,    /* Retrieve the error as a string */
  SFI_CMD_FRAMES   = 0x08,    /* Get number of frames in the file */
  SFI_CMD_FORMAT   = 0x09,    /* Get format of the file */
  SFI_CMD_CHANNELS = 0x0A,    /* Get number of channels in the file */
  SFI_CMD_RATE     = 0x0B,    /* Get the file sample rate */
};

#endif /* _SNDFILE_INTERFACE_HPP_ */

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