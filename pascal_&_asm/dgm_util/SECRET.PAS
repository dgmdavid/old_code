{
   Secret vers∆o 1.0

   Copyright (c) 1998 David Maziero / DGM Inform†tica

   Data : 12 de Dezembro de 1998
}

  Uses Crt,Dos;

  var
   f1,f2 : File;
   buf   : array[1..50000] of Char;
   num   : Word;
   r     : Word;
   nr,nw : Integer;
   S     : PathStr;
   para  : String;
   senha : array[1..10] of Char;
   senha2: array[1..10] of Char;
   senha3: array[1..10] of Char;
   tse   : String;
   Faa   : Word;
   mess  : array[1..65] of Char;
   mess2 : array[1..65] of Char;
   tipo  : String;

  label 1;


  function InputSenha(x,y : Byte) : String;
  var
   r : Word;
   t : Char;
   temp : String;

  Begin
   while keypressed do begin
    t:=ReadKey;
   end;
    t:=#0;

   temp:='';
   GotoXY(x-1,y);  Write('(');
   GotoXY(x+10,y); Write(')');
   for r:=1 to 10 do begin

    t:=ReadKey;

    if t=#27 then begin
     WriteLn;
     WriteLn(' Programa abortado.');
     WriteLn;
     Halt(1);
    End;

    GotoXY(x+r-1,y); Write('*');
    temp:=temp+t;

   end;

   InputSenha:=temp;

  End;


  Begin
   tipo:='SECRET v1.0 - Copyright (c) 1998 David Maziero / DGM Inform†tica ';

   for r:=1 to 65 do begin
    mess[r]:=tipo[r];
   end;


   WriteLn;
   WriteLn(' Secret v1.0 - Copyright (c) 1998 David Maziero / DGM Inform†tica');
   WriteLn;

   If paramcount < 2 then begin
    WriteLn('  Sintax : SECRET (P/D) <Nome-do-arquivo> [opá∆o-especial]');
    WriteLn;
    WriteLn('  P - para proteger o arquivo           D - para desproteger o arquivo');
    WriteLn(' <nome-do-arquivo> - o nome do arquivo a ser protegido ou desprotegido');
    WriteLn;
    WriteLn('  Opá‰es especiais :');
    WriteLn('   S - torna um arquivo de sistema      O - torna um arquivo oculto');
    WriteLn('   R - torna um arquivo s¢ de leitura   N - continua com o atributo anterior');
    WriteLn('  Obs : Caso a opá∆o especial n∆o for especificada, assume como default N.');
    WriteLn;
    Exit;
   end;

    S:=FSearch( ParamStr(2),'' );
    if S='' then begin
     WriteLn(' O arquivo "',paramstr(2),'" n∆o foi encontrado.');
     WriteLn;
     Exit;
    end;

    para:=ParamStr(1);
    if Length(para)>1 then begin
     WriteLn(' Parametro Inv†lido. '); WriteLn; Exit;
    end;

    Case para[1] of
     'P','p' : Write(' Proteger ');
     'D','d' : Write(' Desproteger ');
    else
     WriteLn(' Parametro Inv†lido. '); WriteLn; Exit;
    end;

    if(paramstr(1)='D') or (paramstr(1)='d') then begin

     Assign(f1,ParamStr(2));
     Reset(f1,1);
    for r:=1 to 65 do begin
     mess2[r]:=' ';
    end;
     BlockRead(f1, mess2, 65 );
    Close(f1);
     if mess2<>mess then begin
      Close(f1);
      WriteLn(' Esse n∆o Ç um arquivo protegido por SECRET v1.0.');
      WriteLn; Exit;
     end;
    end;


    WriteLn('o arquivo "',paramstr(2),'".');
    WriteLn;
    Write(' Entre com a senha de proteá∆o :  ');
    tse:='';
    tse :=InputSenha( wherex, wherey );

    for r:=1 to 10 do begin
     senha[r]:=tse[r];
    end;

    WriteLn;
 1:;
    Write(' Confirme a senha de proteá∆o  :  ');
    tse:='';
    tse:=InputSenha( wherex, wherey );

    for r:=1 to 10 do begin
     senha2[r]:=tse[r];
    end;

    WriteLn;

    if senha<>senha2 then begin
     WriteLn;
     WriteLn(' Vocà digitou a senha de confirmaá∆o errado. Tente de novo. ');
     WriteLn;
     Goto 1;
    end;

     WriteLn;

    if(paramstr(1)='D') or (paramstr(1)='d') then begin
     Assign(f1,ParamStr(2));
     Reset(f1,1);
     Seek(f1, 65 );

     BlockRead(f1, senha3, 10 );

     for r:=1 to 10 do begin
       num:= Ord( senha3[r] );
       num:=num-1;
       senha3[r]:= Chr( num );
     end;

     if senha<>senha3 then begin
      WriteLn(' A senha que vocà digitou n∆o esta correta. ');
      WriteLn; Exit;
     end;

     Close(f1);

    end;


{** M¢dulo de proteá∆o ******************************************************}

    If (paramstr(1)='P') or (paramstr(1)='p') then begin

     Assign(f1,ParamStr(2));
     Reset(f1,1);
     Assign(f2,'SECRET.TMP');
     ReWrite(f2,1);

     BlockWrite(f2, mess, 65 );
     for r:=1 to 10 do begin
      senha3[r]:=senha[r];
     end;
     for r:=1 to 10 do begin
       num:= Ord( senha3[r] );
       num:=num+1;
       senha3[r]:= Chr( num );
     end;
     BlockWrite(f2, senha3, 10 );

     repeat

      BlockRead( f1, buf, sizeof( buf ), nr );

       for r:=1 to nr do begin
        num:= Ord( buf[r] );
        num:=num+1;
        buf[r]:= Chr( num );
       end;

      BlockWrite( f2, buf, nr, nw);

       GotoXY( 1, wherey );
       Write(' Protegendo : ', (FilePos(f1)*100) div FileSize(f1),'% concluido... ');

     until (nr = 0) or (nw <> nr);

     Close(f1); Close(f2);
     Faa:=Archive;
     Assign(f1,ParamStr(2));
     GetFAttr(f1,Faa);
     Erase(f1);

     Assign(f2,'SECRET.TMP');
     Rename(f2,ParamStr(2));

     SetFAttr(f2,Faa);

    if(paramstr(3)='S') or (paramstr(3)='s') then
     SetFAttr(f2, SysFile );

    if(paramstr(3)='O') or (paramstr(3)='o') then
     SetFAttr(f2, Hidden );

    if(paramstr(3)='R') or (paramstr(3)='r') then
     SetFAttr(f2, ReadOnly );

     WriteLn; WriteLn;
     WriteLn(' Pronto!');
     WriteLn;
     Exit;

    end;

{** Fim do M¢dulo de proteá∆o ***********************************************}


{** M¢dulo de desproteá∆o ***************************************************}

    If (paramstr(1)='D') or (paramstr(1)='d') then begin

     Assign(f1,ParamStr(2));
     Reset(f1,1);
     Seek(f1, 65+10 );
     Assign(f2,'SECRET.TMP');
     ReWrite(f2,1);

     repeat

      BlockRead( f1, buf, sizeof( buf ), nr );

       for r:=1 to nr do begin
        num:= Ord( buf[r] );
        num:=num-1;
        buf[r]:= Chr( num );
       end;

      BlockWrite( f2, buf, nr, nw);

       GotoXY( 1, wherey );
       Write(' Desprotegendo : ', (FilePos(f1)*100) div FileSize(f1),'% concluido... ');

     until (nr = 0) or (nw <> nr);

     Close(f1); Close(f2);

     Assign(f1,ParamStr(2));
     Erase(f1);

     Assign(f2,'SECRET.TMP');
     Rename(f2,ParamStr(2));

     WriteLn; WriteLn;
     WriteLn(' Pronto!');
     WriteLn;
     Exit;

    end;

{** Fim do M¢dulo de desproteá∆o ********************************************}

  End.