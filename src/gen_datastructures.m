% Generate the data structures for the soundfile package
function sfds = gen_datastructures( sndlibpath )
  [sfds.filetypes,sfds.datatypes,sfds.endiantypes,sfds.mode] ...
      = gen_formats( sndlibpath );
  sfds.cmd = gen_commands;
  return;
end

% Generate the commands data structure
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
  temp = regexp( sfh, 'SFI_CMD_(\w*)\s+=\s+0x(\d+),\s+/\*\s(.*?)\s\*/', 'tokens' );
  
  % Create the command structure
  for ii=1:numel(temp)
    cmd.(lower(temp{ii}{1})) = str2double(temp{ii}{2});
  end
end

% Generate the types strucutres from sndfile.h
function [filetypes,datatypes,endiantypes,mode] ...
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
  
  % Extract formats
  temp = regexp( enums{1}{1}, 'SF_FORMAT_(\w+)\s*=\s*0x(\d+),\s*/\*\s(.*?)\s\*/', 'tokens' );
  
  % Process the formats
  formats = cell( numel(temp), 3 );
  for ii=1:size(temp,2)
    formats{ii,1} = lower( temp{ii}{1} );
    formats{ii,2} = uint32( hex2dec( temp{ii}{2} ) );
    formats{ii,3} = temp{ii}{3};
  end
  
  % Split into major format and subformat
  filetypes = formats( logical( ([formats{:,2}] > hex2dec('ffff') ) ...
    .* ([formats{:,2}] <= hex2dec('fff0000') ) ), : );
  datatypes = formats( ([formats{:,2}]) < hex2dec('ffff') , : );
  
  % Now scan the endianness
  temp = regexp( enums{1}{1}, 'SF_ENDIAN_(\w+)\s*=\s*0x(\d+),\s*/\*\s(.*?)\s\*/', 'tokens' );
  endiantypes = cell( numel(temp), 3 );
  for ii=1:size(temp,2)
    endiantypes{ii,1} = lower( temp{ii}{1} );
    endiantypes{ii,2} = hex2dec( temp{ii}{2} );
    endiantypes{ii,3} = temp{ii}{3};
  end
  
  % Now scan the modes
  temp = regexp( sfh, 'SFM_(\w+)\s*=\s*0x(\d+),', 'tokens' );
  mode = struct;
  for ii=1:size(temp,2)
    mode.( lower( temp{ii}{1} ) ) = hex2dec( temp{ii}{2} );
  end
end