{
  DGM Image Pack Unit v1.0

  Copyright (c) 2000 David Maziero / DGM Inform†tica

  Data : 16/11/00

  Funá‰es gr†ficas para carregamento e manipulaá∆o de imagems 'PACKEADAS'.
                                                             *COMPACTADAS!*
}

 Unit DPackImg;

 interface

 Function GetPackImg( ex,ey,xx,yy : Integer; var img : Pointer; where : Word ) : Word;
 Procedure PutPackImg( x,y : Integer; img : Pointer; where : Word );


 implementation

 Uses DMode13h;

{******* GetPackImg ****** retorna o size ou 0 se falhou ********************}
Function GetPackImg( ex,ey,xx,yy : Integer; var img : Pointer; where : Word ) : Word;
var
 ant,cor,cont : Byte;
 r,Pos,bk,Size : Word;
 x,y : Integer;
Begin

 if(ex<0) or (ey<0) or (xx>320) or (yy>200) then begin
  GetPackImg:=0; Exit;
 end;

 xx:=xx-ex;
 yy:=yy-ey;

 if(xx=0) or (yy=0) then begin
  GetPackImg:=0; Exit;
 end;

 ant:=0; cor:=0; cont:=0; Size:=6; bk:=0;
 { calcula o tamanho da imagem 'PACKEADA'!!! }
 for  y:=0 to yy do begin
  for x:=0 to xx do begin
   ant:=cor;
   cor:=GetPixel(ex+x,ey+y,where);
   cont:=cont+1;
   if (ant<>cor) or (cont>=xx-bk) or (cont>=255) then begin
    cont:=0; Size:=Size+2; bk:=x;
   end;
  end; { x }
  cor:=0;
 end;  { y }
 Size:=Size+4;

 if Size>65528 then begin GetPackImg:=0; Exit; end;
 { aloca a mem¢ria necess†ria }
 GetMem( img, Size );

 { define o cabeáalho da imagem }
 MemW[ SEG(img^):OFS(img^)   ] := xx;   { tamanho xx   }
 MemW[ SEG(img^):OFS(img^)+2 ] := yy;   { tamanho yy   }
 MemW[ SEG(img^):OFS(img^)+4 ] := Size; { tamanho Size }
 { limpa a imagem }
 for r:=6 to Size do Mem[ SEG(img^):OFS(img^)+r ]:=0;


 Pos:=6; { inicia na posiá∆o 6!!!! }
 ant:=0; cor:=0; cont:=0; bk:=0;

 { captura a imagem PACKEANDO-A!!! }
 for  y:=0 to yy do begin
  for x:=0 to xx do begin
   ant:=cor;
   cor:=GetPixel(ex+x,ey+y,where);
   cont:=cont+1;

   if (ant<>cor) or (cont>=(xx-bk)) or (cont>=255) then begin
    Mem[ SEG(img^):OFS(img^) + pos ] := cont; pos:=pos+1;
    Mem[ SEG(img^):OFS(img^) + pos ] := ant ; pos:=pos+1;
    cont:=0; bk:=x;
   end;
  end; { x }
  cor:=0;
 end;  { y }

 GetPackImg:=Size;
 { PRONTO! VOC“ ECONOMIZOU ALGUMA MEM‡RIA!!! (ou n∆o) }

End;


{******** PUTPACKIMG ********************************************************}
Procedure PutPackImg( x,y : Integer; img : Pointer; where : Word );
var
 xx,yy,ex,ey : Integer;
 video,i1,i2,pos : Word;
 ant,cor,cont : Byte;
Begin

 i1:=SEG(img^);
 i2:=OFS(img^);

 xx:=MemW[i1:i2  ];
 yy:=MemW[i1:i2+2];

 video:=(320*y)+x;

 Pos:=i2+6; ant:=0; cont:=0;


 asm
  push ds 

  mov ax,[where]
  mov es,ax
  mov di,[video] { posiá∆o inicial }

  mov ax,[i1]
  mov ds,ax


  mov ax,[yy]
  {for ey}
  mov bx,ax

 @200:
  mov ax,[xx]
  {for ex}
  mov cx,ax
  inc cx

 @100:
  {if ant=0}
  cmp [ant],0
  jne @1

   mov si,[pos]
   inc [pos]
   mov al,ds:[si]
   mov [cont],al

   mov si,[pos]
   inc [pos]
   mov al,ds:[si]
   mov [cor],al
   mov [ant],1

  @1: {ant<>0}

   {if cor>0}
   cmp [cor],0
   je @2

   mov al,[cor]
   mov es:[di],al

  @2: {cor>0}

   inc di

   dec [cont]
   jnz @3

   mov [ant],0

  @3:

   dec cx
   jnz @100

   add di,319
   sub di,[xx]

   dec bx
   jnz @200

  pop ds

 end;


{
 for  ey:=y to y+yy do begin
  for ex:=x to x+xx do begin

    if ant=0 then begin
     cont:=Mem[ i1:i2 + pos ]; pos:=pos+1;
     cor :=Mem[ i1:i2 + pos ]; pos:=pos+1;
     ant :=1;
    end;

     if cor>0 then begin
       asm
        mov ax,[where]
        mov es,ax
        mov di,[video]
        mov al,[cor]
        mov es:[di],al
       end;
     end;
       video:=video+1;

     cont:=cont-1;
     if cont<1 then ant:=0;

  end;
  video:=video+319-xx;
 end;
 }


End;

End.