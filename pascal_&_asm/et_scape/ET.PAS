{

  ET Scape v1.0

  Copyright (c) 1996 David Maziero / DGM Inform tica

}

  Uses Crt,Dos,Graph,WriteStr,DGMLogo;

  type
     EnemiType = record
       x,y,i : Integer;
       end;
     TiroType  = record
       x,y,i : Integer;
       end;
   Var
      Ini   : array[1..50] of EnemiType;
      A     : array[1..50] of TiroType;
      B     : array[1..50] of TiroType;
      t,opsc : Char;
      life,x,y,rr,e,tiro,ti,ti2 : Integer;
      r,t2,c,l,ta,ee,pontos : Integer;
      contini,mortos,pontos2 : Integer;
      fase,fase1,fase2 : Integer;
      nune,nunt : Integer;
      anda : Integer;
      atraso : Word;

   procedure CgaDriver; external;
   {$L CGA.OBJ }

{******** WaitRetrace *******************************************************}
procedure WaitRetrace; assembler; { Espera a verredura vertical da tela }
Label
  l1, l2;
Asm
    mov  dx,3DAh
{l1:
    in   al,dx
    and  al,08h
    jnz  l1 }
l2:
    in   al,dx
    and  al,08h
    jz   l2
end;


   procedure NNave(cor : Integer); forward;
   procedure Nave(cor : Integer; rrf : Integer);forward;
   procedure Nave2(Acor : Integer);forward;
   procedure Score;forward;
   procedure StartEnemi2(a1 : Integer);forward;
   procedure BarLife;forward;
   procedure Bomba(ttt2 : Integer);forward;
   procedure Bombi(tt3 : Integer); forward;
   procedure Bomba2;forward;
   procedure StartEnemi(a1 : Integer);forward;
   procedure RunEnemi(a1,a2,a3,a4,a5,a6,a7,a8 : Integer);forward;
   procedure StartTiro;forward;
   procedure StartTiro2;forward;
   procedure StartTiro3;forward;
   procedure Laser;forward;
   procedure RunTiro;forward;
   procedure RunTiro2(a1 : Integer);forward;
   procedure StartGame;forward;
   procedure comandos;forward;
   procedure despede;forward;

   procedure Final;
   Begin
    ClearDevice;
    SetTextStyle(DEFAULTFONT,HORIZDIR,1);
    OutTextXY(2,5,'Voce conseguiu ! Provou que e o');
    OutTextXY(2,3,'   ^                        ''');
    OutTextXY(2,18,'melhor piloto de aeronaves da galaxia.');
    OutTextXY(2,16,'                                 ''');
    OutTextXY(5,50,'Obrigado por jogar Et Scape');
    OutTextXY(5,65,'David Maziero');
    x:=50; y:=80;
    NNave(3);
    Ini[1].x:=190; Ini[1].y:=80;
    Nave(3,1);
    circle(130,87,1);
    pause;
    despede;
   End;

   procedure comandos;
   Begin
    If pontos>=5000 Then
    Begin
     Sound(4000);
{     delay(atraso+15); }
     waitretrace;
     NoSound;
     ta:=30;pontos:=0;BarLife;Score;
    End;
    If mortos>=fase2 Then
    Begin
     OutTextXY(50,80,'Stage Clear!!!');
     For ee:=1 to 500 do Begin
     Sound(ee*100);
     waitretrace;
     {delay(atraso+1);}NoSound;
   End;
     For ee:=500 downto 1 do Begin
     Sound(ee*100);
     waitretrace;
     {delay(atraso+1);}NoSound;
     End;
     Pause;ClearDevice;
     If fase=5 Then Final;
     r:=100;
     Exit;
    End;
    For ee:=1 to 10 do Begin
    If (x+12>=Ini[ee].x) and (x+12<=Ini[ee].x+17) and (y+7>=Ini[ee].y) and (y+7<=Ini[ee].y+17) and (Ini[ee].i>1) or
    (x=Ini[ee].x) and (y=Ini[ee].y) and (Ini[ee].i>1) Then Begin
     Sound(100);
{     delay(atraso+5);} waitretrace;
     NoSound;
     NNave(0);Dec(ta,1);
     BarLife;
    Dec(x,5);
    end;end;
    t:=#0;
    If KeyPressed Then t:=ReadKey;
    If t=#27 Then Exit;
    If (t=FRENTE) and (x<310) Then Begin NNave(0);Inc(x,5);End;
    If (t=TRAS) and (x>8)     Then Begin NNave(0);Dec(x,5);End;
    If (t=CIMA) and (x>10)    Then Begin NNave(0);Dec(y,5);End;
    If (t=BAIXO) and (x<185)  Then Begin NNave(0);Inc(y,5);End;
    If t=' ' Then StartTiro;
    If t='l' Then Laser;
    if t='|' then morTOS:=morTOS+10;
   End;

   procedure NNave(cor : Integer);
   Begin
    If cor=0 Then SetColor(0);
    rectangle(x+26-20,y+22-15,x+43-20,y+28-15);rectangle(x+26-20,y+23-15,x+22-20,y+27-15);
    putpixel(x+23-20,y+25-15,cor);putpixel(x+24-20,y+25-15,cor);
    putpixel(x+18-20,y+22-15,cor);putpixel(x+17-20,y+24-15,cor);
    putpixel(x+19-20,y+25-15,cor);putpixel(x+20-20,y+24-15,cor);
    putpixel(x+20-20,y+27-15,cor);putpixel(x+18-20,y+27-15,cor);
    rectangle(x+29-20,y+24-15,x+30-20,y+26-15);rectangle(x+40-20,y+24-15,x+41-20,y+26-15);
    line(x+28-20,y+21-15,x+28-20,y+17-15);putpixel(x+29-20,y+16-15,cor);
    line(x+30-20,y+15-15,x+38-20,y+15-15);putpixel(x+39-20,y+16-15,cor);
    line(x+40-20,y+17-15,x+40-20,y+21-15);rectangle(x+32-20,y+24-15,x+38-20,y+26-15);
    line(x+44-20,y+23-15,x+44-20,y+26-15);line(x+45-20,y+24-15,x+45-20,y+25-15);
    line(x+31-20,y+18-15,x+31-20,y+21-15);line(x+32-20,y+17-15,x+37-20,y+17-15);
    line(x+38-20,y+18-15,x+38-20,y+21-15);putpixel(x+36-20,y+19-15,cor);
    putpixel(x+36-20,y+20-15,cor);putpixel(x+34-20,y+20-15,cor);
    putpixel(x+34-20,y+19-15,cor);
    If cor=0 Then SetColor(WHITE);
   End;

   procedure Nave(cor : Integer; rrf : Integer);
   Var
     aa,bb : Integer;
   Begin
    aa:=Ini[rrf].x;
    bb:=Ini[rrf].y;
    If cor=0 Then SetColor(0);
    rectangle(aa+95-94,bb+70-63,aa+110-94,bb+74-63);rectangle(aa+97-94,bb+72-63,aa+98-94,bb+74-63);
    rectangle(aa+106-94,bb+72-63,aa+107-94,bb+73-63);
    rectangle(aa+108-94,bb+70-63,aa+97-94,bb+64-63);line(aa+101-94,bb+66-63,aa+104-94,bb+66-63);
    line(aa+100-94,bb+67-63,aa+100-94,bb+69-63);
    line(aa+102-94,bb+67-63,aa+102-94,bb+70-63);line(aa+104-94,bb+67-63,aa+104-94,bb+70-63);
    line(aa+105-94,bb+67-63,aa+105-94,bb+70-63);
    line(aa+100-94,bb+69-63,aa+105-94,bb+69-63);putpixel(aa+103-94,bb+76-63,cor);putpixel(aa+103-94,bb+75-63,cor);
    putpixel(aa+102-94,bb+75-63,cor);putpixel(aa+103-94,bb+75-63,cor);putpixel(aa+106-94,bb+75-63,cor);
    putpixel(aa+105-94,bb+76-63,cor);putpixel(aa+105-94,bb+77-63,cor);putpixel(aa+104-94,bb+78-63,cor);
    putpixel(aa+104-94,bb+79-63,cor);putpixel(aa+102-94,bb+79-63,cor);putpixel(aa+102-94,bb+78-63,cor);
    putpixel(aa+101-94,bb+77-63,cor);putpixel(aa+101-94,bb+76-63,cor);putpixel(aa+100-94,bb+75-63,cor);
    If cor=0 Then SetColor(WHITE);
   End;
   procedure Nave2(Acor : Integer);
   Var
     aa,bb,cor : Integer;
   Begin
    aa:=Ini[Acor].x;
    bb:=Ini[Acor].y;
    SetColor(0);cor:=0;
    rectangle(aa+95-94,bb+70-63,aa+110-94,bb+74-63);rectangle(aa+97-94,bb+72-63,aa+98-94,bb+74-63);
    rectangle(aa+106-94,bb+72-63,aa+107-94,bb+73-63);
    rectangle(aa+108-94,bb+70-63,aa+97-94,bb+64-63);line(aa+101-94,bb+66-63,aa+104-94,bb+66-63);
    line(aa+100-94,bb+67-63,aa+100-94,bb+69-63);
    line(aa+102-94,bb+67-63,aa+102-94,bb+70-63);line(aa+104-94,bb+67-63,aa+104-94,bb+70-63);
    line(aa+105-94,bb+67-63,aa+105-94,bb+70-63);
    line(aa+100-94,bb+69-63,aa+105-94,bb+69-63);putpixel(aa+103-94,bb+76-63,cor);putpixel(aa+103-94,bb+75-63,cor);
    putpixel(aa+102-94,bb+75-63,cor);putpixel(aa+103-94,bb+75-63,cor);putpixel(aa+106-94,bb+75-63,cor);
    putpixel(aa+105-94,bb+76-63,cor);putpixel(aa+105-94,bb+77-63,cor);putpixel(aa+104-94,bb+78-63,cor);
    putpixel(aa+104-94,bb+79-63,cor);putpixel(aa+102-94,bb+79-63,cor);putpixel(aa+102-94,bb+78-63,cor);
    putpixel(aa+101-94,bb+77-63,cor);putpixel(aa+101-94,bb+76-63,cor);putpixel(aa+100-94,bb+75-63,cor);
    SetColor(WHITE);
   End;

   procedure Score;
   Begin
   SetViewPort(1,1,319,199,ClipOn);
   SetFillStyle(1,0);
   Bar(15,190,250,199);
   SetFillStyle(1,WHITE);
   WriteOut(15,190,Str2(pontos2));
   WriteOut(150,190,Str2(mortos));
   SetViewPort(12,1,319,199,ClipOn);
   End;
   procedure StartEnemi2(a1 : Integer);
   var
     ffa : Integer;
   Begin
     For ffa:=1 to 10 do
     Begin
      If Ini[ffa].i<1 Then
       Begin
        Ini[ffa].x :=315;
        Ini[ffa].y :=random(175)+5;
        Ini[ffa].i :=random(a1)+5;
        Nave(WHITE,rr);
        Exit;
       End;
     end;
   End;
   procedure BarLife;
   Begin
    SetViewPort(1,1,319,199,ClipOn);
    SetFillStyle(SOLIDFILL,0);
    Bar(5,190-30,10,190);
    SetFillStyle(SOLIDFILL,1);
    Bar(5,190-ta,10,190);
    Rectangle(5,190-30,10,190);
    SetViewPort(12,1,319,199,ClipOn);
   End;

   procedure Bomba(ttt2 : Integer);
   Var
     k,kk,k2 : Integer;
   Begin
    For k2:=0 to 3 do
    Begin
    For k:=1 to 8 do
    Begin
    Sound(40+k*5);
    setcolor(random(3)+1);
    Circle(Ini[ttt2].x,Ini[ttt2].y,k);
{    delay(atraso+1);}
    if k mod 3 = 0 then waitretrace;
    NoSound;
    End;
    For k:=8 downto 1 do
    Begin
    setcolor(0);
    Circle(Ini[ttt2].x,Ini[ttt2].y,k);
    End;
    End;
    SetColor(WHITE);
   End;
   procedure Bombi(tt3 : Integer);
   Var
     k,kk,k2 : Integer;
   Begin
    For k2:=0 to 3 do
    Begin
    For k:=1 to 4 do
    Begin
    Sound(40+k*5);
    setcolor(random(3)+1);
    Circle(B[tt3].x,B[tt3].y,k);
{    delay(atraso+1);}
    if k mod 3 = 0 then waitretrace;
    NoSound;
    End;
    For k:=4 downto 1 do
    Begin
    setcolor(0);
    Circle(B[tt3].x,B[tt3].y,k);
    End;
    End;
    SetColor(WHITE);
   End;
   procedure Bomba2;
   Var
     k,kk,k2 : Integer;
     xx,yy   : Integer;
   Begin
    For k2:=0 to 25 do
    Begin
    xx:=x+random(5);yy:=y+random(5);
    For k:=1 to 20 do
    Begin
    Sound(random(k)*10);
    setcolor(random(3)+1);
    Circle(xx,yy,k);
{    delay(atraso+1); } if k mod 4 = 0 then waitretrace;
    NoSound;
    End;
    For k:=20 downto 1 do
    Begin
    Sound(random(k)*10);
    setcolor(0);
    Circle(xx,yy,k);
{    delay(atraso+1);} if k mod 4 = 0 then waitretrace;
    NoSound;
    End;
    End;
    SetColor(WHITE);
    SetTextStyle(DEFAULTFONT,HORIZDIR,1);
    setcolor(1);
    OutTextXY(71,81,'GAME OVER');
    OutTextXY(72,82,'GAME OVER'); setcolor(WHITE);
    OutTextXY(70,80,'GAME OVER'); pause;
    despede;
   End;

   procedure StartEnemi(a1 : Integer);
   Var
      loop : Integer;
   Begin
    For loop:=1 to 10 do
     Begin
      Ini[loop].x :=random(280)+20;
      Ini[loop].y :=random(175)+5;
      Ini[loop].i :=random(a1)+5;
      Nave(WHITE,loop);
     end;
   End;

   procedure RunEnemi(a1,a2,a3,a4,a5,a6,a7,a8 : Integer);
   Var
     gogo : Integer;
   Begin
    Inc(rr,1);

 {   If Ini[rr].i>1 Then Begin Nave(0,rr);End;}
    Nave(0,rr);

    e:=random(3)+1;
    If e=1 Then
    Begin
    If Ini[rr].i>=1 Then
    Begin
    Ini[rr].x := Ini[rr].x + a1;Ini[rr].y := Ini[rr].y + a5;
    end;
    End;
    If e=2 Then
    Begin
    If Ini[rr].i>=1 Then
    Begin
    Ini[rr].x := Ini[rr].x + a2;Ini[rr].y := Ini[rr].y + a6;
    end;
    End;
    If e=3 Then
    Begin
    If Ini[rr].i>=1 Then
    Begin
    Ini[rr].x := Ini[rr].x + a3;Ini[rr].y := Ini[rr].y + a7;
    end;
    End;
    If e=4 Then
    Begin
    If Ini[rr].i>=1 Then
    Begin
    Ini[rr].x := Ini[rr].x + a4;Ini[rr].y := Ini[rr].y + a8;
    end;
    End;

    If Ini[rr].i<1 Then
    Begin
    StartEnemi2(fase1);
    End;

    If Ini[rr].i>=1 Then
    Begin
    If Ini[rr].x<5 Then
    Begin
    Nave(0,rr);
    Ini[rr].i:=0;
    StartEnemi2(fase1);
    If pontos >=50 Then Begin Dec(pontos,50);Score;End;
    End;
    If Ini[rr].y<1 Then
    Begin
    Nave(0,rr);
    Ini[rr].i:=0;
    StartEnemi2(fase1);
    If pontos >=50 Then Begin Dec(pontos,50);Score;End;
    End;
    If Ini[rr].y>195 Then
    Begin
    Nave(0,rr);
    Ini[rr].i:=0;
    StartEnemi2(fase1);
    If pontos >=50 Then Begin Dec(pontos,50);Score;End;
    End;
    Nave(WHITE,rr);
    End;
    If rr = 10 Then rr:=0;
   End;

   procedure StartTiro;
   var
     ff : Integer;
   Begin
     For ff:=1 to 25 do
     Begin
      If A[ff].i=0 Then
       Begin
        A[ff].x:=x+24;A[ff].y:=y+9;
        A[ff].i:=1;
        Exit;
       End;
     end;
   End;
   procedure StartTiro2;
   var
     ffet : Integer;
   Begin
     For ffet:=1 to 10 do
     Begin
      If Ini[ffet].i>1 Then
      Begin
      If B[ffet].i=0 Then
       Begin
        B[ffet].x:=Ini[ffet].x;B[ffet].y:=Ini[ffet].y+9;
        B[ffet].i:=1;
        Exit;
       End;
       end;
     end;
   End;
   procedure StartTiro3;
   var
     fft,sxx : Integer;
   Begin
     sxx:=rr;
     rr:=1;
     For fft:=1 to 10 do
     Begin
      If B[fft].i=0 Then
       Begin
        B[fft].x:=Ini[rr].x;B[fft].y:=Ini[rr].y+9;
        B[fft].i:=1;
        Inc(rr,1);
        If rr=11 Then r:=1;
       End;
     end;
    rr:=sxx;
   End;
   procedure Laser;
   var
     ff : Integer;
     savex : Integer;
   Begin
     savex:=x;
     For ff:=1 to 25 do
     Begin
      If A[ff].i=0 Then
       Begin
        A[ff].x:=x+23;A[ff].y:=y+9;
        A[ff].i:=1;
        Inc(x,4);
       End;
     end;
    x:=savex;
   End;

   procedure RunTiro;
   Var
      tt,tt2 : Integer;
   Begin

{    SetColor(0);
    Circle(A[ti].x,A[ti].y,1);
    SetColor(WHITE);}

     If A[ti].i=1 Then
      Begin
       SetColor(0);
       Circle(A[ti].x,A[ti].y,1);
       SetColor(WHITE);
       Inc(A[ti].x,5);
       Circle(A[ti].x,A[ti].y,1);
      end;

    If (A[ti].x>300) and (A[ti].i=1) Then
     Begin
      SetColor(0);Circle(A[ti].x,A[ti].y,1);SetColor(WHITE);
      A[ti].i:=0;
     End;

    For tt2:=1 to 10 do
    Begin
    If Ini[tt2].i>1 Then
    Begin
    If (A[ti].i=1) and (A[ti].x>=Ini[tt2].x) and (A[ti].x<=Ini[tt2].x+17)
                   and (A[ti].y>=Ini[tt2].y) and (A[ti].y<=Ini[tt2].y+17) or
       (A[ti].i=1) and (A[ti].x=Ini[tt2].x) and (A[ti].y=Ini[tt2].y) Then
    Begin
     SetColor(0);
     Circle(A[ti].x,A[ti].y,1);SetColor(WHITE);
     Dec(Ini[tt2].i,1);
     If Ini[tt2].i=4 Then Begin Inc(pontos2,100);Score;Ini[tt2].i:=0;Bomba(tt2);Nave2(tt2);Inc(mortos,1);End;
{      Sound(40);delay(atraso+1);NoSound; }
      A[ti].i:=0;
      Inc(ti,1);
      If ti=25 Then ti:=1;
      Exit;
    end;
    end;
    end;
    Inc(ti,1);
    If ti=25 Then ti:=1;

   End;
   procedure RunTiro2(a1 : Integer);
   Var
      att,att2 : Integer;
   Begin

     If B[t2].i=1 Then
      Begin
       SetColor(0);
       rectangle(B[t2].x,B[t2].y,B[t2].x+1,B[t2].y+1);
       SetColor(WHITE);
       Dec(B[t2].x,a1);
       rectangle(B[t2].x,B[t2].y,B[t2].x+1,B[t2].y+1);
      end;

     If (B[t2].x<5) and (B[t2].i=1) Then
     Begin
      SetColor(0);
       rectangle(B[t2].x,B[t2].y,B[t2].x+1,B[t2].y+1);
      SetColor(WHITE);
      B[t2].i:=0;StartTiro2;
     End;

    If (B[t2].i=1) and (B[t2].x=x) and (B[t2].y=y) or
       (B[t2].i=1) and (B[t2].x>=x) and (B[t2].x<=x+25) and
                       (B[t2].y>=y) and (B[t2].y<=y+14) Then
    Begin
      bombi(t2);
     Dec(ta,1);
     BarLife;

    SetColor(0);
       rectangle(B[t2].x,B[t2].y,B[t2].x+1,B[t2].y+1);
    SetColor(WHITE);
      B[t2].i:=0;
      Inc(t2,1);
      If t2=25 Then t2:=1;
      StartTiro2;
      Exit;
    end;

    Inc(t2,1);
    If t2=25 Then t2:=1;

   End;

   procedure despede;
   begin
    CloseGraph;
    WriteLn('');
    WriteLn(' Et Scape 1.0');
    WriteLn(' Copyright (c) 1996 David Maziero');
    writeln;
    WriteLn('');
    Halt(1);
   end;


   procedure StartGame;
   Begin
    if RegisterBGIdriver(@CGADriver) < 0 then halt(1);
    ClrScr;
{    WriteLn('');
    WriteLn(' Entre com a velocidade de seu micro :');
    WriteLn('');
    WriteLn('1- 10 a 20 Mhz');
    WriteLn('2- 33 Mhz');
    WriteLn('3- 66 Mhz');
    WriteLn('4- 100 Mhz');
    WriteLn('5- 133 Mhz');
    atraso:=0;
    readln(opsc);
    if opsc='1' then atraso:=0;
    if opsc='2' then atraso:=30;
    if opsc='3' then atraso:=65;
    if opsc='4' then atraso:=95;
    if opsc='5' then atraso:=130; }
    atraso:=0;

    Graphics(CGA,1,'');

   ShowDGMLogo('dgmLOGO.DAT',0,1,0);
   {Procedure ShowDGMLogo( arq : String; pos : LongInt; tipo : Byte; video : Byte );}

{     DGMApresenta(atraso); }
    ClearDevice;

    while keypressed do begin
     t:=ReadKey;
    end; t:=#0;

    SetTextStyle(DEFAULTFONT,HORIZDIR,4);
    OutTextXY(1,1,'Et Scape');
    SetTextStyle(DEFAULTFONT,HORIZDIR,1);
    OutTextXY(1,180,'Copyright (C) 1996 David Maziero');
    while keypressed do begin
    t:=ReadKey;
    end; t:=#0;
    Pause;ClearDevice;
    OutTextXY(5,15, 'Os Et''s fugiram da prisao espacial');
    OutTextXY(5,25,'E.T.P - k17,com o objetivo de con-');
    OutTextXY(5,35,'quistar todos os planetas da galaxia.');
    OutTextXY(5,45,'Foi feito um teste para escolher o');
    OutTextXY(5,55,'melhor piloto de aero-naves da galaxia,');
    OutTextXY(5,65,'e agora cabe a voce, aniquilar todos os');
    OutTextXY(5,75,'Et''s fugitivos...');Pause;ClearDevice;
    SetTextStyle(DEFAULTFONT,HORIZDIR,1);
    pontos:=0;pontos2:=0; mortos:=0;
    For fase:=1 to 5 do Begin
    SetViewPort(1,1,319,199,ClipOn);
    mortos:=0;
    WriteOut(20,60,'Fase '+Str2(fase));Pause;ClearDevice;

    randomize;

    x:=50;y:=50;c:=1;l:=1;

    SetViewPort(12,1,319,199,ClipOn);
    If fase=1 Then Begin StartEnemi(1);fase1:=1;fase2:=50;nune:=2;nunt:=2;end;
    If fase=2 Then Begin StartEnemi(5);fase1:=5;fase2:=100;end;
    If fase=3 Then Begin StartEnemi(10);fase1:=10;fase2:=70;end;
    If fase=4 Then Begin StartEnemi(15);fase1:=15;fase2:=120;end;
    If fase=5 Then Begin StartEnemi(20);fase1:=20;fase2:=40;end;
    For rr:=1 to 25 do Begin
     A[rr].x:=1;A[rr].y:=1;A[rr].i:=0;
     B[rr].x:=1;B[rr].y:=1;B[rr].i:=0;
    End;

    rr:=1;ti:=0;
    ti2:=0;t2:=0;
    ta:=30;
    contini:=0;
    anda:=0;
    e:=1;
    BarLife;
    Score;
    StartTiro3;

    For r:=1 to 100 do
    Begin
     If r>80 Then r:=1;
     if r mod 10 = 0 then begin Score;BarLife;end;

     NNave(WHITE);

     RunTiro;
     If fase=1 Then Begin RunTiro2(3); RunTiro2(3);End;
     If fase=2 Then Begin RunTiro2(4); RunTiro2(4);End;
     If fase=3 Then Begin RunTiro2(4); RunTiro2(4);End;
     If fase=4 Then Begin RunTiro2(5); RunTiro2(5);End;
     If fase=5 Then Begin RunTiro2(6); RunTiro2(6);End;
     RunTiro;
     If fase=1 Then RunEnemi(-2,-1,-2,-1,+1,-1,+1,-1);

     If fase=2 Then RunEnemi(-2,-2,-2,-1,+1,-1,+1,-1);
     If fase=3 Then RunEnemi(-3,-3,-2,-3,+2,-1,+1,-2);
     If fase=4 Then RunEnemi(-3,-4,-3,-4,+2,-2,+2,-2);
     If fase=5 Then RunEnemi(-5,-5,-5,-5,+3,-3,+3,-3);
     RunTiro;
     If fase=1 Then Begin RunTiro2(3);End;
     If fase=2 Then Begin RunTiro2(4);End;
     If fase=3 Then Begin RunTiro2(4);End;
     If fase=4 Then Begin RunTiro2(5);End;
     If fase=5 Then Begin RunTiro2(6);End;
     RunTiro;

{     If (anda>1500) and (contini<5) Then Begin Dec(ta,1);BarLife;End; }

{     If anda>=2999 Then Begin contini:=900;anda:=0;End; }

     if atraso>=1 then delay(atraso);
     if r mod 2 = 0 then waitretrace;
     comandos;
     If ta<=0 Then Begin Bomba2;nosound;despede;End;
     If t=#27 Then Begin Bomba2;nosound;despede;end;
    end;
    end;

    Pause;
    CloseGraph;
   End;

   Begin
    StartGame;
   End.
