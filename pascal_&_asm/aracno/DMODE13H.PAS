{

   DGM Mode 13h Unit v1.0

   Copyright (c) 1999 David Maziero / DGM Informatica

   Data : 13/10/1999

   Biblioteca de funcoes Graficas 320x200x256 cores.

}

{$G+}

Unit DMode13H;

Interface

{USES crt;}

CONST VGA = $A000;
      MCGAerro1 : String = ' Seu v¡deo nÆo suporta modo VGA. '+chr(13)+chr(10)+' $';
      FRENTE  =  #77;
      TRAS    =  #75;
      BAIXO   =  #80;
      CIMA    =  #72;
      MAXX    =  320;
      MAXY    =  200;

TYPE Virtual = Array [1..64000] of byte;  { O Tamanho da tela virtual   }
     VirtPtr = ^Virtual;                  { Pointer para a tela virtual }
     PalType = array[0..255,1..3] of Byte; { pallete DGM }

VAR Virscr : VirtPtr;                     { Primeira tela virtual }
    Virscr2: VirtPtr;                     { Segunda tela virtual }
    Virscr3: VirtPtr;                     { Terceira tela virtual }
    Vaddr  : word;                        { O segmento da 1 tela virtual }
    Vaddr2 : Word;                        { O segmento da 2 tela virtual }
    Vaddr3 : Word;                        { O segmento da 3 tela virtual }
    VPal   : Array[0..255,1..3] of Byte;  { Palette virtual }
    OPal   : Array[0..255,1..3] of Byte;  { Palette Antiga  }
    Scr_Ofs : Array[0..199] of Word;
    c4size :  Byte;

Procedure SetMCGA;
Procedure SetText;
procedure WaitRetrace;
procedure WaitRetraceF;
Procedure RDelay       (ms : Word);
Procedure SetUpVirtual ( tela : Word );
Procedure ShutDown     ( tela : Word );
Procedure Cls          (Where:word;Col : Byte);
procedure flip         (source,dest:Word);
procedure flipXY       (x,y,xx,yy,source,dest:Word);
procedure mixscreen    (source1,source2:Word);
Procedure SetPal       (Col,R,G,B : Byte);
Procedure GetPal       (Col : Byte; Var R,G,B : Byte);
Procedure Hline        (x1,x2,y:word;col:byte;where:word);
Procedure Line         (a,b,c,d:integer;col:byte;where:word);
Procedure LineNC       (a,b,c,d:integer;col:byte;where:word);
Procedure Rectangle    (x,y,xx,yy : Integer; cor : Byte; where : Word );
Procedure RectangleNC  (x,y,xx,yy : Integer; cor : Byte; where : Word );
Procedure Bar          (x,y,xx,yy : Integer; cor : Byte; where : Word );
procedure BAR2( x,y : Word; tx,ty : Word; cor : Byte; where : Word );
Procedure BarNC        (x,y,xx,yy : Integer; cor : Byte; where : Word );
Procedure Putpixel     (X,Y : Integer; Col : Byte; where : word);
Function  Getpixel     (X,Y : Integer; where : word) :Byte;
Procedure PutpixelNC   (X,Y : Integer; Col : Byte; where : word);
Function  GetpixelNC   (X,Y : Integer; where : word) :Byte;
Function  BitMapAlloc  ( xx,yy : Word; var img : Pointer ) : Word;
Procedure BitMapFree   ( var img : Pointer );
Procedure GetImage     ( x,y : Word; var Img : Pointer; Where : Word );
Function  ImageSizeX    ( Img : Pointer ) : word;
Function  ImageSizeY    ( Img : Pointer ) : word;

procedure PutImage     ( x,y : Integer; var Img : Pointer; where : Word );
procedure PutImageNC   ( x,y : Word; var Img : Pointer; where : Word );
procedure PutImageZ    ( x,y : Integer; var Img : Pointer; where : Word );

procedure PutImageI    ( x,y : Integer; var Img : Pointer; where : Word );
procedure PutImageI2   ( x,y : Integer; var Img : Pointer; where : Word );  { Exibe imagem invertida na tela }
procedure PutImageI3   ( x,y : Integer; var Img : Pointer; where : Word );  { Exibe imagem invertida na tela }

procedure PutImageNCI  ( x,y : Word; var Img : Pointer; where : Word );
procedure PutImageNCI2 ( x,y : Word; var Img : Pointer; where : Word );
procedure PutImageNCI3 ( x,y : Word; var Img : Pointer; where : Word );

Procedure ScaleZNC (x,y,w,h : Word; img : Pointer; dest:word);
Procedure ScaleNC (x,y,w,h : Word; img : Pointer; dest:word);
Procedure Scale (x,y : Integer; w,h : Word; img : Pointer; dest:word);

procedure Scroll       ( x1,y1,x2,y2 : Word; tax : Word; where : Word; horiz : Byte; esp : Byte );
procedure SaveVPal;
procedure SetVPal      (Col,R,G,B : Byte);
procedure FlipVPal;
procedure FlipOPal;
procedure SwapOVPal;
procedure BlackOut;
procedure MuteVPal     ( passes,retraces,ms : Word );
procedure FadeDown     ( num,retraces,ms : Word );
procedure FadeUp       ( num,retraces,ms : Word );
procedure FadeUpWhite  ( num,retraces,ms : Word );
procedure SaveOPal;
procedure RemoveRGB    (RGB,num,retraces,ms : Word );
procedure PutRGB       (RGB,num,retraces,ms : Word );


Procedure InitChain4;
Procedure C4PutPixel(X,Y : Word; Col : Byte);
Procedure C4Plane(Which : Byte);
procedure c4moveto(x, y : integer);

PROCEDURE FillCircle( xc, yc, r : Integer; c : Byte; where : word );
PROCEDURE Plot4( xc, yc, xr, yr : Integer; c : Byte; where : Word );
PROCEDURE Ellipse( xc, yc, a, b : Integer; c : Byte; where : word );
PROCEDURE FillEllipse( xc, yc, a, b : Integer; c : Byte; where : word );
procedure Circle(X,Y,YRad,XRad: integer; Color: byte; where : word );

function  LoadPal( nomearq : string; pos : longint; var pal : paltype ) : Boolean;
function  LoadMPal( nomearq: string; pos : longint ) : Boolean;
function  LoadIMG( nomearq : string; pos : longint; var img : Pointer ) : Boolean;

Implementation


{******** LOADIMG **********************************************************}
function  LoadIMG( nomearq : string; pos : longint; var img : Pointer ) : Boolean;
var
 f : file;
 ex,ey,size : Word;
begin

  Assign(f,nomearq); Reset(f,1);
  if IOResult<>0 then begin
   close(f);
   LoadIMG:=FALSE;
   Exit;
  end;

  seek(f,pos);
  ex:=0; ey:=0;
  BlockRead(f,ex,2); BlockRead(f,ey,2);
  size:=BitMapAlloc( ex, ey, img );
  Seek(f,filepos(f)-4); BlockRead(f,img^,size);
  Close(f);
  if IOResult<>0 then begin
   LoadIMG:=FALSE;
  end else begin
   LoadIMG:=TRUE;
  end;

end;

{******** LOADPAL **********************************************************}
function  LoadPal( nomearq : string; pos : longint; var pal : paltype ) : Boolean;
var
 f : file;
begin

  Assign(f,nomearq); Reset(f,1);

  if IOResult<>0 then begin
   close(f);
   LoadPal:=FALSE;
   Exit;
  end;

  Seek(f,pos+41);
  BlockRead(f,pal,sizeof(pal));
  close(f);

  if IOResult<>0 then begin
   LoadPal:=FALSE;
  end else begin
   LoadPal:=TRUE;
  end;

end;

{******** LOADMPAL *********************************************************}
function  LoadMPal( nomearq : string; pos : longint ) : Boolean;
var
 f : file;
 pal : PalType;
 r :  Byte;
begin

  Assign(f,nomearq); Reset(f,1);

  if IOResult<>0 then begin
   close(f);
   LoadMPal:=FALSE;
   Exit;
  end;

  Seek(f,pos+41);
  BlockRead(f,pal,sizeof(pal));
  close(f);

  for r:=0 to 255 do
   SetPal(r,pal[r,1],pal[r,2],pal[r,3]);

  if IOResult<>0 then begin
   LoadMPal:=FALSE;
  end else begin
   LoadMPal:=TRUE;
  end;

end;



{******** Circle ************************************************************}
procedure Circle(X,Y,YRad,XRad: integer; Color: byte; where : word );
VAR
 EX,EY: integer;
 YRadSqr,YRadSqr2,XRadSqr,XRadSqr2,D,DX,DY: longint;
BEGIN
   EX:=0;
   EY:=XRad;
   YRadSqr:=longint(YRad)*YRad;
   YRadSqr2:=2*YRadSqr;
   XRadSqr:=longInt(XRad)*XRad;
   XRadSqr2:=2*XRadSqr;
   D:=XRadSqr-YRadSqr*XRad+YRadSqr div 4;
   DX:=0;
   DY:=YRadSqr2*XRad;

   putpixel(X,Y-EY,Color,where);
   putpixel(X,Y+EY,Color,where);
   putpixel(X-YRad,Y,Color,where);
   putpixel(X+YRad,Y,Color,where);

   while (DX<DY) do
   begin
      if (D>0) then
      begin
         Dec(EY);
         Dec(DY,YRadSqr2);
         Dec(D,DY);
      end;
      Inc(EX);
      Inc(DX,XRadSqr2);
      Inc(D,XRadSqr+DX);
      putpixel(X+EX,Y+EY,Color,where);
      putpixel(X-EX,Y+EY,Color,where);
      putpixel(X+EX,Y-EY,Color,where);
      putpixel(X-EX,Y-EY,Color,where);

   end;
   Inc(D,(3*(YRadSqr-XRadSqr) div 2-(DX+DY)) div 2);
   while (EY>0) do
   begin
      if(D<0) then
      begin
         Inc(EX);
         Inc(DX,XRadSqr2);
         Inc(D,XRadSqr+DX);
      end;
      Dec(EY);
      Dec(DY,YRadSqr2);
      Inc(D,YRadSqr-DY);
      putpixel(X+EX,Y+EY,Color,where);
      putpixel(X-EX,Y+EY,Color,where);
      putpixel(X+EX,Y-EY,Color,where);
      putpixel(X-EX,Y-EY,Color,where);
   end;
END;


{******** FILLBYTEIN ******************************************************}
PROCEDURE FillByteIn( D : Pointer; Bytes : Word; B : Byte );
  INLINE( $58 /         {     pop    ax    }
	  $59 /         {     pop    cx    }
	  $5F /         {     pop    di    }
	  $07 /         {     pop    es    }
	  $88 / $C4 /   {     mov    ah,al }
	  $FC /         {     cld          }
	  $D1 / $E9 /   {     shr    cx,1  }
	  $F3 / $AB /   { rep stosw        }
	  $13 / $C9 /   {     adc    cx,cx }
	  $F3 / $AA );  { rep stosb        }


{******** FILLCIRCLE ********************************************************}
PROCEDURE FillCircle( xc, yc, r : Integer; c : Byte; where : Word );
VAR	p, x, y	: Integer;
	SS, SO	: Word;
	YO, XO  : Word;
	xs, xe, xd : Integer;
BEGIN
  IF ( xc + r < 0 ) OR ( xc - r >= MaxX ) OR
     ( yc + r < 0 ) OR ( yc - r >= MaxY ) THEN Exit;
  SS := where;
  SO := 0 + yc * MaxX;
  x := 0;
  y := r;
  YO := y * MaxX;
  XO := x * MaxX;
  p := 3 - r * 2;
  WHILE x <= y DO
    BEGIN
      xs := xc - y;
      xe := xc + y;
      IF xs < 0 THEN xs := 0;
      IF xe > MaxX THEN xe := MaxX;
      xd := xe - xs;
      IF xd > 0 THEN
	BEGIN
	  IF ( yc - x >= 0 ) AND ( yc - x < MaxY ) THEN
	    FillByteIn( Ptr( SS, SO - XO + xs ), xd, c );
	  IF ( yc + x >= 0 ) AND ( yc + x < MaxY ) THEN
	    FillByteIn( Ptr( SS, SO + XO + xs ), xd, c );
	END;
      IF p >= 0 THEN
	BEGIN
	  xs := xc - x;
	  xe := xc + x;
	  IF xs < 0 THEN xs := 0;
	  IF xe > MaxX THEN xe := MaxX;
	  xd := xe - xs;
	  IF xd > 0 THEN
	    BEGIN
	      IF ( yc - y >= 0 ) AND ( yc - y < MaxY ) THEN
		FillByteIn( Ptr( SS, SO - YO + xs ), xd, c );
	      IF ( yc + y >= 0 ) AND ( yc + y < MaxY ) THEN
		FillByteIn( Ptr( SS, SO + YO + xs ), xd, c );
	    END;
	  Inc( p, ( x - y ) * 4 + 10 );
	  Dec( y );
	  Dec( YO, MaxX );
	END
      ELSE
	Inc( p, x * 4 + 6 );
      Inc( x );
      Inc( XO, MaxX )
    END;
END;


{******** PLOT4   ***********************************************************}
PROCEDURE Plot4( xc, yc, xr, yr : Integer; c : Byte; where : Word );
BEGIN
  PutPixel( xc + xr, yc + yr, c,where );
  PutPixel( xc + xr, yc - yr, c,where );
  PutPixel( xc - xr, yc + yr, c,where );
  PutPixel( xc - xr, yc - yr, c,where );
END;


{******** ELLIPSE ***********************************************************}
PROCEDURE Ellipse( xc, yc, a, b : Integer; c : Byte; where : word );
VAR	aSqr		: Integer;
	bSqr		: Integer;
	twoaSqr		: Integer;
	twobSqr		: Integer;
	X, Y		: Integer;
	twoXbSqr        : Integer;
	twoYaSqr        : Integer;
	error		: Integer;
BEGIN
  aSqr := a * a;
  bSqr := b * b;
  twoaSqr := 2 * aSqr;
  twobSqr := 2 * bSqr;
  X := 0;
  Y := b;
  twoXbSqr := 0;
  twoYaSqr := Y * twoaSqr;
  error := -y * aSqr;
  WHILE twoXbSqr <= twoYaSqr DO
    BEGIN
      plot4( xc, yc, X, Y, c ,where);
      Inc( X );
      Inc( twoXbSqr, twobSqr );
      Inc( error, twoXbSqr - bSqr );
      IF error >= 0 THEN
	BEGIN
	  Dec( Y );
	  Dec( twoYaSqr, twoaSqr );
	  Dec( error, twoYaSqr )
	END;
    END;
  X := a;
  Y := 0;
  twoXbSqr := X * twobSqr;
  twoYaSqr := 0;
  error := -x * bSqr;
  WHILE twoXbSqr > twoYaSqr DO
    BEGIN
      plot4( xc, yc, X, Y, c ,where);
      Inc( Y );
      Inc( twoYaSqr, twoaSqr );
      Inc( error, twoYaSqr - aSqr );
      IF error >= 0 THEN
	BEGIN
	  Dec( X );
	  Dec( twoXbSqr, twobSqr );
	  Dec( error, twoXbSqr )
	END;
    END;
END;


{******** FILLELLIPSE ***********************************************************}
PROCEDURE FillEllipse( xc, yc, a, b : Integer; c : Byte; where : word );
VAR	SS, SO, YO	: Word;
	aSqr		: Integer;
	bSqr		: Integer;
	twoaSqr		: Integer;
	twobSqr		: Integer;
	X, Y		: Integer;
	twoXbSqr        : Integer;
	twoYaSqr        : Integer;
	error		: Integer;
	xs, xe, xd	: Integer;
BEGIN
  IF ( xc + a < 0 ) OR ( xc - a >= MaxX ) OR
     ( yc + b < 0 ) OR ( yc - b >= MaxY ) THEN Exit;
  aSqr := a * a;
  bSqr := b * b;
  twoaSqr := 2 * aSqr;
  twobSqr := 2 * bSqr;
  X := 0;
  Y := b;
  twoXbSqr := 0;
  twoYaSqr := Y * twoaSqr;
  error := -y * aSqr;
  SS := where;
  SO := 0 + yc * MaxX;
  YO := Y * MaxX;
  WHILE twoXbSqr <= twoYaSqr DO
    BEGIN
      Inc( X );
      Inc( twoXbSqr, twobSqr );
      Inc( error, twoXbSqr - bSqr );
      IF error >= 0 THEN
	BEGIN
	  xs := xc - x;
	  xe := xc + x;
	  IF xs < 0 THEN xs := 0;
	  IF xe > MaxX THEN xe := MaxX;
	  xd := xe - xs;
	  IF xd > 0 THEN
	    BEGIN
	      IF ( yc - y >= 0 ) AND ( yc - y < MaxY ) THEN
		FillByteIn( Ptr( SS, SO - YO + xs ), xd, c );
	      IF ( yc + y >= 0 ) AND ( yc + y < MaxY ) THEN
		FillByteIn( Ptr( SS, SO + YO + xs ), xd, c );
	    END;
	  Dec( Y );
	  Dec( YO, MaxX );
	  Dec( twoYaSqr, twoaSqr );
	  Dec( error, twoYaSqr )
	END;
    END;
  X := a;
  Y := 0;
  twoXbSqr := X * twobSqr;
  twoYaSqr := 0;
  error := -x * bSqr;
  YO := Y * MaxX;
  WHILE twoXbSqr > twoYaSqr DO
    BEGIN
      xs := xc - x;
      xe := xc + x;
      IF xs < 0 THEN xs := 0;
      IF xe > MaxX THEN xe := MaxX;
      xd := xe - xs;
      IF xd > 0 THEN
	BEGIN
	  IF ( yc - y >= 0 ) AND ( yc - y < MaxY ) THEN
	    FillByteIn( Ptr( SS, SO - YO + xs ), xd, c );
	  IF ( yc + y >= 0 ) AND ( yc + y < MaxY ) THEN
	    FillByteIn( Ptr( SS, SO + YO + xs ), xd, c );
	END;
      Inc( Y );
      Inc( YO, MaxX );
      Inc( twoYaSqr, twoaSqr );
      Inc( error, twoYaSqr - aSqr );
      IF error >= 0 THEN
	BEGIN
	  Dec( X );
	  Dec( twoXbSqr, twobSqr );
	  Dec( error, twoXbSqr )
	END;
    END;
END;


{******** SetMCGA ***********************************************************}
Procedure SetMCGA; Assembler;  { Coloca a tela no modo 320x200x256 cores }
label TemVGA;
Asm
   xor  bx, bx
   mov  ax, 01A00h  { Verifica se o video ‚ VGA }
   int  10h
   cmp  bl, 7
   jge  TemVGA      { Se for, vai para TemVGA, caso contr rio, erro! }

   mov  ax,09h
   mov  dx,offset(MCGAerro1)  { Mostra mensagem de erro }
   int  21h
   mov  ax, 4CFFh            { E sai do programa }
   int  21h

TemVGA:
   mov ax,0013h    { Inicializa o modo }
   int 10h

End;


{******** SetText ***********************************************************}
Procedure SetText; Assembler; { Volta a tela para o mode texto }
Asm
   mov ax,0003h
   int 10h
End;


{******** Cls ***************************************************************}
Procedure Cls( Where : word; Col : Byte); assembler; { Apaga a tela }
Asm
   push  es
   mov   cx, 32000;
   mov   es,[where]
   xor   di,di
   mov   al,[col]
   mov   ah,al
   rep   stosw
   pop   es
End;


{******** SetUpVirtual ******************************************************}
Procedure SetUpVirtual( tela : Word );  { Aloca Mem¢ria B sica para tela virtual }
Begin
 if tela=1 then begin
  GetMem(VirScr,64000);
  vaddr := seg (virscr^);
 end;
 if tela=2 then begin
  GetMem(VirScr2,64000);
  vaddr2:= seg (virscr2^);
 end;
 if tela=3 then begin
  GetMem(VirScr3,64000);
  vaddr3:= seg (virscr3^);
 end;
End;


{******** ShutDown **********************************************************}
Procedure ShutDown( tela : Word );  { Libera Mem¢ria B sica da tela virtual }
Begin
  if tela=1 then FreeMem (VirScr ,64000);
  if tela=2 then FreeMem (VirScr2,64000);
  if tela=3 then FreeMem (VirScr3,64000);
End;


{******** Flip **************************************************************}
procedure Flip( source,dest : Word ); assembler;  { Copia t.virtual para a tela real }
asm
  push   ds
  mov    ax, [Dest]
  mov    es, ax
  mov    ax, [Source]
  mov    ds, ax
  xor    si, si
  xor    di, di
  mov    cx, 32000

  rep    movsw
  pop    ds
end;


{******** FlipXY ************************************************************}
procedure FlipXY( x,y,xx,yy,source,dest : Word ); assembler;  { Copia t.virtual para a tela real }
var cy : Word;
asm
  push   ds
  mov    ax, [Dest]
  mov    es, ax
  mov    bx,[x]
  mov    dx,[y]
  xchg   dh,dl
  mov    di,dx
  shr    di,2
  add    di,dx
  add    di,bx       { Calcula o offset do primeiro ponto }

  mov    ax, [Source]
  mov    ds, ax
  mov    bx,[x]
  mov    dx,[y]
  xchg   dh,dl
  mov    si,dx
  shr    si,2
  add    si,dx
  add    si,bx       { Calcula o offset do primeiro ponto }

  shr    xx,1

  mov    ax, yy
  mov    cy, ax
 @1:
  mov    cx, xx
  rep    movsw

  add    si,320
  add    di,320
  sub    si,xx
  sub    di,xx
  sub    si,xx
  sub    di,xx
  dec    cy
  jnz    @1

  pop    ds
end;


{******** MixScreen **************************************************************}
procedure MixScreen(source1,source2:Word); Assembler;  { Mistura duas telas e joga em outra }
asm
  push   ds
  mov    ax, [Source1]
  mov    es, ax
  mov    ax, [Source2]
  mov    ds, ax
  xor    si, si  { Source2 }
  xor    di, di  { Source1 }
  mov    cx, 64000
 @1:
  mov    al, es:[di]
  cmp    al,0
  je     @2
  jmp    @3
 @2:
  mov    al,ds:[si]
  mov    es:[di],al
 @3:
  inc    si
  inc    di
  dec    cx
  jnz    @1
  pop    ds
end;



{******** SetPal ***********************************************************}
Procedure SetPal(Col,R,G,B : Byte); assembler; { Acerta pallete RGB }
asm
   mov   dx,3c8h
   mov   al,[col]
   out   dx,al
   inc   dx
   mov   al,[r]
   out   dx,al
   mov   al,[g]
   out   dx,al
   mov   al,[b]
   out   dx,al
end;


{******** GetPal ************************************************************}
Procedure GetPal(Col : Byte; Var R,G,B : Byte); { Le o pallete RGB }
Var
   rr,gg,bb : Byte;
Begin
   asm
      mov    dx,3c7h
      mov    al,col
      out    dx,al

      add    dx,2

      in     al,dx
      mov    [rr],al
      in     al,dx
      mov    [gg],al
      in     al,dx
      mov    [bb],al
   end;
   r := rr;
   g := gg;
   b := bb;
end;


{******** WaitRetrace *******************************************************}
procedure WaitRetrace; assembler; { Espera a verredura vertical da tela }
Label
  l1, l2;
Asm
    mov  dx,3DAh
l1:
    in   al,dx
    and  al,08h
    jnz  l1
l2:
    in   al,dx
    and  al,08h
    jz   l2
end;

{******** WaitRetraceF *****************************************************}
procedure WaitRetraceF; assembler; { Espera a verredura vertical da tela FAST }
Label
  l1;
Asm
    mov  dx,3DAh
l1:
    in   al,dx
    and  al,08h
    jnz  l1
end;


{******** HLine *************************************************************}
Procedure Hline ( x1,x2,y : word; col : byte; where : word ); assembler; { Desenha linha horizontal }
Asm
  mov   ax,where
  mov   es,ax
  mov   ax,y
  mov   di,ax
  shl   ax,8
  shl   di,6
  add   di,ax
  add   di,x1

  mov   al,col
  mov   ah,al
  mov   cx,x2
  sub   cx,x1
  shr   cx,1
  jnc   @start
  stosb
@Start :
  rep   stosw
end;


{******** Line **************************************************************}
Procedure Line( a,b,c,d : integer; col : byte; where : word ); { Desenha uma linha }
  function sgn(a:real):integer;
  begin
   if a>0 then sgn:=+1;
   if a<0 then sgn:=-1;
   if a=0 then sgn:=0;
  end;
var i,s,d1x,d1y,d2x,d2y,u,v,m,n : integer;
Begin
     u:= c - a;
     v:= d - b;
     d1x:= SGN(u);
     d1y:= SGN(v);
     d2x:= SGN(u);
     d2y:= 0;
     m:= ABS(u);
     n := ABS(v);
     IF NOT (M>N) then
     BEGIN
       d2x := 0 ;
       d2y := SGN(v);
       m := ABS(v);
       n := ABS(u);
     END;
     s := m shr 1;
     FOR i := 0 TO m DO
     BEGIN
      if(a>=0) and (a<=319) and (b>=0) and (b<=199) then begin
       asm
        mov  ax,where
        mov  es,ax
        mov  bx,[b]
        shl  bx,1
        mov  di,word ptr [Scr_Ofs + bx]
        add  di,[a]
        mov  al,[col]
        mov  es:[di],al
       end;
      end;
          s := s + n;
          IF not (s<m) THEN
          BEGIN
               s := s - m;
               a:= a + d1x;
               b := b + d1y;
          END
          ELSE
          BEGIN
               a := a + d2x;
               b := b + d2y;
          END;
     end;
END;


{******** LineNC ************************************************************}
Procedure LineNC( a,b,c,d : integer; col : byte; where : word ); { Desenha uma linha sem checar }
  function sgn(a:real):integer;
  begin
   if a>0 then sgn:=+1;
   if a<0 then sgn:=-1;
   if a=0 then sgn:=0;
  end;
var i,s,d1x,d1y,d2x,d2y,u,v,m,n : integer;
Begin
     u:= c - a;
     v:= d - b;
     d1x:= SGN(u);
     d1y:= SGN(v);
     d2x:= SGN(u);
     d2y:= 0;
     m:= ABS(u);
     n := ABS(v);
     IF NOT (M>N) then
     BEGIN
          d2x := 0 ;
          d2y := SGN(v);
          m := ABS(v);
          n := ABS(u);
     END;
     s := m shr 1;
     FOR i := 0 TO m DO
     BEGIN
      asm
       mov  ax,where
       mov  es,ax
       mov  bx,[b]
       shl  bx,1
       mov  di,word ptr [Scr_Ofs + bx]
       add  di,[a]
       mov  al,[col]
       mov  es:[di],al
      end;
          s := s + n;
          IF not (s<m) THEN
          BEGIN
               s := s - m;
               a:= a + d1x;
               b := b + d1y;
          END
          ELSE
          BEGIN
               a := a + d2x;
               b := b + d2y;
          END;
     end;
END;


{******** Bar ***************************************************************}
Procedure Bar(x,y,xx,yy : Integer; cor : Byte; where : Word ); { Desenha um quadrado }
var vx,vy : Integer;
label l1,l2,l3,l4,l6,l7;
Begin
 if x>xx then
  Asm
   mov ax,[xx]
   xchg [x],ax
   mov [xx],ax
  End;
 if y>yy then
  Asm
   mov ax,[yy]
   xchg [y],ax
   mov [yy],ax
  End;

 Asm
  mov ax,[x]
  sub [xx],ax
  mov ax,[y]
  sub [yy],ax

  mov ax,[yy]
  not ax         { nega o valor de yy (torna-o negativo) }
  inc ax
  cmp y,ax       { Verifica se a imagem est  em yy linhas negativas   }
  jle l7         { Se est , ela nÆo aparecer  na tela, entÆo cai fora }

  mov ax,Where
  mov es,ax       { Aponta o destino para tela ou tela virtual }

  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov di,dx
  shr di,2
  add di,dx
  add di,bx       { Calcula o offset do primeiro ponto }

  cmp [y],0
  jge l4          { Se y for maior ou igual a 0, pula para l4 }

 { Daqui at‚ o label l4, verifica sobre a posi‡Æo y negativa }
  xor di,di
  add di,[x]
  not [y]
  inc y
  mov ax,[y]
  sub [yy],ax

  mov ax,[x]
  mov di,ax      { Posi‡Æo certa, linha 0, posi‡Æo x }

l4:
  mov ax,[y]
  mov [vy],ax     { Move posi‡Æo y para virtual y }

l2:
  mov ax,bx
  mov [vx],ax     { Move posi‡Æo x para virtual x }
  mov cx,[xx]     { Contador do tamanho xx }

  mov al,[cor]

  cmp [vy],199    { Compara vy com 199, se maior, pula para l7 (sai fora) }
  jg l7
l1:
  cmp [vx],0      { Compara vx com zero, se menor pula para l3 (nÆo plota o ponto) }
  jl l3
  cmp [vx],319    { Compara vx com 319, se maior, pula para l3 (nÆo plot) }
  jg l3
  mov es:[di],al  { Caso contr rio, plota na tela ou t. virtual }
l3:
  inc di          { Incrementa posi‡Æo da var. imagem }
{  inc si     }     { Incrementa posi‡Æo da tela ou t.v. }
  inc [vx]        { Incrementa virtual x }
  dec cx          { Decrementa contador de tamanho xx }
  jnz l1

  add di,320      { Incrementa uma linha na tela ou tv }
  sub di,[xx]     { E volta o tamanho xx }
  inc [vy]        { Incrementa o virtual y }
  dec [yy]        { Decrementa tamanho yy }
  jnz l2

l7:

 End;
End;

{********** BAR2 ***** mais r pida e mais otimizada! ***********************}
procedure BAR2( x,y : Word; tx,ty : Word; cor : Byte; where : Word ); Assembler;
Asm
   mov ax,x
   sub tx,ax

   mov ax,y
   sub ty,ax

   cmp x,1  { x ‚ menor que zero? }
   jnl  @100

   neg x    { nega o valor. ex : x=-5 torna x=5 }
   mov ax,tx
   sub ax,x { sub. o valor de x de tx }
   mov tx,ax

   cmp tx,2
   jle @999    { se tx <=0 nÆo plota }

   mov x,0  { torna x=0 }

  @100:

   cmp y,1  { y ‚ menor que zero ? }
   jnl  @200

   neg y    { nega o valor. ex : y=-5 torna y=5 }
   mov ax,y
   sub ty,ax { sub. o valor de y de ty }

   cmp ty,2
   jle @999    { se ty <=0 nÆo plota }

   mov y,0

  @200:

   cmp x,319  { cai fora se maior }
   jg  @999

   mov bx,x
   add bx,tx
   cmp bx,319
   jng @300

   mov bx,319
   sub bx,x
   mov tx,bx

  @300:

   cmp y,199  { cai fora }
   jg  @999

   mov bx,y
   add bx,ty
   cmp bx,199
   jng @400

   mov bx,200
   sub bx,y
   mov ty,bx

  @400:

   mov ax,where
   mov es,ax

   { calcula posi‡Æo inicial }
   mov  bx,y
   shl  bx,1
   mov  di,word ptr [Scr_Ofs + bx]
   add  di,x

   mov  al,cor

   mov  bx,ty
  @5:
   mov  cx,tx
   rep  stosb
   add  di,320
   sub  di,tx
   dec  bx
   jnz  @5

  @999:
End;



{******** BarNC ***************************************************************}
Procedure BarNC(x,y,xx,yy : Integer; cor : Byte; where : Word ); { Desenha um quadrado se checar }
var vx,vy : Integer;
label l1,l2;
Begin
 if x>xx then
  Asm
   mov ax,[xx]
   xchg [x],ax
   mov [xx],ax
  End;
 if y>yy then
  Asm
   mov ax,[yy]
   xchg [y],ax
   mov [yy],ax
  End;

 Asm
  mov ax,[x]
  sub [xx],ax
  mov ax,[y]
  sub [yy],ax

  mov ax,Where
  mov es,ax       { Aponta o destino para tela ou tela virtual }

  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov di,dx
  shr di,2
  add di,dx
  add di,bx       { Calcula o offset do primeiro ponto }

  mov ax,[y]
  mov [vy],ax     { Move posi‡Æo y para virtual y }

l2:
  mov ax,bx
  mov [vx],ax     { Move posi‡Æo x para virtual x }
  mov cx,[xx]     { Contador do tamanho xx }
  mov al,[cor]
l1:
  mov es:[di],al  { Caso contr rio, plota na tela ou t. virtual }
  inc di          { Incrementa posi‡Æo da var. imagem }
  inc si          { Incrementa posi‡Æo da tela ou t.v. }
  inc [vx]        { Incrementa virtual x }
  dec cx          { Decrementa contador de tamanho xx }
  jnz l1

  add di,320      { Incrementa uma linha na tela ou tv }
  sub di,[xx]     { E volta o tamanho xx }
  inc [vy]        { Incrementa o virtual y }
  dec [yy]        { Decrementa tamanho yy }
  jnz l2

 End;

End;


{******** Putpixel **********************************************************}
Procedure Putpixel ( X,Y : Integer; Col : Byte; where : word ); assembler;  { Coloca um Pixel }
label l1;
Asm
   cmp y,0
   jl  l1
   cmp y,199
   jg  l1
   cmp x,0
   jl  l1
   cmp x,319
   jg  l1
   mov  ax,where
   mov  es,ax
   mov  bx,[y]
   shl  bx,1
   mov  di,word ptr [Scr_Ofs + bx]
   add  di,[x]
   mov  al,[col]
   mov  es:[di],al
l1:
End;


{******** PutpixelNC *********************************************************}
Procedure PutpixelNC ( X,Y : Integer; Col : Byte; where : word ); assembler;  { Coloca um Pixel }
Asm
   mov  ax,where
   mov  es,ax
   mov  bx,[y]
   shl  bx,1
   mov  di,word ptr [Scr_Ofs + bx]
   add  di,[x]
   mov  al,[col]
   mov  es:[di],al
End;


{******* Getpixel ***********************************************************}
Function Getpixel (X,Y : Integer; where:word):byte; assembler; { Verifica um Pixel }
label l1;
Asm
   cmp y,0
   jl  l1
   cmp y,199
   jg  l1
   cmp x,0
   jl  l1
   cmp x,319
   jg  l1
   mov  ax,where
   mov  es,ax
   mov  bx,[y]
   shl  bx,1
   mov  di,word ptr [Scr_Ofs + bx]
   add  di,[x]
   mov  al,es:[di]
l1:
End;


{******* GetpixelNC *********************************************************}
Function GetpixelNC (X,Y : Integer; where:word):byte; assembler; { Verifica um Pixel }
Asm
   mov  ax,where
   mov  es,ax
   mov  bx,[y]
   shl  bx,1
   mov  di,word ptr [Scr_Ofs + bx]
   add  di,[x]
   mov  al,es:[di]
End;


{******** RDelay ************************************************************}
Procedure RDelay(ms : Word); assembler;  { Delay real, independente da CPU }
Asm
  mov ax,1000
  mul ms
  mov cx,dx
  mov dx,ax
  mov ah,86h
  int 15h
End;


{******** BitMapAlloc *******************************************************}
Function  BitMapAlloc  ( xx,yy : Word; var img : Pointer ) : Word;  { Aloca mem¢ria necess ria para a imagem }
var
 size : Word;
 iddr : Word;
begin

 size:=4+(xx*yy)+5;    { Calcula a mem¢ria necess ria p/ a imagem }

 if MaxAvail>=size then begin { Se tiver mem¢ria suficiente... }
  GetMem( img, size+5 );        { Aloca o espa‡o necess rio na mem¢ria }
  BitMapAlloc:=size;
 end else begin               { Caso contr rio... }
  BitMapAlloc:=0;             { Retorna c¢digo de erro }
  Exit;
 end;

 iddr:=Seg(Img^);      { Vˆ o segmento onde est  a imagem }

 Asm
  mov ax,iddr
  mov es,ax       { Move segmento de dados para Seg da imagem }
  xor di,di
  mov ax,[xx]
  mov es:[di],ax  { Armazena o tamanho xx da imagem }
  add di,2
  mov ax,[yy]
  mov es:[di],ax  { Armazena o tamamnho yy da imagem }
 End;

end;


{******** BitMapFree ********************************************************}
procedure BitMapFree( var img : Pointer );  { Libera espa‡o da mem¢ria da imagem }
var
 size  : Word;
 iddr  : Word;
 xx,yy : Word;
begin

 iddr:=Seg(Img^);  { Vˆ o segmento onde est  a imagem }

 Asm
  mov ax,iddr
  mov es,ax      { Move segmento de dados para Seg da imagem }
  xor di,di
  mov ax,es:[di]  { Pega o valor xx da imagem }
  mov [xx],ax
  add di,2
  mov ax,es:[di]  { Pega o valor yy da imagem }
  mov [yy],ax
 End;

 size:=4+(xx*yy)+5;   { Calcula a mem¢ria necess ria p/ a imagem }

 FreeMem( img, size+5 );     { Desaloca o espa‡o necess rio na mem¢ria }

end;


{******** GetImage **********************************************************}
procedure GetImage( x,y : Word; var Img : Pointer; Where : Word );  { Captura a imagem da tela para a variavel }
var
 size  : Word;
 iddr  : Word;
 xx,yy : Word;
 cor   : Byte;
label l1,l2;
begin

 iddr:=Seg(Img^);  { Vˆ o segmento da imagem }

 Asm
  push ds   { Salva DS }

  mov ax,iddr
  mov es,ax        { Move segmento de dados para o Seg da imagem }
  xor di,di
  mov ax,es:[di]   { Lˆ o tamanho xx da imagem }
  mov [xx],ax
  add di,2
  mov ax,es:[di]   { Lˆ o tamanho yy da imagem }
  mov [yy],ax
  add di,2

  mov ax,Where
  mov ds,ax        { Aponta seg. de dados para a origem (tela ou mem¢ria) }
  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx        { Calcula o seg. e ofs. do ponto inicial }

  mov cx,[yy]      { Contador para tamanho yy }
l1:
  push cx          { Salva antigo contador }
  mov cx,[xx]      { Contador para tamanho xx }
l2:
  mov al,ds:[si]   { Retira da (tela ou mem¢ria o ponto e }
  mov es:[di],al   { armazena-o na v riavel de imagem     }
  inc di           { Incrementa posi‡Æo da imagem }
  inc si           { Incrementa posi‡Æo da tela ou mem¢ria }
  dec cx           { Decrementa o contador xx }
  jnz l2           { Se ele nÆo for 0, v  para l2 }
  add si,320       { Incrementa a posi‡Æo (tela) em uma linha }
  sub si,[xx]      { e volta xx pontos }
  pop cx           { Retorna contador yy }
  dec cx           { e decrementa-o }
  jnz l1           { Se nÆo for 0, v  para l1 }

  pop ds           { Retorna o seg. de dados }

 End;

End;


{******* ImageSizeX ********************************************************}
Function ImageSizeX   ( Img : Pointer ) : Word;
var xx,iddr,iddr2 :word;
Begin
 iddr:=SEG(img^);
 iddr2:=OFS(img^);
 Asm
  mov ax,[iddr]
  mov es,ax        { Move segmento de dados para o Seg da imagem }
  mov di,[iddr2]
  mov ax,es:[di]   { Lˆ o tamanho xx da imagem }
  mov [xx],ax
 End;
 ImageSizex:=xx;
End;

{******* ImageSizeY ********************************************************}
Function ImageSizeY   ( Img : Pointer ) : Word;
var xx,iddr,iddr2 :word;
Begin
 iddr:=SEG(img^);
 iddr2:=OFS(img^);
 Asm
  mov ax,[iddr]
  mov es,ax        { Move segmento de dados para o Seg da imagem }
  mov di,[iddr2]
  add di,2
  mov ax,es:[di]   { Lˆ o tamanho yy da imagem }
  mov [xx],ax
 End;
 ImageSizey:=xx;
End;



{******** PutImage *********************************************************}
procedure PutImage( x,y : Integer; var Img : Pointer; where : Word );  { Exibe imagem na tela }
var
 size  : Word;
 iddr,iddr2  : Word;
 xx,yy : Integer;
 cor   : Byte;
 vx,vy : Integer;
label l1,l2,l3,l4,l5,l6,l7;
begin

 iddr:=Seg(Img^); { Vˆ o segmento da imagem }
 iddr2:=Ofs(Img^);

 Asm

  push ds        { Salva seg. de dados }

  mov ax,iddr
  mov es,ax        { Aponta seg. de dados para Seg da imagem }
  mov di,iddr2
  mov ax,es:[di]
  mov xx,ax        { Pega o tamanho xx }
  add di,2
  mov ax,es:[di]   { E o tamanho yy }
  mov yy,ax
  add di,2

  mov ax,[yy]
  not ax         { nega o valor de yy (torna-o negativo) }
  inc ax
  cmp y,ax       { Verifica se a imagem est  em yy linhas negativas   }
  jle l7         { Se est , ela nÆo aparecer  na tela, entÆo cai fora }

  mov ax,Where
  mov ds,ax       { Aponta o destino para tela ou tela virtual }

  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx       { Calcula o offset do primeiro ponto }

  cmp [y],0
  jge l4          { Se y for maior ou igual a 0, pula para l4 }

 { Daqui at‚ o label l4, verifica sobre a posi‡Æo y negativa }
  xor si,si       { Zera si }
  add si,[x]      { Aponta si para posi‡Æo x }
  not [y]
  inc y
  mov ax,[y]
  sub [yy],ax

  mov cx,[y]      { Contador para y linha negativas }
  mov ax,0
l5:
  add ax,[xx]     { Incrementa y linhas que nÆo aparecerÆo }
  mov di,ax
  dec cx
  jnz l5
  add ax,4
  add ax,iddr2
  mov di,ax      { Posi‡Æo certa, linha 0, posi‡Æo x }

l4:
  mov ax,[y]
  mov [vy],ax     { Move posi‡Æo y para virtual y }

l2:
  mov ax,bx
  mov [vx],ax     { Move posi‡Æo x para virtual x }
  mov cx,[xx]     { Contador do tamanho xx }

  cmp [vy],199    { Compara vy com 199, se maior, pula para l7 (sai fora) }
  jg l7
l1:
  cmp [vx],0      { Compara vx com zero, se menor pula para l3 (nÆo plota o ponto) }
  jl l3
  cmp [vx],319    { Compara vx com 319, se maior, pula para l3 (nÆo plot) }
  jg l3

  mov al,es:[di]  { Pega a cor da v rivel de imagem }
  cmp al,0        { Se ela for zero, nÆo plota }
  je l3
  mov ds:[si],al  { Caso contr rio, plota na tela ou t. virtual }
l3:
  inc di          { Incrementa posi‡Æo da var. imagem }
  inc si          { Incrementa posi‡Æo da tela ou t.v. }
  inc [vx]        { Incrementa virtual x }
  dec cx          { Decrementa contador de tamanho xx }
  jnz l1

  add si,320      { Incrementa uma linha na tela ou tv }
  sub si,[xx]     { E volta o tamanho xx }
  inc [vy]        { Incrementa o virtual y }
  dec [yy]        { Decrementa tamanho yy }
  jnz l2

l7:

  pop ds          { Retorna segmento de dados }

 End;

End;


{******** PutImageNC ********************************************************}
procedure PutImageNC( x,y : Word; var Img : Pointer; where : Word );
          { Exibe imagem na tela sem checar se ela saiu da tela (mais r pido) }
var
 size  : Word;
 iddr  : Word;
 iddr2 : Word;
 xx,yy : Integer;
 cor   : Byte;
 vx,vy : Integer;
label l1,l2,l3;
begin

 iddr:=Seg(Img^); { Vˆ o segmento da imagem }
 iddr2:=Ofs(Img^);

 Asm

  push ds        { Salva seg. de dados }

  mov ax,iddr
  mov es,ax        { Aponta seg. de dados para Seg da imagem }
  mov di,iddr2
  mov ax,es:[di]
  mov xx,ax        { Pega o tamanho xx }
  add di,2
  mov ax,es:[di]   { E o tamanho yy }
  mov yy,ax
  add di,2

  mov ax,Where
  mov ds,ax       { Aponta o destino para tela ou tela virtual }

  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx       { Calcula o offset do primeiro ponto }

  mov ax,[y]
  mov [vy],ax     { Move posi‡Æo y para virtual y }

l2:
  mov ax,bx
  mov [vx],ax     { Move posi‡Æo x para virtual x }
  mov cx,[xx]     { Contador do tamanho xx }
l1:
  mov al,es:[di]  { Pega a cor da v rivel de imagem }
  cmp al,0        { Se ela for zero, nÆo plota }
  je l3
  mov ds:[si],al  { Caso contr rio, plota na tela ou t. virtual }
l3:
  inc di          { Incrementa posi‡Æo da var. imagem }
  inc si          { Incrementa posi‡Æo da tela ou t.v. }
  inc [vx]        { Incrementa virtual x }
  dec cx          { Decrementa contador de tamanho xx }
  jnz l1

  add si,320      { Incrementa uma linha na tela ou tv }
  sub si,[xx]     { E volta o tamanho xx }
  inc [vy]        { Incrementa o virtual y }
  dec [yy]        { Decrementa tamanho yy }
  jnz l2

  pop ds          { Retorna segmento de dados }

 End;

End;


{******** PutImageZ ********************************************************}
procedure PutImageZ( x,y : Integer; var Img : Pointer; where : Word );  { Exibe imagem na tela com brancos }
var
 size  : Word;
 iddr,iddr2  : Word;
 xx,yy : Integer;
 cor   : Byte;
 vx,vy : Integer;
label l1,l2,l3,l4,l5,l6,l7;
begin

 iddr:=Seg(Img^); { Vˆ o segmento da imagem }
 iddr2:=Ofs(Img^);

 Asm

  push ds        { Salva seg. de dados }

  mov ax,iddr
  mov es,ax        { Aponta seg. de dados para Seg da imagem }
  mov di,iddr2
  mov ax,es:[di]
  mov xx,ax        { Pega o tamanho xx }
  add di,2
  mov ax,es:[di]   { E o tamanho yy }
  mov yy,ax
  add di,2

  mov ax,[yy]
  not ax         { nega o valor de yy (torna-o negativo) }
  inc ax
  cmp y,ax       { Verifica se a imagem est  em yy linhas negativas   }
  jle l7         { Se est , ela nÆo aparecer  na tela, entÆo cai fora }

  mov ax,Where
  mov ds,ax       { Aponta o destino para tela ou tela virtual }

  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx       { Calcula o offset do primeiro ponto }

  cmp [y],0
  jge l4          { Se y for maior ou igual a 0, pula para l4 }

 { Daqui at‚ o label l4, verifica sobre a posi‡Æo y negativa }
  xor si,si       { Zera si }
  add si,[x]      { Aponta si para posi‡Æo x }
  not [y]
  inc y
  mov ax,[y]
  sub [yy],ax

  mov cx,[y]      { Contador para y linha negativas }
  mov ax,0
l5:
  add ax,[xx]     { Incrementa y linhas que nÆo aparecerÆo }
  mov di,ax
  dec cx
  jnz l5
  add ax,4
  add ax,iddr2
  mov di,ax      { Posi‡Æo certa, linha 0, posi‡Æo x }

l4:
  mov ax,[y]
  mov [vy],ax     { Move posi‡Æo y para virtual y }

l2:
  mov ax,bx
  mov [vx],ax     { Move posi‡Æo x para virtual x }
  mov cx,[xx]     { Contador do tamanho xx }

  cmp [vy],199    { Compara vy com 199, se maior, pula para l7 (sai fora) }
  jg l7
l1:
  cmp [vx],0      { Compara vx com zero, se menor pula para l3 (nÆo plota o ponto) }
  jl l3
  cmp [vx],319    { Compara vx com 319, se maior, pula para l3 (nÆo plot) }
  jg l3

  mov al,es:[di]  { Pega a cor da v rivel de imagem }
  mov ds:[si],al  { Caso contr rio, plota na tela ou t. virtual }
l3:
  inc di          { Incrementa posi‡Æo da var. imagem }
  inc si          { Incrementa posi‡Æo da tela ou t.v. }
  inc [vx]        { Incrementa virtual x }
  dec cx          { Decrementa contador de tamanho xx }
  jnz l1

  add si,320      { Incrementa uma linha na tela ou tv }
  sub si,[xx]     { E volta o tamanho xx }
  inc [vy]        { Incrementa o virtual y }
  dec [yy]        { Decrementa tamanho yy }
  jnz l2

l7:

  pop ds          { Retorna segmento de dados }

 End;

End;



{******** PutImageI ********************************************************}
procedure PutImageI( x,y : Integer; var Img : Pointer; where : Word );  { Exibe imagem invertida na tela }
var
 size  : Word;
 iddr,iddr2  : Word;
 xx,yy : Integer;
 cor   : Byte;
 vx,vy : Integer;
label l1,l2,l3,l4,l5,l6,l7;
begin
 iddr:=Seg(Img^); { Vˆ o segmento da imagem }
 iddr2:=Ofs(Img^);
 Asm
  push ds        { Salva seg. de dados }
  mov ax,iddr
  mov es,ax        { Aponta seg. de dados para Seg da imagem }
  mov di,iddr2
  mov ax,es:[di]
  mov xx,ax        { Pega o tamanho xx }
  add di,2
  mov ax,es:[di]   { E o tamanho yy }
  mov yy,ax
  add di,2
  add di,[xx]
  sub di,1

  mov ax,[yy]
  not ax         { nega o valor de yy (torna-o negativo) }
  inc ax
  cmp y,ax       { Verifica se a imagem est  em yy linhas negativas   }
  jle l7         { Se est , ela nÆo aparecer  na tela, entÆo cai fora }
  mov ax,Where
  mov ds,ax       { Aponta o destino para tela ou tela virtual }
  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx       { Calcula o offset do primeiro ponto }
  cmp [y],0
  jge l4          { Se y for maior ou igual a 0, pula para l4 }
 { Daqui at‚ o label l4, verifica sobre a posi‡Æo y negativa }
  xor si,si       { Zera si }
  add si,[x]      { Aponta si para posi‡Æo x }
  not [y]
  inc y
  mov ax,[y]
  sub [yy],ax
  mov cx,[y]      { Contador para y linha negativas }
  mov ax,0
l5:
  add ax,[xx]     { Incrementa y linhas que nÆo aparecerÆo }
  mov di,ax
  dec cx
  jnz l5
  add ax,4
  add ax,iddr2
  mov di,ax      { Posi‡Æo certa, linha 0, posi‡Æo x }
  add di,[xx]
  sub di,1
l4:
  mov ax,[y]
  mov [vy],ax     { Move posi‡Æo y para virtual y }
l2:
  mov ax,bx
  mov [vx],ax     { Move posi‡Æo x para virtual x }
  mov cx,[xx]     { Contador do tamanho xx }
  cmp [vy],199    { Compara vy com 199, se maior, pula para l7 (sai fora) }
  jg l7
l1:
  cmp [vx],0      { Compara vx com zero, se menor pula para l3 (nÆo plota o ponto) }
  jl l3
  cmp [vx],319    { Compara vx com 319, se maior, pula para l3 (nÆo plot) }
  jg l3
  mov al,es:[di]  { Pega a cor da v rivel de imagem }
  cmp al,0        { Se ela for zero, nÆo plota }
  je l3
  mov ds:[si],al  { Caso contr rio, plota na tela ou t. virtual }
l3:
  dec di          { Incrementa posi‡Æo da var. imagem }
  inc si          { Incrementa posi‡Æo da tela ou t.v. }
  inc [vx]        { Incrementa virtual x }
  dec cx          { Decrementa contador de tamanho xx }
  jnz l1
  add si,320      { Incrementa uma linha na tela ou tv }
  sub si,[xx]     { E volta o tamanho xx }
  add di,[xx]
  add di,[xx]
  inc [vy]        { Incrementa o virtual y }
  dec [yy]        { Decrementa tamanho yy }
  jnz l2
l7:
  pop ds          { Retorna segmento de dados }
 End;
End;


{******** PutImageNCI ******************************************************}
procedure PutImageNCI( x,y : Word; var Img : Pointer; where : Word );
          { Exibe imagem inv. na tela sem checar se ela saiu da tela (mais r pido) }
var
 size  : Word;
 iddr,iddr2  : Word;
 xx,yy : Integer;
 cor   : Byte;
 vx,vy : Integer;
label l1,l2,l3;
begin
 iddr:=Seg(Img^); { Vˆ o segmento da imagem }
 iddr2:=Ofs(Img^);
 Asm
  push ds        { Salva seg. de dados }
  mov ax,iddr
  mov es,ax        { Aponta seg. de dados para Seg da imagem }
  mov di,iddr2
  mov ax,es:[di]
  mov xx,ax        { Pega o tamanho xx }
  add di,2
  mov ax,es:[di]   { E o tamanho yy }
  mov yy,ax
  add di,2
  add di,[xx]
  sub di,1

  mov ax,Where
  mov ds,ax       { Aponta o destino para tela ou tela virtual }
  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx       { Calcula o offset do primeiro ponto }
  mov ax,[y]
  mov [vy],ax     { Move posi‡Æo y para virtual y }
l2:
  mov ax,bx
  mov [vx],ax     { Move posi‡Æo x para virtual x }
  mov cx,[xx]     { Contador do tamanho xx }
l1:
  mov al,es:[di]  { Pega a cor da v rivel de imagem }
  cmp al,0        { Se ela for zero, nÆo plota }
  je l3
  mov ds:[si],al  { Caso contr rio, plota na tela ou t. virtual }
l3:
  dec di          { Decrementa posi‡Æo da var. imagem }
  inc si          { Incrementa posi‡Æo da tela ou t.v. }
  inc [vx]        { Incrementa virtual x }
  dec cx          { Decrementa contador de tamanho xx }
  jnz l1
  add si,320      { Incrementa uma linha na tela ou tv }
  sub si,[xx]     { E volta o tamanho xx }
  add di,[xx]
  add di,[xx]
  inc [vy]        { Incrementa o virtual y }
  dec [yy]        { Decrementa tamanho yy }
  jnz l2
  pop ds          { Retorna segmento de dados }
 End;
End;


{******** PutImageI2 ********************************************************}
procedure PutImageI2( x,y : Integer; var Img : Pointer; where : Word );  { Exibe imagem invertida na tela }
var
 size  : Word;
 iddr,iddr2  : Word;
 xx,yy : Integer;
 cor   : Byte;
 vx,vy : Integer;
label l1,l2,l3,l4,l5,l6,l7;
begin
 iddr:=Seg(Img^); { Vˆ o segmento da imagem }
 iddr2:=Ofs(Img^);
 Asm
  push ds        { Salva seg. de dados }
  mov ax,iddr
  mov es,ax        { Aponta seg. de dados para Seg da imagem }
  mov di,iddr2
  mov ax,es:[di]
  mov xx,ax        { Pega o tamanho xx }
  add di,2
  mov ax,es:[di]   { E o tamanho yy }
  mov yy,ax
  add di,2
  mov  ax,[xx]
  imul [yy]
  add di,ax
  sub di,1

  mov ax,[yy]
  not ax         { nega o valor de yy (torna-o negativo) }
  inc ax
  cmp y,ax       { Verifica se a imagem est  em yy linhas negativas   }
  jle l7         { Se est , ela nÆo aparecer  na tela, entÆo cai fora }
  mov ax,Where
  mov ds,ax       { Aponta o destino para tela ou tela virtual }
  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx       { Calcula o offset do primeiro ponto }
  cmp [y],0
  jge l4          { Se y for maior ou igual a 0, pula para l4 }
 { Daqui at‚ o label l4, verifica sobre a posi‡Æo y negativa }
  xor si,si       { Zera si }
  add si,[x]      { Aponta si para posi‡Æo x }
  not [y]
  inc y
  mov ax,[y]
  sub [yy],ax
  mov cx,[y]      { Contador para y linha negativas }
  mov ax,di
  sub ax,4
l5:
  sub ax,[xx]     { Incrementa y linhas que nÆo aparecerÆo }
  mov di,ax
  dec cx
  jnz l5
  add ax,4
{  add ax,iddr2 }
  mov di,ax      { Posi‡Æo certa, linha 0, posi‡Æo x }

l4:
  mov ax,[y]
  mov [vy],ax     { Move posi‡Æo y para virtual y }
l2:
  mov ax,bx
  mov [vx],ax     { Move posi‡Æo x para virtual x }
  mov cx,[xx]     { Contador do tamanho xx }
  cmp [vy],199    { Compara vy com 199, se maior, pula para l7 (sai fora) }
  jg l7
l1:
  cmp [vx],0      { Compara vx com zero, se menor pula para l3 (nÆo plota o ponto) }
  jl l3
  cmp [vx],319    { Compara vx com 319, se maior, pula para l3 (nÆo plot) }
  jg l3
  mov al,es:[di]  { Pega a cor da v rivel de imagem }
  cmp al,0        { Se ela for zero, nÆo plota }
  je l3
  mov ds:[si],al  { Caso contr rio, plota na tela ou t. virtual }
l3:
  dec di          { Decrementa posi‡Æo da var. imagem }
  inc si          { Incrementa posi‡Æo da tela ou t.v. }
  inc [vx]        { Incrementa virtual x }
  dec cx          { Decrementa contador de tamanho xx }
  jnz l1
  add si,320      { Incrementa uma linha na tela ou tv }
  sub si,[xx]     { E volta o tamanho xx }
  inc [vy]        { Incrementa o virtual y }
  dec [yy]        { Decrementa tamanho yy }
  jnz l2
l7:
  pop ds          { Retorna segmento de dados }
 End;
End;


{******** PutImageNCI2 *****************************************************}
procedure PutImageNCI2( x,y : Word; var Img : Pointer; where : Word );
          { Exibe imagem inv. na tela sem checar se ela saiu da tela (mais r pido) }
var
 size  : Word;
 iddr,iddr2  : Word;
 xx,yy : Integer;
 cor   : Byte;
 vx,vy : Integer;
label l1,l2,l3;
begin
 iddr:=Seg(Img^); { Vˆ o segmento da imagem }
 iddr2:=Ofs(Img^);
 Asm
  push ds        { Salva seg. de dados }
  mov ax,iddr
  mov es,ax        { Aponta seg. de dados para Seg da imagem }
  mov di,iddr2
  mov ax,es:[di]
  mov xx,ax        { Pega o tamanho xx }
  add di,2
  mov ax,es:[di]   { E o tamanho yy }
  mov yy,ax
  add di,2
  mov  ax,[xx]
  imul [yy]
  add di,ax
  sub di,1

  mov ax,Where
  mov ds,ax       { Aponta o destino para tela ou tela virtual }
  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx       { Calcula o offset do primeiro ponto }
  mov ax,[y]
  mov [vy],ax     { Move posi‡Æo y para virtual y }
l2:
  mov ax,bx
  mov [vx],ax     { Move posi‡Æo x para virtual x }
  mov cx,[xx]     { Contador do tamanho xx }
l1:
  mov al,es:[di]  { Pega a cor da v rivel de imagem }
  cmp al,0        { Se ela for zero, nÆo plota }
  je l3
  mov ds:[si],al  { Caso contr rio, plota na tela ou t. virtual }
l3:
  dec di          { Decrementa posi‡Æo da var. imagem }
  inc si          { Incrementa posi‡Æo da tela ou t.v. }
  inc [vx]        { Incrementa virtual x }
  dec cx          { Decrementa contador de tamanho xx }
  jnz l1
  add si,320      { Incrementa uma linha na tela ou tv }
  sub si,[xx]     { E volta o tamanho xx }
  inc [vy]        { Incrementa o virtual y }
  dec [yy]        { Decrementa tamanho yy }
  jnz l2
  pop ds          { Retorna segmento de dados }
 End;
End;


{******** PutImageI3 ********************************************************}
procedure PutImageI3( x,y : Integer; var Img : Pointer; where : Word );  { Exibe imagem invertida na tela }
var
 size  : Word;
 iddr,iddr2  : Word;
 xx,yy : Integer;
 cor   : Byte;
 vx,vy : Integer;
label l1,l2,l3,l4,l5,l6,l7;
begin
 iddr:=Seg(Img^); { Vˆ o segmento da imagem }
 iddr2:=Ofs(Img^);
 Asm
  push ds        { Salva seg. de dados }
  mov ax,iddr
  mov es,ax        { Aponta seg. de dados para Seg da imagem }
  mov di,iddr2
  mov ax,es:[di]
  mov xx,ax        { Pega o tamanho xx }
  add di,2
  mov ax,es:[di]   { E o tamanho yy }
  mov yy,ax
  add di,2
  mov  ax,[xx]
  imul [yy]
  add di,ax
  sub di,[xx]

  mov ax,[yy]
  not ax         { nega o valor de yy (torna-o negativo) }
  inc ax
  cmp y,ax       { Verifica se a imagem est  em yy linhas negativas   }
  jle l7         { Se est , ela nÆo aparecer  na tela, entÆo cai fora }
  mov ax,Where
  mov ds,ax       { Aponta o destino para tela ou tela virtual }
  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx       { Calcula o offset do primeiro ponto }
  cmp [y],0
  jge l4          { Se y for maior ou igual a 0, pula para l4 }
 { Daqui at‚ o label l4, verifica sobre a posi‡Æo y negativa }
  xor si,si       { Zera si }
  add si,[x]      { Aponta si para posi‡Æo x }
  not [y]
  inc y
  mov ax,[y]
  sub [yy],ax
  mov cx,[y]      { Contador para y linha negativas }
  mov ax,di
  sub ax,4
l5:
  sub ax,[xx]     { Incrementa y linhas que nÆo aparecerÆo }
  mov di,ax
  dec cx
  jnz l5
  add ax,4
{  add ax,iddr2 }
  mov di,ax      { Posi‡Æo certa, linha 0, posi‡Æo x }
l4:
  mov ax,[y]
  mov [vy],ax     { Move posi‡Æo y para virtual y }
l2:
  mov ax,bx
  mov [vx],ax     { Move posi‡Æo x para virtual x }
  mov cx,[xx]     { Contador do tamanho xx }
  cmp [vy],199    { Compara vy com 199, se maior, pula para l7 (sai fora) }
  jg l7
l1:
  cmp [vx],0      { Compara vx com zero, se menor pula para l3 (nÆo plota o ponto) }
  jl l3
  cmp [vx],319    { Compara vx com 319, se maior, pula para l3 (nÆo plot) }
  jg l3
  mov al,es:[di]  { Pega a cor da v rivel de imagem }
  cmp al,0        { Se ela for zero, nÆo plota }
  je l3
  mov ds:[si],al  { Caso contr rio, plota na tela ou t. virtual }
l3:
  inc di          { Decrementa posi‡Æo da var. imagem }
  inc si          { Incrementa posi‡Æo da tela ou t.v. }
  inc [vx]        { Incrementa virtual x }
  dec cx          { Decrementa contador de tamanho xx }
  jnz l1
  add si,320      { Incrementa uma linha na tela ou tv }
  sub si,[xx]     { E volta o tamanho xx }
  sub di,[xx]
  sub di,[xx]
  inc [vy]        { Incrementa o virtual y }
  dec [yy]        { Decrementa tamanho yy }
  jnz l2
l7:
  pop ds          { Retorna segmento de dados }
 End;
End;


{******** PutImageNCI3 *****************************************************}
procedure PutImageNCI3( x,y : Word; var Img : Pointer; where : Word );
          { Exibe imagem inv. na tela sem checar se ela saiu da tela (mais r pido) }
var
 size  : Word;
 iddr,iddr2  : Word;
 xx,yy : Integer;
 cor   : Byte;
 vx,vy : Integer;
label l1,l2,l3;
begin
 iddr:=Seg(Img^); { Vˆ o segmento da imagem }
 iddr2:=Ofs(Img^);
 Asm
  push ds        { Salva seg. de dados }
  mov ax,iddr
  mov es,ax        { Aponta seg. de dados para Seg da imagem }
  mov di,iddr2
  mov ax,es:[di]
  mov xx,ax        { Pega o tamanho xx }
  add di,2
  mov ax,es:[di]   { E o tamanho yy }
  mov yy,ax
  add di,2
  mov  ax,[xx]
  imul [yy]
  add di,ax
  sub di,[xx]

  mov ax,Where
  mov ds,ax       { Aponta o destino para tela ou tela virtual }
  mov bx,[x]
  mov dx,[y]
  xchg dh,dl
  mov si,dx
  shr si,2
  add si,dx
  add si,bx       { Calcula o offset do primeiro ponto }
  mov ax,[y]
  mov [vy],ax     { Move posi‡Æo y para virtual y }
l2:
  mov ax,bx
  mov [vx],ax     { Move posi‡Æo x para virtual x }
  mov cx,[xx]     { Contador do tamanho xx }
l1:
  mov al,es:[di]  { Pega a cor da v rivel de imagem }
  cmp al,0        { Se ela for zero, nÆo plota }
  je l3
  mov ds:[si],al  { Caso contr rio, plota na tela ou t. virtual }
l3:
  inc di          { Decrementa posi‡Æo da var. imagem }
  inc si          { Incrementa posi‡Æo da tela ou t.v. }
  inc [vx]        { Incrementa virtual x }
  dec cx          { Decrementa contador de tamanho xx }
  jnz l1
  add si,320      { Incrementa uma linha na tela ou tv }
  sub si,[xx]     { E volta o tamanho xx }
  sub di,[xx]
  sub di,[xx]
  inc [vy]        { Incrementa o virtual y }
  dec [yy]        { Decrementa tamanho yy }
  jnz l2
  pop ds          { Retorna segmento de dados }
 End;
End;





{******** Scroll ***********************************************************}
procedure Scroll( x1,y1,x2,y2 : Word; tax : Word; where : Word; horiz : Byte; esp : Byte );
var r,r2 : Word;
Begin
 x2:=x2-x1;
 if horiz>3 then begin
{  x2:=x2-tax; }
  y2:=y2-tax;
 end;

 x2:=x2-(esp-1);

 if horiz=1 then
  For r:=y1 to y2 do begin
   for r2:=1 to tax do
     move (mem[where:esp+(r*320)+x1],   mem[where:(r*320)+x1],x2);
  end;

 if horiz=2 then
  For r:=y1 to y2 do begin
   for r2:=1 to tax do
    move (mem[where:(r*320)+x1],   mem[where:esp+(r*320)+x1],x2-1);
  end;

 if horiz=3 then
  For r:=y1+tax to y2 do begin
   for r2:=1 to tax do
    move (mem[where:(r*320)+x1],   mem[where:(r*320)+x1-((320*esp)*r2)],x2+esp);
  end;

 if horiz=4 then
  For r:=y2 downto y1 do begin
   for r2:=tax downto 1 do
    move (mem[where:(r*320)+x1],mem[where:(r*320)+x1+((320*esp)*r2)],x2+esp);
   end;

End;


{******** Rectangle *********************************************************}
Procedure Rectangle(x,y,xx,yy : Integer; cor : Byte; where : Word );  { Desenha um retangulo }
Begin
 line(x ,y  ,xx,y   ,cor,where);
 line(x ,yy ,xx,yy  ,cor,where);
 line(x ,y+1,x ,yy-1,cor,where);
 line(xx,y+1,xx,yy-1,cor,where);
End;


{******** RectangleNC *******************************************************}
Procedure RectangleNC(x,y,xx,yy : Integer; cor : Byte; where : Word );  { Desenha um retangulo }
Begin
 lineNC(x ,y  ,xx,y   ,cor,where);
 lineNC(x ,yy ,xx,yy  ,cor,where);
 lineNC(x ,y+1,x ,yy-1,cor,where);
 lineNC(xx,y+1,xx,yy-1,cor,where);
End;


{******** SaveVPal **********************************************************}
procedure SaveVPal;
var w,R,G,B : Byte;
Begin
 for w:=0 to 255 do begin
  GetPal(w,R,G,B);
  VPal[w,1]:=R;
  VPal[w,2]:=G;
  VPal[w,3]:=B;
 end;
End;


{******** SetVPal ***********************************************************}
procedure SetVPal      (Col,R,G,B : Byte);
Begin
 VPal[Col,1]:=R;
 VPal[Col,2]:=G;
 VPal[Col,3]:=B;
End;


{******** FlipVPal **********************************************************}
procedure FlipVPal;
var w,R,G,B : Byte;
Begin
 for w:=0 to 255 do begin
  VPal[w,1]:=R;
  VPal[w,2]:=G;
  VPal[w,3]:=B;
  SetPal(w,R,G,B);
 end;
End;


{******** FlipOPal **********************************************************}
procedure FlipOPal;
var w,R,G,B : Byte;
Begin
 for w:=0 to 255 do begin
  SetPal(w,OPal[w,1],OPal[w,2],OPal[w,3]);
 end;
End;


{******** MuteVPal **********************************************************}
procedure MuteVPal( passes,retraces,ms : Word );
var w,R,G,B,w2,c : Byte;
    temp    : array[1..3] of Byte;
    finish  : LongInt;
label 1;
Begin
 SaveOPal;
 finish:=0; c:=0;
 while finish<255 do begin
  finish:=0;
  c:=c+1;
  if ms>0 then RDelay(ms);
  if retraces>0 then for w2:=1 to retraces do WaitRetrace;
  for w:=0 to 255 do begin
   GetPal(w,R,G,B);
   if R < VPal[w,1] then R:=R+1;
   if G < VPal[w,2] then G:=G+1;
   if B < VPal[w,3] then B:=B+1;
   if R > VPal[w,1] then R:=R-1;
   if G > VPal[w,2] then G:=G-1;
   if B > VPal[w,3] then B:=B-1;
   if(R=VPal[w,1]) and (G=VPal[w,2]) and (B=VPal[w,3]) then finish:=finish+1;
   SetPal(w,R,G,B);
   if finish>=255 then goto 1;
  end;
   if passes>0 then begin
    if c=passes then goto 1;
   end;
 end;
 1:;
End;


{******** FadeDown **********************************************************}
procedure FadeDown( num,retraces,ms : Word );
var w,w2,w3,R,G,B : Word;
    temp    : Array[1..3] of Byte;
Begin

if num>0 then
 for w:=1 to num do begin
  if ms>0 then RDelay(ms);
  if retraces>0 then for w3:=1 to retraces do WaitRetrace;
  for w2:=0 to 255 do begin
   GetPal(w2,temp[1],temp[2],temp[3]);
   if temp[1]>0 then temp[1]:=temp[1]-1;
   if temp[2]>0 then temp[2]:=temp[2]-1;
   if temp[3]>0 then temp[3]:=temp[3]-1;
   SetPal(w2,temp[1],temp[2],temp[3]);
  end;
 end;
End;


{******** FadeUp ************************************************************}
procedure FadeUp(num,retraces,ms : Word );
var w,w2,w3,R,G,B : Word;
    temp    : Array[1..3] of Byte;
Begin
if num>0 then
 for w:=1 to num do begin
  if ms>0 then RDelay(ms);
  if retraces>0 then for w3:=1 to retraces do WaitRetrace;
  for w2:=0 to 255 do begin
   GetPal(w2,temp[1],temp[2],temp[3]);
   if temp[1] < OPal[w2,1] then temp[1]:=temp[1]+1;
   if temp[2] < OPal[w2,2] then temp[2]:=temp[2]+1;
   if temp[3] < OPal[w2,3] then temp[3]:=temp[3]+1;
   SetPal(w2,temp[1],temp[2],temp[3]);
  end;
 end;
End;


{******** FadeUpWhite ******************************************************}
procedure FadeUpWhite(num,retraces,ms : Word );
var w,w2,w3,R,G,B : Word;
    temp    : Array[1..3] of Byte;
Begin
if num>0 then
 for w:=1 to num do begin
  if ms>0 then RDelay(ms);
  if retraces>0 then for w3:=1 to retraces do WaitRetrace;
  for w2:=0 to 255 do begin
   GetPal(w2,temp[1],temp[2],temp[3]);
   if temp[1] < 63 then temp[1]:=temp[1]+1;
   if temp[2] < 63 then temp[2]:=temp[2]+1;
   if temp[3] < 63 then temp[3]:=temp[3]+1;
   SetPal(w2,temp[1],temp[2],temp[3]);
  end;
 end;
End;


{******** RemoveRGB *********************************************************}
procedure RemoveRGB(RGB,num,retraces,ms : Word );
var w,w2,w3,R,G,B : Word;
    temp    : Array[1..3] of Byte;
Begin
if num>0 then
 for w:=1 to num do begin
  if ms>0 then RDelay(ms);
  if retraces>0 then for w3:=1 to retraces do WaitRetrace;
  for w2:=0 to 255 do begin
   GetPal(w2,temp[1],temp[2],temp[3]);
   if temp[RGB] > 0 then temp[RGB]:=temp[RGB]-1;
   SetPal(w2,temp[1],temp[2],temp[3]);
  end;
 end;
End;

{******** PutRGB ************************************************************}
procedure PutRGB(RGB,num,retraces,ms : Word );
var w,w2,w3,R,G,B : Word;
    temp    : Array[1..3] of Byte;
Begin
if num>0 then
 for w:=1 to num do begin
  if ms>0 then RDelay(ms);
  if retraces>0 then for w3:=1 to retraces do WaitRetrace;
  for w2:=0 to 255 do begin
   GetPal(w2,temp[1],temp[2],temp[3]);
   if temp[RGB] < opal[w2,RGB] then temp[RGB]:=temp[RGB]+1;
   SetPal(w2,temp[1],temp[2],temp[3]);
  end;
 end;
End;


{****************************************************************************}
procedure SaveOPal;
var w,R,G,B : Byte;
Begin
 For w:=0 to 255 do begin
  GetPal(w,R,G,B);
  OPal[w,1]:=R;
  OPal[w,2]:=G;
  OPal[w,3]:=B;
 end;
End;


{****************************************************************************}
procedure BlackOut;
var r : Word;
Begin
 for r:=0 to 255 do SetPal(r,0,0,0);
End;


{****************************************************************************}
procedure SwapOVPal;
var w,R,G,B : Byte;
    temp : array[0..255,1..3] of byte;
Begin
 for w:=0 to 255 do begin
  temp[w,1]:=vpal[w,1];
  temp[w,2]:=vpal[w,2];
  temp[w,3]:=vpal[w,3];
 end;
 for w:=0 to 255 do begin
  vpal[w,1]:=Opal[w,1];
  vpal[w,2]:=Opal[w,2];
  vpal[w,3]:=Opal[w,3];
 end;
 for w:=0 to 255 do begin
  Opal[w,1]:=temp[w,1];
  Opal[w,2]:=temp[w,2];
  Opal[w,3]:=temp[w,3];
 end;
End;





{******** ScaleZNC **********************************************************}
Procedure ScaleZNC (x,y,w,h : Word; img : Pointer; dest:word);
VAR jx,jy,depth,temp,origw,origh,source,iddr2:word;
Begin
 source:=Seg(IMG^);
 iddr2:=Ofs(Img^);
 Asm
  mov ax,source
  mov es,ax        { Aponta seg. de dados para Seg da imagem }
  mov di,iddr2
  mov ax,es:[di]
  mov [origw],ax        { Pega o tamanho xx }
  add di,2
  mov ax,es:[di]     { E o tamanho yy }
  mov [origh],ax
  add di,2
  dec origh

  push  ds

  mov   ax,source
  mov   ds,ax
  mov   ax,dest
  mov   es,ax
  mov   depth,0
  dec   h

  xor   si,si
  add   si,4

  xor   dx,dx
  mov   ax,origw
  shl   ax,6 {6}
  mov   bx,w
  div   bx
  shl   ax,2  {2}
  mov   jx,ax     { jx:=origw*256/w }

  xor   dx,dx
  mov   ax,origh
  shl   ax,6
  mov   bx,h
  div   bx
  shl   ax,2
  mov   jy,ax     { jy:=origh*256/h }

  xor   cx,cx
@Loop2 :          { vertical loop }
  push  cx
  mov   ax,depth
  add   ax,jy
  mov   depth,ax

  xor   dx,dx
  mov   ax,depth
  shr   ax,8
  mov   bx,origw
  mul   bx
  mov   temp,ax   { temp:=depth shr 8*origw;}

  mov   di,y
  add   di,cx
  mov   bx,di
  shl   di,8
  shl   bx,6
  add   di,bx
  add   di,x      { es:di = dest ... di=(loop1+y)*320+x }

  mov   cx,w
  xor   bx,bx
  mov   dx,jx
  mov   ax,temp
@Loop1 :          { horizontal loop }
  mov   si,bx
  shr   si,8
  add   si,ax     { ax = temp = start of line }
  add   si,4
  add   si,iddr2

  movsb

 @1:
  add   bx,dx

  dec   cx
  jnz   @loop1    { horizontal loop }

  pop   cx
  inc   cx
  cmp   cx,h
  jl    @loop2    { vertical loop }

  pop   ds
end;
End;

{******** ScaleNC **********************************************************}
Procedure ScaleNC (x,y,w,h : Word; img : Pointer; dest:word);
VAR jx,jy,depth,temp,origw,origh,source,cor,iddr2:word;
Begin
 source:=Seg(IMG^);
 iddr2:=Ofs(Img^);
 Asm
  mov ax,source
  mov es,ax        { Aponta seg. de dados para Seg da imagem }
  mov di,iddr2
  mov ax,es:[di]
  mov [origw],ax        { Pega o tamanho xx }
  add di,2
  mov ax,es:[di]   { E o tamanho yy }
  mov [origh],ax
  dec origh

  push  ds

  mov   ax,source
  mov   ds,ax
  mov   ax,dest
  mov   es,ax
  mov   depth,0
  dec   h

  xor   si,si
  add   si,4

  xor   dx,dx
  mov   ax,origw
  shl   ax,6
  mov   bx,w
  div   bx
  shl   ax,2
  mov   jx,ax     { jx:=origw*256/w }

  xor   dx,dx
  mov   ax,origh
  shl   ax,6
  mov   bx,h
  div   bx
  shl   ax,2
  mov   jy,ax     { jy:=origh*256/h }

  xor   cx,cx
@Loop2 :          { vertical loop }
  push  cx
  mov   ax,depth
  add   ax,jy
  mov   depth,ax

  xor   dx,dx
  mov   ax,depth
  shr   ax,8
  mov   bx,origw
  mul   bx
  mov   temp,ax   { temp:=depth shr 8*origw;}

  mov   di,y
  add   di,cx
  mov   bx,di
  shl   di,8
  shl   bx,6
  add   di,bx
  add   di,x      { es:di = dest ... di=(loop1+y)*320+x }

  mov   cx,w
  xor   bx,bx
  mov   dx,jx
  mov   ax,temp
@Loop1 :          { horizontal loop }
  mov   si,bx
  shr   si,8
  add   si,ax     { ax = temp = start of line }
  add   si,4

  push ax
  mov al,ds:[si]
  cmp al,0
  je  @1
  mov es:[di],al
 @1:
  pop ax

  inc  di

  add   bx,dx

  dec   cx
  jnz   @loop1    { horizontal loop }

  pop   cx
  inc   cx
  cmp   cx,h
  jl    @loop2    { vertical loop }

  pop   ds
end;
End;


{******** Scale *************************************************************}
Procedure Scale (x,y : Integer; w,h : Word; img : Pointer; dest:word);
VAR jx,jy,depth,temp,origw,origh,source,cor,iddr2:word;
    vx,vy : Integer;
Begin
 if x>=320 then Exit;
 if y>=200 then Exit;
 source:=Seg(IMG^);
 iddr2:=Ofs(IMG^);
 Asm
  mov ax,source
  mov es,ax        { Aponta seg. de dados para Seg da imagem }
  mov di,[iddr2]
  mov ax,es:[di]
  mov [origw],ax        { Pega o tamanho xx }
  add di,2
  mov ax,es:[di]   { E o tamanho yy }
  mov [origh],ax
  add di,2
  dec origh

  push  ds

  mov  ax,x
  mov  vx,ax
  mov  ax,y
  mov  vy,ax

  mov   ax,source
  mov   ds,ax
  mov   ax,dest
  mov   es,ax
  mov   depth,0
  dec   h

  xor   si,si
  add   si,4

  xor   dx,dx
  mov   ax,origw
  shl   ax,6
  mov   bx,w
  div   bx
  shl   ax,2
  mov   jx,ax     { jx:=origw*256/w }

  xor   dx,dx
  mov   ax,origh
  shl   ax,6
  mov   bx,h
  div   bx
  shl   ax,2
  mov   jy,ax     { jy:=origh*256/h }

  xor   cx,cx
@Loop2 :          { vertical loop }
  push  cx
  mov   ax,depth
  add   ax,jy
  mov   depth,ax

  xor   dx,dx
  mov   ax,depth
  shr   ax,8
  mov   bx,origw
  mul   bx
  mov   temp,ax   { temp:=depth shr 8*origw;}

  mov   di,y
  add   di,cx
  mov   bx,di
  shl   di,8
  shl   bx,6
  add   di,bx
  add   di,x      { es:di = dest ... di=(loop1+y)*320+x }

  mov   cx,w
  xor   bx,bx
  mov   dx,jx
  mov   ax,temp
@Loop1 :          { horizontal loop }
  mov   si,bx
  shr   si,8
  add   si,ax     { ax = temp = start of line }
  add   si,4
  add   si,[iddr2]

 push  ax

  cmp vy,0
  jl  @1

  mov al,ds:[si]
  cmp al,0
  je  @1
  mov es:[di],al
 @1:
  pop ax

  inc  di

  add   bx,dx

  inc   vx
  cmp   vx,319
  ja    @2
  cmp   vx,0
  jl    @2

  dec   cx
  jnz   @loop1    { horizontal loop }
@2:

  mov cx,x
  mov vx,cx

  pop   cx
  inc   cx

  inc   vy
  cmp   vy,199
  ja    @3

  cmp   cx,h
  jl    @loop2    { vertical loop }
@3:
  pop   ds
end;
End;



{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure InitChain4; ASSEMBLER;
  {  This procedure gets you into Chain 4 mode }
Asm
    mov    ax, 13h
    int    10h         { Get into MCGA Mode }

    mov    dx, 3c4h    { Port 3c4h = Sequencer Address Register }
    mov    al, 2       { Index 4 = memory mode }
    out    dx, al
    inc    dx          { Port 3c5h ... here we set the mem mode }
    in     al, dx
    and    al, not 08h { not 08h }
    or     al, 04h     { 04h }
    out    dx, al
    mov    dx, 3ceh
    mov    al, 5
    out    dx, al
    inc    dx
    in     al, dx
    and    al, not 10h { not 10h }
    out    dx, al
    dec    dx
    mov    al, 6 { 6 }
    out    dx, al
    inc    dx
    in     al, dx
    and    al, not 02h { not 02h }
    out    dx, al
    mov    dx, 3c4h
    mov    ax, (0fh shl 8)+2 {shl 8 +2 }
    out    dx, ax
    mov    ax, 0a000h
    mov    es, ax
    sub    di, di
    mov    ax, 0000h {8080h} { 0000h }
    mov    cx, 32768 { 32768 }
    cld
    rep    stosw            { Clear garbage off the screen ... }

    mov    dx, 3d4h
    mov    al, 14h   { 14h }
    out    dx, al
    inc    dx
    in     al, dx
    and    al, not 40h { not 40h }
    out    dx, al
    dec    dx
    mov    al, 17h   { 17h}
    out    dx, al
    inc    dx
    in     al, dx
    or     al, 40h  { 40h }
    out    dx, al

    mov    dx, 3d4h
    mov    al, 13h  { 13h }
    out    dx, al
    inc    dx
    mov    al, c4size     { Size * 8 = Pixels across. Only 320 are visible}
    out    dx, al
End;


{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure C4PutPixel(X,Y : Word; Col : Byte); ASSEMBLER;
  { This puts a pixel on the chain 4 screen }
Asm
    mov    ax,[y]
    xor    bx,bx
    mov    bl,c4size
    imul   bx
    shl    ax,1
    mov    bx,ax
    mov    ax, [X]
    mov    cx, ax
    shr    ax, 2
    add    bx, ax
    and    cx, 00000011b
    mov    ah, 1
    shl    ah, cl
    mov    dx, 3c4h                  { Sequencer Register    }
    mov    al, 2                     { Map Mask Index        }
    out    dx, ax

    mov    ax, 0a000h
    mov    es, ax
    mov    al, [col]
    mov    es: [bx], al
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure C4Plane(Which : Byte); ASSEMBLER;
  { This sets the plane to write to in Chain 4}
Asm
   mov     al, 2h
   mov     ah, 1
   mov     cl, [Which]
   shl     ah, cl
   mov     dx, 3c4h                  { Sequencer Register    }
   out     dx, ax
End;


{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
procedure c4moveto(x, y : integer);
  { This moves to position x*4,y on a chain 4 screen }
var o : word;
begin
 { o := y*c4size*2+x; } { size }
  o:=(y*80)+x;
  asm
    mov    bx, [o]
    mov    ah, bh
    mov    al, 0ch

    mov    dx, 3d4h
    out    dx, ax

    mov    ah, bl
    mov    al, 0dh
    mov    dx, 3d4h
    out    dx, ax
  end;
end;




{****************************************************************************}
VAR
 Loop1 : integer;
 R,G,B : Byte;

BEGIN
  For Loop1 := 0 to 199 do
    Scr_Ofs[Loop1] := Loop1 * 320;
  For Loop1 := 0 to 255 do begin
   GetPal(loop1,R,G,B);
   VPal[loop1,1]:=R;
   VPal[loop1,2]:=G;
   VPal[loop1,3]:=B;
  end;
  c4size:=160;
END.
