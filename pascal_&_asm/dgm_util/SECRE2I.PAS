{
  DGM Secret v2.0

  Copyright (c) 2000 David Maziero / DGM Inform†tica

  M¢dulo Interno (proteá∆o/desproteá∆o)

  Data : 7/10/2000
}

{$M 24000,0,0} {24KB}

{$I-}

 Uses Dos,Crt;


const
  modsize = 8704;   { O tamanho do m¢dulo interno (em bytes) }
  { modifique de acordo com SECRE2I.EXE }

 var
  f : file;
  buf : array[1..modsize] of Char; {EXE original}
  buf2: array[1..modsize] of char; {SECRET BODY}
  r  : word;
  cmdline : String;
  senha : array[1..10] of Char;
  senha2: array[1..10] of Char;
  t : Char;

 label 1,denovo1,denovo2;



  procedure LimpaTeclado;
  var
   t : Char;
  Begin
   while keypressed do begin
    t:=ReadKey;
   end;
  End;




 begin

  clrscr;
  WriteLn(' Arquivo protegido por : ');
  WriteLn(' DGM Secret v2.0 - Copyright (c) 2000 David Maziero / DGM Inform†tica');
  WriteLn;
  WriteLn('  ** Para executar este programa, vocà precisa inserir a senha correta **');
  WriteLn;

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
    goto denovo1;
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


 {$I-}
  Assign(f,PARAMSTR(0)); Reset(f,1);
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



 if paramcount>0 then begin
  for r:=1 to paramcount do begin
   cmdline:=cmdline+' '+paramstr(r);
  end; end;


 {Là os "modsize" bytes iniciais do arquivo,correspondestes ao SECRET BODY }
 {$I-}
  Assign(f,PARAMSTR(0)); Reset(f,1);
  Seek(f,0);
  BlockRead(f,buf2,modsize);
  close(f);
 {$I+}
  If IOResult<>0 then begin
   WriteLn(' Erro inesperado. ');
   WriteLn; WriteLn; Halt(1);
  end;

 {Là o EXE original ao final do arquivo - modsize- sizeof(senha) }
 {$I-}
  Assign(f,PARAMSTR(0)); Reset(f,1);
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
  Assign(f,PARAMSTR(0)); Reset(f,1);
  Seek(f,0);
  BlockWrite(f,buf,modsize);
  close(f);
 {$I+}
  If IOResult<>0 then begin
   WriteLn(' Erro inesperado. ');
   WriteLn; WriteLn; Halt(1);
  end;



  {EXECUTA O ARQUIVO ORIGINAL}
  swapvectors;
  exec(paramstr(0),CmdLine);
  swapvectors;



  {Grava o SECRET BODY de volta no inicio do arquivo }
 {$I-}
  Assign(f,PARAMSTR(0)); Reset(f,1);
  Seek(f,0);
  BlockWrite(f,buf2,modsize);
  close(f);
 {$I+}
  If IOResult<>0 then begin
   WriteLn(' Erro inesperado. ');
   WriteLn; WriteLn; Halt(1);
  end;

 end.
