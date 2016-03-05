{$X+}
{
  DGM Font Editor v3.0 for 320x200x256 video mode.

  Copyright (c) 1999 David Maziero / DGM Inform tica

  Data : 14/10/1999
}

  Uses Crt,Dos,DMode13H,Divrf;


  type

  { Define Letras 4x4 }
   Letras4x4 = array[1..4,1..4] of Byte;
   Letras4x4s= array[32..124]   of Letras4x4;
     Font4x4 = ^Letras4x4s;
{     Font4x4f= file of Font4x4;  NÆo precisa disso! }

  { Define Letras 5x5 }
   Letras5x5 = array[1..5,1..5] of Byte;
   Letras5x5s= array[32..124]   of Letras5x5;
     Font5x5 = ^Letras5x5s;
     Font5x5f= file of Font5x5;

  { Define Letras 8x8 }
   Letras8x8 = array[1..8,1..8] of Byte;
   Letras8x8s= array[32..124]   of Letras8x8;
     Font8x8 = ^Letras8x8s;
     Font8x8f= file of Font8x8;

  { Define Letras 8x10 }
   Letras8x10 = array[1..8,1..10] of Byte;
   Letras8x10s= array[32..124]    of Letras8x10;
     Font8x10 = ^Letras8x10s;
     Font8x10f= file of Font8x10;

  { Define Letras 10x10 }
   Letras10x10 = array[1..10,1..10] of Byte;
   Letras10x10s= array[32..124]    of Letras10x10;
     Font10x10 = ^Letras10x10s;
     Font10x10f= file of Font10x10;

  { Define Letras 13x13 }
   Letras13x13 = array[1..13,1..13] of Byte;
   Letras13x13s= array[32..124]    of Letras13x13;
     Font13x13 = ^Letras13x13s;
     Font13x13f= file of Font13x13;

  { Define Letras 16x16 }
   Letras16x16 = array[1..16,1..16] of Byte;
   Letras16x16s= array[32..124]    of Letras16x16;
     Font16x16 = ^Letras16x16s;
     Font16x16f= file of Font16x16;

  { Define Letras 18x18 }
   Letras18x18 = array[1..18,1..18] of Byte;
   Letras18x18s= array[32..124]    of Letras18x18;
     Font18x18 = ^Letras18x18s;
     Font18x18f= file of Font18x18;

  { Define Letras 20x20 }
   Letras20x20 = array[1..20,1..20] of Byte;
   Letras20x20s= array[32..124]    of Letras20x20;
     Font20x20 = ^Letras20x20s;
     Font20x20f= file of Font20x20;

  var
   t : Char;
   op: Byte;
   x,y : Byte;
   tx,ty : Byte;
   cor : Byte;
   s   : PathStr;
   P: PathStr;
   D: DirStr;
   N: NameStr;
   E: ExtStr;
   st,nome : String;
   max : Word;
   fontname : String[35];
   fonttype : String[5];
   fonttype2: String[5];

   fonte4x4  : Font4x4;
   fonte5x5  : Font5x5;
   fonte8x8  : Font8x8;
   fonte8x10 : Font8x10;
   fonte10x10 : Font10x10;
   fonte13x13: Font13x13;
   fonte16x16: Font16x16;
   fonte18x18: Font18x18;
   fonte20x20: Font20x20;

   f : file;
   back : Byte;
   r,r2 : word;
   ex : Byte;
   pal : array[0..255,1..3] of Byte; { V riavel de pallete DGM }

  procedure Despede;
  Begin
   WriteLn;
   WriteLn(' DGM. ');
   WriteLn; WriteLn; Halt(1);
  End;

  procedure PoeLetra( r : Word );
  var
   ex,ey : Word;
  Begin
   for ey:=1 to ty do begin
   for ex:=1 to tx do begin
    if op=1 then begin fonttype:='04x04'; PutPixel(47+ex,47+ey,   Fonte4x4^[r,ex,ey],vaddr); end;
    if op=2 then begin fonttype:='05x05'; PutPixel(47+ex,47+ey,   Fonte5x5^[r,ex,ey],vaddr); end;
    if op=3 then begin fonttype:='08x08'; PutPixel(47+ex,47+ey,   Fonte8x8^[r,ex,ey],vaddr); end;
    if op=4 then begin fonttype:='08x10'; PutPixel(47+ex,47+ey,  Fonte8x10^[r,ex,ey],vaddr); end;
    if op=5 then begin fonttype:='010x10'; PutPixel(47+ex,47+ey,  Fonte10x10^[r,ex,ey],vaddr); end;
    if op=6 then begin fonttype:='13x13'; PutPixel(47+ex,47+ey, Fonte13x13^[r,ex,ey],vaddr); end;
    if op=7 then begin fonttype:='16x16'; PutPixel(47+ex,47+ey, Fonte16x16^[r,ex,ey],vaddr); end;
    if op=8 then begin fonttype:='18x18'; PutPixel(47+ex,47+ey, Fonte18x18^[r,ex,ey],vaddr); end;
    if op=9 then begin fonttype:='20x20'; PutPixel(47+ex,47+ey, Fonte20x20^[r,ex,ey],vaddr); end;
   end;
   end;
  end;

  procedure PoeLetra2( x,y : Word; r : Word );
  var
   ex,ey : Word;
  Begin
   for ey:=1 to ty do begin
   for ex:=1 to tx do begin
    if op=1 then begin fonttype:='04x04'; PutPixel(x+ex,y+ey,   Fonte4x4^[r,ex,ey],vaddr); end;
    if op=2 then begin fonttype:='05x05'; PutPixel(x+ex,y+ey,   Fonte5x5^[r,ex,ey],vaddr); end;
    if op=3 then begin fonttype:='08x08'; PutPixel(x+ex,y+ey,   Fonte8x8^[r,ex,ey],vaddr); end;
    if op=4 then begin fonttype:='08x10'; PutPixel(x+ex,y+ey,  Fonte8x10^[r,ex,ey],vaddr); end;
    if op=5 then begin fonttype:='010x10'; PutPixel(x+ex,y+ey,  Fonte10x10^[r,ex,ey],vaddr); end;
    if op=6 then begin fonttype:='13x13'; PutPixel(x+ex,y+ey, Fonte13x13^[r,ex,ey],vaddr); end;
    if op=7 then begin fonttype:='16x16'; PutPixel(x+ex,y+ey, Fonte16x16^[r,ex,ey],vaddr); end;
    if op=8 then begin fonttype:='18x18'; PutPixel(x+ex,y+ey, Fonte18x18^[r,ex,ey],vaddr); end;
    if op=9 then begin fonttype:='20x20'; PutPixel(x+ex,y+ey, Fonte20x20^[r,ex,ey],vaddr); end;
   end;
   end;
  End;

  var
   wx,wy,cr : Word;
   cx,cy : Integer;
   cuzao : Pointer;
   backcor : Byte;
  Begin
   GetMem( Fonte4x4  , SizeOf( Letras4x4s  ) );
   GetMem( Fonte5x5  , SizeOf( Letras5x5s  ) );
   GetMem( Fonte8x8  , SizeOf( Letras8x8s  ) );
   GetMem( Fonte8x10 , SizeOf( Letras8x10s ) );
   GetMem( Fonte10x10, SizeOf( Letras10x10s ) );
   GetMem( Fonte13x13, SizeOf( Letras13x13s) );
   GetMem( Fonte16x16, SizeOf( Letras16x16s) );
   GetMem( Fonte18x18, SizeOf( Letras18x18s) );
   GetMem( Fonte20x20, SizeOf( Letras20x20s) );

   for r:=32 to 124 do for y:=1  to 04 do for x:=1 to 04  do Fonte4x4^[r,x,y]:=0;
   for r:=32 to 124 do for y:=1  to 05 do for x:=1 to 05  do Fonte5x5^[r,x,y]:=0;
   for r:=32 to 124 do for y:=1  to 08 do for x:=1 to 08  do Fonte8x8^[r,x,y]:=0;
   for r:=32 to 124 do for y:=1  to 08 do for x:=1 to 10  do Fonte8x10^[r,x,y]:=0;
   for r:=32 to 124 do for y:=1  to 10 do for x:=1 to 10  do Fonte10x10^[r,x,y]:=0;
   for r:=32 to 124 do for y:=1  to 13 do for x:=1 to 13  do Fonte13x13^[r,x,y]:=0;
   for r:=32 to 124 do for y:=1  to 16 do for x:=1 to 16  do Fonte16x16^[r,x,y]:=0;
   for r:=32 to 124 do for y:=1  to 18 do for x:=1 to 18  do Fonte18x18^[r,x,y]:=0;
   for r:=32 to 124 do for y:=1  to 20 do for x:=1 to 20  do Fonte20x20^[r,x,y]:=0;


   ClrScr;
   WriteLn('DGM Font Editor v3.0 for 320x200x256 video mode.');
   WriteLn('Copyright (c) 1999 David Maziero / DGM Inform tica');
   WriteLn;
   WriteLn(' Escolha o tipo de fonte a ser criada : ');
   WriteLn('  1 - 4x4   Super Small Font ' );
   WriteLn('  2 - 5x5   Small Font       ' );
   WriteLn('  3 - 8x8   Normal Font      ' );
   WriteLn('  4 - 8x10  Normal Font      ' );
   WriteLn('  5 - 10x10 VGA Font         ' );
   WriteLn('  6 - 13x13 Big Font         ' );
   WriteLn('  7 - 16x16 Big Font         ' );
   WriteLn('  8 - 18x18 Bigest Font      ' );
   WriteLn('  9 - 20x20 Giga Font        ' );
   t:=perg('123456789'+chr(27));
   if t=#27 then Despede;
   op:=Val2(t);

   if op=1 then begin fonttype:='04x04'; tx:=04; ty:=04; end;
   if op=2 then begin fonttype:='05x05'; tx:=05; ty:=05; end;
   if op=3 then begin fonttype:='08x08'; tx:=08; ty:=08; end;
   if op=4 then begin fonttype:='08x10'; tx:=08; ty:=10; end;
   if op=5 then begin fonttype:='10x10'; tx:=10; ty:=10; end;
   if op=6 then begin fonttype:='13x13'; tx:=13; ty:=13; end;
   if op=7 then begin fonttype:='16x16'; tx:=16; ty:=16; end;
   if op=8 then begin fonttype:='18x18'; tx:=18; ty:=18; end;
   if op=9 then begin fonttype:='20x20'; tx:=20; ty:=20; end;

   WriteLn;
   Write(' Entre com o nome do arquivo : ');
   ReadLn(P);

   FSplit(P, D, N, E);
   if N = '' then N:='NONAME';
   if E = '' then E:='.FNT';
   Nome := D + N + E;
   WriteLn(' Nome do arquivo : ',nome);

{   ESQUEMA BµSICO DE UM ARQUIVO DE FONTE DGM V3.0

     1 - Nome da Fonte (36 caracteres)
     2 - Especifica‡Æo 00x00 (6 caracteres) ex. 04x04 ou 010x10 etc.
     3 - A fonte em si.                                                      }

   S:=FSearch(nome,'');
   if s<>'' then begin

    Assign(f,nome); Reset(f,1);
    BlockRead(f,fontname,36);
    BlockRead(f,fonttype2,6);

    WriteLn(' Nome da Fonte : (',fontname,') ');
    WriteLn(' Tipo da Fonte : ',fonttype2);

    if fonttype2='04x04' then begin fonttype:='04x04'; tx:=04; ty:=04; op:=1; end;
    if fonttype2='05x05' then begin fonttype:='05x05'; tx:=05; ty:=05; op:=2; end;
    if fonttype2='08x08' then begin fonttype:='08x08'; tx:=08; ty:=08; op:=3; end;
    if fonttype2='08x10' then begin fonttype:='08x10'; tx:=08; ty:=10; op:=4; end;
    if fonttype2='10x10' then begin fonttype:='10x10'; tx:=10; ty:=10; op:=5; end;
    if fonttype2='13x13' then begin fonttype:='13x13'; tx:=13; ty:=13; op:=6; end;
    if fonttype2='16x16' then begin fonttype:='16x16'; tx:=16; ty:=16; op:=7; end;
    if fonttype2='18x18' then begin fonttype:='18x18'; tx:=18; ty:=18; op:=8; end;
    if fonttype2='20x20' then begin fonttype:='20x20'; tx:=20; ty:=20; op:=9; end;

      if op=1 then BlockRead(f, Fonte4x4^  , SizeOf( Letras4x4s  ));
      if op=2 then BlockRead(f, Fonte5x5^  , SizeOf( Letras5x5s  ));
      if op=3 then BlockRead(f, Fonte8x8^  , SizeOf( Letras8x8s  ));
      if op=4 then BlockRead(f, Fonte8x10^ , SizeOf( Letras8x10s  ));
      if op=5 then BlockRead(f, Fonte10x10^, SizeOf( Letras10x10s ));
      if op=6 then BlockRead(f, Fonte13x13^, SizeOf( Letras13x13s ));
      if op=7 then BlockRead(f, Fonte16x16^, SizeOf( Letras16x16s ));
      if op=8 then BlockRead(f, Fonte18x18^, SizeOf( Letras18x18s ));
      if op=9 then BlockRead(f, Fonte20x20^, SizeOf( Letras20x20s ));

    Close(f);

    WriteLn(' Deseja alterar o nome da fonte ? (S/N)');
    t:=perg('SNsn'+chr(13));
    if upcase(t)='S' then begin
     Write(' Entre com o novo nome : (                                   )');
     GotoXY(wherex-36,wherey);
     ReadLn( fontname );
     Assign(f,nome);
     ReWrite(f,1);
     BlockWrite(f,fontname,36);
     BlockWrite(f,fonttype2,6);
     close(f);
    end;

   end else begin
    Write(' Entre com o nome da fonte (35 Char.) : (                                   )');
    GotoXY(wherex-36,wherey);
    ReadLn( fontname );
    WriteLn(' Tipo da fonte : ',fonttype );

    Assign(f,nome);
    ReWrite(f,1);
    BlockWrite(f,fontname,36);
    BlockWrite(f,fonttype,6);
    close(f);
   end;

   DirectVideo:=False;

   SetMCGA;

{   Assign(f,'d:\dgm\draw7\grey.pal'); Reset(f,1); Seek(f,41);
   BlockRead(f,pal,sizeof(pal)); close(f);
   for r:=0 to 255 do SetPal(r,pal[r,1],pal[r,2],pal[r,3]);
 }
   Assign(f,'c:\dgm\draw7\dgmnorm.pal'); Reset(f,1); Seek(f,41);
   BlockRead(f,pal,sizeof(pal)); close(f);
   for r:=0 to 255 do SetPal(r,pal[r,1],pal[r,2],pal[r,3]);


    Pal[0,1]:=000; Pal[0,2]:=000; Pal[0,3]:=000;
    Pal[1,1]:=255; Pal[1,2]:=255; Pal[1,3]:=255;
    SetPal(0,0,0,0);
    SetPal(1,0,0,0);
    SetPal(2,255,255,255);
   textcolor(2);
   SetUpVirtual(1);
   SetUpVirtual(2);
   Cls(vaddr,0);
   Cls(vaddr2,0);
   Cls(vga,0);

   t:=#0; while keypressed do t:=ReadKey;
   x:=1; y:=1; cor:=2; r2:=32; r:=1; ex:=0;

   SetPal(2,255,255,255);
     cx:=0; cy:=0;

   PoeLetra(r2);

   repeat

    PoeLetra(r2);

    PutPixel(47+x,47+y,cor,vaddr);

    line(250,165,290,165,cor-6,vaddr);
    line(250,166,290,166,cor-5,vaddr);
    line(250,167,290,167,cor-4,vaddr);
    line(250,168,290,168,cor-3,vaddr);
    line(250,169,290,169,cor-2,vaddr);
    line(250,170,290,170,cor-1,vaddr);
    line(240,171,290,171,cor,vaddr);
    line(250,172,290,172,cor+1,vaddr);
    line(250,173,290,173,cor+2,vaddr);
    line(250,174,290,174,cor+3,vaddr);
    line(250,175,290,175,cor+4,vaddr);
    line(250,176,290,176,cor+5,vaddr);
    line(250,177,290,177,cor+6,vaddr);

    flip(vaddr,vga);

    if ex=1 then begin GotoXY(7,7); Write(chr(r)); PutPixel(47+x,47+y,cor,vga);           end;
    GotoXY(1,21);
    Write('x=',x,' y=',y);
    GotoXY(1,22);
       if op=1 then backcor:=Fonte4x4^[r2,x,y]  ;
       if op=2 then backcor:=Fonte5x5^[r2,x,y]  ;
       if op=3 then backcor:=Fonte8x8^[r2,x,y]  ;
       if op=4 then backcor:=Fonte8x10^[r2,x,y] ;
       if op=5 then backcor:=Fonte10x10^[r2,x,y];
       if op=6 then backcor:=Fonte13x13^[r2,x,y];
       if op=7 then backcor:=Fonte16x16^[r2,x,y];
       if op=8 then backcor:=Fonte18x18^[r2,x,y];
       if op=9 then backcor:=Fonte20x20^[r2,x,y];


    Write('Caract. (',chr(r2),')  cor=',cor,' | ',backcor);

    t:=ReadKey;

    if t='@' then begin
     t:=#0;
     Assign(f,paramstr(1)); reset(f,1);
     blockread(f,wx,2); blockread(f,wy,2);
     cr:=BitMapAlloc(wx,wy,cuzao);
     seek(f,0); blockread(f,cuzao^,cr); close(f);
     flip(vga,vaddr2);

     while t<>#13 do begin
      putimage(cx,cy,cuzao,vaddr);
      Rectangle(46,46,49+tx,49+ty,2,vaddr);
      flip(vaddr,vga);
      t:=ReadKey;
      if t<>#13 then flip(vaddr2,vaddr);
      if t=#27 then break;
      if t=FRENTE then cx:=cx+1;
      if t=TRAS then cx:=cx-1;
      if t=CIMA then cy:=cy-1;
      if t=BAIXO then cy:=cy+1;
      if t='6' then cx:=cx+5;
      if t='4' then cx:=cx-5;
      if t='8' then cy:=cy-5;
      if t='2' then cy:=cy+5;
     end;
      if t=#13 then begin
       putimage(cx,cy,cuzao,vga);
       Rectangle(46,46,49+tx,49+ty,2,vga);
      end;
      BitMapFree(cuzao);
      t:=#0;
      limpateclado;

      for wy:=1 to ty do begin
      for wx:=1 to tx do begin
       if op=1 then Fonte4x4^[r2,wx,wy]  :=GetPixel(47+wx,47+wy,vga);
       if op=2 then Fonte5x5^[r2,wx,wy]  :=GetPixel(47+wx,47+wy,vga);
       if op=3 then Fonte8x8^[r2,wx,wy]  :=GetPixel(47+wx,47+wy,vga);
       if op=4 then Fonte8x10^[r2,wx,wy] :=GetPixel(47+wx,47+wy,vga);
       if op=5 then Fonte10x10^[r2,wx,wy]:=GetPixel(47+wx,47+wy,vga);
       if op=6 then Fonte13x13^[r2,wx,wy]:=GetPixel(47+wx,47+wy,vga);
       if op=7 then Fonte16x16^[r2,wx,wy]:=GetPixel(47+wx,47+wy,vga);
       if op=8 then Fonte18x18^[r2,wx,wy]:=GetPixel(47+wx,47+wy,vga);
       if op=9 then Fonte20x20^[r2,wx,wy]:=GetPixel(47+wx,47+wy,vga);
       putPixel(47+wx,47+wy,2,vga);
      end;
      end;
       r2:=r2+1;
       if r2>124 then r2:=124;
    end;


    if t='q' then begin

     if op=2 then begin
      for r2:=32 to 124 do begin
      for wy:=1 to 5 do begin
      for wx:=1 to 5 do begin
        if Fonte5x5^[r2,wx,wy]<>0 then begin
         if(wy=1) or (wy=5) then Fonte5x5^[r2,wx,wy]:=7;
         if(wy=2) or (wy=4) then Fonte5x5^[r2,wx,wy]:=10;
         if wy=3 then Fonte5x5^[r2,wx,wy]:=13;
        end;
      end;
      end;
      end;
      r2:=32;
     end;

     if op=3 then begin
      for r2:=32 to 124 do begin
      for wy:=1 to 8 do begin
      for wx:=1 to 8 do begin
        if Fonte8x8^[r2,wx,wy]<>0 then begin
         if wy=4 then Fonte8x8^[r2,wx,wy]:=13;
         if(wy=3) or (wy=5) then Fonte8x8^[r2,wx,wy]:=11;
         if(wy=2) or (wy=6) then Fonte8x8^[r2,wx,wy]:=09;
         if(wy=1) or (wy=7) then Fonte8x8^[r2,wx,wy]:=07;
         if wy=8 then Fonte8x8^[r2,wx,wy]:=06;
        end;
      end;
      end;
      end;
      r2:=32;
     end;


    end;

    if t='$' then begin
      for r2:=32 to 124 do begin
      for wy:=1 to ty do begin
      for wx:=1 to tx do begin
       if op=9 then begin
        if Fonte20x20^[r2,wx,wy]<>0 then begin
         if(Fonte20x20^[r2,wx,wy]>=5)   and (Fonte20x20^[r2,wx,wy]<25)   then Fonte20x20^[r2,wx,wy]:=04;
         if(Fonte20x20^[r2,wx,wy]>=25)  and (Fonte20x20^[r2,wx,wy]<50)   then Fonte20x20^[r2,wx,wy]:=05;
         if(Fonte20x20^[r2,wx,wy]>=50)  and (Fonte20x20^[r2,wx,wy]<75)   then Fonte20x20^[r2,wx,wy]:=06;
         if(Fonte20x20^[r2,wx,wy]>=75)  and (Fonte20x20^[r2,wx,wy]<100)  then Fonte20x20^[r2,wx,wy]:=07;
         if(Fonte20x20^[r2,wx,wy]>=100) and (Fonte20x20^[r2,wx,wy]<125)  then Fonte20x20^[r2,wx,wy]:=08;
         if(Fonte20x20^[r2,wx,wy]>=125) and (Fonte20x20^[r2,wx,wy]<150)  then Fonte20x20^[r2,wx,wy]:=09;
         if(Fonte20x20^[r2,wx,wy]>=150) and (Fonte20x20^[r2,wx,wy]<175)  then Fonte20x20^[r2,wx,wy]:=10;
         if(Fonte20x20^[r2,wx,wy]>=175) and (Fonte20x20^[r2,wx,wy]<200)  then Fonte20x20^[r2,wx,wy]:=11;
         if(Fonte20x20^[r2,wx,wy]>=200) and (Fonte20x20^[r2,wx,wy]<225)  then Fonte20x20^[r2,wx,wy]:=12;
         if(Fonte20x20^[r2,wx,wy]>=225) and (Fonte20x20^[r2,wx,wy]<=255) then Fonte20x20^[r2,wx,wy]:=13;
        end;
       end;
       if op=8 then begin
        if Fonte18x18^[r2,wx,wy]<>0 then begin
         if(Fonte18x18^[r2,wx,wy]>=5)   and (Fonte18x18^[r2,wx,wy]<25)   then Fonte18x18^[r2,wx,wy]:=04;
         if(Fonte18x18^[r2,wx,wy]>=25)  and (Fonte18x18^[r2,wx,wy]<50)   then Fonte18x18^[r2,wx,wy]:=05;
         if(Fonte18x18^[r2,wx,wy]>=50)  and (Fonte18x18^[r2,wx,wy]<75)   then Fonte18x18^[r2,wx,wy]:=06;
         if(Fonte18x18^[r2,wx,wy]>=75)  and (Fonte18x18^[r2,wx,wy]<100)  then Fonte18x18^[r2,wx,wy]:=07;
         if(Fonte18x18^[r2,wx,wy]>=100) and (Fonte18x18^[r2,wx,wy]<125)  then Fonte18x18^[r2,wx,wy]:=08;
         if(Fonte18x18^[r2,wx,wy]>=125) and (Fonte18x18^[r2,wx,wy]<150)  then Fonte18x18^[r2,wx,wy]:=09;
         if(Fonte18x18^[r2,wx,wy]>=150) and (Fonte18x18^[r2,wx,wy]<175)  then Fonte18x18^[r2,wx,wy]:=10;
         if(Fonte18x18^[r2,wx,wy]>=175) and (Fonte18x18^[r2,wx,wy]<200)  then Fonte18x18^[r2,wx,wy]:=11;
         if(Fonte18x18^[r2,wx,wy]>=200) and (Fonte18x18^[r2,wx,wy]<225)  then Fonte18x18^[r2,wx,wy]:=12;
         if(Fonte18x18^[r2,wx,wy]>=225) and (Fonte18x18^[r2,wx,wy]<=255) then Fonte18x18^[r2,wx,wy]:=13;
        end;
       end;

      end;
      end;
      end;
      r2:=33;
    end;

    if t=' ' then begin
     if op=1 then Fonte4x4^[r2,x,y]  :=cor;
     if op=2 then Fonte5x5^[r2,x,y]  :=cor;
     if op=3 then Fonte8x8^[r2,x,y]  :=cor;
     if op=4 then Fonte8x10^[r2,x,y] :=cor;
     if op=5 then Fonte10x10^[r2,x,y]:=cor;
     if op=6 then Fonte13x13^[r2,x,y]:=cor;
     if op=7 then Fonte16x16^[r2,x,y]:=cor;
     if op=8 then Fonte18x18^[r2,x,y]:=cor;
     if op=9 then Fonte20x20^[r2,x,y]:=cor;
    end;
    if t='c' then begin
     for wy:=1 to ty do begin
     for wx:=1 to tx do begin
      if op=1 then Fonte4x4^[r2,wx,wy]  :=0;
      if op=2 then Fonte5x5^[r2,wx,wy]  :=0;
      if op=3 then Fonte8x8^[r2,wx,wy]  :=0;
      if op=4 then Fonte8x10^[r2,wx,wy] :=0;
      if op=5 then Fonte10x10^[r2,wx,wy]:=0;
      if op=6 then Fonte13x13^[r2,wx,wy]:=0;
      if op=7 then Fonte16x16^[r2,wx,wy]:=0;
      if op=8 then Fonte18x18^[r2,wx,wy]:=0;
      if op=9 then Fonte20x20^[r2,wx,wy]:=0;
     end;
     end;
    end;


    if t=#8 then begin
     if op=1 then Fonte4x4^[r2,x,y]  :=0;
     if op=2 then Fonte5x5^[r2,x,y]  :=0;
     if op=3 then Fonte8x8^[r2,x,y]  :=0;
     if op=4 then Fonte8x10^[r2,x,y] :=0;
     if op=5 then Fonte10x10^[r2,x,y]:=0;
     if op=6 then Fonte13x13^[r2,x,y]:=0;
     if op=7 then Fonte16x16^[r2,x,y]:=0;
     if op=8 then Fonte18x18^[r2,x,y]:=0;
     if op=9 then Fonte20x20^[r2,x,y]:=0;
    end;

    if t='e' then begin
     if ex=0 then begin ex:=1; end else begin ex:=0; end;
    end;

    if(t=FRENTE) and (x<tx) then x:=x+1;
    if(t=TRAS)   and (x>1 ) then x:=x-1;
    if(t=BAIXO)  and (y<ty) then y:=y+1;
    if(t=CIMA)   and (y>1 ) then y:=y-1;

    if(t='1') and (x>1)    and (y<ty) then begin x:=x-1; y:=y+1; end;
    if(t='3') and (x<tx) and (y<ty) then begin x:=x+1; y:=y+1; end;

    if(t='7') and (x>1)    and (y>1) then begin x:=x-1; y:=y-1; end;
    if(t='9') and (x<tx) and (y>1) then begin x:=x+1; y:=y-1; end;

    Cls(vaddr,0);
    Rectangle(46,46,49+tx,49+ty,2,vaddr);
    back:=GetPixel(x,y,vaddr);

    if ex=1 then begin GotoXY(7,7); Write(chr(r)); end;

    if(t='.') and (r<256) then r:=r+1;
    if(t=',') and (r>0  ) then r:=r-1;

    if(t='*') and (r2<124) then begin r2:=r2+1; PoeLetra(r2); end;
    if(t='/') and (r2>32)  then begin r2:=r2-1; PoeLetra(r2); end;

    if(t='+') and (cor<256) then cor:=cor+1;
    if(t='-') and (cor>0  ) then cor:=cor-1;

    if t='t' then begin
     max:=320 div (tx+1);
     gotoXY(1,1);
     Write('Texto (m x ',max,') :');
     ReadLn(st);
     cls(vaddr,0);
     for r:=1 to length(st) do begin
      PoeLetra2((r-1)*tx+r,25,ord(st[r]));
     end;
     flip(vaddr,vga);
     ReadKey;
    end;

    if t='g' then begin
      Assign(f,nome); Reset(f,1); Seek(f,36+6); { Pula o nome e o tipo }
      if op=1 then BlockWrite(f, Fonte4x4^  , SizeOf( Letras4x4s  ));
      if op=2 then BlockWrite(f, Fonte5x5^  , SizeOf( Letras5x5s  ));
      if op=3 then BlockWrite(f, Fonte8x8^  , SizeOf( Letras8x8s  ));
      if op=4 then BlockWrite(f, Fonte8x10^ , SizeOf( Letras8x10s  ));
      if op=5 then BlockWrite(f, Fonte10x10^, SizeOf( Letras10x10s ));
      if op=6 then BlockWrite(f, Fonte13x13^, SizeOf( Letras13x13s ));
      if op=7 then BlockWrite(f, Fonte16x16^, SizeOf( Letras16x16s ));
      if op=8 then BlockWrite(f, Fonte18x18^, SizeOf( Letras18x18s ));
      if op=9 then BlockWrite(f, Fonte20x20^, SizeOf( Letras20x20s ));
      Close(f);
     end;


   until t=#27;

   ShutDown(1);
   SetText;
   WriteLn;
   WriteLn(' DGM.');
   WriteLn;
   WriteLn;
  End.