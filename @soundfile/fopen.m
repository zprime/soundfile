% Open a SoundFile object
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