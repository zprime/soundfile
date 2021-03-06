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
% v0.1.2 2013-11-09
%
% Copyright (c) 2013, Zebb Prime
% License appended to source
function fopen( this, mode )
% State checking
if this.sfo ~= 0
  error('soundfile:fopen:AlreadyOpen','File is already open.');
end

% Input checking (implicit in set.mode)
if nargin == 2
  this.mode = mode;
end

% Different behaviour for reading and writing
switch lower(this.mode)
  case 'r'
    % Open the file for reading
    this.sfo = this.sndfile_interface( this.sfds.cmd.new, this.filename, this.sfds.mode.read, 0, 0, 0 );
    
    % Check for errors
    if this.sndfile_interface( this.sfds.cmd.error )
      errstr = this.ferror;
      this.sndfile_interface( this.sfds.cmd.del );
      this.sfo = 0;
      error('soundfile:fopen:interfaceErr', errstr );
    end
    
    % Read in the file data
    rate = this.sndfile_interface( this.sfds.cmd.rate );
    channels = this.sndfile_interface( this.sfds.cmd.channels );
    format = this.sndfile_interface( this.sfds.cmd.format );
    I = bitand( format, this.sfds.mask.type ) == [this.sfds.filetypes{:,2}];
    filetype = this.sfds.filetypes{I,1};
    I = bitand( format, this.sfds.mask.sub ) == [this.sfds.datatypes{:,2}];
    datatype = this.sfds.datatypes{I,1};
    
    % Now set the file data (need to work around open test).
    tempsfo = this.sfo;
    this.sfo = 0;
    this.rate = rate;
    this.channels = channels;
    this.filetype = filetype;
    this.datatype = datatype;
    this.sfo = tempsfo;
    
  case 'w'
    % Verify file type and get the format code
    I = strcmpi( this.filetype, this.sfds.filetypes(:,1) );
    ftf = this.sfds.filetypes{I,2};
    if numel(ftf) ~= 1
      error('soundfile:fopen:wrongnumfiletypesfound','Incorrect number of matched filetypes.');
    end
    
    % Verify the data type and add it to the format code
    I = strcmpi( this.datatype, this.sfds.datatypes(:,1) );
    dtf = this.sfds.datatypes{I,2};
    if numel(dtf) ~= 1
      error('soundfile:fopen:wrongnumdatatypesfound','Incorrect number of matched datatypes.');
    end
    
    % Finally, open the file for writing
    this.sfo = this.sndfile_interface( this.sfds.cmd.new, this.filename, this.sfds.mode.write, ...
      ftf+dtf, this.channels, this.rate );
    
    % Check for errors
    if this.sndfile_interface( this.sfds.cmd.error )
      errstr = this.ferror;
      this.sndfile_interface( this.sfds.cmd.del );
      this.sfo = 0;
      error('soundfile:fopen:interfaceErr', errstr );
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