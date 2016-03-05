uses crt,dos;

begin
 clrscr;
 while(port[$60]<>59) do begin
  gotoxy(5,5);
  writeln('    ',port[$60],'      ',readkey);
 end;

end.