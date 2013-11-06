% Write to a file
%
% Usage:
% count = s.fwrite( Y );
% count = fwrite( s, Y );
%
% count is number of frame written
%
% v0.1 2013-11-05
%
% Copyright (c) 2013, Zebb Prime
% License appended to source

function count = fwrite( this, Y )
  % Make sure the file is open
  if isempty( this.sfo )
    error('soundfile:fwrite:FileNotOpen','Can not write because the file is closed.');
  end  

  % Check the number of input parameters
  if nargin ~= 2
    error('soundfile:fwrite:NotEnoughInputs','Exactly 1 non-self parameters expected.');
  end
  
  % Check to make sure we are in the right mode.
  if strcmpi( this.mode, 'r' )
    error('soundfile:fwrite:ReadMode','Can not write in read mode.');
  end
  
  % Now check Y
  assert( isnumeric(Y) && isreal(Y), 'Y must be real and numeric');
  if size(Y,1) == this.size(1)
    % a-okay
  elseif size(Y,2) == this.size(1)
    Y = transpose(Y);
  else
    error('soundfile:fwrite:NumChannelsDontMatch','Neither the number of rows (default) or the number of columns match the number of channels in the file.');
  end
  
  % Now we can write!
  count = sndfile_interface( this.sfds.cmd.write, this.sfo, Y );
  count = count/this.size(1);
  
  % Check for errors
  if sndfile_interface( this.sfo, this.sfds.cmd.error )
    error('soundfile:fwrite:interfaceErr', this.ferror );
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