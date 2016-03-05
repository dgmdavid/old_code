{                                }
{  Bomb - Editor de Fase         }
{                                }
{  David Maziero                 }
{                                }
{  22 de julho de 1997           }
{                                }

  Uses Crt,Dos,Graph,WriteStr,Apren;

  type

   ArenaType = record
    Condi : array[1..135] of Word;
   end;
   Fika = file of ArenaType;

  var
   x,y : Word;
   r,tipo : Word;
   f : Fika;
   t : Char;
   bloco : ArenaType;
   fi : file;
   s : PathStr;
   a : array[1..46] of Pointer;
   paro : Word;
   rr,num : Word;
   nome : string;
   perg : string;

  Procedure PoeTela;
  var
   xx,yy,rr : Word;
  Begin
   xx:=5; yy:=2;
   for rr:=1 to 135 do begin
    PutImage(xx,yy,a[bloco.condi[rr]]^,CopyPut);
    xx:=xx+20;
    if xx>=290 then begin xx:=5; yy:=yy+20; end;
   end;
  End;

  Begin
   Graphics(CGA,1,'c:\tp\bgi');

   Assign(fi,'BOMB.DAT'); Reset(fi,1);
   For r:=1 to 46 do begin
    GetMem(a[r],132);BlockRead(fi,a[r]^,132);
   End;
   Close(fi);

   x:=5; y:=2;
   for r:=1 to 135 do begin
    bloco.condi[r]:=12;
    x:=x+20;
    if x>=290 then begin x:=5; y:=y+20; end;
   end;

   x:=5; y:=2; paro:=1; tipo:=1;

   For r:=1 to 100 do begin
    if r>80 then r:=1;
    PoeTela; PutImage(x,y,a[tipo]^,XorPut);
    WriteOut(1,190,'bloco='+str2(paro)+' tipo='+str2(tipo) );
    t:=ReadKey;
    SetColor(0); WriteOut(1,190,'bloco='+str2(paro)+' tipo='+str2(tipo)); SetCOlor(WHITE);
    If(x<280) and (t=FRENTE) then x:=x+20;
    If(x>5) and (t=TRAS) then x:=x-20;
    If(y>2) and (t=CIMA) then y:=y-20;
    If(y<150) and (t=BAIXO) then y:=y+20;

    If t=FRENTE then paro:=paro+1;
    If t=TRAS then paro:=paro-1;
    If(paro>15) and (t=CIMA) then paro:=paro-15;
    If(paro<120) and (t=BAIXO) then paro:=paro+15;
    if paro=0 then begin x:=5;y:=2;paro:=1;end;
    if t='r' then begin paro:=1;x:=5;y:=2;end;
    if(tipo>1) and (t='-') then tipo:=tipo-1;
    if(tipo<56) and (t='+') then tipo:=tipo+1;
    if t=#27 then begin closegraph; exit; end;

    if t=' ' then
    begin
     SetFillStyle(solidfill,0);
     bar(0,185,320,199);
     nome:=ReadText(1,188,'Nome do arquivo :',28,0,15);
     SetFillStyle(solidfill,0);
     bar(0,185,320,199);
     Assign(f,nome);
     s:=FSearch(nome,'');
     if s='' then ReWrite(f);
     if s<>'' then
     begin
      perg:=ReadText(1,188,'Arquivo Existe ( Append ? ) :',1,0,15);
      perg:=UpCase(perg[1]);
      if perg='N' then ReWrite(f);
      if perg='T' then
      begin
       ReadLn(num);
       Reset(f);
       seek(f,num-1);
       Write(f,bloco);
       Close(f);
       exit;
      end;
     end;
     Reset(f);
     seek(f,filesize(f));
     Write(f,bloco);
     Close(f);
    end;

    if t='z' then
    begin
     SetFillStyle(solidfill,0);
     bar(0,185,320,199);
     nome:=ReadText(1,188,'Nome do arquivo :',28,0,15);
     SetFillStyle(solidfill,0);
     bar(0,185,320,199);
     GotoXY(1,23); ReadLn(num);
     Assign(f,nome);
     Reset(f);
     for rr:=1 to num do begin
      Read(f,bloco);
     end;
     Close(f);


    end;

    if t=#13 then bloco.condi[paro]:=tipo; 

   end;

  End.
