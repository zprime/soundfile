% Sound file reading/writing using the libsndfile library
classdef soundfile < handle
  
  % Private properties
  properties (Hidden = true, SetAccess = private )
    % SoundFile data structure (contains command and format codes)
    sfds;
    % SoundFile handle (private)
    sfo = [];
    % Properties of the file
    fname = '';
    mode = 0;
    format = 0;
    channels = 0;
    rate = 0;
  end
  
  % Public methods (m-file calls)
  methods
    
    % Constructor method
    function this = soundfile( varargin )
      % Load the data structure into the object
      temp = load( [fileparts( mfilename('fullpath') ),filesep,'sfds.mat'] );
      this.sfds = temp.sfds;
      
      ip = inputParser;
      ip.addRequired( 'fname', @ischar );
      ip.addParamValue( 'format', {'rf64','double','little'} );
      ip.addParamValue( 'mode', 'r', @(x) any( strcmpi(x,{'r','w'}) ) );
      ip.addParamValue( 'channels', 0, @(x) isscalar(x) && isnumeric(x) && isreal(x) );
      ip.addParamValue( 'rate', 0, @(x) isscalar(x) && isnumeric(x) && isreal(x) );
      ip.parse( varargin{:} );
      
      this.fname = ip.Results.fname;
      this.mode = ip.Results.mode;
      
      % If writing, validate the format. If reading, file has not been
      % opened yet.
      if strcmpi( ip.Results.mode, 'w' )
        sff_parse( this, ip.Results.format );
        
        % Test the channels
        if ( ~isempty( ip.Results.UsingDefaults ) ) ...
            && strcmpi( ip.Results.UsingDefaults, 'channels' )
          error('soundfile:soundfile:NoChannels','Channels must be specified when writing');
        end
        this.channels = floor( ip.Results.channels );
        
        % Test the sample rate
        if ( ~isempty( ip.Results.UsingDefaults ) ) ...
            && strcmpi( ip.Results.UsingDefaults, 'rate' )
          error('soundfile:soundfile:NoRate','Rate must be specified when writing');
        end
        this.rate = ip.Results.rate;
        
      end
      
    end
    
    % Destructor method
    function delete( this )
      if ~isempty( this.sfo );
        this.sfo = sf_fclose( this );
      end
    end
    
    % External methods (m files)
    fopen( sfh );
    Y = fread( sfh, size, format );
    count = fwrite( sfh, Y );
    fclose( sfh );
    status = fseek( sfh, offset, origin );
    message = ferror( sfh );
    set( sfh, sval );
    gval = get( sfh );
    
  end
  
  % Private methods (m file calls)
  methods (Hidden = true)
    sff_parse( this, in_format );
  end
  
  % Private methods (c++ calls)
  methods (Hidden = true)
    varargout = sndfile_interface( varargin )
  end
end