{$G+}
{
  DGM Font v3.0 for 320x200x256 video mode.

  Copyright (c) 1999 David Maziero / DGM Informatica

  Biblioteca para exibicao de DGM Fonts v3.0.

  OBS : Carregamento de ate 4 fontes simultaneas.

  Data : 14/10/1999
}

 Unit DGMFont;

 interface

 type
  { Define Letras 4x4 }
   Letras4x4 = array[1..4,1..4] of Byte;
   Letras4x4s= array[32..124]   of Letras4x4;
     Font4x4 = ^Letras4x4s;

  { Define Letras 5x5 }
   Letras5x5 = array[1..5,1..5] of Byte;
   Letras5x5s= array[32..124]   of Letras5x5;
     Font5x5 = ^Letras5x5s;

  { Define Letras 8x8 }
   Letras8x8 = array[1..8,1..8] of Byte;
   Letras8x8s= array[32..124]   of Letras8x8;
     Font8x8 = ^Letras8x8s;

  { Define Letras 8x10 }
   Letras8x10 = array[1..8,1..10] of Byte;
   Letras8x10s= array[32..124]    of Letras8x10;
     Font8x10 = ^Letras8x10s;

  { Define Letras 10x10 }
   Letras10x10 = array[1..10,1..10] of Byte;
   Letras10x10s= array[32..124]    of Letras10x10;
     Font10x10 = ^Letras10x10s;

  { Define Letras 13x13 }
   Letras13x13 = array[1..13,1..13] of Byte;
   Letras13x13s= array[32..124]    of Letras13x13;
     Font13x13 = ^Letras13x13s;

  { Define Letras 16x16 }
   Letras16x16 = array[1..16,1..16] of Byte;
   Letras16x16s= array[32..124]    of Letras16x16;
     Font16x16 = ^Letras16x16s;

  { Define Letras 18x18 }
   Letras18x18 = array[1..18,1..18] of Byte;
   Letras18x18s= array[32..124]    of Letras18x18;
     Font18x18 = ^Letras18x18s;

  { Define Letras 20x20 }
   Letras20x20 = array[1..20,1..20] of Byte;
   Letras20x20s= array[32..124]    of Letras20x20;
     Font20x20 = ^Letras20x20s;

 var
  dgm_fname : array[1..4] of String[36];
  dgm_ftype : array[1..4] of String[6];
  dgm_fTX   : array[1..4] of Byte;       { Tamanho x da letra }
  dgm_fTY   : array[1..4] of Byte;       { Tamanho y da letra }
  dgm_fls   : array[1..4] of Word;       { Tamanho x*y da letra }
  dgm_fload : array[1..4] of Byte;       { 0 - n∆o carregada  1 - Carregada }
  dgm_espace : array[1..4] of Byte;      { Espaáo para os acentos }

   fonte4x4  : Font4x4;
   fonte5x5  : Font5x5;
   fonte8x8  : Font8x8;
   fonte8x10 : Font8x10;
   fonte10x10 : Font10x10;
   fonte13x13: Font13x13;
   fonte16x16: Font16x16;
   fonte18x18: Font18x18;
   fonte20x20: Font20x20;

 procedure DGMInitFonts;
 procedure DGMLoadFont( font : Byte; nomearq : String; pos : LongInt; esp : Byte );
 procedure DGMFreeFont( font : Byte );
 procedure DGMOutText ( x,y : Integer; mess : String; font : Byte; where : Word; esp : Integer; z : Byte; cor : Integer );
 procedure DGMOutTextI( x,y : Integer; mess : String; font : Byte; where : Word; esp : Integer;z : Byte; cor : Integer );

 procedure DGMOutTextShadow( x,y : Integer; mess : String; font : Byte; where : word; esp : Integer; z : Byte;
                             corf,cors : Integer; italic : Byte );

 procedure DGMOutTextShadow2( x,y : Integer; mess : String; font : Byte; where : Word; esp : Integer; z : Byte;
                              corf,cors : Integer; italic : Byte; prof : Byte );


 implementation

 Uses Crt;

{***************************************************************************}
 procedure DGMInitFonts;
 var r : Byte;
 Begin
  for r:=1 to 4 do begin
   dgm_fname[r]:='';
   dgm_ftype[r]:='';
   dgm_fTX[r]:=0;
   dgm_fTY[r]:=0;
   dgm_fls[r]:=0;
   dgm_fload[r]:=0;
   dgm_espace[r]:=0;
  end;
 End;


{***************************************************************************}
 procedure DGMLoadFont( font : Byte; nomearq : String; pos : LongInt; esp : Byte );
 var op : Byte;
     f  : file;
 Begin

  if font>4 then font:=4;

  if dgm_fload[font]<>0 then DGMFreeFont( font );

 {$I-}
  Assign(f,nomearq); Reset(f,1);  { Abre o Arquivo }
 {$I+}

  if pos>0 then Seek(f,pos);   { Coloca na posiá∆o certa }

  BlockRead(f,dgm_fname[font],36);    { Le informaá‰es como : nome da fonte }
  BlockRead(f,dgm_ftype[font],6);     { e o tipo da fonte }

  op:=1;
  if dgm_ftype[font]='04x04' then begin dgm_Ftx[font]:=04; dgm_Fty[font]:=04; op:=1; end;
  if dgm_ftype[font]='05x05' then begin dgm_Ftx[font]:=05; dgm_Fty[font]:=05; op:=2; end;
  if dgm_ftype[font]='08x08' then begin dgm_Ftx[font]:=08; dgm_Fty[font]:=08; op:=3; end;
  if dgm_ftype[font]='08x10' then begin dgm_Ftx[font]:=08; dgm_Fty[font]:=10; op:=4; end;
  if dgm_ftype[font]='10x10' then begin dgm_Ftx[font]:=10; dgm_Fty[font]:=10; op:=5; end;
  if dgm_ftype[font]='13x13' then begin dgm_Ftx[font]:=13; dgm_Fty[font]:=13; op:=6; end;
  if dgm_ftype[font]='16x16' then begin dgm_Ftx[font]:=16; dgm_Fty[font]:=16; op:=7; end;
  if dgm_ftype[font]='18x18' then begin dgm_Ftx[font]:=18; dgm_Fty[font]:=18; op:=8; end;
  if dgm_ftype[font]='20x20' then begin dgm_Ftx[font]:=20; dgm_Fty[font]:=20; op:=9; end;

   dgm_fls[font]:=0+(dgm_Ftx[font] * dgm_Fty[font]);   { Calcula tamanho x*y da letra }

  { Aloca memoria para a fonte e carrega letra }
  if op=1 then begin GetMem( Fonte4x4,  SizeOf( Letras4x4s  )); BlockRead(f, Fonte4x4^  , SizeOf( Letras4x4s  ));  end;
  if op=2 then begin GetMem( Fonte5x5,  SizeOf( Letras5x5s  )); BlockRead(f, Fonte5x5^  , SizeOf( Letras5x5s  ));  end;
  if op=3 then begin GetMem( Fonte8x8,  SizeOf( Letras8x8s  )); BlockRead(f, Fonte8x8^  , SizeOf( Letras8x8s  ));  end;
  if op=4 then begin GetMem( Fonte8x10, SizeOf( Letras8x10s )); BlockRead(f, Fonte8x10^ , SizeOf( Letras8x10s  )); end;
  if op=5 then begin GetMem( Fonte10x10,SizeOf( Letras10x10s)); BlockRead(f, Fonte10x10^, SizeOf( Letras10x10s )); end;
  if op=6 then begin GetMem( Fonte13x13,SizeOf( Letras13x13s)); BlockRead(f, Fonte13x13^, SizeOf( Letras13x13s )); end;
  if op=7 then begin GetMem( Fonte16x16,SizeOf( Letras16x16s)); BlockRead(f, Fonte16x16^, SizeOf( Letras16x16s )); end;
  if op=8 then begin GetMem( Fonte18x18,SizeOf( Letras18x18s)); BlockRead(f, Fonte18x18^, SizeOf( Letras18x18s )); end;
  if op=9 then begin GetMem( Fonte20x20,SizeOf( Letras20x20s)); BlockRead(f, Fonte20x20^, SizeOf( Letras20x20s )); end;

  Close(f);

 {$I+}

  if IORESULT=0 then begin
   dgm_fload[font]:=1;
   dgm_espace[font]:=esp;
  end;

  if IORESULT<>0 then begin
   sound(100); delay(200); nosound;
   asm
    mov ax,0003h
    int 10h
   end;
   WriteLN(' Erro ao carregar as fontes - Erro #F100 - DGM. ');
   Halt(1);
  end;

 End;


{***************************************************************************}
 procedure DGMFreeFont( font : Byte );
 Begin

  if dgm_fload[font]=0 then Exit;

  if dgm_ftype[font]='04x04' then FreeMem( Fonte4x4,   SizeOf( Letras4x4s  ));
  if dgm_ftype[font]='05x05' then FreeMem( Fonte5x5,   SizeOf( Letras5x5s  ));
  if dgm_ftype[font]='08x08' then FreeMem( Fonte8x8,   SizeOf( Letras8x8s  ));
  if dgm_ftype[font]='08x10' then FreeMem( Fonte8x10,  SizeOf( Letras8x10s ));
  if dgm_ftype[font]='10x10' then FreeMem( Fonte10x10, SizeOf( Letras10x10s));
  if dgm_ftype[font]='13x13' then FreeMem( Fonte13x13, SizeOf( Letras13x13s));
  if dgm_ftype[font]='16x16' then FreeMem( Fonte16x16, SizeOf( Letras16x16s));
  if dgm_ftype[font]='18x18' then FreeMem( Fonte18x18, SizeOf( Letras18x18s));
  if dgm_ftype[font]='20x20' then FreeMem( Fonte20x20, SizeOf( Letras20x20s));

 End;


{***************************************************************************}
 procedure DGMPutLetter( x,y : Integer; segm,ofst : Word; where : Word; tx,ty,tm : Word; cor : integer ); Assembler;
 var vx : Word;
     vx2,vy : Integer;
 Asm
  push ds  { Salva registrador DS }

  { Movimenta ponteiro ES:DI para inicio da letra }
  mov ax, segm
  mov es, ax
  mov ax, ofst
  mov di, ax

  { Movimente destino DS:SI para posiá∆o x e y (tela ou t.v.) }
  mov ax, where
  mov ds, ax
  xor si, si
  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx

  { Comeáa a plotar a letra }

  mov cx, ty   { Contador de linhas }
  mov ax, y
  mov vy, ax
 @1:
  mov ax, tx
  mov vx, ax   { Contador vx para colunas }
  mov ax, x
  mov vx2,ax
 @2:
  cmp vx2,319
  jg  @3
  cmp vx2,0
  jl  @3
  mov al,es:[di]   { Pega ponto }
  cmp al,0         { Se for zero, n∆o coloca }
  je  @3
  add al,byte ptr cor
  mov ds:[si],al   { Plota no destino }
 @3:
  inc vx2
  add di,tx
  inc si
  dec vx
  jnz @2
  sub di,tm
  inc di
  add si,320
  sub si,tx
  inc vy
  cmp vy,199
  jg  @4
  dec cx
  jnz @1
 @4:
  pop ds

 End;


{***************************************************************************}
 procedure DGMPutLetterZ( x,y : Integer; segm,ofst : Word; where : Word; tx,ty,tm : Word; cor : Integer ); Assembler;
 var vx : Word;
     vx2,vy : Integer;
 Asm
  push ds  { Salva registrador DS }

  { Movimenta ponteiro ES:DI para inicio da letra }
  mov ax, segm
  mov es, ax
  mov ax, ofst
  mov di, ax

  { Movimente destino DS:SI para posiá∆o x e y (tela ou t.v.) }
  mov ax, where
  mov ds, ax
  xor si, si
  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx

  { Comeáa a plotar a letra }

  mov cx, ty   { Contador de linhas }
  mov ax, y
  mov vy, ax
 @1:
  mov ax, tx
  mov vx, ax   { Contador vx para colunas }
  mov ax, x
  mov vx2,ax
 @2:
  cmp vx2,319
  jg  @3
  cmp vx2,0
  jl  @3
  mov al,es:[di]   { Pega ponto }
  add al,byte ptr cor
  mov ds:[si],al   { Plota no destino }
 @3:
  inc vx2
  add di,tx
  inc si
  dec vx
  jnz @2
  sub di,tm
  inc di
  add si,320
  sub si,tx
  inc vy
  cmp vy,199
  jg  @4
  dec cx
  jnz @1
 @4:
  pop ds

 End;



{***************************************************************************}
 procedure DGMOutText ( x,y : Integer; mess : String; font : Byte; where : Word; esp : Integer; z : Byte; cor : Integer );
 var r : Byte;
     segm,ofst,addr2 : Word;
     c,bc : Word;
 Begin

  if dgm_fload[font]=0 then Exit;

  ofst:=0;
  segm:=0; addr2:=0;
  { Verifica o segmento da fonte }
  if dgm_ftype[font]='04x04' then segm:=Seg( Fonte4x4^   );
  if dgm_ftype[font]='05x05' then segm:=Seg( Fonte5x5^   );
  if dgm_ftype[font]='08x08' then segm:=Seg( Fonte8x8^   );
  if dgm_ftype[font]='08x10' then segm:=Seg( Fonte8x10^  );
  if dgm_ftype[font]='10x10' then segm:=Seg( Fonte10x10^ );
  if dgm_ftype[font]='13x13' then segm:=Seg( Fonte13x13^ );
  if dgm_ftype[font]='16x16' then segm:=Seg( Fonte16x16^ );
  if dgm_ftype[font]='18x18' then segm:=Seg( Fonte18x18^ );
  if dgm_ftype[font]='20x20' then segm:=Seg( Fonte20x20^ );

  if dgm_ftype[font]='04x04' then addr2:=ofs( Fonte4x4^   );
  if dgm_ftype[font]='05x05' then addr2:=ofs( Fonte5x5^   );
  if dgm_ftype[font]='08x08' then addr2:=ofs( Fonte8x8^   );
  if dgm_ftype[font]='08x10' then addr2:=ofs( Fonte8x10^  );
  if dgm_ftype[font]='10x10' then addr2:=ofs( Fonte10x10^ );
  if dgm_ftype[font]='13x13' then addr2:=ofs( Fonte13x13^ );
  if dgm_ftype[font]='16x16' then addr2:=ofs( Fonte16x16^ );
  if dgm_ftype[font]='18x18' then addr2:=ofs( Fonte18x18^ );
  if dgm_ftype[font]='20x20' then addr2:=ofs( Fonte20x20^ );

{  directvideo:=FALSE;
  textcolor(240);
  write(' ',dgm_fls[font],' ');
  dgm_fls[font]:=400; }

  if y<dgm_espace[font]-dgm_fty[font] then Exit;
  if y>199 then Exit;
  c:=0;
  for r:=1 to Length(mess) do begin
   bc:=c;
   c:=ord(mess[r]);
   ofst :=0+ addr2 + (dgm_fls[font] * (c-32));


   {    '         ^         `          {         |   }

   if(c=39) or (c=94) or (c=96) or (c=123) or (c=124) then y:=y - dgm_espace[font];
   if(bc=67) and (c=44) or (bc=99) and (c=44) then begin
    x:=x - (dgm_ftx[font] + esp); y:=y + dgm_espace[font];
   end;
   if z<>1 then DGMPutLetter( x,y, segm, ofst, where, dgm_ftx[font],dgm_fty[font],dgm_fls[font],cor );
   if z=1  then DGMPutLetterZ( x,y, segm, ofst, where, dgm_ftx[font],dgm_fty[font],dgm_fls[font],cor );
   x:=x + dgm_ftx[font] + esp;
   if(c=39) or (c=94) or (c=96) or (c=123) or (c=124) then begin
    x:=x - (dgm_ftx[font] + esp);  y:=y + dgm_espace[font]; end;
   if x>319 then Exit;
   if(bc=67) and (c=44) or (bc=99) and (c=44) then begin
    {x:=x + (dgm_ftx[font] + esp);}
     y:=y - dgm_espace[font];
   end;

  end;

 End;


{***************************************************************************}
 procedure DGMPutLetterI( x,y : Integer; segm,ofst : Word; where : Word; tx,ty,tm : Word; cor : Integer ); Assembler;
 var vx : Word;
     vx2,vy : Integer;
 Asm
  push ds  { Salva registrador DS }

  mov ax,tx
  add x,ax

  { Movimenta ponteiro ES:DI para inicio da letra }
  mov ax, segm
  mov es, ax
  mov ax, ofst
  mov di, ax


  { Movimente destino DS:SI para posiá∆o x e y (tela ou t.v.) }
  mov ax, where
  mov ds, ax
  xor si, si
  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx

  { Comeáa a plotar a letra }

  mov cx, ty   { Contador de linhas }
  mov ax, y
  mov vy, ax
 @1:
  mov ax, tx
  mov vx, ax   { Contador vx para colunas }
  mov ax, x
  mov vx2,ax
 @2:
  cmp vx2,319
  jg  @3
  cmp vx2,0
  jl  @3
  mov al,es:[di]   { Pega ponto }
  cmp al,0         { Se for zero, n∆o coloca }
  je  @3
  add al,byte ptr cor
  mov ds:[si],al   { Plota no destino }
 @3:
  inc vx2
  add di,tx
  inc si
  dec vx
  jnz @2
  sub di,tm
  inc di
  add si,320
  sub si,tx
  dec si
  inc vy
  cmp vy,199
  jg  @4
  dec cx
  jnz @1
 @4:
  pop ds

 End;


{***************************************************************************}
 procedure DGMPutLetterZI( x,y : Integer; segm,ofst : Word; where : Word; tx,ty,tm : Word; cor : Integer ); Assembler;
 var vx : Word;
     vx2,vy : Integer;
 Asm
  push ds  { Salva registrador DS }

  mov ax,tx
  add x,ax

  { Movimenta ponteiro ES:DI para inicio da letra }
  mov ax, segm
  mov es, ax
  mov ax, ofst
  mov di, ax

  { Movimente destino DS:SI para posiá∆o x e y (tela ou t.v.) }
  mov ax, where
  mov ds, ax
  xor si, si
  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx

  { Comeáa a plotar a letra }

  mov cx, ty   { Contador de linhas }
  mov ax, y
  mov vy, ax
 @1:
  mov ax, tx
  mov vx, ax   { Contador vx para colunas }
  mov ax, x
  mov vx2,ax
 @2:
  cmp vx2,319
  jg  @3
  cmp vx2,0
  jl  @3
  mov al,es:[di]   { Pega ponto }
  add al,byte ptr cor
  mov ds:[si],al   { Plota no destino }
 @3:
  inc vx2
  add di,tx
  inc si
  dec vx
  jnz @2
  sub di,tm
  inc di
  add si,320
  sub si,tx
  dec si
  inc vy
  cmp vy,199
  jg  @4
  dec cx
  jnz @1
 @4:
  pop ds

 End;



{***************************************************************************}
 procedure DGMOutTextI( x,y : Integer; mess : String; font : Byte; where : Word; esp : Integer;  z : Byte; cor : Integer );
 var r : Byte;
     segm,ofst,addr2 : Word;
     c,bc : Word;
 Begin

  if dgm_fload[font]=0 then Exit;

  ofst:=0;
  { Verifica o segmento da fonte }
  if dgm_ftype[font]='04x04' then segm:=Seg( Fonte4x4^   );
  if dgm_ftype[font]='05x05' then segm:=Seg( Fonte5x5^   );
  if dgm_ftype[font]='08x08' then segm:=Seg( Fonte8x8^   );
  if dgm_ftype[font]='08x10' then segm:=Seg( Fonte8x10^  );
  if dgm_ftype[font]='10x10' then segm:=Seg( Fonte10x10^ );
  if dgm_ftype[font]='13x13' then segm:=Seg( Fonte13x13^ );
  if dgm_ftype[font]='16x16' then segm:=Seg( Fonte16x16^ );
  if dgm_ftype[font]='18x18' then segm:=Seg( Fonte18x18^ );
  if dgm_ftype[font]='20x20' then segm:=Seg( Fonte20x20^ );

  if dgm_ftype[font]='04x04' then addr2:=ofs( Fonte4x4^   );
  if dgm_ftype[font]='05x05' then addr2:=ofs( Fonte5x5^   );
  if dgm_ftype[font]='08x08' then addr2:=ofs( Fonte8x8^   );
  if dgm_ftype[font]='08x10' then addr2:=ofs( Fonte8x10^  );
  if dgm_ftype[font]='10x10' then addr2:=ofs( Fonte10x10^ );
  if dgm_ftype[font]='13x13' then addr2:=ofs( Fonte13x13^ );
  if dgm_ftype[font]='16x16' then addr2:=ofs( Fonte16x16^ );
  if dgm_ftype[font]='18x18' then addr2:=ofs( Fonte18x18^ );
  if dgm_ftype[font]='20x20' then addr2:=ofs( Fonte20x20^ );




  if y<dgm_espace[font]-dgm_fty[font] then Exit;
  if y>199 then Exit;
  c:=0;
  for r:=1 to Length(mess) do begin
   bc:=c;
   c:=ord(mess[r]);
   ofst := addr2 + dgm_fls[font] * (c-32);
   if(c=39) or (c=94) or (c=96) or (c=123) or (c=124) then y:=y - dgm_espace[font];
   if(bc=67) and (c=44) or (bc=99) and (c=44) then begin
    x:=x - (dgm_ftx[font] + esp); y:=y + dgm_espace[font];
   end;
   if z<>1 then DGMPutLetterI( x,y, segm, ofst, where, dgm_ftx[font],dgm_fty[font],dgm_fls[font],cor );
   if z=1  then DGMPutLetterZI( x,y, segm, ofst, where, dgm_ftx[font],dgm_fty[font],dgm_fls[font],cor );
   x:=x + dgm_ftx[font] + esp;
   if(c=39) or (c=94) or (c=96) or (c=123) or (c=124) then begin
    x:=x - (dgm_ftx[font] + esp);  y:=y + dgm_espace[font]; end;
   if x>319 then Exit;
   if(bc=67) and (c=44) or (bc=99) and (c=44) then begin
    {x:=x + (dgm_ftx[font] + esp);}
     y:=y - dgm_espace[font];
   end;

  end;

 End;


{***************************************************************************}
 procedure DGMOutTextShadow( x,y : Integer; mess : String; font : Byte; where : Word; esp : Integer; z : Byte;
  corf,cors : Integer;
                             italic : Byte );
 var r : Byte;
     segm,ofst : Word;
     c,bc : Word;
 Begin

 if italic=1 then begin
  DGMOutTextI( x-1,y-1,mess,font,where,esp,z,cors );
  DGMOutTextI( x-1,y  ,mess,font,where,esp,z,cors );
  DGMOutTextI( x-1,y+1,mess,font,where,esp,z,cors );
  DGMOutTextI( x  ,y-1,mess,font,where,esp,z,cors );
  DGMOutTextI( x  ,y+1,mess,font,where,esp,z,cors );
  DGMOutTextI( x+1,y-1,mess,font,where,esp,z,cors );
  DGMOutTextI( x+1,y  ,mess,font,where,esp,z,cors );
  DGMOutTextI( x+1,y+1,mess,font,where,esp,z,cors );
  DGMOutTextI( x  ,y  ,mess,font,where,esp,z,corf );
 end else begin
  DGMOutText( x-1,y-1,mess,font,where,esp,z,cors );
  DGMOutText( x-1,y  ,mess,font,where,esp,z,cors );
  DGMOutText( x-1,y+1,mess,font,where,esp,z,cors );
  DGMOutText( x  ,y-1,mess,font,where,esp,z,cors );
  DGMOutText( x  ,y+1,mess,font,where,esp,z,cors );
  DGMOutText( x+1,y-1,mess,font,where,esp,z,cors );
  DGMOutText( x+1,y  ,mess,font,where,esp,z,cors );
  DGMOutText( x+1,y+1,mess,font,where,esp,z,cors );
  DGMOutText( x  ,y  ,mess,font,where,esp,z,corf );
 end;

 End;


{***************************************************************************}
 procedure DGMOutTextShadow2( x,y : Integer; mess : String; font : Byte; where : Word; esp : Integer; z : Byte;
 corf,cors : Integer;
                             italic : Byte; prof : Byte );
 var r : Byte;
     segm,ofst : Word;
     c,bc : Word;
     w : word;
 Begin

 if italic=1 then begin
  x:=x-prof; y:=y+prof;

  for w:=1 to prof do begin

   if w=prof then begin
    DGMOutTextI( x  ,y  ,mess,font,where,esp,z,corf );
   end else begin
    DGMOutTextI( x  ,y  ,mess,font,where,esp,z,cors );
   end;
   x:=x+1;
   y:=y-1;

  end;

 end else begin
  x:=x-prof; y:=y+prof;

  for w:=1 to prof do begin

   if w=prof then begin
    DGMOutText( x  ,y  ,mess,font,where,esp,z,corf );
   end else begin
    DGMOutText( x  ,y  ,mess,font,where,esp,z,cors );
   end;
   x:=x+1;
   y:=y-1;

 end;
 end;

 End;




End.
