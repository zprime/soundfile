function make

%% Default paths for the sndfile library
if nargin == 0
  if ispc
    sflibpath = 'C:\Program Files\something';
  elseif ismac
    sflibpath = '/usr/local/';
  else
    sflibpath = '/usr';
  end
end

fname = {'sndfile_interface.cpp'};

%% Build the mex file
mex(['-I','"',sflibpath,filesep,'include','"'],...
  ['-L','"',sflibpath,filesep,'lib','"'],...
  '-lsndfile','-largeArrayDims',fname{1} );

%% Generate the data structures used for the commands
sfds = gen_datastructures( sflibpath );
save sfds sfds;

%% Move files into place
[~,name] = fileparts(fname{1});
copyfile([name,'.',mexext],'../@soundfile');
copyfile('sfds.mat','../@soundfile');