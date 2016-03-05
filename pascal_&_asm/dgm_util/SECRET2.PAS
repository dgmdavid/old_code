{
  DGM Secret v2.0

  Copyright (c) 2000 David Maziero / DGM Inform†tica

  M¢dulo Principal (proteá∆o/desproteá∆o)

  Data : 7/10/2000
}


  Uses Crt,Dos;


const
  modsize = 8704;   { O tamanho do m¢dulo interno (em bytes) }
  { modifique de acordo com SECRE2I.EXE }

var
 S : PathStr;
 P : PathStr;
 D : DirStr;
 N : NameStr;
 E : ExtStr;
 f : file;
 r : Word;
 buf : array[1..modsize] of Char;
 senha : array[1..10] of Char;
 senha2: array[1..10] of Char;
 t : Char;

label tudook1,tudook2,denovo1,denovo2,denovo3,denovo4,1,2;



  procedure LimpaTeclado;
  var
   t : Char;
  Begin
   while keypressed do begin
    t:=ReadKey;
   end;
  End;



Begin

  {Poe o cabeáalho}
  WriteLn;
  WriteLn(' DGM Secret v2.0 - Proteá∆o de Arquivos por senha ');
  WriteLn(' Copyright (c) 2000 David Maziero / DGM Inform†tica');
  WriteLn;

  {verifica parametros}
  if ParamCount<2 then begin
   WriteLn(' Parametros insuficientes. ');
   WriteLn(' Use : Secret2 P/D nomedoarq.ext ');
   WriteLn;
   WriteLn(' P - Protege o arquivo     D - Desprotege ');
   WriteLn(' nomedoarq.ext - O arquivo a ser protegido (.EXE ou .COM) ');
   WriteLn;
   WriteLn;
   Halt(1);
  end;


  {m¢dulo de proteá∆o}
  if (ParamStr(1)='p') or (ParamStr(1)='P') then begin

   S:=FSearch(ParamStr(2),'');
   if s='' then begin
    WriteLn(' Arquivo <',ParamStr(2),'> n∆o encontrado.');
    WriteLn; WriteLn; Halt(1);
   end;


   P:=ParamStr(2);
   FSplit(P,D,N,E);


   if(E='.EXE') or (E='.exe') then goto tudook1;
   if(E='.COM') or (E='.com') then goto tudook1;

   WriteLn(' O arquivo deve ter extens∆o EXE ou COM.');
   WriteLn; WriteLn; Halt(1);


   tudook1:

1:;
  {Insira a senha}
  WriteLn(' Somente letras e numeros ser∆o aceitos! / 10 carac.)');
  GotoXY(0,wherey);
  Write(' Senha : [          ]');
  for r:=1 to 10 do senha[r]:=' ';
  for r:=1 to 10 do begin
denovo1:;
   GotoXY(9+r,wherey);
   if r>1 then Write('*');
   t:=ReadKey;
    if t=#27 then begin
     WriteLn; Writeln(' Programa cancelado. '); WriteLn;WriteLn;Halt(1);
    end;
   if t=#0 then begin
    t:=ReadKey;
    goto denovo1;
   end;
   if (Ord(t)>=48) and (Ord(t)<=122) then begin
    senha[r]:=t;
   end else begin
    r:=r-1;
    Sound(220); Delay(200); NoSound;
   end;
  end;

  LimpaTeclado;

  {Confirma senha}
  writeLn;
  WriteLn(' Confirme a senha :');
  GotoXY(0,wherey);
  Write(' Senha : [          ]');
  for r:=1 to 10 do senha2[r]:=' ';
  for r:=1 to 10 do begin
denovo2:;
   GotoXY(9+r,wherey);
   if r>1 then Write('*');
   t:=ReadKey;
    if t=#27 then begin
     WriteLn; Writeln(' Programa cancelado. '); WriteLn;WriteLn;Halt(1);
    end;
   if t=#0 then begin
    t:=ReadKey;
    goto denovo2;
   end;
   if (Ord(t)>=48) and (Ord(t)<=122) then begin
    senha2[r]:=t;
   end else begin
    r:=r-1;
    Sound(220); Delay(200); NoSound;
   end;
  end;


  if senha<>senha2 then begin
   WriteLn;
   WriteLn(' As senhas digitadas n∆o s∆o iguais. Digite tudo novamente. ');
   WriteLn;
   goto 1;
  end;


  {Là os "modsize" bytes iniciais do arquivo }
  {$I-}
   Assign(f,PARAMSTR(2)); Reset(f,1);
   Seek(f,0);
   BlockRead(f,buf,modsize);
   close(f);
  {$I+}
   If IOResult<>0 then begin
    WriteLn(' Erro inesperado. ');
    WriteLn; WriteLn; Halt(1);
   end;

   for r:=1 to modsize do
    buf[r]:=Chr( Ord(buf[r]) xor $18 ); { Codifica o in°cio do arq. em XOR 18h }

  {Salva o buffer codificado ao final do arquivo }
  {$I-}
   Assign(f,PARAMSTR(2)); Reset(f,1);
   Seek(f,filesize(f));
   BlockWrite(f,buf,modsize);
   close(f);
  {$I+}
   If IOResult<>0 then begin
    WriteLn(' Erro inesperado. ');
    WriteLn; WriteLn; Halt(1);
   end;

  {Carrega o corpo do programa / no final deste arquivo }
  {$I-}
   Assign(f,PARAMSTR(0)); Reset(f,1);
   Seek(f,filesize(f)-modsize);
   BlockRead(f,buf,modsize);
   Close(f);
  {$I+}
   If IOResult<>0 then begin
    WriteLn(' Erro inesperado. ');
    WriteLn; WriteLn; Halt(1);
   end;

  {Grava no in°cio do arquivo especificado}
  {$I-}
   Assign(f,PARAMSTR(2)); Reset(f,1);
   Seek(f,0);
   BlockWrite(f,buf,modsize);
   Close(f);
  {$I+}
   If IOResult<>0 then begin
    WriteLn(' Erro inesperado. ');
    WriteLn; WriteLn; Halt(1);
   end;

  {Salva a senha no final do arquivo}
   for r:=1 to 10 do senha[r]:=Chr( Ord(senha[r]) xor $18 );
  {$I-}
   Assign(f,PARAMSTR(2)); Reset(f,1);
   Seek(f,filesize(f));
   BlockWrite(f,senha,sizeof(senha));
   Close(f);
  {$I+}
   If IOResult<>0 then begin
    WriteLn(' Erro inesperado. ');
    WriteLn; WriteLn; Halt(1);
   end;

   WriteLn;
   WriteLn;
   WriteLn(' OK. Arquivo <',PARAMSTR(2),'> protegido por DGM Secret v2.0 ');
   WriteLn(' OBS : N∆o se esqueáa da senha!!!');
   WriteLn; WriteLn; Halt(1);

  end; {mod.prot.}


  {m¢dulo de desproteá∆o}
  if (ParamStr(1)='d') or (ParamStr(1)='D') then begin

   S:=FSearch(ParamStr(2),'');
   if s='' then begin
    WriteLn(' Arquivo <',ParamStr(2),'> n∆o encontrado.');
    WriteLn; WriteLn; Halt(1);
   end;


   P:=ParamStr(2);
   FSplit(P,D,N,E);


   if(E='.EXE') or (E='.exe') then goto tudook2;
   if(E='.COM') or (E='.com') then goto tudook2;

   WriteLn(' O arquivo deve ter extens∆o EXE ou COM.');
   WriteLn; WriteLn; Halt(1);


   tudook2:

2:;
  {Insira a senha}
  WriteLn(' Somente letras e numeros ser∆o aceitos! / 10 carac.)');
  GotoXY(0,wherey);
  Write(' Senha : [          ]');
  for r:=1 to 10 do senha[r]:=' ';
  for r:=1 to 10 do begin
denovo3:;
   GotoXY(9+r,wherey);
   if r>1 then Write('*');
   t:=ReadKey;
    if t=#27 then begin
     WriteLn; Writeln(' Programa cancelado. '); WriteLn;WriteLn;Halt(1);
    end;
   if t=#0 then begin
    t:=ReadKey;
    goto denovo3;
   end;
   if (Ord(t)>=48) and (Ord(t)<=122) then begin
    senha[r]:=t;
   end else begin
    r:=r-1;
    Sound(220); Delay(200); NoSound;
   end;
  end;

  LimpaTeclado;

  {Confirma senha}
  writeLn;
  WriteLn(' Confirme a senha :');
  GotoXY(0,wherey);
  Write(' Senha : [          ]');
  for r:=1 to 10 do senha2[r]:=' ';
  for r:=1 to 10 do begin
denovo4:;
   GotoXY(9+r,wherey);
   if r>1 then Write('*');
   t:=ReadKey;
    if t=#27 then begin
     WriteLn; Writeln(' Programa cancelado. '); WriteLn;WriteLn;Halt(1);
    end;
   if t=#0 then begin
    t:=ReadKey;
    goto denovo4;
   end;
   if (Ord(t)>=48) and (Ord(t)<=122) then begin
    senha2[r]:=t;
   end else begin
    r:=r-1;
    Sound(220); Delay(200); NoSound;
   end;
  end;


  if senha<>senha2 then begin
   WriteLn;
   WriteLn(' As senhas digitadas n∆o s∆o iguais. Digite tudo novamente. ');
   WriteLn;
   goto 2;
  end;


 {$I-}
  Assign(f,PARAMSTR(2)); Reset(f,1);
  Seek(f,filesize(f)-sizeof(senha2));
  BlockRead(f,senha2,sizeof(senha2));
  Close(f);
 {$I+}
   If IOResult<>0 then begin
    WriteLn(' Erro inesperado. ');
    WriteLn; WriteLn; Halt(1);
   end;

  for r:=1 to 10 do senha2[r]:=Chr( Ord(senha2[r]) xor $18 );

  if senha<>senha2 then begin
   WriteLn;
   WriteLn(' A senha digitada n∆o est† correta. ');
   WriteLn; WriteLn; Halt(1);
  end;


 {Là o EXE original ao final do arquivo - modsize- sizeof(senha) }
 {$I-}
  Assign(f,PARAMSTR(2)); Reset(f,1);
  Seek(f,(filesize(f)-modsize)-sizeof(senha));
  BlockRead(f,buf,modsize);
  close(f);
 {$I+}
  If IOResult<>0 then begin
   WriteLn(' Erro inesperado. ');
   WriteLn; WriteLn; Halt(1);
  end;

 {Grava o EXE original ao inicio do arquivo }
   for r:=1 to modsize do
    buf[r]:=Chr( Ord(buf[r]) xor $18 ); { De-Codifica o in°cio do arq. em XOR 18h }
 {$I-}
  Assign(f,PARAMSTR(2)); Reset(f,1);
  Seek(f,0);
  BlockWrite(f,buf,modsize);
  close(f);
 {$I+}
  If IOResult<>0 then begin
   WriteLn(' Erro inesperado. ');
   WriteLn; WriteLn; Halt(1);
  end;


  { Apaga o corpo original no final do arquivo }
 {$I-}
  Assign(f,PARAMSTR(2)); Reset(f,1);
  Seek(f,(filesize(f)-modsize)-sizeof(senha));
  truncate(f);
  close(f);
 {$I+}
  If IOResult<>0 then begin
   WriteLn(' Erro inesperado. ');
   WriteLn; WriteLn; Halt(1);
  end;


   WriteLn;
   WriteLn;
   WriteLn(' OK. Arquivo <',PARAMSTR(2),'> foi desprotegido por DGM Secret v2.0 ');
   WriteLn; WriteLn; Halt(1);



  end; {mod.desprot.}



End.