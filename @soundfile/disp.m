% Display information about the SoundFile object
function disp( this )
  fprintf(1,'SoundFile object\n');
  fprintf(1,'File name: %s\n', this.filename );
  fprintf(1,'File type: %s\n', this.filetype );
  fprintf(1,'Data type: %s\n', this.datatype );
  fprintf(1,'Mode: %s\n', this.mode );
  if isempty(this.sfo)
    fprintf(1,'Status: closed\n');
  else
    fprintf(1,'Status: open\n');
  end
end