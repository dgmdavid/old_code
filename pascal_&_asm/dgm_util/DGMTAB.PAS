{
  DGM TAB v1.0 - by David Maziero
  Inseridor de TABS na margem esquerda de arquivos Texto.
  Data : 17/09/99
}

 Uses Crt,Dos;

 const

  CopyR = 'DGM TAB v1.0 - by David Maziero / Copyright (c) 1999 David Maziero / DGM Inform†tica ';

 var
  f,f2 : Text;
  b : Char;
  s : PathStr;

 Begin
  WriteLn;
  WriteLn(' DGM TAB v1.0 - by David Maziero');
  WriteLn(' Copyright (c) 1999 David Maziero / DGM Inform†tica ');
  WriteLn;

  if ParamCount<1 then begin
   WriteLn('  Digite : DGMTAB <nome-do-arquivo>.TXT ');
   WriteLn('  DGM TAB insere margems de 8 caracteres (TAB) na margem esquera de ');
   WriteLn('  arquivos TEXTOS. ');
   WriteLn;
   Halt(1);
  end;

  s:=FSearch(paramstr(1),'');
  if s=''  then begin
   WriteLn('  Arquivo <',paramstr(1),'> n∆o encontrado.');
   WriteLn; Halt(1);
  end;

  Assign(f,ParamStr(1));   Reset(f);
  Assign(f2,'DGMTAB.TMP'); ReWrite(f2);

  WriteLn('  Iniciando o processo...');
  WriteLn;

  Write(f2,'        ');

  while not eof(f) do begin
   Read(f,b);
   if b<>#10 then Write(f2,b);
   if b=#10 then begin
    Write(f2,b,'        ');
  end;
  end;

  Close(f);
  Erase(f);

  Close(f2);
  Rename(f2,paramstr(1));

  WriteLn('  Pronto!');
  WriteLn;

 End.




