% Open a SoundFile object for reading or writing
%
% Usage:
% s.fopen;
% s.fopen(mode);
% fopen(s);
% fopen(s,mode);
%
% Where mode is 'r' for reading, and 'w' for writing.
%
% When writing, file properties should be set beforehand, either during
% object creation or using set.
%
% v0.1 2013-11-05
%
% Copyright (c) 2013, Zebb Prime
% License appended to source
function fopen( this, mode )
% State checking
if ~isempty( this.sfo )
  error('soundfile:fopen:AlreadyOpen','File is already open.');
end

% Input checking
if nargin == 1
  mode = this.mode;
end
this.mode = mode;

% Check to make sure it's either read or write
if ~strcmpi( mode, {'r','w'} )
  error('soundfile:fopen:wrongMode','Mode must be either ''r'' or ''w''.');
end

% Different behaviour for reading and writing
switch lower(mode)
  case 'r'
    % Open the file for reading
    this.sfo = sndfile_interface( this.sfds.cmd.new, this.sfds.mode.read, 0, 0, 0 );
    
    % Check for errors
    if sndfile_interface( this.sfo, this.sfds.cmd.error )
      error('soundfile:fopen:interfaceErr', sndfile_interface( this.sfo, this.sfds.cmd.strerr ) );
    end
    
    % Read in the file data
    this.fpos = 0;
    this.rate = sndfile_interface( this.sfo, this.sfds.cmd.rate );
    this.channels = sndfile_interface( this.sfo, this.sfds.cmd.channels );
    format = sndfile_interface( this.sfo, this.sfds.cmd.format );
    I = bitand( format, this.sfds.mask.type ) == [this.sfds.filetypes{:,2}];
    this.filetype = this.sfds.filetypes{I,2};
    I = bitand( format, this.sfds.mask.sub ) == [this.sfds.datatypes{:,2}];
    this.datatype = this.sfds.datatypes{I,2};
    
  case 'w'
    % Vertify file type and get the format code
    I = strcmpi( this.filetype, this.sfds.filetypes(:,1) );
    if ~any( I )
      error('soundfile:fopen:invalidfiletype',...
        'Invalid filetype. Valid file types are:\n%s', listfiletypes(this) );
    end
    ftf = this.sfds.filetypes{I,2};
    if numel(ftf) ~= 1
      error('soundfile:fopen:wrongnumfiletypesfound','Incorrect number of matched filetypes.');
    end
    
    % Verify the data type and add it to the format code
    I = strcmpi( this.format, this.sfds.formats(:,1) );
    if ~any( I )
      error('soundfile:fopen:invaliddatatype',...
        'Invalid datatype. Valid data types are:\n%s', listdatatypes(this) );
    end
    dtf = this.sfds.datatypes{I,2};
    if numel(dtf) ~= 1
      error('soundfile:fopen:wrongnumdatatypesfound','Incorrect number of matched datatypes.');
    end
    
    % Verify both the rate and number of channels are > 0
    if floor(this.rate) <= 0
      error('soundfile:fopen:invalidrate','Sample rate must be > 0');
    end
    if floor(this.channels) <= 0
      error('soundfile:fopen:invalidchannels','Number of channels must be > 0');
    end
    
    % Finally, open the file for writing
    this.sfo = sndfile_interface( this.sfds.cmd.new, this.sfds.mode.write, ...
      ftf+dtf, this.channels, this.rate );
    
    % Check for errors
    if sndfile_interface( this.sfo, this.sfds.cmd.error )
      error('soundfile:fopen:interfaceErr', sndfile_interface( this.sfo, this.sfds.cmd.strerr ) );
    end
    
  otherwise
    error('soundfile:fopen:wrongMode','This error probably only occurs as the results of a bug.');
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