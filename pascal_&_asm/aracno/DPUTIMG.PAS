{
  DGM FAST RAW IMAGE CONTROL v1.0

  Copyright (c) 2000 David Maziero / DGM Inform tica

  Data : 16/11/2000

  Fun‡äes semelhantes aos PUTIMAGE's do DMODE13h mas 25% mais r pidos!!!
  Sem altera‡Æo da velocidade com rota‡Æo da imagem!!!
  ** THE BEST ***
}

 Unit DPutIMG;

 interface


 { fun‡äes sem CLIPPING, usam 320x200 como padrÆo }
 procedure XPutImage( x,y : Integer; img : Pointer; where : Word );
 procedure XPutImageDir( x,y : Integer; img : Pointer; dir : Byte; where : Word );
 procedure XPutImageCOR( x,y : Integer; img : Pointer; dir,tpcor,inccor : Byte; where : Word );
 procedure XPutImageSCOR( x,y : Integer; img : Pointer; dir,cor,outra : Byte; where : Word );

 implementation

 Uses Dmode13h;


{******** XPUTIMAGE ********* sim est  ‚ a fun‡Æo FLASH!!! muito r pida ***}
{                             quase na velocidade do BAR2!!!!!!            }
procedure XPutImage( x,y : Integer; img : Pointer; where : Word );
var
 xx,yy,sx,sy : Word;
 i1,i2 : Word;
 ipos  : Word;
 ex,ey : Word;
Begin
 i1:=SEG(img^);
 i2:=OFS(img^)+4;

 xx:=MemW[i1:i2-4];
 yy:=MemW[i1:i2-2];

 { vˆ se nÆo est  fora da tela }
 if(x>319) or (y>199) or (x+xx<=0) or (y+yy<=0) then Exit;

 sx:=0;  sy:=0;

 if x<0 then
  asm
   neg [x]     {torna x positivo}
   mov ax,[x]
   sub [xx],ax {subtrai x de ex }
   mov [sx],ax {aumenta sx (start x)}
   mov [x],0   {zera x}
  end;

 if y<0 then
  asm
   neg [y]     {torna y positivo}
   mov ax,[y]
   sub [yy],ax {subtrai y de ey }
   mov [sy],ax {aumenta sy (start y)}
   mov [y],0   {zera y}
  end;

 if y+yy>200 then
  asm
   mov ax,200
   sub ax,[y]
   mov [yy],ax
  end;

 if x+xx>320 then
  asm
   mov ax,320
   sub ax,[x]
   mov [xx],ax
  end;

 ex:=MemW[i1:i2-4]-xx;
 ey:=MemW[i1:i2-2]-yy;

 ipos:=i2+(MemW[i1:i2-4]*sy)+sx;

 {tudo ok? entÆo plota a imagem na tela}
 asm
   push ds
   {acha a posi‡Æo inicial do v¡deo}
   mov  ax,[where]
   mov  es,ax
   mov  bx,[y]
   shl  bx,1
   mov  di,word ptr [Scr_Ofs + bx]
   add  di,[x]

   mov  ax,[i1]
   mov  ds,ax
   mov  si,[ipos]

   mov  bx,[yy]
@3:
   mov  cx,[xx]
@2:
   mov  al,ds:[si]
   cmp  al,0
   je   @1
   mov  es:[di],al
@1:
   inc  di
   inc  si
   dec  cx
   jnz  @2

   add  si,[ex]
   add  di,320
   sub  di,[xx]
   dec  bx
   jnz  @3

   pop  ds
 end;

 { SPEED!!! }

End;


{******** XPUTIMAGEDIR *********** em diversas dire‡äes ********************}
{                                  sem altera‡Æo na velocidade!!!! incr¡vel!!! }
procedure XPutImageDir( x,y : Integer; img : Pointer; dir : Byte; where : Word );
var
 xx,yy,sx,sy : INTEGER;
 i1,i2 : Word;
 ipos  : Word;
 ex,ey : Word;
Begin
 i1:=SEG(img^);
 i2:=OFS(img^)+4;

 xx:=MemW[i1:i2-4];
 yy:=MemW[i1:i2-2];

 { vˆ se nÆo est  fora da tela }
 if(x>319) or (y>199) or (x+xx<=0) or (y+yy<=0) then Exit;

 sx:=0;  sy:=0;

 if x<0 then
  asm
   neg [x]     {torna x positivo}
   mov ax,[x]
   sub [xx],ax {subtrai x de ex }
   mov [sx],ax {aumenta sx (start x)}
   mov [x],0   {zera x}
  end;

 if y<0 then
  asm
   neg [y]     {torna y positivo}
   mov ax,[y]
   sub [yy],ax {subtrai y de ey }
   mov [sy],ax {aumenta sy (start y)}
   mov [y],0   {zera y}
  end;

 if y+yy>200 then
  asm
   mov ax,200
   sub ax,[y]
   mov [yy],ax
  end;

 if x+xx>320 then
  asm
   mov ax,320
   sub ax,[x]
   mov [xx],ax
  end;

 ex:=MemW[i1:i2-4]-xx;
 ey:=MemW[i1:i2-2]-yy;

{ normal }
if dir=1 then begin
ipos:=i2+(MemW[i1:i2-4]*sy)+sx;
 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2
   add  si,[ex]  ;  add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;

{ invertido }
if dir=2 then begin
 if x+xx<320 then begin
  ipos:=i2+(MemW[i1:i2-4]*sy)+(MemW[i1:i2-4]-ex)-1;
 end else
  ipos:=i2+(MemW[i1:i2-4]*sy)+(MemW[i1:i2-4])-1;

 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3: mov  cx,[xx]
@2: mov  al,ds:[si]
   cmp  al,0  ; je   @1
   mov  es:[di],al
@1:
   inc  di  ;  dec  si
   dec  cx  ;  jnz  @2
   add  si,[xx]
   add  si,[xx]
   add  si,[ex]
   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;

{ normal cabe‡a para baixo }
if dir=3 then begin

 if y>0 then
  ipos:=i2+(MemW[i1:i2-4]*(MemW[i1:i2-2]))-sx-1;
 if y<=0 then
  ipos:=i2+((MemW[i1:i2-4]*yy))-sx-1;

 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   mov  es:[di],al
@1:
   inc  di  ;  dec  si
   dec  cx  ;  jnz  @2

   sub  si,[ex]

   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;


{ normal cabe‡a para baixo invertido }
if dir=4 then begin

 if (y>0) and (x>0) and (x+xx<320) then begin
  ipos:=i2+(((MemW[i1:i2-4]*MemW[i1:i2-2])-sx)-xx);
 end;

 if (y>0) and (x+xx>=320) then begin
  ipos:=i2+(((MemW[i1:i2-4]*MemW[i1:i2-2])-xx))-ex;
  asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2
   sub  si,[ex]
   sub  si,[xx]
   sub  si,[xx]
   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
  end;
  Exit;
 end;

 if (y<=0) and (x<=0) then begin
  ipos:=i2+(((MemW[i1:i2-4]*yy)))-(xx);
  asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2
   sub  si,[ex]
   sub  si,[xx]
   sub  si,[xx]
   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
  end;
  Exit;
 end;

 if (y>0) and (x<=0) then begin
  ipos:=i2+((MemW[i1:i2-4]*MemW[i1:i2-2]) - MemW[i1:i2-4])+Ex;
 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2

   sub  si,[ex]
   sub  si,[xx]
   sub  si,[xx]

   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;

 if (y<=0) and (x>0) and (x+xx>=320) then begin
  ipos:=i2+((MemW[i1:i2-4]*yy))-(xx+ex);
 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2

   sub  si,[ex]
   sub  si,[xx]
   sub  si,[xx]

   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;

 if (y<=0) and (x>0) and (x+xx<320) then begin
  ipos:=i2+(((MemW[i1:i2-4]*(MemW[i1:i2-2]-ey-1))));
 end;

 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2
   sub  si,[xx]
   sub  si,[ex]
   sub  si,[xx]
   sub  si,[ex]
   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;


 { SPEED!!! }

End;



{******** XPUTIMAGECOR *********** em diversas dire‡äes c/ alt de cor *******}
{                      *********** sem mudan‡a de velocidade!!!!!     *******}
procedure XPutImageCOR( x,y : Integer; img : Pointer; dir,tpcor,inccor : Byte; where : Word );
var
 xx,yy,sx,sy : INTEGER;
 i1,i2 : Word;
 ipos  : Word;
 ex,ey : Word;
Begin
 i1:=SEG(img^);
 i2:=OFS(img^)+4;

 xx:=MemW[i1:i2-4];
 yy:=MemW[i1:i2-2];

 { vˆ se nÆo est  fora da tela }
 if(x>319) or (y>199) or (x+xx<=0) or (y+yy<=0) then Exit;

 sx:=0;  sy:=0;

 if x<0 then
  asm
   neg [x]     {torna x positivo}
   mov ax,[x]
   sub [xx],ax {subtrai x de ex }
   mov [sx],ax {aumenta sx (start x)}
   mov [x],0   {zera x}
  end;

 if y<0 then
  asm
   neg [y]     {torna y positivo}
   mov ax,[y]
   sub [yy],ax {subtrai y de ey }
   mov [sy],ax {aumenta sy (start y)}
   mov [y],0   {zera y}
  end;

 if y+yy>200 then
  asm
   mov ax,200
   sub ax,[y]
   mov [yy],ax
  end;

 if x+xx>320 then
  asm
   mov ax,320
   sub ax,[x]
   mov [xx],ax
  end;

 ex:=MemW[i1:i2-4]-xx;
 ey:=MemW[i1:i2-2]-yy;

{ normal }
if dir=1 then begin
ipos:=i2+(MemW[i1:i2-4]*sy)+sx;
 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,[tpcor]  ; je   @1
   cmp  al,0        ; je   @1
   add  al,[inccor]
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2
   add  si,[ex]  ;  add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;

{ invertido }
if dir=2 then begin
 if x+xx<320 then begin
  ipos:=i2+(MemW[i1:i2-4]*sy)+(MemW[i1:i2-4]-ex)-1;
 end else
  ipos:=i2+(MemW[i1:i2-4]*sy)+(MemW[i1:i2-4])-1;

 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3: mov  cx,[xx]
@2: mov  al,ds:[si]
   cmp  al,[tpcor]  ; je   @1
   cmp  al,0        ; je   @1
   add  al,[inccor]
   mov  es:[di],al
@1:
   inc  di  ;  dec  si
   dec  cx  ;  jnz  @2
   add  si,[xx]
   add  si,[xx]
   add  si,[ex]
   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;

{ normal cabe‡a para baixo }
if dir=3 then begin

 if y>0 then
  ipos:=i2+(MemW[i1:i2-4]*(MemW[i1:i2-2]))-sx-1;
 if y<=0 then
  ipos:=i2+((MemW[i1:i2-4]*yy))-sx-1;

 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,[tpcor]  ; je   @1
   cmp  al,0        ; je   @1
   add  al,[inccor]
   mov  es:[di],al
@1:
   inc  di  ;  dec  si
   dec  cx  ;  jnz  @2

   sub  si,[ex]

   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;


{ normal cabe‡a para baixo invertido }
if dir=4 then begin

 if (y>0) and (x>0) and (x+xx<320) then begin
  ipos:=i2+(((MemW[i1:i2-4]*MemW[i1:i2-2])-sx)-xx);
 end;

 if (y>0) and (x+xx>=320) then begin
  ipos:=i2+(((MemW[i1:i2-4]*MemW[i1:i2-2])-xx))-ex;
  asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,[tpcor]  ; je   @1
   cmp  al,0        ; je   @1
   add  al,[inccor]
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2
   sub  si,[ex]
   sub  si,[xx]
   sub  si,[xx]
   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
  end;
  Exit;
 end;

 if (y<=0) and (x<=0) then begin
  ipos:=i2+(((MemW[i1:i2-4]*yy)))-(xx);
  asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,[tpcor]  ; je   @1
   cmp  al,0        ; je   @1
   add  al,[inccor]
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2
   sub  si,[ex]
   sub  si,[xx]
   sub  si,[xx]
   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
  end;
  Exit;
 end;

 if (y>0) and (x<=0) then begin
  ipos:=i2+((MemW[i1:i2-4]*MemW[i1:i2-2]) - MemW[i1:i2-4])+Ex;
 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,[tpcor]  ; je   @1
   cmp  al,0        ; je   @1
   add  al,[inccor]
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2

   sub  si,[ex]
   sub  si,[xx]
   sub  si,[xx]

   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;

 if (y<=0) and (x>0) and (x+xx>=320) then begin
  ipos:=i2+((MemW[i1:i2-4]*yy))-(xx+ex);
 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,[tpcor]  ; je   @1
   cmp  al,0        ; je   @1
   add  al,[inccor]
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2

   sub  si,[ex]
   sub  si,[xx]
   sub  si,[xx]

   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;

 if (y<=0) and (x>0) and (x+xx<320) then begin
  ipos:=i2+(((MemW[i1:i2-4]*(MemW[i1:i2-2]-ey-1))));
 end;

 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,[tpcor]  ; je   @1
   cmp  al,0        ; je   @1
   add  al,[inccor]
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2
   sub  si,[xx]
   sub  si,[ex]
   sub  si,[xx]
   sub  si,[ex]
   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;


 { SPEED!!! }

End;




{******** XPUTIMAGESCOR ********** em diversas dire‡äes ********************}
{                                  muda UMA cor por OUTRA                   }
procedure XPutImageSCOR( x,y : Integer; img : Pointer; dir,cor,outra : Byte; where : Word );
var
 xx,yy,sx,sy : INTEGER;
 i1,i2 : Word;
 ipos  : Word;
 ex,ey : Word;
Begin
 i1:=SEG(img^);
 i2:=OFS(img^)+4;

 xx:=MemW[i1:i2-4];
 yy:=MemW[i1:i2-2];

 { vˆ se nÆo est  fora da tela }
 if(x>319) or (y>199) or (x+xx<=0) or (y+yy<=0) then Exit;

 sx:=0;  sy:=0;

 if x<0 then
  asm
   neg [x]     {torna x positivo}
   mov ax,[x]
   sub [xx],ax {subtrai x de ex }
   mov [sx],ax {aumenta sx (start x)}
   mov [x],0   {zera x}
  end;

 if y<0 then
  asm
   neg [y]     {torna y positivo}
   mov ax,[y]
   sub [yy],ax {subtrai y de ey }
   mov [sy],ax {aumenta sy (start y)}
   mov [y],0   {zera y}
  end;

 if y+yy>200 then
  asm
   mov ax,200
   sub ax,[y]
   mov [yy],ax
  end;

 if x+xx>320 then
  asm
   mov ax,320
   sub ax,[x]
   mov [xx],ax
  end;

 ex:=MemW[i1:i2-4]-xx;
 ey:=MemW[i1:i2-2]-yy;

{ normal }
if dir=1 then begin
ipos:=i2+(MemW[i1:i2-4]*sy)+sx;
 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   cmp  al,[cor]; jne @4
   mov  al,[outra]
@4:
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2
   add  si,[ex]  ;  add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;

{ invertido }
if dir=2 then begin
 if x+xx<320 then begin
  ipos:=i2+(MemW[i1:i2-4]*sy)+(MemW[i1:i2-4]-ex)-1;
 end else
  ipos:=i2+(MemW[i1:i2-4]*sy)+(MemW[i1:i2-4])-1;

 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3: mov  cx,[xx]
@2: mov  al,ds:[si]
   cmp  al,0  ; je   @1
   cmp  al,[cor]; jne @4
   mov  al,[outra]
@4:
   mov  es:[di],al
@1:
   inc  di  ;  dec  si
   dec  cx  ;  jnz  @2
   add  si,[xx]
   add  si,[xx]
   add  si,[ex]
   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;

{ normal cabe‡a para baixo }
if dir=3 then begin

 if y>0 then
  ipos:=i2+(MemW[i1:i2-4]*(MemW[i1:i2-2]))-sx-1;
 if y<=0 then
  ipos:=i2+((MemW[i1:i2-4]*yy))-sx-1;

 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   cmp  al,[cor]; jne @4
   mov  al,[outra]
@4:
   mov  es:[di],al
@1:
   inc  di  ;  dec  si
   dec  cx  ;  jnz  @2

   sub  si,[ex]

   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;


{ normal cabe‡a para baixo invertido }
if dir=4 then begin

 if (y>0) and (x>0) and (x+xx<320) then begin
  ipos:=i2+(((MemW[i1:i2-4]*MemW[i1:i2-2])-sx)-xx);
 end;

 if (y>0) and (x+xx>=320) then begin
  ipos:=i2+(((MemW[i1:i2-4]*MemW[i1:i2-2])-xx))-ex;
  asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   cmp  al,[cor]; jne @4
   mov  al,[outra]
@4:
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2
   sub  si,[ex]
   sub  si,[xx]
   sub  si,[xx]
   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
  end;
  Exit;
 end;

 if (y<=0) and (x<=0) then begin
  ipos:=i2+(((MemW[i1:i2-4]*yy)))-(xx);
  asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   cmp  al,[cor]; jne @4
   mov  al,[outra]
@4:
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2
   sub  si,[ex]
   sub  si,[xx]
   sub  si,[xx]
   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
  end;
  Exit;
 end;

 if (y>0) and (x<=0) then begin
  ipos:=i2+((MemW[i1:i2-4]*MemW[i1:i2-2]) - MemW[i1:i2-4])+Ex;
 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   cmp  al,[cor]; jne @4
   mov  al,[outra]
@4:
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2

   sub  si,[ex]
   sub  si,[xx]
   sub  si,[xx]

   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;

 if (y<=0) and (x>0) and (x+xx>=320) then begin
  ipos:=i2+((MemW[i1:i2-4]*yy))-(xx+ex);
 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   cmp  al,[cor]; jne @4
   mov  al,[outra]
@4:
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2

   sub  si,[ex]
   sub  si,[xx]
   sub  si,[xx]

   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;

 if (y<=0) and (x>0) and (x+xx<320) then begin
  ipos:=i2+(((MemW[i1:i2-4]*(MemW[i1:i2-2]-ey-1))));
 end;

 asm
   push ds       ;   mov  ax,[where]   ;   mov  es,ax   ;  mov  bx,[y]
   shl  bx,1     ;   mov  di,word ptr [Scr_Ofs + bx]    ;  add  di,[x]
   mov  ax,[i1]  ;   mov  ds,ax        ;   mov  si,[ipos]
   mov  bx,[yy]
@3:mov  cx,[xx]
@2:mov  al,ds:[si]
   cmp  al,0  ; je   @1
   cmp  al,[cor]; jne @4
   mov  al,[outra]
@4:
   mov  es:[di],al
@1:
   inc  di  ;  inc  si
   dec  cx  ;  jnz  @2
   sub  si,[xx]
   sub  si,[ex]
   sub  si,[xx]
   sub  si,[ex]
   add  di,320
   sub  di,[xx]
   dec  bx       ;  jnz  @3
   pop  ds
 end;
 Exit;
end;


 { SPEED!!! }

End;




End.

