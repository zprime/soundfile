% SoundFile reading/writing using the libsndfile library
%
% SoundFile is implemented as an object with the standard file calls,
% e.g. fopen, fclose, etc.
% To see a list of methods or properties, run:
%   methods('soundfile')
% or
%   properties('soundfile');
% Please see the list of compatible file types and formats at the
% <a href="http://www.mega-nerd.com/libsndfile/">libsndfile homepage</a>.
%
% Basic read example:
%   sf = soundfile('testin.wav');
%   fopen( sf, 'r' );
%   [Y,Fs] = fread( sf, inf );
%   fclose( sf );
%   delete( sf );
%
% Basic write example:
%   sf = soundfile('testout.wav','channels',2,'filetype','wav',...
%           'format','pcm_24','rate',44100);
%   fopen( sf, 'w' );
%   fwrite( sf, Y );
%   fclose( sf );
%   delete( sf );
%
% v0.1 2013-11-05
%
% Copyright (c) 2013, Zebb Prime
% License appended to source
classdef soundfile
  
  % Private and hidden properties
  properties ( Hidden = true, SetAccess = private )
    % SoundFile data structure (contains command and format codes)
    sfds;
    % SoundFile handle (private)
    sfo = [];
    % Index to where we are in the file, since libsndfile doesn't seem to
    % have a ftell command.
    fpos = 0;
  end
  
  % Private but visible properties
  properties( SetAccess = private )
    % Properties of the file
    filename;
    mode;
    filetype;
    datatype;
    channels;
    rate;
  end
  
  % Public methods (m-file calls)
  methods
    
    % Constructor method
    function this = soundfile( varargin )
      % Load the data structure into the object
      temp = load( [fileparts( mfilename('fullpath') ),filesep,'sfds.mat'] );
      this.sfds = temp.sfds;
      
      % Make sure there is at least one argument
      if nargin <1
        error('soundfile:soundfile:noName','Filename must be specified');
      end
      
      % Parse all inputs using inputParser
      ip = inputParser;
      ip.addRequired( 'filename', @(x) propertyvalidator( this, 'soundfile','filename',x) );
      ip.addParamValue( 'mode', 'r', @(x) propertyvalidator( this, 'soundfile','mode',x) );
      ip.addParamValue( 'filetype', 'wav', @(x) propertyvalidator( this, 'soundfile','filetype',x) );
      ip.addParamValue( 'datatype', 'pcm_16', @(x) propertyvalidator( this, 'soundfile','datatype',x) );
      ip.addParamValue( 'channels', 2, @(x) propertyvalidator( this, 'soundfile','channels',x) );
      ip.addParamValue( 'rate', 44100, @(x) propertyvalidator( this, 'soundfile','rate',x) );
      ip.parse( varargin{:} );
      
      % Assign values
      this.filename = ip.Results.filename;
      this.filetype = ip.Results.filetype;
      this.datatype = ip.Results.datatype;
      this.mode = ip.Results.mode;
      this.channels = ip.Results.channels;
      this.rate = ip.Results.rate;
      
    end
    
    % Destructor method
    function delete( this )
      if ~isempty( this.sfo );
        fclose( this );
      end
    end
    
    % External methods (m files)
    fopen( sfh, mode );                         %done
    Y = fread( sfh, size, format );
    count = fwrite( sfh, Y );
    fclose( sfh );                              %done
    status = fseek( sfh, offset, origin );      %done
    count = ftell( sfh );                       %done
    message = ferror( sfh );                    %done
    set( sfh, varargin );                       %done
    value = get( sfh, property );               %done
    types = listfiletypes( sfh );               %done
    types = listdatatypes( sfh );               %done
    disp( sfh );                                %done
    s = size( sfh, dim )                        %done
    n = numel( sfh );                           %done
    l = length( sfh );                          %done
  end
  
  % Private methods
  methods (Hidden = true)
    propertyvalidator( sfh, caller, property, value );    %done
    varargout = sndfile_interface( varargin );            %done
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