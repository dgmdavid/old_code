{
   Bomb v2.0 Editor de Fases v2.0

   Copyright (c) 1999 David Maziero / DGM Inform†tica

   Data : 29 de Dezembro de 1999
}

  Uses Crt,Dos,DMode13H,Divrf;

  type

    Bomb2MapType = record
     tipo : Byte;  { O Tipo da fase :
                      1 - Floresta     2 - Terra      3 - Gelo
                      4 - Espacial     5 - Castelo                }
     arq : array[1..17,1..10] of Byte;   { Qual Arquivo ? Bmov,Basico etc }
     gra : array[1..17,1..10] of Byte;   { O Gr†fico dele }
     hori : array[1..17,1..10] of Byte;  { A orientaá∆o do gr†fico }
    end;
    FaseBomb = file of Bomb2MapType;

  var
   Imgs : array[1..5,1..90] of Pointer;
   x,y  : Word;
   r,w  : Integer;
   fase : Bomb2MapType;
   f    : file;
   t    : Char;
   pal : array[0..255,1..3] of Byte; { V†riavel de pallete DGM }
   arq,img,hori : Byte;
   cu : Integer;

{---- LoadImg ---------------------------------------------------------------}
procedure LoadImg(var f : File; var img : Pointer );
var
 size,ex,ey : Word;
Begin
 ex:=0; ey:=0;
 BlockRead(f,ex,2); BlockRead(f,ey,2);
 Seek(f,filepos(f)-4);
 size:=BitMapAlloc(ex,ey,img);
 BlockRead(f,img^,size);
end;

{---- PutBack ---------------------------------------------------------------}
procedure PutBack;
var
 x,y,w : Word;
Begin
 w:=1;
 for y:=1 to 10 do begin
 for x:=1 to 17 do begin
  PutImageNC( 5+(x-1)*18, 0+(y-1)*18, Imgs[5, 1+((fase.tipo-1)*11)+(w-1)] ,vaddr);
  case w of
   1 : w:=2;
   2 : w:=1;
  end;
 end;
 end;
end;

{---- PutFront --------------------------------------------------------------}
procedure PutFront;
var
 ex,ey,w : Word;
 def : Integer;
Begin
 w:=1; def:=0;
 for ey:=1 to 10 do begin
 for ex:=1 to 17 do begin
  if fase.arq[ex,ey]<>0 then begin

   if fase.arq[ex,ey]=1 then def:=0;
   if fase.arq[ex,ey]=2 then def:=cu;
   if fase.arq[ex,ey]=3 then def:=(cu-2);
   if fase.arq[ex,ey]=4 then def:=0;
   if fase.arq[ex,ey]=5 then def:=cu;

   if fase.hori[ex,ey]=1 then PutImage( 5+(ex-1)*18, def+(ey-1)*18, Imgs[fase.arq[ex,ey],fase.gra[ex,ey]] ,vaddr);
   if fase.hori[ex,ey]=2 then PutImageI( 5+(ex-1)*18, def+(ey-1)*18, Imgs[fase.arq[ex,ey],fase.gra[ex,ey]] ,vaddr);
   if fase.hori[ex,ey]=3 then PutImageI2( 5+(ex-1)*18, def+(ey-1)*18, Imgs[fase.arq[ex,ey],fase.gra[ex,ey]] ,vaddr);
   if fase.hori[ex,ey]=4 then PutImageI3( 5+(ex-1)*18, def+(ey-1)*18, Imgs[fase.arq[ex,ey],fase.gra[ex,ey]] ,vaddr);

  end;
  if(ex=x) and (ey=y) then begin
   if hori=1 then PutImageNC( 5+(x-1)*18,0+(y-1)*18, Imgs[arq,img], vaddr );
   if hori=2 then PutImageNCI( 5+(x-1)*18,0+(y-1)*18, Imgs[arq,img], vaddr );
   if hori=3 then PutImageNCI2( 5+(x-1)*18,0+(y-1)*18, Imgs[arq,img], vaddr );
   if hori=4 then PutImageNCI3( 5+(x-1)*18,0+(y-1)*18, Imgs[arq,img], vaddr );
  end;

 end;
 end;
end;

procedure Anima;
var
 x,y : Word;
Begin
 for y:=1 to 10 do begin
 for x:=1 to 17 do begin

  if fase.arq[x,y]=5 then begin
   case fase.gra[x,y] of
    7 : fase.gra[x,y]:=8;
    8 : fase.gra[x,y]:=7;
    9 : fase.gra[x,y]:=10;
    10: fase.gra[x,y]:=9;
    11+7 : fase.gra[x,y]:=11+8;
    11+8 : fase.gra[x,y]:=11+7;
    11+9 : fase.gra[x,y]:=11+10;
    11+10: fase.gra[x,y]:=11+9;
    22+7 : fase.gra[x,y]:=22+8;
    22+8 : fase.gra[x,y]:=22+7;
    22+9 : fase.gra[x,y]:=22+10;
    22+10: fase.gra[x,y]:=22+9;
    33+7 : fase.gra[x,y]:=33+8;
    33+8 : fase.gra[x,y]:=33+7;
    33+9 : fase.gra[x,y]:=33+10;
    33+10: fase.gra[x,y]:=33+9;
    44+7 : fase.gra[x,y]:=44+8;
    44+8 : fase.gra[x,y]:=44+7;
    44+9 : fase.gra[x,y]:=44+10;
    44+10: fase.gra[x,y]:=44+9;
  end;
  end;

  if fase.arq[x,y]=2 then begin
   case fase.gra[x,y] of
    12 : fase.gra[x,y]:=13;
    13 : fase.gra[x,y]:=12;
    14 : fase.gra[x,y]:=15;
    15 : fase.gra[x,y]:=14;
    22 : fase.gra[x,y]:=23;
    23 : fase.gra[x,y]:=22;

    24 : fase.gra[x,y]:=25;
    25 : fase.gra[x,y]:=26;
    26 : fase.gra[x,y]:=24;

    27 : fase.gra[x,y]:=28;
    28 : fase.gra[x,y]:=29;
    29 : fase.gra[x,y]:=27;

    34 : fase.gra[x,y]:=35;
    35 : fase.gra[x,y]:=34;


   end;
  end;

  if fase.arq[x,y]=3 then begin
   case fase.gra[x,y] of
    16 : fase.gra[x,y]:=17;
    17 : fase.gra[x,y]:=16;
    18 : fase.gra[x,y]:=19;
    19 : fase.gra[x,y]:=18;

    28 : fase.gra[x,y]:=29;
    29 : fase.gra[x,y]:=28;

    30 : fase.gra[x,y]:=31;
    31 : fase.gra[x,y]:=30;





   end;
  end;

 end;
 end;
end;


{---- Grava -----------------------------------------------------------------}
procedure Grava;
var
 nome : String;
 f : FaseBomb;
 s : PathStr;
 P : PathStr;
 D : DirStr;
 N : NameStr;
 E : ExtStr;
 t : Char;
 posi : word;
label 1;
Begin
 SetText;
 nome:='';
 ClrScr;
 WriteLn(' WRITE ');
 Write(' Entre com o nome do arquivo : ');
 ReadLn( P );
 FSplit(P, D, N, E);
 if N = '' then
    N := 'FASES';
 if E = '' then
    E := '.MAP';
 P := D + N + E;
 nome:=P;

 s:=FSearch( nome, '' );

 if s='' then begin
  Assign(f,nome); ReWrite(f);
  Write(f,fase); Close(f);
  WriteLn;
  WriteLn(' Arquivo <',nome,'> criado. ');
  WriteLn;
 end;

 if s<>'' then begin
  Assign(f,nome); Reset(f);
  WriteLn;
  WriteLn(' O Arquivo <',nome,'> j† existe, e possui ',filesize(f),' fases. ');
  WriteLn(' Deseja Reescreve-lo, gravar no Final ou gravar em outra Posiá∆o ? (R/F/P)');
  t:=Perg('RrFfPp'+#27+#13);

  if UpCase(t)='R' then begin
   ReWrite(f); Write(f,fase);
  end;

  if(UpCase(t)='F') or (t=#13) then begin
   Seek(f,filesize(f)); Write(f,fase);
  end;

  if UpCase(t)='P' then begin
   Write(' Em qual posiá∆o (1..',filesize(f),') ? ');
  {$I-}
   ReadLn( posi );
  {$I+}
   if IOResult<>0 then goto 1;

   if posi=0 then goto 1;
   if posi>filesize(f) then goto 1;

   Seek(f,(posi-1));
   Write(f,fase);
  end;

1:;
  Close(f);
 end;

 SetMCGA;
 for r:=0 to 255 do SetPal(r,pal[r,1],pal[r,2],pal[r,3]);

End;

{---- Le --------------------------------------------------------------------}
procedure Le;
var
 nome : String;
 f : FaseBomb;
 s : PathStr;
 P : PathStr;
 D : DirStr;
 N : NameStr;
 E : ExtStr;
 t : Char;
 posi : word;
label 1;
Begin
 SetText;
 nome:='';
 ClrScr;
 WriteLn(' LOAD ');
 Write(' Entre com o nome do arquivo : ');
 ReadLn( P );
 FSplit(P, D, N, E);
 if N = '' then
    N := 'FASES';
 if E = '' then
    E := '.MAP';
 P := D + N + E;
 nome:=P;

 s:=FSearch( nome, '' );

 if s='' then begin
  WriteLn;
  WriteLn(' Arquivo <',nome,'> n∆o existe. ');
  WriteLn;
 end;

 if s<>'' then begin
  Assign(f,nome); Reset(f);
  WriteLn;
  WriteLn(' O Arquivo <',nome,'> existe e possui ',filesize(f),' fases. ');
  WriteLn(' Deseja ler qual (1..',filesize(f),') ? ');
  {$I-}
   ReadLn( posi );
  {$I+}
   if IOResult<>0 then goto 1;

   if posi=0 then goto 1;
   if posi>filesize(f) then goto 1;

   Seek(f,(posi-1));
   Read(f,fase);
  Close(f);
  end;

1:;

 SetMCGA;
 for r:=0 to 255 do SetPal(r,pal[r,1],pal[r,2],pal[r,3]);

End;




{---- Principal -------------------------------------------------------------}
Begin
 ClrScr;
 WriteLn(' Bomb v2.0 - Editor de Fases v2.0 ');
 WriteLn(' Copyright (c) 1999 David Maziero / DGM Inform†tica ');
 RDelay(150);

  fase.tipo:=1;
  WriteLn;
  WriteLn(' Que tipo de fase : ');
  WriteLn('  1 - Floresta  ');
  WriteLn('  2 - Terra     ');
  WriteLn('  3 - Gelo      ');
  WriteLn('  4 - Espacial  ');
  WriteLn('  5 - Castelo   ');
  t:=Perg('12345'+#27);
  if t=#27 then begin
   WriteLn; WriteLn(' DGM.');
   WriteLn; Halt(1);
  end;
  if t='1' then fase.tipo:=1;
  if t='2' then fase.tipo:=2;
  if t='3' then fase.tipo:=3;
  if t='4' then fase.tipo:=4;
  if t='5' then fase.tipo:=5;

 WriteLn;
 WriteLn(' Carregando gr†ficos... ');
 RDelay(150);

 { Arquivo 1 - Bmov.dat }
 Assign(f,'BOMB2.DAT'); Reset(f,1);
 for r:=1 to 24 do LoadImg(f,Imgs[1,r]);

 { Arquivo 2 - Basico.dat }
 for r:=1 to 35 do LoadImg(f,Imgs[2,r]);

 { Arquivo 3 - Items.dat }
 for r:=1 to 31 do LoadImg(f,Imgs[3,r]);

 { Arquivo 4 - Monstro.dat }
 for r:=1 to 87 do LoadImg(f,Imgs[4,r]);

 { Arquivo 5 - Cena.dat }
 for r:=1 to 55 do LoadImg(f,Imgs[5,r]);

 Seek(f,filesize(f)-(809-41));
 BlockRead(f,pal,sizeof(pal));

 Close(f);


 SetUpVirtual(1);
 SetMCGA;
 cls(vga,0); cls(vaddr,0);

 cu:=-5;

 for r:=0 to 255 do SetPal(r,pal[r,1],pal[r,2],pal[r,3]);

 for y:=1 to 10 do begin
 for x:=1 to 17 do begin
  fase.arq[x,y]:=0;
  fase.gra[x,y]:=0;
  fase.hori[x,y]:=1;
 end;
 end;

 x:=1; y:=1; w:=1;
 arq:=1;
 img:=1; hori:=1;
 DirectVideo:=False;

 repeat
  w:=w+1;
  if w=5 then w:=1;

  PutBack;
  PutFront;
  if w=1 then Anima;

{  if hori=1 then PutImageNC( 5+(x-1)*18,0+(y-1)*18, Imgs[arq,img], vaddr );
  if hori=2 then PutImageNCI( 5+(x-1)*18,0+(y-1)*18, Imgs[arq,img], vaddr );
  if hori=3 then PutImageNCI2( 5+(x-1)*18,0+(y-1)*18, Imgs[arq,img], vaddr );
  if hori=4 then PutImageNCI3( 5+(x-1)*18,0+(y-1)*18, Imgs[arq,img], vaddr ); }

  waitretrace;
  flip(vaddr,vga);
  cls(vaddr,0);
  gotoXY(1,24);
  Write(' Horiz : ',hori,'   ',cu );

  if not keypressed then t:=#0;
  if keypressed then t:=ReadKey;

  if(t=FRENTE) and (x<17) then x:=x+1;
  if(t=TRAS  ) and (x>1 ) then x:=x-1;
  if(t=CIMA  ) and (y>1 ) then y:=y-1;
  if(t=BAIXO ) and (y<10) then y:=y+1;

  if t='[' then cu:=cu+1;
  if t=']' then cu:=cu-1;

  if t='0' then begin
   case hori of
    1 : hori:=2;
    2 : hori:=3;
    3 : hori:=4;
    4 : hori:=1;
   end;
  end;

  if(t='*') and (arq<5) then arq:=arq+1;
  if(t='/') and (arq>1) then arq:=arq-1;

  if(t='-') and (img>1) then img:=img-1;

  if arq=1 then begin
   if(t='+') and (img<24) then img:=img+1;
   if img>24 then img:=24;
  end;
  if arq=2 then begin
   if(t='+') and (img<35) then img:=img+1;
   if img>35 then img:=35;
  end;
  if arq=3 then begin
   if(t='+') and (img<31) then img:=img+1;
   if img>31 then img:=31;
  end;
  if arq=4 then begin
   if(t='+') and (img<87) then img:=img+1;
   if img>87 then img:=87;
  end;
  if arq=5 then begin
   if(t='+') and (img<55) then img:=img+1;
   if img>55 then img:=55;
  end;

  if t=#13 then begin
   fase.arq[x,y]:=arq;
   fase.gra[x,y]:=img;
   fase.hori[x,y]:=hori;
  end;
  if t=#8 then begin
   fase.arq[x,y]:=0;
   fase.gra[x,y]:=0;
   fase.hori[x,y]:=0;
  end;

  if UpCase(t)='G' then Grava;
  if UpCase(t)='L' then Le;

  if t='.' then begin
   case fase.tipo of
    1 : fase.tipo:=2;
    2 : fase.tipo:=3;
    3 : fase.tipo:=4;
    4 : fase.tipo:=5;
    5 : fase.tipo:=1;
   end;
  end;

 until t=#27;

 ReadLn;


 SetText;
 ShutDown(1);

End.

