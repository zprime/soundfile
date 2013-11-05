% Display information about the SoundFile object
function disp( this )
  fprintf(1,'SoundFile object\n');
  fprintf(1,'File name: %s\n', this.fname );
  fprintf(1,'Format: %s (%s)\n', this.major, this.sub );
  fprintf(1,'Mode: %s\n', this.mode );
  fprintf(1,'Endianness: %s\n', this.endianness );
  if isempty(this.sfo)
    fprintf(1,'Status: closed\n');
  else
    fprintf(1,'Status: open\n');
  end
end