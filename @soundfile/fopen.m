% Open a SoundFile object
function fopen( this )
  switch lower( this.mode )
    case 'r'
      mode = 0;
    case 'w'
      mode = 1;
    otherwise
      error('soundfile:fopen:UnknownMode','Unknown mode in SoundFile');
  end
  
  this.fho = sf_create( this.fname, uint32(mode), this.code, uint32(this.channels), uint32(this.rate) );
end