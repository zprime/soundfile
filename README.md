soundfile
=========

Matlab interface to the sndfile library.

This package uses a small interface to the libsndfile library
(http://www.mega-nerd.com/libsndfile/), and implements most of the
functionality as a Matlab object.

To use, you will need to install libsndfile, then in the src directory run
make.m (in Matlab) to compile the interface against.  This simplest ways to
obtain libsndfile for each platform are:
OS X: Install via Homebrew: http://brew.sh/
Linux: Install via a package manager, e.g. sudo aptitude install libsndfile1-dev
Windows: Download from: http://www.mega-nerd.com/libsndfile/