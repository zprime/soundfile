% List all supported data types
%
% Usage:
% types = listdatatypes(s);
% types = s.listdatatypes;
% listdatatypes(s);
% s.listdatatypes;
%
% Note that not all combinations of file and data type are supported. To
% see which are supported, please visit the sndfile <a href="http://www.mega-nerd.com/libsndfile/">homepage.</a>
%
% v0.1 2013-11-05
%
% Copyright (c) 2013, Zebb Prime
% License appended to source

function types = listdatatypes(this)
  if nargout == 1
    types = this.sfds.datatypes(:,[1,3]);
  else
    for ii=1:size(this.sfds.datatypes,1)
      fprintf(1,'%12s | %s\n', this.sfds.datatypes{ii,1}, this.sfds.datatypes{ii,3} );
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