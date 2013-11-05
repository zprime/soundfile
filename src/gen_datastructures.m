% Generate the data structures for the soundfile package
%
% This function uses the current libsndfile header files to generate
% a data structure used to interface with the libsndfile version that
% sndfile_interface is compiled against.
%
% v0.1 2013-11-05
%
% Copyright (c) 2013 Zebb Prime
% License information appended to source

%%
function sfds = gen_datastructures( sndlibpath )
  [sfds.mask,sfds.filetypes,sfds.datatypes,sfds.endiantypes,sfds.mode] ...
      = gen_formats( sndlibpath );
  sfds.cmd = gen_commands;
  return;
end

%% Generate the commands data structure
function cmd = gen_commands
  % Open the file
  fh = fopen( 'sndfile_interface.hpp', 'r' );
  if fh > 0
    sfh = fread( fh, inf, 'uint8=>char' ).';
    fclose(fh);
  else
    error('gen_datastructures:gen_commands:nosndfile','Could not find sndfile.h in %s',sndlibpath);
  end
  
  % Extract commands
  temp = regexp( sfh, 'SFI_CMD_(\w*)\s+=\s+0x([0-9a-fA-F]+),\s+/\*\s(.*?)\s\*/', 'tokens' );
  
  % Create the command structure
  for ii=1:numel(temp)
    cmd.(lower(temp{ii}{1})) = hex2dec(temp{ii}{2});
  end
end

%% Generate the types strucutres from sndfile.h
function [mask,filetypes,datatypes,endiantypes,mode] ...
    = gen_formats( sndlibpath )
  % Open the file
  fh = fopen( [sndlibpath,filesep,'include',filesep,'sndfile.h'], 'r' );
  if fh > 0
    sfh = fread( fh, inf, 'uint8=>char' ).';
    fclose(fh);
  else
    error('gen_datastructures:gen_commands:nosndfile','Could not find sndfile.h in %s',sndlibpath);
  end
  
  % Scan for all enum entries
  enums = regexp( sfh, 'enum\s*{(.*?)}','tokens' );
  
  %% Extract the masks
  temp = regexp( enums{1}{1}, 'SF_FORMAT_(\w+)MASK\s*=\s*0x([0-9a-fA-F]+)','tokens' );
  
  % Process the masks
  mask = struct;
  for ii=1:size(temp,2)
    mask.(lower(temp{ii}{1})) = uint32( hex2dec( temp{ii}{2} ) );
  end
  
  
  %% Extract formats
  temp = regexp( enums{1}{1}, 'SF_FORMAT_(\w+)\s*=\s*0x([0-9a-fA-F]+),\s*/\*\s(.*?)\s\*/', 'tokens' );
  
  % Process the formats
  formats = cell( numel(temp), 3 );
  for ii=1:size(temp,2)
    formats{ii,1} = lower( temp{ii}{1} );
    formats{ii,2} = uint32( hex2dec( temp{ii}{2} ) );
    formats{ii,3} = temp{ii}{3};
  end
  
  % Split into major format and subformat
  filetypes = formats( logical( bitand( mask.type, [formats{:,2}] ) ) , : );
  datatypes = formats( logical( bitand( mask.sub, [formats{:,2}] ) ), : );
  
  % Now scan the endianness
  temp = regexp( enums{1}{1}, 'SF_ENDIAN_(\w+)\s*=\s*0x([0-9a-fA-F]+),\s*/\*\s(.*?)\s\*/', 'tokens' );
  endiantypes = cell( numel(temp), 3 );
  for ii=1:size(temp,2)
    endiantypes{ii,1} = lower( temp{ii}{1} );
    endiantypes{ii,2} = hex2dec( temp{ii}{2} );
    endiantypes{ii,3} = temp{ii}{3};
  end
  
  % Now scan the modes
  temp = regexp( sfh, 'SFM_(\w+)\s*=\s*0x([0-9a-fA-F]+),', 'tokens' );
  mode = struct;
  for ii=1:size(temp,2)
    mode.( lower( temp{ii}{1} ) ) = hex2dec( temp{ii}{2} );
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