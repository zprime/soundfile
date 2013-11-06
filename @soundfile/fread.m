% Read from the soundfile
%
% Usage:
% Y = s.fread( numframes );
% Y = fread( s, numframes );
%
% v0.1.1 2013-11-06
%
% Copyright (c) 2013, Zebb Prime
% License appended to source

function Y = fread( this, numframes )
  % Make sure the file is open
  if this.sfo == 0
    error('soundfile:fread:FileNotOpen','Can not read because the file is closed.');
  end
  
  % If no input arguments are given, read the whole file.
  if nargin==1
    numframes=inf;
  end
  
  % Check to make sure we are in the right mode.
  if strcmpi( this.mode, 'w' )
    error('soundfile:fread:WriteMode','Can not read in write mode.');
  end
  
  assert( isnumeric(numframes) && isscalar(numframes) && isreal(numframes) && (numframes>0), ...
    'Number of frames to read must be numeric, real, scalar and greater than zero' );
  
  % If numframes is greater than how much is left, reduce it to what is
  % left
  numframes = min( this.length() - this.ftell(), numframes );
  
  % Read the data
  Y = this.snfile_interface( this.sfds.cmd.read, numframes );
  
  % Check for errors
  if this.sndfile_interface( this.sfds.cmd.error )
    error('soundfile:fread:interfaceErr', this.ferror );
  end
end

% Copyright (c) 2013, Zebb Prime
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE. 