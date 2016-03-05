{
  DGM File Broken v1.0 - by David Maziero

  Data : 18/09/99
}

 Uses Crt,Dos;

 const
  CopyR = 'DGM File Broken v1.0 - by David Maziero / Copyright (c) 1999 David Maziero / DGM Inform†tica';

 var
  f,f2 : Text;
  s : PathStr;
  P: PathStr;
  D: DirStr;
  N: NameStr;
  E: ExtStr;
  code : integer;
  parts : word;
  size : LongInt;
  r,w : Word;
  cont : LongInt;
  buf : char;

  function Str2(L : LongInt) : string;
  var
   S : string;
  begin
   Str(L, S);
   Str2 := S;
  end;

 Begin
  WriteLn;
  WriteLn(' DGM File Broken v1.0 - by David Maziero ');
  WriteLn(' Copyright (c) 1999 David Maziero / DGM Inform†tica ');
  WriteLn;

  if ParamCount<2 then begin
   WriteLn('  Digite : DGMFB <nome-do-arquivo> <n£mero-de-partes>');
   WriteLn('  OBS : O n£mero de partes deve ser no m†ximo 255.');
   WriteLn('  *IMPORTANTE* : O arquivo a ser dividido deve ser arquivo TEXTO.');
   WriteLn; Halt(1);
  end;

  Val(paramstr(2),parts,code);
  if code<>0 then begin
   WriteLn('  Erro no parametro <n£mero-de-partes>.');
   WriteLn; Halt(1);
  end;
  if parts>255 then begin
   WriteLn('  O n£mero de partes ultrapassou o limite de 255.');
   WriteLn; Halt(1);
  end;

  s:=FSearch(ParamStr(1),'');
  if s='' then begin
   WriteLn('  Arquivo <',paramstr(1),'> n∆o encontrado.');
   WriteLn; Halt(1);
  end;

  P:=ParamStr(1);

  FSplit(P, D, N, E);

  Assign(f,paramstr(1));
  reset(f);
  size:=0;
  WriteLn('  Verificando o arquivo <',paramstr(1),'>...');
  while not eof(f) do begin
   Read(f,buf);
   if buf=#10 then size:=size+1;
  end;
  reset(f);

  size:=size div parts;

  for r:=1 to parts do begin
   WriteLn('  Criando o arquivo <',N,'.',str2(r),'>...');
   Assign(f2,N+'.'+str2(r));
   ReWrite(f2);

   if r<parts then begin
    w:=0;
    while w<size do begin
     Read(f,buf);
     if buf=#10 then w:=w+1;
     Write(f2,buf);
    end;
   end;

   if r=parts then begin
    while not eof(f) do begin
     Read(f,buf);
     Write(f2,buf);
    end;
   end;

   Close(f2);
  end;

   Close(f);

   WriteLn;
   WriteLn('   Pronto!');
   WriteLn;

 End.