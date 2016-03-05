{
   ET SCAPE 2  -  by David Maziero

   Data : 02/01/98
}

  Uses Crt,Dos,Graph,WriteStr,FontU2,PlayUnit,DGMLogo;

  type

    EnemyType = record

     lifes : Word;    { Vidas }
     x,y   : Integer; { Posi‡ƒo do Ininigo }
     a     : Byte;    { Condi‡ƒo : 1=Ativo / 0=Inativo }
     t     : Byte;    { Condi‡ƒo : 1=Atirou / 0=Nƒo Atirou }
     tt    : Byte;    { Se atira (1) se nƒo (0) }
     vt    : Byte;    { velocidade tiro }
     t2    : Integer; { Espa‡o de Tempo entre cada tiro }
     t3    : Integer; { =a t2 / depois do tiro vai -- se 0 atira de novo }
     tx,ty : Integer; { Posi‡ƒo do Tiro }
     a1,a2 : Byte;    { Gr ficos dos Inimigos ( n£mero ) }

    end;

    TiroType = record

     tx,ty : Integer;   { Posi‡ƒo do Tiro }
     a     : Word;   { Condi‡ƒo : 1=Ativo / 0=Inativo }

    end;

   Var

    Ini : array[1..35] of EnemyType;
    Ti  : array[1..30] of TiroType;
    graf : array[1..26] of Pointer;
    x,y : Integer;
    w2 : Byte;
    w3 : Byte;
    w4 : Byte;
    life : Integer;
    quac : Byte;
    atra : Word;
    t : Char;
    r,rr,rrr : Word;
    s : PathStr;
    letra : FontType;
    Barrier : Byte;
    ponts : Word;
    up : Byte;
    Laser : Byte;
    fase : Byte;
    ho,ho2,mim : Word;
    mor : Word;

   procedure CgaDriver; external;
   {$L CGA.OBJ }

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

   procedure Explode2(x,y : Word); forward;

   procedure Final;
   var w : Word;
   Begin
    Delay(500+(atra*99)); Delay(500+(atra*99));
    ClearDevice;
    PutImage(140,80,graf[20]^,CopyPut);
    x:=10; y:=5;
    for x:=10 to 100 do begin
     if x mod 2 = 0 then y:=y+2;
     quac:=12+random(2)+1;
     putimage(x,y,graf[quac]^,CopyPut);
     sound(40+random(x));
   {  Delay(55+(atra*4)); } rdelay(100);
     putimage(x,y,graf[quac]^,XorPut);
    end;
    nosound;
    putimage(x,y,graf[quac]^,CopyPut);
   { Delay(500+(atra*99)); Delay(500+(atra*99)); } rdelay(2000);
    ClearDevice;
    PutImage(200,70,graf[23]^,CopyPut);
    x:=10;
    for w:=1 to 77 do begin
     putimage(x,73,graf[21]^,CopyPut);
{     delay(25+atra); } rdelay(100);
     putimage(x,73,graf[21]^,XorPut); x:=x+1;
     putimage(x-1,73,graf[22]^,CopyPut);
{     delay(25+atra); } rdelay(100);
     putimage(x-1,73,graf[22]^,XorPut);
    end;
     putimage(x-1,73,graf[22]^,CopyPut);
{     delay(555+(atra*4)); delay(555+(atra*4)); } rdelay(1000);
     PutImage(201,70,graf[24]^,CopyPut);
     PutImage(195,70,graf[25]^,CopyPut);
     putimage(x-1,73,graf[22]^,XorPut);
     putimage(x-1,73,graf[26]^,CopyPut); {delay(25+atra); } rdelay(80);
     PutImage(195,70,graf[25]^,XorPut);PutImage(190,65,graf[25]^,CopyPut);{ delay(80+atra;} rdelay(100);
     PutImage(190,65,graf[25]^,XorPut);PutImage(185,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(185,65,graf[25]^,XorPut);PutImage(180,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(180,65,graf[25]^,XorPut);PutImage(175,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(175,65,graf[25]^,XorPut);PutImage(170,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(170,65,graf[25]^,XorPut);PutImage(165,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(165,65,graf[25]^,XorPut);PutImage(160,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(160,65,graf[25]^,XorPut);PutImage(155,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(155,65,graf[25]^,XorPut);PutImage(150,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(150,65,graf[25]^,XorPut);PutImage(145,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(145,65,graf[25]^,XorPut);PutImage(140,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(140,65,graf[25]^,XorPut);PutImage(135,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(135,65,graf[25]^,XorPut);PutImage(130,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(130,65,graf[25]^,XorPut);PutImage(125,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(125,65,graf[25]^,XorPut);PutImage(120,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(120,65,graf[25]^,XorPut);PutImage(115,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(115,65,graf[25]^,XorPut);PutImage(110,65,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PutImage(110,65,graf[25]^,XorPut);PutImage(105,70,graf[25]^,CopyPut);{ delay(80+atra);} rdelay(100);
     PlayInit('r2;i2;dgjfgkhjmbbnvm.e.e.e.ghjkl.....'); Play;
{     Delay(555+(atra*50)); Delay(555+(atra*40)); Delay(999);} rdelay(3500); Stop;
     for x:=300 downto 10 do begin
      putimage(x,20,graf[1]^,CopyPut);
      sound(40+x); {delay(20+(atra*2));} rdelay(30);
      putimage(x,20,graf[1]^,XorPut);
     end; nosound;
      putimage(x,20,graf[1]^,CopyPut);
     letra.laser(x+15,35,3,20+atra,1);
     letra.SizeFont(2,0,2,0);
     letra.ShowFont(40,160,'FIM',0,11,0,1);
     SetTExtStyle(DEFAULTFONT,HORIZDIR,3);
     Sound(80); rdelay(1000);{delay(500+(atra*4));} nosound;
     setcolor(WHITE); OutTextXY(120,160,'?');
     pause;
     ClearDevice;
     letra.laser(160,199,3,10+atra,1);
     letra.SizeFont(0,0,0,0);
     letra.ShowFont(10,10,'OBRIGADO POR JOGAR ET SCAPE',0,11,0,1);
     letra.ShowFont(10,40,'       DAVID MAZIERO       ',0,11,0,1);
     pause;
     CloseGraph;
     WriteLn;
     WriteLn(' ET Scape 2.0 - by David Maziero');
     WriteLn(' Copyright (c) 1998 David Maziero / DGM Inform tica');
     WriteLn;
     WriteLn;
     Halt(1);
    End;

   procedure InitBoss;
   Begin
    Ini[1].a1:=11;Ini[1].a2:=12;Ini[1].lifes:=800;Ini[1].a:=1;Ini[1].t:=0;
    Ini[1].t2:=320;Ini[1].t3:=0;Ini[1].tx:=0;Ini[1].ty:=0;Ini[1].tt:=1;
    Ini[1].vt:=10;Ini[1].x:=200;Ini[1].y:=100;
    Ini[2].a1:=1;   Ini[2].a2:=2;  Ini[2].lifes:=30; Ini[2].a:=1; Ini[2].t:=0;
    Ini[2].t2:=320; Ini[2].t3:=0;  Ini[2].tx:=0;     Ini[2].ty:=0; Ini[2].tt:=1;
    Ini[2].vt:=5;   Ini[2].x:=150; Ini[2].y:=50;
    Ini[3].a1:=1;   Ini[3].a2:=2;  Ini[3].lifes:=30; Ini[3].a:=1;  Ini[3].t:=0;
    Ini[3].t2:=320; Ini[3].t3:=0;  Ini[3].tx:=0;     Ini[3].ty:=0; Ini[3].tt:=1;
    Ini[3].vt:=5;   Ini[3].x:=150; Ini[3].y:=150;
    Ini[4].a1:=1;   Ini[4].a2:=2;  Ini[4].lifes:=30; Ini[4].a:=1;  Ini[4].t:=0;
    Ini[4].t2:=320; Ini[4].t3:=0;  Ini[4].tx:=0;     Ini[4].ty:=0; Ini[4].tt:=1;
    Ini[4].vt:=5;   Ini[4].x:=300; Ini[4].y:=100;
   End;

   procedure ApreFase;
   Begin
    ClearDevice;
    setcolor(WHITE);
    SetTextStyle(DEFAULTFONT,HORIZDIR,2);
    if fase<15 then OutTextXY(40,80,'Fase '+str2(fase));
    if fase=15 then begin
     OutTextXY(40,80,'Fase '+str2(fase));
     OutTextXY(40,110,'A Nave Mae');
     OutTextXY(40,106,'        ~');
    end;
    mor:=0;
    Pause;
    ClearDevice;
   End;

   procedure ExplodeVoce;
   var dx,dy,w,whate : Word;
   Begin
    dx:=x; dy:=y;
    for whate:=1 to 30 do begin
    x:=dx; y:=dy; x:=x+random(40); y:=y+random(25);
    for w:=1 to 20 do begin
     setcolor(random(3)+1);
     circle(x,y,w); sound(100+random(300)+w); {delay(1+atra);} rdelay(1);
    end;
    for w:=20 downto 1 do begin
     setcolor(0);
     circle(x,y,w); sound(100+random(300)+w); rdelay(1);
    end;
    end; nosound;
    letra.sizefont(0,0,0,0);
    letra.Laser(160,199,3,10+atra,0);
    letra.ShowFont(101,91,'GAME OVER',1,11,0,1);
    letra.ShowFont(102,92,'GAME OVER',1,11,0,1);
    letra.Laser(160,199,3,20+atra,1);
    letra.ShowFont(100,90,'GAME OVER',0,11,0,1);
    pause;
    closegraph;
    WriteLn;
    WriteLn(' ET Scape 2.0 - by David Maziero');
    WriteLn(' Copyright (c) 1998 David Maziero / DGM Inform tica');
    WriteLn;
    WriteLn;
    Halt(1);
   End;

   procedure ExplodeChefe;
   var dx,dy,w,whate : Word;
   Begin
    x:=Ini[1].x; y:=Ini[1].y;
    dx:=x; dy:=y;
    for whate:=1 to 30 do begin
    x:=dx; y:=dy; x:=x+random(66); y:=y+random(30);
    for w:=1 to 20 do begin
     setcolor(random(3)+1);
     circle(x,y,w); sound(100+random(300)+w); rdelay(1);
    end;
    for w:=20 downto 1 do begin
     setcolor(0);
     circle(x,y,w); sound(100+random(300)+w); rdelay(1);
    end;
    end; nosound;
    Final;
   End;

   procedure PONT;
   Begin
    SetTextStyle(DEFAULTFONT,HORIZDIR,1);
    setcolor(WHITE); Rectangle(2,185,54,195);
    setfillstyle(SOLIDFILL,0); Bar(3,186,53,194);
    setfillstyle(SOLIDFILL,1); Bar(3,186,3+life,194);
    Setfillstyle(SOLIDFILL,0); Bar(60,185,315,195);
    OutTextXY(65,187,str2(ponts));
    OutTextXY(130,187,'B:'+str2(Barrier));
    OutTextXY(180,187,'L:'+str2(Laser));
    OutTextXY(230,187,'UP:'+str2(up));
    OutTextXY(280,187,str2(mor));
    if(life<=0) and (up>1) then begin
     up:=up-1;
     for life:=1 to 50 do begin
      PONT;
      sound(100+(life*5)); rdelay(5);
     end; nosound; life:=50; PONT;
    end;
    if(life<=0) and (up=1) then ExplodeVoce;
   End;

   procedure RunTiro2;
   Begin
    w4:=w4+1;
    if w4>=36 then w4:=1;

    if Ini[w4].a=1 then begin

     if(Ini[w4].tt=1) and (Ini[w4].t=0) then begin
      Ini[w4].t:=1; Ini[w4].tx:=Ini[w4].x-3; Ini[w4].ty:=Ini[w4].y+16;
      Ini[w4].t3:=Ini[w4].t2; end;

    end;

    if(Ini[w4].tt=1) and (Ini[w4].t=1) then begin
     setcolor(0); rectangle(Ini[w4].tx,Ini[w4].ty,Ini[w4].tx+1,Ini[w4].ty+1);
     Ini[w4].tx:=Ini[w4].tx-Ini[w4].vt;
     If Ini[w4].tx<=1 then begin Ini[w4].t:=2; Exit; end;
     Ini[w4].t3:=Ini[w4].t3-Ini[w4].vt;
     If Ini[w4].t3<=0 then begin Ini[w4].t:=0; Exit; end;
     setcolor(WHITE); rectangle(Ini[w4].tx,Ini[w4].ty,Ini[w4].tx+1,Ini[w4].ty+1);

      If (Ini[w4].tx>=x) and (Ini[w4].tx<=x+46) and
         (Ini[w4].ty>=y) and (Ini[w4].ty<=y+27) then begin
        Explode2(Ini[w4].tx,Ini[w4].ty); life:=life-1;
        setcolor(0); rectangle(Ini[w4].tx,Ini[w4].ty,Ini[w4].tx+1,Ini[w4].ty+1);
        Ini[w4].t:=2;
       end;
    end;

    if(Ini[w4].tt=1) and (Ini[w4].t=2) then begin
     Ini[w4].t3:=Ini[w4].t3-(Ini[w4].vt*2);
     If Ini[w4].t3<=0 then begin Ini[w4].t:=0; Exit; end;
    end;

   End;

   procedure Explode2(x,y : Word);
   var w : Word;
   begin
    for w:=1 to 8 do begin
     setcolor(random(2)+1);
     circle(x,y,w); sound(100+random(300)+w); rdelay(1);
    end;
    for w:=8 downto 1 do begin
     setcolor(0);
     circle(x,y,w); sound(100+random(300)+w); rdelay(1);
    end; nosound;
   end;

   procedure Explode(x,y,i : Word);
   var w : Word;
   Begin
    putimage(Ini[i].x,Ini[i].y,graf[Ini[i].a1]^,CopyPut);
    putimage(Ini[i].x,Ini[i].y,graf[Ini[i].a1]^,XorPut);

    if(Ini[i].a2=2) or (Ini[i].a2=6) or (Ini[i].a2=8) then putimage(Ini[i].x,Ini[i].y,graf[Ini[i].a2]^,CopyPut);
    if Ini[i].a2=4 then putimage(Ini[i].x-2,Ini[i].y-6,graf[Ini[i].a2]^,CopyPut);
    if Ini[i].a2=10 then putimage(Ini[i].x-2,Ini[i].y,graf[Ini[i].a2]^,CopyPut);

    rdelay(10);
    for w:=1 to 15 do begin
     setcolor(random(2)+1); circle(x,y,w);
     sound(100+random(300)+w); rdelay(1);
    end;
    for w:=15 downto 1 do begin
     setcolor(0); circle(x,y,w);
     sound(100+random(300)+w); rdelay(1);
    end; setcolor(WHITE);
    nosound;

    if(Ini[i].a2=2) or (Ini[i].a2=6) or (Ini[i].a2=8) then putimage(Ini[i].x,Ini[i].y,graf[Ini[i].a2]^,CopyPut);
    if Ini[i].a2=4 then putimage(Ini[i].x-2,Ini[i].y-6,graf[Ini[i].a2]^,CopyPut);
    if Ini[i].a2=10 then putimage(Ini[i].x-2,Ini[i].y,graf[Ini[i].a2]^,CopyPut);

    if(Ini[i].a2=2) or (Ini[i].a2=6) or (Ini[i].a2=8) then putimage(Ini[i].x,Ini[i].y,graf[Ini[i].a2]^,XorPut);
    if Ini[i].a2=4 then putimage(Ini[i].x-2,Ini[i].y-6,graf[Ini[i].a2]^,XorPut);
    if Ini[i].a2=10 then putimage(Ini[i].x-2,Ini[i].y,graf[Ini[i].a2]^,XorPut);

   End;

   procedure InitEnemy;
   var w,ww : Word;
   Begin
    for w:=1 to 35 do begin
     if Ini[w].a=0 then begin setcolor(0); rectangle(Ini[w].tx,Ini[w].ty,Ini[w].tx+1,Ini[w].ty+1);end;
    end;
    w:=1;
    for w:=1 to 35 do begin

     if Ini[w].a=0 then Begin

      if fase=1 then begin
       ww:=random(9)+1;

       if (ww=1) or (ww=3) or (ww=7) or (ww=8) then begin
        Ini[w].a1:=1; Ini[w].a2:=2; Ini[w].lifes:=1; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0; Ini[w].tt:=0; Ini[w].vt:=0;
        Ini[w].x:=300; Ini[w].y:=Random(160); Exit;
       end;
       if ww=2 then begin
        Ini[w].a1:=3; Ini[w].a2:=4; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=4 then begin
        Ini[w].a1:=5; Ini[w].a2:=6; Ini[w].lifes:=3; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=2;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=9 then begin
        ww:=random(10);
        if ww=1 then begin
         Ini[w].a1:=15; Ini[w].a2:=15; Ini[w].lifes:=1; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=3 then begin
         Ini[w].a1:=16; Ini[w].a2:=16; Ini[w].lifes:=1; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=5 then begin
         Ini[w].a1:=17; Ini[w].a2:=17; Ini[w].lifes:=1; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=7 then begin
         Ini[w].a1:=18; Ini[w].a2:=18; Ini[w].lifes:=1; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=8 then begin
         Ini[w].a1:=19; Ini[w].a2:=19; Ini[w].lifes:=1; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
       end;

      end; { FASE 1 }

      if (fase>=2) and (fase<=5) then begin
       ww:=random(9)+1;
       if (ww=1) or (ww=2) then begin
        Ini[w].a1:=1; Ini[w].a2:=2; Ini[w].lifes:=random(1)+1; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0; Ini[w].tt:=0; Ini[w].vt:=0;
        Ini[w].x:=300; Ini[w].y:=Random(160); Exit;
       end;
       if ww=3 then begin
        Ini[w].a1:=3; Ini[w].a2:=4; Ini[w].lifes:=random(2)+2; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=4 then begin
        Ini[w].a1:=5; Ini[w].a2:=6; Ini[w].lifes:=random(3)+3; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=2;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=5 then begin
        Ini[w].a1:=7; Ini[w].a2:=8; Ini[w].lifes:=random(4)+5; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=4;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=6 then begin
        Ini[w].a1:=9; Ini[w].a2:=10; Ini[w].lifes:=random(6)+8; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=5;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=7 then begin
        ww:=random(20);
        if ww=1 then begin
         Ini[w].a1:=15; Ini[w].a2:=15; Ini[w].lifes:=1; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=9 then begin
         Ini[w].a1:=16; Ini[w].a2:=16; Ini[w].lifes:=1; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=5 then begin
         Ini[w].a1:=17; Ini[w].a2:=17; Ini[w].lifes:=1; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=17 then begin
         Ini[w].a1:=18; Ini[w].a2:=18; Ini[w].lifes:=1; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=15 then begin
         Ini[w].a1:=19; Ini[w].a2:=19; Ini[w].lifes:=1; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
       end;

      end; { FASE >2 <5 }

      if (fase>=6) and (fase<=8) then begin
       ww:=random(9)+1;
       if (ww=1) or (ww=2) then begin
        Ini[w].a1:=1; Ini[w].a2:=2; Ini[w].lifes:=random(1)+2; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0; Ini[w].tt:=0; Ini[w].vt:=0;
        Ini[w].x:=300; Ini[w].y:=Random(160); Exit;
       end;
       if ww=3 then begin
        Ini[w].a1:=3; Ini[w].a2:=4; Ini[w].lifes:=random(2)+4; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=4 then begin
        Ini[w].a1:=5; Ini[w].a2:=6; Ini[w].lifes:=random(3)+5; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=4;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=5 then begin
        Ini[w].a1:=7; Ini[w].a2:=8; Ini[w].lifes:=random(4)+8; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=6;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=6 then begin
        Ini[w].a1:=9; Ini[w].a2:=10; Ini[w].lifes:=random(6)+10; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=8;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=7 then begin
        ww:=random(25);
        if ww=1 then begin
         Ini[w].a1:=15; Ini[w].a2:=15; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=9 then begin
         Ini[w].a1:=16; Ini[w].a2:=16; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=5 then begin
         Ini[w].a1:=17; Ini[w].a2:=17; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=17 then begin
         Ini[w].a1:=18; Ini[w].a2:=18; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=15 then begin
         Ini[w].a1:=19; Ini[w].a2:=19; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
       end;

      end; { FASE >6 <8 }

      if (fase>=9) and (fase<=11) then begin
       ww:=random(9)+1;
       if ww=1 then begin
        Ini[w].a1:=1; Ini[w].a2:=2; Ini[w].lifes:=random(2)+4; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0; Ini[w].tt:=1; Ini[w].vt:=3;
        Ini[w].x:=300; Ini[w].y:=Random(160); Exit;
       end;
       if ww=3 then begin
        Ini[w].a1:=3; Ini[w].a2:=4; Ini[w].lifes:=random(4)+5; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=4;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=4 then begin
        Ini[w].a1:=5; Ini[w].a2:=6; Ini[w].lifes:=random(6)+8; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=4;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if (ww=2) or (ww=5) then begin
        Ini[w].a1:=7; Ini[w].a2:=8; Ini[w].lifes:=random(8)+12; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=6;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if (ww=6) or (ww=9) then begin
        Ini[w].a1:=9; Ini[w].a2:=10; Ini[w].lifes:=random(12)+14; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=8;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=7 then begin
        ww:=random(15);
        if ww=1 then begin
         Ini[w].a1:=15; Ini[w].a2:=15; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=9 then begin
         Ini[w].a1:=16; Ini[w].a2:=16; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=5 then begin
         Ini[w].a1:=17; Ini[w].a2:=17; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=15 then begin
         Ini[w].a1:=18; Ini[w].a2:=18; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=14 then begin
         Ini[w].a1:=19; Ini[w].a2:=19; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
       end;

      end; { FASE >9 <11 }

      if (fase>=12) and (fase<=14) then begin
       ww:=random(9)+1;
       if ww=1 then begin
        Ini[w].a1:=1; Ini[w].a2:=2; Ini[w].lifes:=random(4)+5; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0; Ini[w].tt:=1; Ini[w].vt:=6;
        Ini[w].x:=300; Ini[w].y:=Random(160); Exit;
       end;
       if ww=3 then begin
        Ini[w].a1:=3; Ini[w].a2:=4; Ini[w].lifes:=random(6)+6; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=6;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=4 then begin
        Ini[w].a1:=5; Ini[w].a2:=6; Ini[w].lifes:=random(8)+12; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=6;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=5 then begin
        Ini[w].a1:=7; Ini[w].a2:=8; Ini[w].lifes:=random(12)+14; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=8;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if (ww=6) or (ww=9) then begin
        Ini[w].a1:=9; Ini[w].a2:=10; Ini[w].lifes:=random(14)+16; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=8;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=2 then begin
        Ini[w].a1:=11; Ini[w].a2:=12; Ini[w].lifes:=random(25)+30; Ini[w].a:=1; Ini[w].t:=0;
        Ini[w].t2:=320; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=1; Ini[w].vt:=10;
        Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
       end;
       if ww=7 then begin
        ww:=random(15);
        if ww=1 then begin
         Ini[w].a1:=15; Ini[w].a2:=15; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=9 then begin
         Ini[w].a1:=16; Ini[w].a2:=16; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=5 then begin
         Ini[w].a1:=17; Ini[w].a2:=17; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=15 then begin
         Ini[w].a1:=18; Ini[w].a2:=18; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;Ini[w].tt:=0; Ini[w].vt:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
        if ww=14 then begin
         Ini[w].a1:=19; Ini[w].a2:=19; Ini[w].lifes:=2; Ini[w].a:=1; Ini[w].t:=0;
         Ini[w].t2:=0; Ini[w].t3:=0; Ini[w].tx:=0; Ini[w].ty:=0;
         Ini[w].x:=300; Ini[w].y:=Random(160);Exit;
        end;
       end;

      end; { FASE >12 <14 }


     end;  { a = 0 }

    end;  { For }

   End;

   procedure CarregaImg;
   var
    f : File;
   Begin
    s:=FSearch('ET2.DAT','');
    if s='' then Begin CloseGraph;
     WriteLn; WriteLn('O Arquivo ET2.DAT nƒo foi encontrado.');
     WriteLn('Programa abortado.'); WriteLn; Halt(1);  end;
    GetMem(graf[1],96); GetMem(graf[2],96); GetMem(graf[3],114); GetMem(graf[4],198);
    GetMem(graf[5],126); GetMem(graf[6],144); GetMem(graf[7],358); GetMem(graf[8],358);
    GetMem(graf[9],608); GetMem(graf[10],608); GetMem(graf[11],690); GetMem(graf[12],708);
    GetMem(graf[13],294); GetMem(graf[14],294); GetMem(graf[15],84); GetMem(graf[16],84);
    GetMem(graf[17],42); GetMem(graf[18],46);  GetMem(graf[19],114);
    GetMem(graf[20],3282);GetMem(graf[21],146); GetMem(graf[22],146);
    GetMem(graf[23],396); GetMem(graf[24],396); GetMem(graf[25],66); GetMem(graf[26],216);

    Assign(f,'ET2.DAT'); Reset(f,1);
    BlockRead(f,graf[1]^,96); BlockRead(f,graf[2]^,96);
    BlockRead(f,graf[3]^,114); BlockRead(f,graf[4]^,198);
    BlockRead(f,graf[5]^,126); BlockRead(f,graf[6]^,144);
    BlockRead(f,graf[7]^,358); BlockRead(f,graf[8]^,358);
    BlockRead(f,graf[9]^,608); BlockRead(f,graf[10]^,608);
    BlockRead(f,graf[11]^,690); BlockRead(f,graf[12]^,708);
    BlockRead(f,graf[13]^,294); BlockRead(f,graf[14]^,294);
    BlockRead(f,graf[15]^,84); BlockRead(f,graf[16]^,84);
    BlockRead(f,graf[17]^,42); BlockRead(f,graf[18]^,46);
    BlockRead(f,graf[19]^,114); BlockRead(f,graf[20]^,3282);
    BlockRead(f,graf[21]^,146); BlockRead(f,graf[22]^,146);
    BlockRead(f,graf[23]^,396); BlockRead(f,graf[24]^,396);
    BlockRead(f,graf[25]^,66); BlockRead(f,graf[26]^,216);
    Close(f);
   End;

   procedure Apresenta;
   Begin
    ClearDevice;
    setcolor(1); rectangle(3,3,316,196); rectangle(2,2,317,197);
    setcolor(3); rectangle(1,1,318,198);
    letra.Laser(0,0,0,0,0);
    letra.ShowFont(15,20,'OS ETS FUGIRAM NOVAMENTE',0,11,0,1);
    SetTextStyle(DEFAULTFONT,HORIZDIR,1);
    OutTextXY(7,60,'Essa foi a manchete que o imperador de');
    OutTextXY(7,70,'Glub X colocou no jornal interplaneta-');
    OutTextXY(7,80,'rio. E mais : que conseguir acabar com');
    OutTextXY(7,90,'todos levara uma generosa recompenca!');
    OutTextXY(7,92,'                                  ,');OutTextXY(9,88,'           ''');
    OutTextXY(7,100,'E voce quer essa recompenca, nao e ?');
OutTextXY(7,98,'     ^ ');OutTextXY(7,102,'                         , ');OutTextXY(7,98,'                              ~  ''');
    pause;
   End;

   procedure ResetEnemys;
   var w : Word;
   Begin
    For w:=1 to 35 do Begin
     Ini[w].lifes :=0;
     Ini[w].x :=0; Ini[w].y :=0; Ini[w].a :=0;
     Ini[w].t :=0; Ini[w].t2 :=0; Ini[w].t3 :=0;
     Ini[w].tx :=0; Ini[w].ty :=0;
     Ini[w].a1 :=0; Ini[w].a2 :=0;
     Ini[w].tt :=0; Ini[w].vt :=0;
   end;
    w3:=0; w4:=0;
   End;

   procedure ResetTiroYou;
   var w : Word;
   Begin
    For w:=1 to 30 do Begin Ti[w].tx:=0; Ti[w].ty:=0; Ti[w].a:=0; end;
    w2:=0;
   End;

   procedure RunTiro; forward;

   procedure Atirou;
   var w : Word;
   Begin
    For w:=1 to 30 do Begin
     If Ti[w].a=0 then Begin Ti[w].tx:=x+49; Ti[w].ty:=y+19; Ti[w].a:=1; Exit; end;
    end;
   End;

   procedure ExplodeTudo;
   var w,dx,dy : Word;
   Begin
    for w:=1 to 30 do begin
     setcolor(0); circle(Ti[w].tx,Ti[w].ty,1); Ti[w].a:=0;
     sound(100+(w*5)); rdelay(15);
    end; setcolor(WHITE);
    dx:=x; dy:=y; w:=1;
    for w:=1 to 30 do begin
     x:=Ini[w].x+2; y:=Ini[w].y+2;
     Ti[w].tx:=x; Ti[w].ty:=y; Ti[w].a:=1;
     sound(100+(w*5)); rdelay(15);
    end; nosound; w:=1;
    for w:=1 to 60 do RunTiro;
    x:=dx; y:=dy;
   End;

   procedure RunTiro;
   var w,defax,defay,mp,mmp : Word;
   Begin
    w2:=w2+1;
    if w2=31 then w2:=1;
    if Ti[w2].a=0 then Exit;

    setcolor(0); circle(Ti[w2].tx,Ti[w2].ty,1);
    Ti[w2].tx:=Ti[w2].tx+5;
    if Ti[w2].tx>=319 then Begin Ti[w2].tx:=0; Ti[w2].ty:=0; Ti[w2].a:=0; Exit; end;
    setcolor(WHITE); circle(Ti[w2].tx,Ti[w2].ty,1);

    for w:=1 to 35 do begin

     If Ini[w].a=1 then
     Begin
       if Ini[w].a1=1  then begin defax:=15; defay:=15; mp:=5;  mmp:=0; end;
       if Ini[w].a1=3  then begin defax:=20; defay:=20; mp:=10; mmp:=0; end;
       if Ini[w].a1=5  then begin defax:=25; defay:=20; mp:=15; mmp:=0; end;
       if Ini[w].a1=7  then begin defax:=60; defay:=20; mp:=20; mmp:=0; end;
       if Ini[w].a1=9  then begin defax:=55; defay:=42; mp:=30; mmp:=0; end;
       if Ini[w].a1=11 then begin defax:=66; defay:=37; mp:=100; mmp:=0; end;

       If Ini[w].a1=15 then begin defax:=12; defay:=16; mp:=50; mmp:=1; end;
       If Ini[w].a1=16 then begin defax:=12; defay:=16; mp:=50; mmp:=2; end;
       If Ini[w].a1=17 then begin defax:=11; defay:=8; mp:=50;  mmp:=3; end;
       If Ini[w].a1=18 then begin defax:=13; defay:=9; mp:=50;  mmp:=4; end;
       If Ini[w].a1=19 then begin defax:=17; defay:=18; mp:=50; mmp:=5; end;


       If (Ti[w2].tx>=Ini[w].x) and (Ti[w2].tx<=Ini[w].x+defax) and
          (Ti[w2].ty>=Ini[w].y) and (Ti[w2].ty<=Ini[w].y+defay) then Begin
        setcolor(0); circle(Ti[w2].tx,Ti[w2].ty,1); Explode2(Ti[w2].tx,Ti[w2].ty);
        Ini[w].lifes:=Ini[w].lifes-1; Ti[w2].a:=0;
        if Ini[w].lifes=0 then begin
        if fase<=15 then Explode(Ti[w2].tx,Ti[w2].ty,w);
        if(fase=15) and (Ini[w].a1=11) then ExplodeChefe;
        Ini[w].a:=0; ponts:=ponts+mp;
        mor:=mor+1;
        if mmp=1 then Barrier:=Barrier+1;
        if mmp=2 then Laser:=Laser+1;
        if (mmp=3) and (life<=40) then life:=life+10;
        if mmp=4 then up:=up+1;
        if mmp=5 then ExplodeTudo;
        if fase<15 then InitEnemy;
        end;
        Exit;
       end;

     end;
    end;

   End;


   procedure RunEnemy;
   var w : Word;
   Begin
    w3:=w3+1;
    if w3=36 then w3:=1;
    if Ini[w3].a=0 then Exit;

    putimage(Ini[w3].x,Ini[w3].y,graf[Ini[w3].a1]^,CopyPut);
    putimage(Ini[w3].x,Ini[w3].y,graf[Ini[w3].a1]^,XorPut);
    w:=random(6);
  if fase=1 then begin
    if w=1 then Ini[w3].x:=Ini[w3].x-4;
    if w=2 then Ini[w3].y:=Ini[w3].y-3;
    if w=3 then Ini[w3].y:=Ini[w3].y+3;
    if w=4 then Ini[w3].x:=Ini[w3].x-4;
    if w=5 then Ini[w3].x:=Ini[w3].x-5;
    if w=6 then Ini[w3].x:=Ini[w3].x-3; end;
  if (fase>=2) and (fase<=5) then begin
    if w=1 then Ini[w3].x:=Ini[w3].x-4;
    if w=2 then Ini[w3].y:=Ini[w3].y-4;
    if w=3 then Ini[w3].y:=Ini[w3].y+4;
    if w=4 then Ini[w3].x:=Ini[w3].x-5;
    if w=5 then Ini[w3].x:=Ini[w3].x-5;
    if w=6 then Ini[w3].x:=Ini[w3].x-4; end;
  if (fase>=6) and (fase<=8) then begin
    if w=1 then Ini[w3].x:=Ini[w3].x-1;
    if w=2 then Ini[w3].y:=Ini[w3].y-1;
    if w=3 then Ini[w3].y:=Ini[w3].y+1;
    if w=4 then Ini[w3].x:=Ini[w3].x-2;
    if w=5 then Ini[w3].x:=Ini[w3].x-3;
    if w=6 then Ini[w3].x:=Ini[w3].x-1; end;
  if (fase>=9) and (fase<=11) then begin
    if w=1 then Ini[w3].x:=Ini[w3].x-5;
    if w=2 then Ini[w3].y:=Ini[w3].y-4;
    if w=3 then Ini[w3].y:=Ini[w3].y+4;
    if w=4 then Ini[w3].x:=Ini[w3].x-5;
    if w=5 then Ini[w3].x:=Ini[w3].x-6;
    if w=6 then Ini[w3].x:=Ini[w3].x-4; end;

  if (fase>=12) and (fase<=14) then begin
    if w=1 then Ini[w3].x:=Ini[w3].x-4;
    if w=2 then Ini[w3].y:=Ini[w3].y-4;
    if w=3 then Ini[w3].y:=Ini[w3].y+4;
    if w=4 then Ini[w3].x:=Ini[w3].x-5;
    if w=5 then Ini[w3].x:=Ini[w3].x-4;
    if w=6 then Ini[w3].x:=Ini[w3].x-5; end;

  if fase=15 then begin
    w:=random(9);
    if w=1 then Ini[w3].x:=Ini[w3].x-2;
    if w=2 then Ini[w3].x:=Ini[w3].x+2;
    if w=3 then Ini[w3].y:=Ini[w3].y-2;
    if w=4 then Ini[w3].y:=Ini[w3].y+2;
    if w=5 then Ini[w3].x:=Ini[w3].x-4;
    if w=6 then Ini[w3].x:=Ini[w3].x+4;
    if w=7 then Ini[w3].y:=Ini[w3].y-4;
    if w=8 then Ini[w3].y:=Ini[w3].y+4;
   end;

   if fase<15 then begin
    if Ini[w3].x<1 then   begin Ini[w3].a:=0; InitEnemy; Exit; end;
    if Ini[w3].y<-4 then  begin Ini[w3].a:=0; InitEnemy; Exit; end;
    If Ini[w3].y>165 then begin Ini[w3].a:=0; InitEnemy; Exit; end;
   end;

   if fase=15 then begin
    if Ini[w3].x<=3   then Ini[w3].x:=Ini[w3].x+5;
    if Ini[w3].x>=250 then Ini[w3].x:=Ini[w3].x-5;
    if Ini[w3].y<=2   then Ini[w3].y:=Ini[w3].y+5;
    If Ini[w3].y>=155 then Ini[w3].y:=Ini[w3].y-5;
   end;

    putimage(Ini[w3].x,Ini[w3].y,graf[Ini[w3].a1]^,CopyPut);

      If (Ini[w3].x>=x) and (Ini[w3].x<=x+46) and
         (Ini[w3].y>=y) and (Ini[w3].y<=y+27) then begin
        Explode2(Ini[w3].x,Ini[w3].y); life:=life-1;
        Putimage(x,y,graf[quac]^,CopyPut);
        PutImage(x,y,graf[quac]^,XorPut);
        if (x>5) then x:=x-5;
        Putimage(x,y,graf[quac]^,CopyPut);
       end;
      If (Ini[w3].x>=x) and (Ini[w3].x<=x+46) and
         (Ini[w3].y+15>=y) and (Ini[w3].y+15<=y+27) then begin
        Explode2(Ini[w3].x,Ini[w3].y); life:=life-1;
        Putimage(x,y,graf[quac]^,CopyPut);
        PutImage(x,y,graf[quac]^,XorPut);
        if (x>5) then x:=x-5;
        Putimage(x,y,graf[quac]^,CopyPut);
       end;

   End;


   Begin
    if RegisterBGIdriver(@CGADriver) < 0 then Halt(1);
    ClrScr;
{    WriteLn(' Entre com a velocidade do seu computador :');
    WriteLn;
    WriteLn(' 1- 10Mhz..20Mhz ');
    WriteLn(' 2- 33Mhz..40Mhz ');
    WriteLn(' 3- 60Mhz..75Mhz ');
    WriteLn(' 4- 90Mhz..100Mhz');
    WriteLn(' 5- + 100Mhz');
     t:=#0;
     while (t<>'!') do begin
      t:=ReadKey;
      if t='1' then begin atra:=0; t:='!'; end;
      if t='2' then begin atra:=5; t:='!'; end;
      if t='3' then begin atra:=15; t:='!'; end;
      if t='4' then begin atra:=25; t:='!'; end;
      if t='5' then begin atra:=50; t:='!'; end;
     end;
 }
 atra:=1;

    Graphics(CGA,1,'');

    Randomize;

     s:=FSearch('ET2.FNT','');
     if s='' then Begin
      OutTextXY(7,25,'Esta faltando o arquivo ET2.FNT');OutTextXY(9,23,'   ''');
      OutTextXY(7,35,'sem o qual, o programa nao pode ser');OutTextXY(7,45,'executado.');
      rdelay(1000);
      CloseGraph;
      WriteLn('Esta faltando o arquivo ET2.FNT sem o qual, o programa nao pode');
      WriteLn('ser executado.'); WriteLn;
      Halt(1);
     End;

   ShowDGMLogo('dgmLOGO.DAT',0,1,0);
     ClearDevice;
     while keypressed do begin
      t:=ReadKey;
     end; t:=#0;

     letra.Init(3);
     letra.SetFontType('ET2.FNT');
     letra.Laser(160,199,3,20+atra,1);
     letra.SizeFont(3,0,3,0);
     letra.ShowFont(20,10,'ET SCAPE',0,11,0,1);

     SetTextStyle(DEFAULTFONT,HORIZDIR,6);
     x:=300; y:=220;
     For x:=300 downto 125 do begin
      y:=y-1;
      OutTextXY(x,y,'2');
      sound(400+atra+x);
      rdelay(5);
      if x mod 4 = 0 then rdelay(5);
      nosound;
      setcolor(0); OutTextXY(x,y,'2'); setcolor(WHITE);
     end; OutTextXY(x,y,'2'); Sound(50);
      setcolor(2);OutTextXY(x+1,y+1,'2'); OutTextXY(x+2,y+2,'2');
      setcolor(3); OutTextXY(x,y,'2');
     rdelay(50);nosound;
     letra.Laser(0,0,0,0,0);
     for r:=1 to 5 do begin
      letra.ShowFont(21,11,'ET SCAPE',1,11,0,1);letra.ShowFont(22,12,'ET SCAPE',1,11,0,1);
      sound(100+random(200));
      letra.ShowFont(20,10,'ET SCAPE',0,11,0,1); rdelay(5); nosound; end;
     setcolor(3);
     letra.sizefont(0,0,0,0);
     letra.Laser(160,1,3,1+atra,1);
     letra.ShowFont(5,185,'DAVID MAZIERO  DGM INFORMATICA',0,10,0,1);
     SetTextStyle(DEFAULTFONT,HORIZDIR,1);
     OutTextXY(80,120,'Pressione <Enter>');
     while keypressed do begin
      t:=ReadKey;
     end; t:=#0;
     Pause; Apresenta; CarregaImg;
     ClearDevice;
     fase:=1;
     ResetEnemys;
     ResetTiroYou;

    Barrier:=0; Laser:=0; x:=50; y:=50; up:=3;
    life:=50; ponts:=0; fase:=1;

    for fase:=1 to 15 do begin

     ResetEnemys;
     ResetTiroYou;

    x:=50; y:=50;

    if fase=1 then               begin ho:=10; ho2:=160; mim:=100; end;
    if fase=2 then               begin ho:=4;  ho2:=160; mim:=70;  end;
    if fase=3 then               begin ho:=6;  ho2:=160; mim:=75;  end;
    if(fase=4) or (fase=5) then  begin ho:=10; ho2:=120; mim:=75;  end;
    if fase=6 then               begin ho:=2;  ho2:=90;  mim:=50;   end;
    if fase=7 then               begin ho:=4;  ho2:=120; mim:=65;   end;
    if fase=8 then               begin ho:=6;  ho2:=160; mim:=70;   end;
    if(fase=9) or (fase=10) then begin ho:=6;  ho2:=120; mim:=50;   end;

    if fase=11 then              begin ho:=15;  ho2:=200; mim:=80;   end;

    if fase=12 then              begin ho:=2;  ho2:=60;  mim:=30;   end;
    if fase=13 then              begin ho:=4;  ho2:=90;  mim:=40;   end;
    if fase=14 then              begin ho:=8;  ho2:=120; mim:=50;   end;
    if fase=15 then              begin InitBoss; mim:=4; end;

    ApreFase;

    if fase<15 then begin
     for r:=1 to ho do begin
      InitEnemy;
      for rr:=1 to ho2 do RunEnemy;
     end;
    end;

    t:=#0;

    for r:=1 to 100 do begin
    if r>90 then r:=1;
     if r mod 10 = 0 then PONT;

     if (t=')') or (t=#27) then ExplodeVoce;
     if t='|' then mor:=mim;
     if mor>=mim then r:=100;

     setcolor(WHITE);rectangle(0,0,319,180);

     quac:=12+random(2)+1;

     putimage(x,y,graf[quac]^,CopyPut);

     if not keypressed then t:=#0;
     if keypressed then t:=readkey;

     putimage(x,y,graf[quac]^,XorPut);

     if atra>0 then rdelay(5);

     if t=' ' then Atirou;

     if (t=FRENTE) and (x<265) then x:=x+5;
     if (t=TRAS) and (x>=5) then x:=x-5;
     if (t=CIMA) and (y>=5) then y:=y-5;
     if (t=BAIXO) and (y<170) then y:=y+5;

     if(t='1') and (Barrier>=1) then begin
      rr:=y; y:=-4; Barrier:=Barrier-1;
      for r:=1 to 30 do begin setcolor(0);Circle(Ti[r].tx,Ti[r].ty,1);Ti[r].a:=0;end;
      for r:=1 to 30 do begin
       y:=y+5;
       Atirou;
      end; r:=1; y:=rr; setcolor(WHITE);
     end;
     if(t='3') and (Laser>=1) then begin
      rr:=x; Laser:=Laser-1;
      for rrr:=1 to 30 do begin setcolor(0);Circle(Ti[rrr].tx,Ti[rrr].ty,1);Ti[rrr].a:=0;end;
      for rrr:=1 to 30 do begin
       x:=x+1;
       Atirou;
      end; x:=rr; setcolor(WHITE);
     end;
     if t='$' then begin
      rr:=y; y:=-4;
      for r:=1 to 30 do begin setcolor(0);Circle(Ti[r].tx,Ti[r].ty,1);Ti[r].a:=0;end;
      for r:=1 to 30 do begin
       y:=y+5;
       Atirou;
      end; r:=1; y:=rr; setcolor(WHITE);
     end;
     if t='%' then begin
      rr:=x;
      for rrr:=1 to 30 do begin setcolor(0);Circle(Ti[rrr].tx,Ti[rrr].ty,1);Ti[rrr].a:=0;end;
      for rrr:=1 to 30 do begin
       x:=x+1;
       Atirou;
      end; x:=rr; setcolor(WHITE);
     end;
     if t='&' then ExplodeTudo;

     putimage(x,y,graf[quac]^,CopyPut);


     RunEnemy; RunTiro; RunTiro2; RunEnemy; RunTiro; RunTiro2; RunEnemy; RunTiro; RunTiro2;
    if atra>0 then rdelay(3);
     RunEnemy; RunTiro; RunTiro2; RunEnemy; RunTiro; RunTiro2; RunEnemy; RunTiro; RunTiro2;
   if atra>0 then rdelay(3);
     RunEnemy; RunTiro; RunTiro2; RunEnemy; RunTiro; RunTiro2; RunEnemy; RunTiro; RunTiro2;
    if atra>0 then rdelay(3);
     RunEnemy; RunTiro; RunTiro2; RunEnemy; RunTiro; RunTiro2; RunEnemy; RunTiro; RunTiro2;
    if atra>0 then rdelay(3);
    end;

    end;

   End.
