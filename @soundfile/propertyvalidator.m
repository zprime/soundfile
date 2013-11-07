% Property validator (private function)
%
% v0.1.1 2013-11-06
%
% Copyright (c) 2013, Zebb Prime
% License appended to source

function valid = propertyvalidator( this, caller, property, value )

publicprops = {
  'filename';
  'mode';
  'filetype';
  'datatype';
  'channels';
  'rate';
  };

%%
assert( nargin==4, 'Property validator requires 3 (non-self) inputs.' );
assert( ischar(caller), 'Caller must be a string' );
assert( ischar(property), 'Property must be a string' );

%% Make sure the property is publically accessable
if ~any( strcmpi( publicprops, property ) )
  error(['soundfile:',caller,':UnknownProperty'],'Unknown property %s\n',property);
end

%% Now switch between known property types, and validate them
switch lower(property)
  case 'filename'
    valid = ischar(value);
    if ~valid
      error(['soundfile:',caller,':FileNameNotString'],'Filename must be a string.');
    end
    
  case 'mode'
    valid = ischar(value) && any( strcmpi( value, {'r','w'} ) );
    if ~valid
      error(['soundfile:',caller,':ModeNotValid'],'Mode must be either ''r'' or ''w''.');
    end
    
  case 'filetype'
    if ~any( strcmpi( value, this.sfds.filetypes(:,1) ) )
      error(['soundfile:',caller,':invalidfiletype'],...
        'Invalid filetype. Valid file types are:\n%s', listfiletypes(this) );
    end
    
  case 'datatype'
    if ~any( strcmpi( value, this.sfds.datatypes(:,1) ) )
      error(['soundfile:',caller,':invaliddatatype'],...
        'Invalid datatype. Valid data types are:\n%s', listdatatypes(this) );
    end
    
  case 'channels'
    valid = isnumeric(value) && isscalar(value) && isreal(value) && isfinite(value) && (floor(value)>0);
    if ~valid
      error(['soundfile:',caller,':InvalidChannels'],...
        'Channels must be real, scalar value greater than zero.');
    end
    
  case 'rate'
    valid = isnumeric(value) && isscalar(value) && isreal(value) && isfinite(value) && (floor(value)>0);
    if ~valid
      error(['soundfile:',caller,':InvalidRate'],...
        'Rate must be real, scalar value greater than zero.');
    end
    
  otherwise
    error('soundfile:propertyvalidator:unknownproperty','Property validator encountered an unknown property %s',property );
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