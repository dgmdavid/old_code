{
  DGM MOUSE LIBRARY v1.0

  Copyright (c) 2000 David Maziero / DGM Informatica

  Data : 27/10/2000
}

{$F+}
Unit DGMMouse;

interface

const DMOUSE_COM1INTR = $0C;
      DMOUSE_COM1PORT = $3F8;

      DMOUSE_PNORMAL    = 0;
      DMOUSE_PHOURGLASS = 1;

var   DMOUSE_bytenum : word;
      DMOUSE_combytes : array[0..2] of byte;
      DMOUSE_x, DMOUSE_y   : Integer;
      DMOUSE_dx, DMOUSE_dy : Integer;
      DMOUSE_b1, DMOUSE_b2 : boolean;
      DMOUSE_MouseHandler : procedure;

      DMOUSE_MaxX,DMOUSE_MinX,
      DMOUSE_MaxY,DMOUSE_MinY : Integer;

      DMOUSE_divx,DMOUSE_divy : Byte;


{ funcoes para DGM Mouse Handles - aparentemente nao funciona no Windows }
procedure InitDGMMouse( xmin,ymin,xmax,ymax : Integer; divx,divy : Byte );
procedure ResetDGMMouse( xmin,ymin,xmax,ymax : Integer; divx,divy : Byte );
procedure PutSmallMouse( x,y : Integer; cor,tipo,horiz,shadow : Byte; where : Word );
procedure DoneDGMMouse;

{ funcoes com o DRIVER DE MOUSE }
function  InitMouse : boolean;
function  MouseDriverPresent : boolean;
procedure MouseOn;
procedure MouseOff;
procedure MouseInfo;
procedure MouseAct; { use esse }
function  LeftButton : boolean;
function  RightButton : boolean;
procedure LastButtonPress(button : integer; VAR x,y : integer);
procedure LastButtonRelease(button : integer; VAR x,y : integer);
procedure SetMousePos(x,y : integer);
procedure SetMouseWindow(x1,y1,x2,y2 : integer);
procedure SetMouseImage(hotx,hoty : integer; Image : pointer);
procedure ReadMouseMotionCounters;
procedure DefineMouseRatio(h,v : word);


implementation

Uses Crt,Dos,Dmode13h;



procedure PutSmallMouse( x,y : Integer; cor,tipo,horiz,shadow : Byte; where : Word );
Begin

{ if (x<DMOUSE_minx) or (x>DMOUSE_maxx) or
    (y<DMOUSE_miny) or (y>DMOUSE_maxy) then Exit; }


 { setinha normal }
 if tipo=DMOUSE_PNORMAL then begin
  { normal p/ esquerda (normal) }

  if shadow=1 then begin
   PutSmallMouse( DMOUSE_X+1,DMOUSE_Y  ,0,DMOUSE_PNORMAL,horiz,0,vaddr);
   PutSmallMouse( DMOUSE_X-1,DMOUSE_Y  ,0,DMOUSE_PNORMAL,horiz,0,vaddr);
   PutSmallMouse( DMOUSE_X  ,DMOUSE_Y-1,0,DMOUSE_PNORMAL,horiz,0,vaddr);
   PutSmallMouse( DMOUSE_X  ,DMOUSE_Y+1,0,DMOUSE_PNORMAL,horiz,0,vaddr);
   PutSmallMouse( DMOUSE_X-1,DMOUSE_Y-1,0,DMOUSE_PNORMAL,horiz,0,vaddr);
   PutSmallMouse( DMOUSE_X+1,DMOUSE_Y+1,0,DMOUSE_PNORMAL,horiz,0,vaddr);
   PutSmallMouse( DMOUSE_X-1,DMOUSE_Y+1,0,DMOUSE_PNORMAL,horiz,0,vaddr);
   PutSmallMouse( DMOUSE_X+1,DMOUSE_Y-1,0,DMOUSE_PNORMAL,horiz,0,vaddr);
  end;

  PutPixel( x  ,y  ,cor, where);
  if horiz=0 then begin
   PutPixel( x+1,y  ,cor, where); PutPixel( x+2,y  ,cor, where); PutPixel( x  ,y+1,cor, where);
   PutPixel( x  ,y+2,cor, where); PutPixel( x+1,y+1,cor, where); PutPixel( x+2,y+2,cor, where); PutPixel( x+3,y+3,cor, where);
   Exit; end;
  { cima }
  if horiz=1 then begin
   PutPixel( x  ,y+1,cor, where); PutPixel( x  ,y+2,cor, where); PutPixel( x  ,y+3,cor, where);
   PutPixel( x  ,y+4,cor, where); PutPixel( x-1,y+1,cor, where); PutPixel( x-2,y+2,cor, where); PutPixel( x+1,y+1,cor, where);
   PutPixel( x+2,y+2,cor, where); Exit; end;
  { normal p/ direita }
  if horiz=2 then begin
   PutPixel( x-1,y  ,cor, where); PutPixel( x-2,y  ,cor, where); PutPixel( x  ,y+1,cor, where);
   PutPixel( x  ,y+2,cor, where); PutPixel( x-1,y+1,cor, where); PutPixel( x-2,y+2,cor, where); PutPixel( x-3,y+3,cor, where);
   Exit; end;
  { frente }
  if horiz=3 then begin
   PutPixel( x-1,y  ,cor, where); PutPixel( x-2,y  ,cor, where); PutPixel( x-3,y  ,cor, where);
   PutPixel( x-4,y  ,cor, where); PutPixel( x-1,y-1,cor, where); PutPixel( x-2,y-2,cor, where); PutPixel( x-1,y+1,cor, where);
   PutPixel( x-2,y+2,cor, where); Exit; end;
  { normal p/ baixo direita }
  if horiz=4 then begin
   PutPixel( x  ,y-1,cor, where); PutPixel( x  ,y-2,cor, where); PutPixel( x-1,y  ,cor, where);
   PutPixel( x-2,y  ,cor, where); PutPixel( x-1,y-1,cor, where); PutPixel( x-2,y-2,cor, where); PutPixel( x-3,y-3,cor, where);
   Exit; end;
  { para baixo }
  if horiz=5 then begin
   PutPixel( x  ,y-1,cor, where); PutPixel( x  ,y-2,cor, where); PutPixel( x  ,y-3,cor, where);
   PutPixel( x  ,y-4,cor, where); PutPixel( x-1,y-1,cor, where); PutPixel( x-2,y-2,cor, where); PutPixel( x+1,y-1,cor, where);
   PutPixel( x+2,y-2,cor, where); Exit; end;
  { normal p/ baixo esquerda }
  if horiz=6 then begin
   PutPixel( x+1,y  ,cor, where); PutPixel( x+2,y  ,cor, where); PutPixel( x  ,y-1,cor, where);
   PutPixel( x  ,y-2,cor, where); PutPixel( x+1,y-1,cor, where); PutPixel( x+2,y-2,cor, where); PutPixel( x+3,y-3,cor, where);
   Exit; end;
  { tras (para esquerda) }
  if horiz=7 then begin
   PutPixel( x+1,y  ,cor, where); PutPixel( x+2,y  ,cor, where); PutPixel( x+3,y  ,cor, where);
   PutPixel( x+4,y  ,cor, where); PutPixel( x+1,y+1,cor, where); PutPixel( x+2,y+2,cor, where); PutPixel( x+1,y-1,cor, where);
   PutPixel( x+2,y-2,cor, where); Exit; end;
 end; { tipo = DMOUSE_PNORMAL }

 { ampulheta de espera }
 if tipo=DMOUSE_PHOURGLASS then begin

 end;


End;



{$F+,S-}
procedure DGMMouseHandler; interrupt;
var dx, dy : integer;
var inbyte : byte;
begin

  { Pega um byte na porta }
  inbyte := Port[DMOUSE_COM1PORT];

  if (inbyte and 64) = 64 then DMOUSE_bytenum := 0;

  DMOUSE_combytes[DMOUSE_bytenum] := inbyte;
  inc(DMOUSE_bytenum);

  { recebemos 3 bytes ? }
  if DMOUSE_bytenum = 3 then
    begin
      { sim, ent∆o processe-os }

      dx := (DMOUSE_combytes[0] and 3) shl 6 + DMOUSE_combytes[1];
      dy := (DMOUSE_combytes[0] and 12) shl 4 + DMOUSE_combytes[2];

      if dx >= 128 then dx := dx - 256;
      if dy >= 128 then dy := dy - 256;

      DMOUSE_dx:=(dx div DMOUSE_divx);
      DMOUSE_dy:=(dy div DMOUSE_divy);

      DMOUSE_x := DMOUSE_x + DMOUSE_dx;

      if DMOUSE_x<DMOUSE_MinX then DMOUSE_x:=DMOUSE_MinX;
      if DMOUSE_x>DMOUSE_MaxX then DMOUSE_x:=DMOUSE_MaxX;


      DMOUSE_y := DMOUSE_y + DMOUSE_dy;

      if DMOUSE_y<DMOUSE_MinY then DMOUSE_y:=DMOUSE_MinY;
      if DMOUSE_y>DMOUSE_MaxY then DMOUSE_y:=DMOUSE_MaxY;

      DMOUSE_b1 := (DMOUSE_combytes[0] And 32) <> 0;
      DMOUSE_b2 := (DMOUSE_combytes[0] And 16) <> 0;

      { e comeáe do primeiro byte novamente }
      DMOUSE_bytenum := 0;
    end;

  { tome conhecimento da interrupá∆o }
  Port[$20] := $20;

end;

procedure InitDGMMouse( xmin,ymin,xmax,ymax : Integer; divx,divy : Byte );
begin

  DMOUSE_MinX:= xmin;
  DMOUSE_MaxX:= xmax;

  DMOUSE_MinY:= ymin;
  DMOUSE_MaxY:= ymax;

  if divx=0 then divx:=1;
  if divy=0 then divy:=1;

  DMOUSE_divx:= divx;
  DMOUSE_divy:= divy;

  { inicializa o handler nomal do mouse }
  asm
    xor ax,ax
    int $33
  end;

  { inicializando as variaveis que ser∆o usadas }
  DMOUSE_bytenum := 0;
  DMOUSE_x  := (DMOUSE_MaxX-DMOUSE_MinX) div 2;
  DMOUSE_y  := (DMOUSE_MaxY-DMOUSE_MinY) div 2;
  DMOUSE_dx:=0;
  DMOUSE_dy:=0;
  DMOUSE_b1 := false;
  DMOUSE_b2 := false;

  { salva o handler de mouse antigo e poe o novo! }
  GetIntVec(DMOUSE_COM1INTR, @DMOUSE_MouseHandler);
  SetIntVec(DMOUSE_COM1INTR, Addr(DGMMouseHandler));

end;


procedure ResetDGMMouse( xmin,ymin,xmax,ymax : Integer; divx,divy : Byte );
Begin

  DMOUSE_MinX:= xmin;
  DMOUSE_MaxX:= xmax;

  DMOUSE_MinY:= ymin;
  DMOUSE_MaxY:= ymax;

  if divx=0 then divx:=1;
  if divy=0 then divy:=1;

  DMOUSE_divx:= divx;
  DMOUSE_divy:= divy;

  { iniciando vari†veis }
  DMOUSE_bytenum := 0;
  DMOUSE_x  := (DMOUSE_MaxX-DMOUSE_MinX) div 2;
  DMOUSE_y  := (DMOUSE_MaxY-DMOUSE_MinY) div 2;
  DMOUSE_dx:=0;
  DMOUSE_dy:=0;
  DMOUSE_b1 := false;
  DMOUSE_b2 := false;

End;


procedure DoneDGMMouse;
begin
  SetIntVec(DMOUSE_COM1INTR, @DMOUSE_MouseHandler);
end;


{ funcoes do DRIVER NORMAL }
function InitMouse : boolean; assembler;
asm
	xor	ax,ax
	int	$33
	not	ax
	xor	ax,1
	and	ax,1
end;

function MouseDriverPresent : boolean; assembler;
asm
	mov	ax,$21 {reset mouse}
	int	$33
	cmp	ax,-1
	je		@found
	mov	ax,$0	{not there. might be bad driver version... try setup mouse}
	int	$33
	push	ax
	mov	ax,$2	{quickly hide it again}
	int	$33
	pop	ax
@found:
	inc	ax
	xor	ax,1
end;

procedure MouseOn; assembler;
asm
	mov	ax,$0001
	int	$33
end;

procedure MouseOff; assembler;
asm
	mov	ax,$0002
	int	$33
end;

procedure MouseInfo;
procedure MouseInfo2(VAR x,y : integer; VAR lb,rb : boolean); assembler;
asm
	mov	ax,$0003
	int	$33
	les	si,x
	mov	[es:si],cx
	les	si,y
	mov	[es:si],dx

	mov	ax,bx
	and	al,1
	les	si,lb
	mov	[es:si],al
	shr	bl,1
	and	bl,1
	les	si,rb
	mov	[es:si],bl
end;
begin
 MouseInfo2(DMOUSE_x,DMOUSE_y,DMOUSE_b1,DMOUSE_b2);
 DMOUSE_x:=DMOUSE_x div 2;
end;

function LeftButton : boolean; assembler;
asm
	mov	ax,3
	int	$33
	mov	ax,bx
	and	ax,1
end;

function RightButton : boolean; assembler;
asm
	mov	ax,3
	int	$33
	mov	ax,bx
	shr	ax,1
	and	ax,1
end;

procedure LastButtonPress(button : integer; VAR x,y : integer); assembler;
asm
	mov	ax,5
	mov	bx,button
	int	$33
	les	di,x
	mov	[es:di],cx
	les	di,y
	mov	[es:di],dx
end;

procedure LastButtonRelease(button : integer; VAR x,y : integer); assembler;
asm
	mov	ax,6
	mov	bx,button
	int	$33
	les	di,x
	mov	[es:di],cx
	les	di,y
	mov	[es:di],dx
end;

procedure SetMousePos(x,y : integer); assembler;
asm
	mov	ax,$0004
	mov	cx,x
	mov	dx,y
	int	$33
end;

procedure SetMouseWindow(x1,y1,x2,y2 : integer);
procedure SetMouseWindow2(x1,y1,x2,y2 : integer); assembler;
asm
	mov	ax,$0007
	mov	cx,x1
	mov	dx,x2
	int	$33
	mov	ax,$0008
	mov	cx,y1
	mov	dx,y2
	int	$33
end;
begin
 SetMouseWindow2(x1,y1,x2,y2);
 DMOUSE_MINX:=X1;
 DMOUSE_MINY:=Y1;
 DMOUSE_MAXX:=X2;
 DMOUSE_MAXY:=Y2;
 DMOUSE_X:=(DMOUSE_MAXX-DMOUSE_MINX) div 2;
 DMOUSE_Y:=(DMOUSE_MAXY-DMOUSE_MINY) div 2;

end;

procedure SetMouseImage(hotx,hoty : integer; Image : pointer); assembler;
asm
	mov	ax,$0009
	mov	bx,hotx
	mov	cx,hoty
	les	dx,Image
	int	$33
end;

procedure DefineMouseRatio(h,v : word); assembler;
asm
	mov	ax,$000F
	mov	cx,h
	mov	dx,v
	int	$33
end;

procedure ReadMouseMotionCounters;
procedure ReadMouseMotionCounters2(VAR x,y : integer); assembler;
asm
	mov	ax,$000B
	int	$33
	les	di,x
	mov	[es:di],cx
	les	di,y
	mov	[es:di],dx
end;
begin
 ReadMouseMotionCounters2(DMOUSE_dx,DMOUSE_dy);
end;


procedure MouseAct;
procedure MouseInfo2(VAR x,y : integer; VAR lb,rb : boolean); assembler;
asm
	mov	ax,$0003
	int	$33
	les	si,x
	mov	[es:si],cx
	les	si,y
	mov	[es:si],dx

	mov	ax,bx
	and	al,1
	les	si,lb
	mov	[es:si],al
	shr	bl,1
	and	bl,1
	les	si,rb
	mov	[es:si],bl
end;
var
 x,y : Integer;
begin
 ReadMouseMotionCounters;
 DMOUSE_X:=DMOUSE_X+(DMOUSE_DX div 2);
 DMOUSE_Y:=DMOUSE_Y+(DMOUSE_DY div 2);

 if DMOUSE_X<=DMOUSE_MINX then DMOUSE_X:=DMOUSE_MINX;
 if DMOUSE_Y<=DMOUSE_MINY then DMOUSE_Y:=DMOUSE_MINY;

 if DMOUSE_X>=DMOUSE_MAXX then DMOUSE_X:=DMOUSE_MAXX;
 if DMOUSE_Y>=DMOUSE_MAXY then DMOUSE_Y:=DMOUSE_MAXY;

 MouseInfo2(x,y,DMOUSE_b1,DMOUSE_b2);
end;



begin
 DMOUSE_MINX:=0;
 DMOUSE_MINY:=0;
 DMOUSE_MAXX:=320;
 DMOUSE_MAXY:=200;
 DMOUSE_X:=160;
 DMOUSE_Y:=100;
end.