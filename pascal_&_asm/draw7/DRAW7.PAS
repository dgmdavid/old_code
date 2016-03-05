{
  DGM Draw vers∆o 7.0 - para o modo 320x200x256 cores

  Copyright (c) 1999 David Maziero / DGM Inform†tica

   * Tipos de Arquivos Criados por DGM Draw v7.0 :
   -> IMG - Uma imagem isolada (n∆o compat°vel com outros aplicativos que
                                eventualmente utilizam essa extens∆o      )
   -> DAT - V†rias imagems num s¢ arquivo ( novamente n∆o compativel com
                                            outros aplicativos            )
   -> PAL - Arquivo de Pallete de cores (n∆o compat°vel)
   -> MOV - Arquivo de movimento seqÅàncial (n∆o compat°vel)

  Data : 22/10/1999
}

{     " DGM Palette File v1.0 - DGM Inform†tica "
       123456789+123456789+123456789+123456789+1       }

  Uses Crt,Dos,DMODE13H,Divrf,DGMPCX;

  const
   palinf : string[41] = ' DGM Palette File v1.0 - DGM Inform†tica ';

  var
   t : Char;
   x,y,cor,back,back2,r,i,o,xx,yy,ex,ey,vert : Word;
   orix,oriy : Word;
   tx,ty : Word;
   x4 : Integer;
   visi : Byte;
   pal : array[0..255,1..3] of Byte; { V†riavel de pallete DGM }
   func : Byte;  { 0 - PutPixel     1 - Line
                   2 - Bar          3 - Rectangle
                   4 - Circle       5 - Salvar IMG
                   6 - Carregar     7 - Colar Imagem
                   8 - Recortar                                }

   s : PathStr;
   nomearq : String;
   f : file;
   size : LongInt;
   P : PathStr;
   D : DirStr;
   N : NameStr;
   E : ExtStr;

   img : Pointer;

  label 1,2;


   procedure FloodFill( x,y : Word; cor : Byte; where : Word );
   var
    ex,ey : Integer;
    stop : word;
    c,c2 : Byte;

   Begin
    ex:=x; ey:=y;
    c:=getPixel(ex,ey,where);

    for stop:=1 to 64000 do begin
     c2:=getPixel(ex,ey,where);
     if c2=c then PutPixel(ex,ey,cor,where);
     if c2<>c then begin
      ex:=x-1; ey:=ey+1;
      c2:=GetPixel(ex,ey,where);
      if c2<>c then stop:=64000;
     end;
     ex:=ex+1;
    end;
    ex:=x; ey:=y;
    stop:=1;
    for stop:=1 to 64000 do begin
     c2:=getPixel(ex,ey,where);
     if c2=c then PutPixel(ex,ey,cor,where);
     if c2<>c then begin
      ex:=x-1; ey:=ey-1;
      c2:=GetPixel(ex,ey,where);
      if c2<>c then stop:=64000;
     end;
     ex:=ex+1;
    end;

    ex:=x; ey:=y; stop:=1;
    for stop:=1 to 64000 do begin
     ex:=ex-1;
     c2:=getPixel(ex,ey,where);
     if c2=c then PutPixel(ex+1,ey,cor,where);
     if c2=c then PutPixel(ex,ey,cor,where);
     if c2<>c then begin
      ex:=x-1; ey:=ey-1;
      c2:=GetPixel(ex,ey,where);
      if c2<>c then stop:=64000;
     end;
{     ex:=ex-1; }
    end;

    ex:=x; ey:=y; stop:=1;
    for stop:=1 to 64000 do begin
     ex:=ex-1;
     c2:=getPixel(ex,ey,where);
     if c2=c then PutPixel(ex+1,ey,cor,where);
     if c2=c then PutPixel(ex,ey,cor,where);
     if c2<>c then begin
      ex:=x-1; ey:=ey+1;
      c2:=GetPixel(ex,ey,where);
      if c2<>c then stop:=64000;
     end;
{     ex:=ex-1; }
    end;



   End;


 Procedure Coloca; forward;

{ Procedure Zoom }
 Procedure Zoom;
 var
  xx,yy,back,work,ex,ey,bex,bey : Word;
  t : Char;
  pots : array[1..64,1..36] of Byte;
  bx,by : Word;
  label 1;
 Begin

  for ey:=1 to 36 do begin
  for ex:=1 to 64 do begin
   pots[ex,ey]:=0;
  end; end;

  flip(vaddr,vaddr2);
  while keypressed do t:=ReadKey; t:=#0;
  while(t<>#13) do begin
   RecTangle(x,y,x+64,y+36,2,vaddr);
   flip(vaddr,vga);
   flip(vaddr2,vaddr);
   t:=ReadKey;
   if t=#27 then Exit;
   if(t=FRENTE) and (x+64<319) then x:=x+1;
   if(t=TRAS  ) and (x>0     ) then x:=x-1;
   if(t=BAIXO ) and (y+36<185) then y:=y+1;
   if(t=CIMA  ) and (y>0     ) then y:=y-1;
   if(t='6') and (x+64<314) then x:=x+5;
   if(t='4') and (x>5     ) then x:=x-5;
   if(t='2') and (y+36<180) then y:=y+5;
   if(t='8') and (y>5     ) then y:=y-5;
  end;
   bx:=1; by:=1;
  1:;
{  flip(vaddr,vga); }
  { Captura Imagem }
  ex:=0; ey:=0;
  for ey:=1 to 36 do begin
  for ex:=1 to 64 do begin
   pots[ex,ey]:=GetPixel(x+(ex-1),y+(ey-1),vaddr);
  end;
  end;


  cls(vaddr,0);
  { Coloca com Zoom }
  for ey:=1 to 36 do begin
  for ex:=1 to 64 do begin
    Bar( (ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, pots[ex,ey],vaddr);
      if pots[ex,ey]=1 then begin
       Bar( (ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, pots[ex,ey],vaddr);
       Rectangle(1+(ex-1)*5,1+(ey-1)*5,4+(ex-1)*5,4+(ey-1)*5, 2,vaddr);
      end;
  end;
  end;
  flip(vaddr,vga);
  ex:=bx; ey:=by;
  while keypressed do t:=ReadKey; t:=#0; work:=0;

  while(t<>#13) and (t<>#27) do begin
   back:=GetPixel(2+(ex-1)*5,2+(ey-1)*5,vaddr);
   if work=1 then begin
    Bar( (ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, pots[ex,ey],vaddr);
      if pots[ex,ey]=1 then begin
       Bar( (ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, pots[ex,ey],vaddr);
       Rectangle(1+(ex-1)*5,1+(ey-1)*5,4+(ex-1)*5,4+(ey-1)*5, 2,vaddr);
      end;
   end;
   if work=0 then begin
    if cor<>pots[ex,ey] then Bar( (ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, cor,vaddr);
    if cor= pots[ex,ey] then Bar( (ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, 0,vaddr);
    if pots[ex,ey]=1    then begin
     Bar( (ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, 2,vaddr);
     Bar( 1+(ex-1)*5,1+(ey-1)*5,4+(ex-1)*5,4+(ey-1)*5, 0,vaddr);
     Bar( (ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, pots[ex,ey],vaddr);
     Rectangle(1+(ex-1)*5,1+(ey-1)*5,4+(ex-1)*5,4+(ey-1)*5, 2,vaddr);
    end;
    if(pots[ex,ey]=0) or (pots[ex,ey]=2) then begin
     Bar( (ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5,2,vaddr);
     line((ex-1)*5,(ey-1)*5,4+(ex-1)*5,4+(ey-1)*5,0,vaddr);
    end;
   end;

   case work of
    0 : work:=1;
    1 : work:=0;
   end;
   flip(vaddr,vga);
   Coloca; waitretrace;


   if work=1 then Bar( (ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, pots[ex,ey],vaddr);
      if pots[ex,ey]=1 then begin
       Bar( (ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, pots[ex,ey],vga);
       Rectangle(1+(ex-1)*5,1+(ey-1)*5,4+(ex-1)*5,4+(ey-1)*5, 2,vga);
      end;

   if not keypressed then t:=#0;
   if keypressed then t:=ReadKey;

   if(t=FRENTE) and (ex<64) then ex:=ex+1;
   if(t=TRAS)   and (ex>1 ) then ex:=ex-1;
   if(t=BAIXO)  and (ey<36) then ey:=ey+1;
   if(t=CIMA)   and (ey>1 ) then ey:=ey-1;

   if(t='6') and (ex<64-5) then ex:=ex+5;
   if(t='4') and (ex>1+5 ) then ex:=ex-5;
   if(t='2') and (ey<36-5) then ey:=ey+5;
   if(t='8') and (ey>1+5 ) then ey:=ey-5;

   if(t='7') and (ex>1) and (ey>1) then begin ex:=ex-1; ey:=ey-1; end;
   if(t='9') and (ex<64) and (ey>1) then begin ex:=ex+1; ey:=ey-1; end;
   if(t='1') and (ex>1) and (ey<36) then begin ex:=ex-1; ey:=ey+1; end;
   if(t='3') and (ex<64) and (ey<36) then begin ex:=ex+1; ey:=ey+1; end;

   if upcase(t)='Z' then cor:=pots[ex,ey];

   if(t='+') and (cor<255) then cor:=cor+1;
   if(t='-') and (cor>000) then cor:=cor-1;

   if UpCase(t)='R' then begin
    bey:=1; bex:=1;
    for bey:=1 to 36 do begin
    for bex:=1 to 64 do begin
      Bar( (bex-1)*5,(bey-1)*5,5+(bex-1)*5,5+(bey-1)*5, pots[bex,bey],vaddr);
      if pots[bex,bey]=1 then begin
       Bar( (bex-1)*5,(bey-1)*5,5+(bex-1)*5,5+(bey-1)*5, pots[bex,bey],vaddr);
       Rectangle(1+(bex-1)*5,1+(bey-1)*5,4+(bex-1)*5,4+(bey-1)*5, 2,vaddr);
      end;
    end;
    end;

   end;

   if t=#8 then begin
    Bar((ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, 0,vaddr);
    pots[ex,ey]:=0;
   end;
   if t='\' then begin
    Bar((ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, 1,vaddr);
    pots[ex,ey]:=1;
    Rectangle(1+(ex-1)*5,1+(ey-1)*5,4+(ex-1)*5,4+(ey-1)*5, 2,vaddr);
   end;
   if t=' ' then begin
    Bar((ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, cor,vaddr);
    pots[ex,ey]:=cor;
      if pots[ex,ey]=1 then begin
       Bar( (ex-1)*5,(ey-1)*5,5+(ex-1)*5,5+(ey-1)*5, pots[ex,ey],vaddr);
       Rectangle(1+(ex-1)*5,1+(ey-1)*5,4+(ex-1)*5,4+(ey-1)*5, 2,vaddr);
      end;
   end;

   if UpCase(t)='F' then begin
    bx:=ex; by:=ey;
    for ey:=1 to 36 do begin
    for ex:=1 to 64 do begin
     PutPixel(x+(ex-1),y+(ey-1),pots[ex,ey],vaddr2);
    end;
    end;
    Floodfill( x+(bx-1), y+(by-1), cor, vaddr2 );
    flip(vaddr2,vaddr);
    goto 1;
   end;



  end;

   if t=#13 then begin
    for ey:=1 to 36 do begin
    for ex:=1 to 64 do begin
     PutPixel(x+(ex-1),y+(ey-1),pots[ex,ey],vaddr2);
    end;
    end;
   end;

   flip(vaddr2,vaddr);
 End;


{ Funá∆o Coloca }
 Procedure Coloca;
 Begin
  Bar(0,186,319,199,0,vga);
  Line(0,186,319,186,2,vga);

  if cor-4<=255 then Line(290,188,319,188, cor-4,vga);
  if cor-3<=255 then Line(290,189,319,189, cor-3,vga);
  if cor-2<=255 then Line(290,190,319,190, cor-2,vga);
  if cor-1<=255 then Line(290,191,319,191, cor-1,vga);
  Line(280,192,319,192, cor  ,vga);
  if cor+1<=255 then Line(290,193,319,193, cor+1,vga);
  if cor+2<=255 then Line(290,194,319,194, cor+2,vga);
  if cor+3<=255 then Line(290,195,319,195, cor+3,vga);
  if cor+4<=255 then Line(290,196,319,196, cor+4,vga);
  Bar(260,188,280,197,cor,vga);

 End; { Coloca }

VAR LOOP1:WORD;

{ Funá∆o Principal }

  Begin

   ClrScr;
   WriteLn(' DGM Draw v7.0 - Copyright (c) 1999 David Maziero / DGM Inform†tica ');
   WriteLn(' Editor gr†fico para modo 320x200x256 cores ');
   WriteLn;
   WriteLn(' Iniciando telas virtuais...');

   SetUpVirtual(1); RDelay(150);
   SetUpVirtual(2); RDelay(150);

   WriteLn(' Iniciando modo gr†fico 320x200x256 cores...');
   RDelay(200);

   SetMCGA;

   { Inicia Pallete default }
   for r:=0 to 255 do begin
    GetPal( r, Pal[r,1], Pal[r,2], Pal[r,3] );
   end;
    Pal[0,1]:=000; Pal[0,2]:=000; Pal[0,3]:=000;
    Pal[1,1]:=255; Pal[1,2]:=255; Pal[1,3]:=255;
    SetPal(0,0,0,0);
    SetPal(1,0,0,0);
    SetPal(2,255,255,255);

{   Assign(f,'d:\dgm\draw7\dgmnorm.pal'); Reset(f,1); Seek(f,41);
   BlockRead(f,pal,sizeof(pal)); close(f);
   for r:=0 to 255 do SetPal(r,pal[r,1],pal[r,2],pal[r,3]); }



   { Faz 10 tons de cinza    x,x,x }
   x:=1; for loop1:=3 to 13 do begin x:=x+6; SetPal(loop1, x,x,x ); end; SetPal(loop1,63,63,63);
   { Faz 10 tons de vermelho x,0,0 }
   x:=1; for loop1:=14 to 24 do begin x:=x+6; SetPal(loop1, x,0,0 ); end; SetPal(loop1,63,0,0);
   { Faz 10 tons de verde    0,x,0 }
   x:=1; for loop1:=25 to 35 do begin x:=x+6; SetPal(loop1, 0,x,0 ); end; SetPal(loop1,0,63,0);
   { Faz 10 tons de azul     0,0,x }
   x:=1; for loop1:=36 to 46 do begin x:=x+6; SetPal(loop1, 0,0,x ); end; SetPal(loop1,0,0,63);
   { Faz 10 tons de amarelo  x,x,0 }
   x:=1; for loop1:=47 to 57 do begin x:=x+6; SetPal(loop1, x,x,0 ); end; SetPal(loop1,63,63,0);
   { Faz 10 tons de ciano    0,x,x }
   x:=1; for loop1:=58 to 68 do begin x:=x+6; SetPal(loop1, 0,x,x ); end; SetPal(loop1,0,63,63);
   { Faz 10 tons de violeta  x,0,x }
   x:=1; for loop1:=69 to 79 do begin x:=x+6; SetPal(loop1, x,0,x ); end; SetPal(loop1,63,0,63);
   { Faz 10 tons de laranja  x+16,32,0 }
   x:=27; for loop1:=80 to 90 do begin x:=x+2; SetPal(loop1,   x+16,32,0 ); end; SetPal(loop1,63,32,0);
   { Faz 10 tons de rosa     x+24,32,32 }
   x:=27; for loop1:=91 to 101 do begin x:=x+2; SetPal(loop1, x+16,32,32 ); end; SetPal(loop1,63,32,32);
   { Faz 10 tons de laranja escuro   x,x+32,0 }
   x:=38; for loop1:=102 to 112 do begin x:=x+2; SetPal(loop1, x,x+32,0 ); end; SetPal(loop1,61,61+31,0);
   { Faz 10 tons de bege dourado  x,x,x+48 }
   x:=32; for loop1:=113 to 123 do begin x:=x+2; SetPal(loop1, x,x,x+48 ); end; SetPal(loop1,58,58,58+48);
   { Faz 10 tons de marrom 2  x+16,x,x+48 }
   x:=14; for loop1:=124 to 134 do begin x:=x+2; SetPal(loop1, x+16,x,x+48 ); end; SetPal(loop1,x+17,x+1,x+49);
   { Faz 10 tons de bege +escuro  x+16,x+8,x+48 }
   x:=14; for loop1:=135 to 145 do begin x:=x+2; SetPal(loop1, x+16,x+8,x+48 ); end; SetPal(loop1,x+17,x+9,x+49);
   { Faz 10 tons de cinza escuro x+2,x+2,x+3 //x+6,x+12,x+12 }
   x:=6; for loop1:=146 to 156 do begin x:=x+2; SetPal(loop1, x+2,x+2,x+3 ); end; SetPal(loop1,x+3,x+3,x+4);
   { Faz 10 tons de roxo  x+6,x+4,32 }
   x:=0; for loop1:=157 to 167 do begin x:=x+2; SetPal(loop1, x+6,x+4,32 ); end; SetPal(loop1,x+7,x+5,32);
   { Faz 10 tons de marrom +escuro  x+16,x+2,x+1 }
   x:=0; for loop1:=168 to 178 do begin SetPal(loop1, 16+x,x+2,x+1 ); x:=x+2; end; SetPal(loop1,x+16,x+2,x+1);
   { Faz 10 tons de roxo/violeta x+18,x+2,x-42 }
   x:=0; for loop1:=179 to 189 do begin x:=x+2; SetPal(loop1, x+18,x+2,x-42 );  end; SetPal(loop1,x+19,x+3,x-43);
   { Faz 10 tons de ? }
   x:=0; for loop1:=190 to 200 do begin SetPal(loop1, x,63,x );  x:=x+5; end;   { Faz 10 tons de ? }
   x:=0; for loop1:=201 to 211 do begin SetPal(loop1, 63,x,x );  x:=x+5;end;   { Faz 10 tons de ? }
   x:=0; for loop1:=212 to 222 do begin SetPal(loop1, x,x,63 );  x:=x+5;end;   { Faz 10 tons de ? }
   x:=0; for loop1:=223 to 233 do begin SetPal(loop1, 63,x,63 );  x:=x+5;end;   { Faz 10 tons de ? }
   x:=0; for loop1:=234 to 244 do begin SetPal(loop1, 63,63,x );  x:=x+5;end;   { Faz 10 tons de ? }
   x:=0; for loop1:=245 to 255 do begin SetPal(loop1, x,63,63 );  x:=x+5; end;




   { Limpa tela e tela virtual }
   Cls(vga,0); Cls(vaddr,0);

   func:=0; i:=0; o:=0; x:=50; y:=50; cor:=1; xx:=50; yy:=50; vert:=1;
   tx:=1; ty:=1; visi:=1;

   { Limpa buffer do teclado }
   while keypressed do t:=ReadKey; t:=#0;

   DirectVideo:=False;

   { Inicia loop principal }
   while(t<>'!') do begin

    { PutPixel }
    if func=0 then begin
     back:=GetPixel(x,y,vaddr);
     PutPixel(x,y,cor,vaddr);
    end; { func=0 }

    { Line }
    if func=1 then begin
     flip(vaddr2,vaddr);
     line(x,y,xx,yy,cor,vaddr);
    end; { func=1 }

    { Bar }
    if func=2 then begin
     flip(vaddr2,vaddr);
     if(x<>xx) and (y<>yy) then begin
      if(x<xx) and (y<yy) then Bar(x,y,xx,yy,cor,vaddr);
      if(x>xx) and (y>yy) then Bar(xx,yy,x,y,cor,vaddr);
      if(x<xx) and (y>yy) then Bar(x,yy,xx,y,cor,vaddr);
      if(x>xx) and (y<yy) then Bar(xx,y,x,yy,cor,vaddr);
     end;
    end; { func=2 }

    { Rectangle }
    if func=3 then begin
     flip(vaddr2,vaddr);
     if(x<xx) and (y<yy) then Rectangle(x,y,xx,yy,cor,vaddr);
     if(x>xx) and (y>yy) then Rectangle(xx,yy,x,y,cor,vaddr);
     if(x<xx) and (y>yy) then Rectangle(x,yy,xx,y,cor,vaddr);
     if(x>xx) and (y<yy) then Rectangle(xx,y,x,yy,cor,vaddr);
    end; { func=3 }

    { Salvar IMG }
    if func=5 then begin
     flip(vaddr2,vaddr);
     Rectangle(x,y,x+ex,y+ey,2,vaddr);
    end; { func=5 }

    { Colar IMG }
    if func=7 then begin
     flip(vaddr2,vaddr);

     if(tx=orix) and (ty=oriy) then begin
      if vert=1 then PutImage(x,y,img,vaddr);
      if vert=2 then PutImageI(x,y,img,vaddr);
      if vert=3 then PutImageI2(x,y,img,vaddr);
      if vert=4 then PutImageI3(x,y,img,vaddr);
     end;

     if(tx<>orix) and (ty<>oriy) or
       (tx<>orix) and (ty=oriy) or
       (tx=orix) and (ty<>oriy) then begin
      if vert=1 then ScaleNC(x,y,tx,ty,img,vaddr);
      if vert=2 then ScaleNC(x,y,tx,ty,img,vaddr);
      if vert=3 then ScaleNC(x,y,tx,ty,img,vaddr);
      if vert=4 then ScaleNC(x,y,tx,ty,img,vaddr);
     end;

    end; { func=7 }

    { Recortar }
    if func=8 then begin
     flip(vaddr2,vaddr);
     if(x<xx) and (y<yy) then Rectangle(x,y,xx,yy,cor,vaddr);
     if(x>xx) and (y>yy) then Rectangle(xx,yy,x,y,cor,vaddr);
     if(x<xx) and (y>yy) then Rectangle(x,yy,xx,y,cor,vaddr);
     if(x>xx) and (y<yy) then Rectangle(xx,y,x,yy,cor,vaddr);
    end; { func=8 }


    { Poe tela virtual na tela real }
    flip(vaddr,vga);

    { Plota o cabeáalho }
    if visi=1 then Coloca;

   if visi=1 then begin
    if(func<>5) and (func<>7) then begin
     GotoXY(1,25); Write( x,',',y,',',cor,' ',i,',',o,':',xx,',',yy); end;
    if func=5 then begin
     GotoXY(1,25); Write( x,',',y,',',cor,' ',i,',',o,':',ex,',',ey); end;
    if func=7 then begin
     GotoXY(1,25); Write( x,',',y,' : ',vert,' : ',tx:2,',',ty:2); end;

    if func=0 then Write(' PutPixel');
    if func=1 then Write(' Line');
    if func=2 then Write(' Bar');
    if func=3 then Write(' Rectangle');
    if func=5 then Write(' Gravar');
    if func=6 then Write(' Ler IMG');
    if func=7 then Write(' Colar IMG');
    if func=8 then Write(' Recortar IMG');
   end;

    t:=ReadKey;
    if t=#0 then t:=ReadKey;

{inicia dgmnorm pal }
if t='@' then begin
   { Faz 10 tons de cinza    x,x,x }
   x:=1; for loop1:=3 to 13 do begin x:=x+6; SetPal(loop1, x,x,x ); end; SetPal(loop1,63,63,63);
   { Faz 10 tons de vermelho x,0,0 }
   x:=1; for loop1:=14 to 24 do begin x:=x+6; SetPal(loop1, x,0,0 ); end; SetPal(loop1,63,0,0);
   { Faz 10 tons de verde    0,x,0 }
   x:=1; for loop1:=25 to 35 do begin x:=x+6; SetPal(loop1, 0,x,0 ); end; SetPal(loop1,0,63,0);
   { Faz 10 tons de azul     0,0,x }
   x:=1; for loop1:=36 to 46 do begin x:=x+6; SetPal(loop1, 0,0,x ); end; SetPal(loop1,0,0,63);
   { Faz 10 tons de amarelo  x,x,0 }
   x:=1; for loop1:=47 to 57 do begin x:=x+6; SetPal(loop1, x,x,0 ); end; SetPal(loop1,63,63,0);
   { Faz 10 tons de ciano    0,x,x }
   x:=1; for loop1:=58 to 68 do begin x:=x+6; SetPal(loop1, 0,x,x ); end; SetPal(loop1,0,63,63);
   { Faz 10 tons de violeta  x,0,x }
   x:=1; for loop1:=69 to 79 do begin x:=x+6; SetPal(loop1, x,0,x ); end; SetPal(loop1,63,0,63);
   { Faz 10 tons de laranja  x+16,32,0 }
   x:=27; for loop1:=80 to 90 do begin x:=x+2; SetPal(loop1,   x+16,32,0 ); end; SetPal(loop1,63,32,0);
   { Faz 10 tons de rosa     x+24,32,32 }
   x:=27; for loop1:=91 to 101 do begin x:=x+2; SetPal(loop1, x+16,32,32 ); end; SetPal(loop1,63,32,32);
   { Faz 10 tons de laranja escuro   x,x+32,0 }
   x:=38; for loop1:=102 to 112 do begin x:=x+2; SetPal(loop1, x,x+32,0 ); end; SetPal(loop1,61,61+31,0);
   { Faz 10 tons de bege dourado  x,x,x+48 }
   x:=32; for loop1:=113 to 123 do begin x:=x+2; SetPal(loop1, x,x,x+48 ); end; SetPal(loop1,58,58,58+48);
   { Faz 10 tons de marrom 2  x+16,x,x+48 }
   x:=14; for loop1:=124 to 134 do begin x:=x+2; SetPal(loop1, x+16,x,x+48 ); end; SetPal(loop1,x+17,x+1,x+49);
   { Faz 10 tons de bege +escuro  x+16,x+8,x+48 }
   x:=14; for loop1:=135 to 145 do begin x:=x+2; SetPal(loop1, x+16,x+8,x+48 ); end; SetPal(loop1,x+17,x+9,x+49);
   { Faz 10 tons de cinza escuro x+2,x+2,x+3 //x+6,x+12,x+12 }
   x:=6; for loop1:=146 to 156 do begin x:=x+2; SetPal(loop1, x+2,x+2,x+3 ); end; SetPal(loop1,x+3,x+3,x+4);
   { Faz 10 tons de roxo  x+6,x+4,32 }
   x:=0; for loop1:=157 to 167 do begin x:=x+2; SetPal(loop1, x+6,x+4,32 ); end; SetPal(loop1,x+7,x+5,32);
   { Faz 10 tons de marrom +escuro  x+16,x+2,x+1 }
   x:=0; for loop1:=168 to 178 do begin SetPal(loop1, 16+x,x+2,x+1 ); x:=x+2; end; SetPal(loop1,x+16,x+2,x+1);
   { Faz 10 tons de roxo/violeta x+18,x+2,x-42 }
   x:=0; for loop1:=179 to 189 do begin x:=x+2; SetPal(loop1, x+18,x+2,x-42 );  end; SetPal(loop1,x+19,x+3,x-43);
   { Faz 10 tons de ? }
   x:=0; for loop1:=190 to 200 do begin SetPal(loop1, x,63,x );  x:=x+5; end;   { Faz 10 tons de ? }
   x:=0; for loop1:=201 to 211 do begin SetPal(loop1, 63,x,x );  x:=x+5;end;   { Faz 10 tons de ? }
   x:=0; for loop1:=212 to 222 do begin SetPal(loop1, x,x,63 );  x:=x+5;end;   { Faz 10 tons de ? }
   x:=0; for loop1:=223 to 233 do begin SetPal(loop1, 63,x,63 );  x:=x+5;end;   { Faz 10 tons de ? }
   x:=0; for loop1:=234 to 244 do begin SetPal(loop1, 63,63,x );  x:=x+5;end;   { Faz 10 tons de ? }
   x:=0; for loop1:=245 to 255 do begin SetPal(loop1, x,63,63 );  x:=x+5; end;
end;


    if t='&' then begin
     case visi of
      1 : visi:=0;
      0 : visi:=1;
     end;
    end;

    if t='%' then begin
     displaypcx(paramstr(1),vaddr,true);
     flip(vaddr,vga);
    end;

{    if t=' ' then Scroll( 5,5,315,175,2,vaddr,1,2 );
    if t=' ' then Scroll( 5,5,315,175,2,vaddr2,1,2 ); }

    if t='`' then cls(vaddr,0);


    { PutPixel }
    if func=0 then begin
     if i=1 then PutPixel(x,y,0,vaddr);
     if o=1 then PutPixel(x,y,back,vaddr);
    end; { func=0 }

    { Poe tela virtual na tela real }
 {    flip(vaddr,vga); }

    if UpCase(t)='I' then
     Case i of
      0 : i:=1;
      1 : i:=0;
     end;

    if UpCase(t)='O' then
     Case o of
      0 : o:=1;
      1 : o:=0;
     end;

    if UpCase(t)='V' then
     Case vert of
      1 : vert:=2;
      2 : vert:=3;
      3 : vert:=4;
      4 : vert:=1;
     end;

    if t=#27 then begin
     if func=7 then BitMapFree(img);
     if func<>0 then flip(vaddr2,vaddr);
     func:=0;
    end;

   if func=0 then begin
    if UpCase(t)='F' then FloodFill(x,y,cor,vaddr);
    if UpCase(t)='L' then begin
     func:=1; flip(vaddr,vaddr2); xx:=x; yy:=y;
    end;

    if UpCase(t)='B' then begin
     func:=2; flip(vaddr,vaddr2); xx:=x; yy:=y;
    end;

    if UpCase(t)='R' then begin
     xx:=x; yy:=y;
     func:=3; flip(vaddr,vaddr2);
    end;

    if UpCase(t)='G' then begin
     func:=5; flip(vaddr,vaddr2); ex:=5; ey:=5;
    end;

    if t='m' then begin
     func:=8; flip(vaddr,vaddr2);
    end;

    if UpCase(t)='X' then begin
     func:=6; flip(vaddr,vaddr2);
     while keypressed do t:=ReadKey; t:=#0;
    end;
   end;

    if(func=8) and (t=#13) then begin
     flip(vaddr2,vaddr);     t:=#0;
     if(x<xx) and (y<yy) then begin ex:=(xx-x)+1; ey:=(yy-y)+1; end;
     if(x>xx) and (y>yy) then begin ex:=(x-xx)+1; ey:=(y-yy)+1; end;
     if(x<xx) and (y>yy) then begin ex:=(xx-x)+1; ey:=(y-yy)+1; end;
     if(x>xx) and (y<yy) then begin ex:=(x-xx)+1; ey:=(yy-y)+1; end;
     size:=BitMapAlloc( ex, ey, img );
     if(x<xx) and (y<yy) then GetImage( x, y, img, vaddr );
     if(x>xx) and (y>yy) then GetImage( xx, yy, img, vaddr );
     if(x<xx) and (y>yy) then GetImage( x, yy, img, vaddr );
     if(x>xx) and (y<yy) then GetImage( xx, y, img, vaddr );
     func:=7;
      ex:=Seg(img^);
      Asm
       mov ax,ex
       mov es,ax      { Move segmento de dados para Seg da imagem }
       xor di,di
       mov ax,es:[di]  { Pega o valor xx da imagem }
       mov orix,ax
       add di,2
       mov ax,es:[di]  { Pega o valor yy da imagem }
       mov oriy,ax
      End;
   {$I+}
      tx:=orix; ty:=oriy;
    end;

    if(func<>0) and (t=#13) and (func<>5) then flip(vaddr,vaddr2);
    if(func=1) and (t=#13) or (func=2) and (t=#13) or (func=3) and (t=#13) then begin
     xx:=x; yy:=y;
    end;

   if func<>5 then begin
    if(t=FRENTE) and (x<319) then x:=x+1;
    if(t=TRAS  ) and (x>000) then x:=x-1;
    if(t=BAIXO ) and (y<199) then y:=y+1;
    if(t=CIMA  ) and (y>000) then y:=y-1;
   end;
   if func=5 then begin
    if(t=FRENTE) and (ex<319-x) then ex:=ex+1;
    if(t=TRAS  ) and (ex>4) then ex:=ex-1;
    if(t=BAIXO ) and (ey<199-y) then ey:=ey+1;
    if(t=CIMA  ) and (ey>4) then ey:=ey-1;
   end;

   if func<>5 then begin
    if(t='s') and (xx<319) then xx:=xx+1;
    if(t='a') and (xx>000) then xx:=xx-1;
    if(t='z') and (yy<199) then yy:=yy+1;
    if(t='w') and (yy>000) then yy:=yy-1;
   end;
   if func=5 then begin
    if(t='s') and (x<319) then x:=x+1;
    if(t='a') and (x>000) then x:=x-1;
    if(t='z') and (y<199) then y:=y+1;
    if(t='w') and (y>000) then y:=y-1;
   end;

   if func<>5 then begin
    if(t='6') and (x<315) then x:=x+5;
    if(t='4') and (x>005) then x:=x-5;
    if(t='2') and (y<194) then y:=y+5;
    if(t='8') and (y>005) then y:=y-5;
   end;
   if func=5 then begin
    if(t='6') and (ex<315-x) then ex:=ex+5;
    if(t='4') and (ex>4+5) then ex:=ex-5;
    if(t='2') and (ey<199-y) then ey:=ey+5;
    if(t='8') and (ey>4+5) then ey:=ey-5;
   end;

   if func<>5 then begin
    if(t='S') and (xx<315) then xx:=xx+5;
    if(t='A') and (xx>005) then xx:=xx-5;
    if(t='Z') and (yy<194) then yy:=yy+5;
    if(t='W') and (yy>005) then yy:=yy-5;
   end;
   if func=5 then begin
    if(t='S') and (x<315) then x:=x+5;
    if(t='A') and (x>005) then x:=x-5;
    if(t='Z') and (y<199) then y:=y+5;
    if(t='W') and (y>005) then y:=y-5;
   end;

    if(t='7') and (x>000) and (y>000) then begin x:=x-1; y:=y-1; end;
    if(t='9') and (x<319) and (y>000) then begin x:=x+1; y:=y-1; end;
    if(t='1') and (x>000) and (y<199) then begin x:=x-1; y:=y+1; end;
    if(t='3') and (x<319) and (y<199) then begin x:=x+1; y:=y+1; end;

    if func<>7 then begin
     if(t='+') and (cor<255) then cor:=cor+1;
     if(t='-') and (cor>000) then cor:=cor-1;
    end;

    if func=7 then begin
     if t='+' then tx:=tx+1;
     if(t='-') and (tx>2) then tx:=tx-1;
     if t='*' then ty:=ty+1;
     if(t='/') and (ty>2) then ty:=ty-1;
    end;

    { Carregar PAL }
    if UpCase(t)='T' then begin
     while keypressed do t:=ReadKey;
     if keypressed then begin t:=ReadKey; if t=#13 then begin gotoxy(1,24);readln;end; end;
     while keypressed do t:=ReadKey;
     func:=0;
     GotoXY(1,24); Write('Nome PAL :'); ReadLn(nomearq);
     P:=nomearq;
     FSplit(P, D, N, E);
     if N = '' then N:='NONAME';
     if E = '' then E:='.PAL';
     P := D + N + E;
     nomearq:=P;

     S:=FSearch(nomearq,'');

     if s='' then begin
      gotoxy(1,24);
      WriteLn(' Arquivo n∆o encontrado!               ');
      pause;
     end;
     if s<>'' then begin
   {$I-}
      Assign(f,nomearq); Reset(f,1); Seek(f,41);
      BlockRead(f,pal,sizeof(pal)); close(f);
   {$I+}
     if IOResult<>0 then begin
      gotoxy(1,24); WriteLn(' Erro ao Ler!             ');
      Pause;
     end;
      for r:=0 to 255 do SetPal(r,pal[r,1],pal[r,2],pal[r,3]);
     end;
    end;

    { Salva PAL }
    if UpCase(t)='Y' then begin
     while keypressed do t:=ReadKey;
     if keypressed then begin t:=ReadKey; if t=#13 then begin gotoxy(1,24);readln;end; end;
     while keypressed do t:=ReadKey;
     func:=0;
     GotoXY(1,24); Write('Nome Sav. PAL :'); ReadLn(nomearq);
     P:=nomearq;
     FSplit(P, D, N, E);
     if N = '' then N:='NONAME';
     if E = '' then E:='.PAL';
     P := D + N + E;
     nomearq:=P;

     S:=FSearch(nomearq,'');

     if s='' then begin
     {$I-}
       for r:=0 to 255 do begin
        GetPal(r,pal[r,1],pal[r,2],pal[r,3]);
       end;
       Assign(f,nomearq); Rewrite(f,1);
       blockwrite(f,palinf,41);
       Blockwrite(f,pal,sizeof(pal)); close(f);
     {$I+}
     if IOResult<>0 then begin
      gotoxy(1,24); WriteLn(' Erro ao salvar!            ');
      Pause;
     end;
     end;
     if s<>'' then begin
      gotoxy(1,24);
      writeln(' Arquivo j† existe !           ');
      pause;
     end;
    end;

    { Salvar IMG }
    if(t=#13) and (func=5) then begin
     ex:=ex+1; ey:=ey+1;
     while keypressed do t:=ReadKey;
     if keypressed then begin t:=ReadKey; if t=#13 then begin gotoxy(1,24);readln;end; end;
     while keypressed do t:=ReadKey;
     flip(vaddr2,vaddr); func:=0;

     GotoXY(1,24); Write('Nome :'); ReadLn(nomearq);
     P:=nomearq;
     FSplit(P, D, N, E);
     if N = '' then N:='NONAME';
     if E = '' then E:='.IMG';
     P := D + N + E;
     nomearq:=P;

     S:=FSearch(nomearq,'');

     if s<>'' then begin
      GotoXY(1,24);
      WriteLn('Esse arquivo j† existe! (Pr¢x/Sob) ?  ');
      t:=Perg('PpSs'+chr(27)+char(13));
      if t=#27 then goto 1;
      if UpCase(t)='S' then s:='';
      if(UpCase(t)='P') or (t=#13) then begin
    {$I-}
       Assign(f,nomearq);
       Reset(f,1); Seek(f,filesize(f)+1);
       size:=BitMapAlloc( ex, ey, img );
       GetImage( x, y, img, vaddr );
       BlockWrite(f,img^,size);
       Close(f);
    {$I+}
       if IoResult<>0 then begin
        GotoXY(1,24);
        WriteLn('Erro ao Gravar. ');
        BitMapFree(img);
        pause; goto 1;
       end;
       BitMapFree(img);
       end;
     end; { s<>'' }

     if s='' then begin
   {$I-}
      Assign(f,nomearq);
      ReWrite(f,1);
      size:=BitMapAlloc( ex, ey, img );
      GetImage( x, y, img, vaddr );
      BlockWrite(f,img^,size);
      Close(f);
   {$I+}
      if IoResult<>0 then begin
       GotoXY(1,24);
       WriteLn('Erro ao Gravar. ');
       BitMapFree(img);
       pause; goto 1;
      end;
       BitMapFree(img);
     end; { s='' }

     1:;
     while keypressed do t:=ReadKey; t:=#0;
    end;  { Salvar IMG }


    { Ler IMG }
    if func=6 then begin
     while keypressed do t:=ReadKey; t:=#0;
     if keypressed then begin t:=ReadKey; if t=#13 then begin gotoxy(1,24);readln;end; end;
     while keypressed do t:=ReadKey; t:=#0;
     {flip(vaddr2,vaddr);} func:=0;

     GotoXY(1,24); Write('Nome :'); ReadLn(nomearq);
     P:=nomearq;
     FSplit(P, D, N, E);
     if N = '' then N:='NONAME';
     if E = '' then E:='.IMG';
     P := D + N + E;
     nomearq:=P;

     S:=FSearch(nomearq,'');

     if s='' then begin
      GotoXY(1,24);
      WriteLn('Esse arq. n∆o existe! ');
      pause; goto 2;
     end; { s='' }

     if s<>'' then begin
   {$I-}
     Assign(f,nomearq); Reset(f,1); size:=0;
     while not eof(f) do begin
      size:=size+1;
      BlockRead(f,ex,2); BlockRead(f,ey,2);
      Seek(f,filepos(f)+(ex*ey)+5+1);
     end;
   {$I+}
      if IOResult<>0 then begin
       GotoXY(1,24);
       WriteLn('Erro ao ler. ');
       pause; goto 2;
      end;
     while keypressed do t:=ReadKey; t:=#0;
     gotoxy(1,24); Write('(',size,') Ler Qual ?'); ReadLn(loop1);
     if(loop1<=0) or (loop1>size) then goto 2;

      Assign(f,nomearq);
      Reset(f,1); seek(f,0);
      ex:=0; ey:=0;
      if size>1 then begin
       if loop1>1 then begin
       for loop1:=1 to (size-1) do begin
        BlockRead(f,ex,2); BlockRead(f,ey,2);
        Seek(f,filepos(f)+(ex*ey)+5+1);
       end;
       end;
      end;
      ex:=0; ey:=0;
      BlockRead(f,ex,2); BlockRead(f,ey,2);
      size:=BitMapAlloc( ex, ey, img );
      Seek(f,filepos(f)-4); BlockRead(f,img^,size);
      Close(f);
      func:=7;
      ex:=Seg(img^);
      Asm
       mov ax,ex
       mov es,ax      { Move segmento de dados para Seg da imagem }
       xor di,di
       mov ax,es:[di]  { Pega o valor xx da imagem }
       mov orix,ax
       add di,2
       mov ax,es:[di]  { Pega o valor yy da imagem }
       mov oriy,ax
      End;
   {$I+}
      tx:=orix; ty:=oriy;
      if IOResult<>0 then begin
       GotoXY(1,24);
       WriteLn('Erro ao ler. ');
       BitMapFree(img);
       pause; goto 2;
      end;

     end; { s<>'' }

     2:;
      while keypressed do t:=ReadKey; t:=#0;
    end;  { Ler IMG }

    if UpCase(t)='E' then Zoom;

    nomearq:='';

    end; { while }

   ShutDown(1);
   ShutDown(2);
   SetText;

  End.