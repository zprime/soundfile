% Set properties of the soundfile object
%
% v0.1 2013-11-05
%
% Copyright (c) 2013, Zebb Prime
% License appended to source

function set( this, varargin )
  % Check to make sure the file is closed
  if this.sfo ~= 0
    error('soundfile:set:FileOpen','Cannot use set while file is open.');
  end
  
  % Check to make sure we have the correct number of input arguments
  if mod( numel(varargin), 2 )
    error('soundfile:set:WrongNumberInputs','Inputs must be specified in ''property'' ''value'' pairs.');
  end
  
  for ii=1:2:numel(varargin)
    prop = varargin{ii};
    value = varargin{ii+1};
    
    % Check data types
    if ~( iscell(prop) || ischar(prop) )
      error('soundfile:set:PropertyNotCellorString','Property must be a string (or a cell of strings)');
    end
    
    % Allow multiple entries in a cell
    if iscell(prop)
      assert( iscell(value), 'When property is a cell, value must be a cell as well.' );
      if numel(prop) ~= numel(value)
        error('soundfile:set:WrongSizedCellPair','When using cell property inputs, the corresponding value input must be the same size.');
      end
      % Recursion FTW
      cellfun( @(a,b) this.set(a,b), prop, value, 'UniformOutput', false );
    else
      % Time to look at actually setting the properties
      publicprops = properties(this);
      if ~strcmpi( prop, publicprops )
        error('soundfile:set:UnknownProperty','Unknown property %s.',prop);
      end
      propertyvalidator( this, 'set', lower(prop), value );
      this.(lower(prop)) = value;
    end
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