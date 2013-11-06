% Seek to a certain point in the file
%
% Usage:
% position = fseek( s, offset, origin );
% position = s.fseek( offset, origin );
%
% Where offset is a number of frames to seek relative to origin, and origin
% is either:
%  -1 or 'bof' for beginning of file
%   0 or 'cof' for current position in file
%   1 or 'eof' for the end of file
%
% v0.1 2013-11-05
%
% Copyright (c) 2013, Zebb Prime
% License appended to source

function position = fseek( this, offset, origin )
% Firstly make sure the file is open
if isempty( this.fso )
  error('soundfile:fseek:FileClosed','Can not seek since file is closed.');
end

% Now sanity check the inputs
% Origin
if ischar( origin )
  Io = strcmpi( origin, {'bof','cof','eof'} );
elseif isnumeric( origin )
  assert( isscalar(origin), 'Numeric origin must be scalar' );
  Io = ( origin == [-1 0 1] );
else
  error('soundfile:fseek:UnknownOrigin','Origin must be a string or numeric');
end
if ~any(Io)
  error('soundfile:fseek:UnknownOrigin','Origin must either -1, 0, 1, or ''bof'',''cof'',''eof''.');
end

% Look up C seek valus
if Io(1); origin = this.sfds.seek_set;
elseif Io(2); origin = this.sfds.seek_cur;
elseif Io(3); origin = this.sfds.seek_end;
else
  error('soundfile:fseek:UnknownIO','Something strange has happened. Probably a bug.');
end

% Offset
assert( isnumeric(offset) && isreal(offset) && isscalar(offset) && isfinite(offset), ...
  'Offset must be a real, numeric and finite scalar.' );

% Make sure we're not going outside the file
l = length(this);
switch C_ORG(Io)
  case this.sfds.seek_set
    org = 0;
  case this.sfds.seek_cur
    org = this.ftell;
  case this.sfds.seek_end
    org = l;
  otherwise
    error('fseek:origin:NotInList','Something went wrong (most likely a bug), and the origin wasn''t found');
end
assert( offset+org>=0, 'Offset is bad - before beginning-of-file.' );
assert( offset+org<=l, 'Offset is bad - after end-of-file.' );


% Seek
position = sndfile_interface( this.sfds.cmd.seek, this.fso, offset, origin ); 

% Check for errors
if sndfile_interface( this.sfo, this.sfds.cmd.error )
  error('soundfile:fseek:interfaceErr', sndfile_interface( this.sfo, this.sfds.cmd.strerr ) );
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