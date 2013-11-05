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