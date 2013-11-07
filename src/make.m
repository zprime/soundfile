% Make (build) the binaries and data structures to interface with libsndfile
%
% This function uses mex to compile the soundfile interface (make sure that
% you have a working mex setup before calling.
%
% v0.1 2013-11-05
%
% Copyright (c) 2013 Zebb Prime
% License information appended to source
function make

%% Default paths for the sndfile library
if nargin == 0
  if ispc
    sflibpath = 'C:\Program Files\Mega-Nerd\libsndfile';
    libname = 'libsndfile-1';
  elseif ismac
    sflibpath = '/usr/local';
    libname = 'libsndfile';
  else
    sflibpath = '/usr';
    libname = 'libsndfile1';
  end
end

fname = {'sndfile_interface.cpp'};

%% Build the mex file
mex(['-I',sflibpath,filesep,'include'],...
  ['-L',sflibpath,filesep,'lib'],...
  ['-l',libname],'-largeArrayDims',fname{1} );

%% Generate the data structures used for the commands
sfds = gen_datastructures( sflibpath );
save sfds sfds;

%% Move files into place
[~,name] = fileparts(fname{1});
copyfile([name,'.',mexext],'../@soundfile');
copyfile('sfds.mat','../@soundfile');

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