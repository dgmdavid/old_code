{

   Bomb v1.0 - by David Maziero

   Copyright (c) 1997 David Maziero / DGM Inform tica

   22 de julho de 1997

}

  Uses Crt,Dos,Graph,BombC,Apren,DGMLogo,PlayUnit;

  type

   ArenaType = record
    Condi : array[1..135] of Word;
   end;
   Fika = file of ArenaType;

  var
   vidas : Word;
   Loca : Word;
   Movi : Word;
   Lado : Word;
   ColocaVeT : Word;
   Bombas : Word;
   LoSta : Word;
   Chave : Word;
   contar : Word;
   Super : Word;
   ActSu : Word;
   SALo : word;
   Fase : Word;
   swi : Word;
   RGra : Word;
   t : Char;
   bloco : ArenaType;
   Gra : array[1..46] of Pointer;
   NuSuper : Word;
   f : File;
   f2 : Fika;
   Colu : Word;
   r : Word;
   PFase : Word;
   opcao : Word;
   ColocaTipo : Word;
   Passo : Word;
   Pontos : LongInt;
   MaxSW : Word;
   atra : Word;
   antigo : Byte;

function CenterBox3Op(op1,op2,op3,mess1,mess2 : String; cormess1,cormess2,corops,corselect,corb,corfundo,cord,
  atra,speed,le:Word):Word;
  var
   ViewPort: ViewPortType;
   TextS   : TextSettingsType;
   savecor : Word;
   savecorbk : Word;
   key : Char;
   opcao,w : Word;
   x : Integer;
   savep : Pointer;
   size : Word;
  Begin
   atra:=2;
   size:=ImageSize(99,49,176,126);
   GetMem(savep,size);
   GetImage(99,49,176,126,savep^);

   savecor:=GetColor;
   savecorbk:=GetBkColor;
   GetViewSettings( ViewPort );
   GetTextSettings( TextS    );

   SetFillStyle(SolidFill,corfundo);
   bar(101,51,175,125);

   SetViewPort(99,49,176,126,ClipOn);
   SetColor( corb ); Rectangle(1,1,77,77);

   SetViewPort(101,50,175,125,ClipOn);

   SetTextStyle( SmallFont, HorizDir, 4);
   if le=1 then SetUserCharSize(2,3,1,1);

   SetColor( cormess1 ); OutTextXY( 36-TextWidth( mess1 ) div 2, 2, mess1 );

   SetColor( corops );
   OutTextXY( 36-TextWidth( op1 ) div 2, 19, op1 );
   OutTextXY( 36-TextWidth( op2 ) div 2, 31, op2 );
   OutTextXY( 36-TextWidth( op3 ) div 2, 43, op3 );
   SetColor( corselect );
   Rectangle( 36-TextWidth( op1 ) div 2-3, 20, 36+TextWidth( op1 ) div 2+3, 31);
   Opcao:=1;
   x:=70;

   for w:=1 to 100 do Begin
    If w>80 then w:=1;
    SetColor( cord );
    OutTextXY(x+atra,64,mess2);
    SetColor( cormess2 );
    OutTextXY(x,64,mess2);
    if w mod 2 = 0 then RDelay( 1 );
    x:=x-atra;
    If x<=-74-TextWidth( mess2 )+70 then x:=74;
    If not KeyPressed then Key:=#0;
    If KeyPressed then key:=ReadKey;
    If Key=#13 then Begin w:=100;CenterBox3Op:=Opcao;End;
    If Key=#27 then Begin w:=100;CenterBox3Op:=0;End;

    If (Key=BAIXO) and (Opcao=1) then
    Begin
     Opcao:=2;
     SetColor( cord );
     Rectangle( 36-TextWidth( op1 ) div 2-3, 20, 36+TextWidth( op1 ) div 2+3, 31);
     SetColor( corselect );
     Rectangle( 36-TextWidth( op2 ) div 2-3, 32, 36+TextWidth( op2 ) div 2+3, 43);
     Key:=#0;
    End;
    If (Key=BAIXO) and (Opcao=2) then
    Begin
     Opcao:=3;
     SetColor( cord );
     Rectangle( 36-TextWidth( op2 ) div 2-3, 32, 36+TextWidth( op2 ) div 2+3, 43);
     SetColor( corselect );
     Rectangle( 36-TextWidth( op3 ) div 2-3, 44, 36+TextWidth( op3 ) div 2+3, 55);
     Key:=#0;
    End;
    If (Key=BAIXO) and (Opcao=3) then
    Begin
     Opcao:=1;
     SetColor( cord );
     Rectangle( 36-TextWidth( op3 ) div 2-3, 44, 36+TextWidth( op3 ) div 2+3, 55);
     SetColor( corselect );
     Rectangle( 36-TextWidth( op1 ) div 2-3, 20, 36+TextWidth( op1 ) div 2+3, 31);
     Key:=#0;
    End;
    If (Key=CIMA) and (Opcao=3) then
    Begin
     Opcao:=2;
     SetColor( cord );
     Rectangle( 36-TextWidth( op3 ) div 2-3, 44, 36+TextWidth( op3 ) div 2+3, 55);
     SetColor( corselect );
     Rectangle( 36-TextWidth( op2 ) div 2-3, 32, 36+TextWidth( op2 ) div 2+3, 43);
     Key:=#0;
    End;
    If (Key=CIMA) and (Opcao=2) then
    Begin
     Opcao:=1;
     SetColor( cord );
     Rectangle( 36-TextWidth( op2 ) div 2-3, 32, 36+TextWidth( op2 ) div 2+3, 43);
     SetColor( corselect );
     Rectangle( 36-TextWidth( op1 ) div 2-3, 20, 36+TextWidth( op1 ) div 2+3, 31);
     Key:=#0;
    End;

    If (Key=CIMA) and (Opcao=1) then
    Begin
     Opcao:=3;
     SetColor( cord );
     Rectangle( 36-TextWidth( op1 ) div 2-3, 20, 36+TextWidth( op1 ) div 2+3, 31);
     SetColor( corselect );
     Rectangle( 36-TextWidth( op3 ) div 2-3, 44, 36+TextWidth( op3 ) div 2+3, 55);
     Key:=#0;
    End;
   End;
   SetColor(savecor);
   SetBkColor(savecorbk);
   with ViewPort do
   Begin
    SetViewPort(x1,y1,x2,y2,Clip);
   End;
   with TextS do
   Begin
    SetTextStyle(Font,Direction,CharSize);
   End;

   PutImage(99,49,savep^,CopyPut);
   FreeMem(savep,size);
  End;



   Procedure Money(po : LongInt); forward;

   procedure Shoping;
   var
    s : array[1..5] of Pointer;
    f : File;
    a : PathStr;
    w,op : Word;
   Begin
    GetMem(s[1],142); GetMem(s[2],142); GetMem(s[3],142); GetMem(s[4],142);
    GetMem(s[5],4134);

    a:=FSearch('SHOP.DAT','');
    if a='' then begin CloseGraph;WriteLn; WriteLn('  Arquivo SHOP.DAT nƒo encontrado.');
     WriteLn('  Programa abortado.'); WriteLn; Halt(1); end;

    PlayInit('o1;r3;i3;jjjkl.mn.mn.ccv.vbmbbm.jlhk.ggfddsfghj.mn.mn.');

    Assign(f,'SHOP.DAT'); Reset(f,1);
    BlockRead(f,s[1]^,142); BlockRead(f,s[2]^,142);
    BlockRead(f,s[3]^,142); BlockRead(f,s[4]^,142);
    BlockRead(f,s[5]^,4134); Close(f);

    ClearDevice;
    if colocatipo=NotPut then begin setfillstyle(SOLIDFILL,3); FloodFill(1,1,1); end;

    PutImage(55,5,s[5]^,ColocaTipo);
    if colocatipo=NotPut then setcolor(0);
    SetTextStyle(DEFAULTFONT,HORIZDIR,1);
    OutTextXY(5,150,'O que voce quer comprar ?');
    OutTextXY(5,148,'         ^');

    op:=1;
    for w:=1 to 100 do begin
     if w>=4 then w:=1;
     if w<=4 then PutImage(50,120,s[w]^,ColocaTipo);

     PutImage(30,165,Gra[13]^,ColocaTipo);
     PutImage(80,165,Gra[17]^,ColocaTipo);
     PutImage(130,165,Gra[18]^,ColocaTipo);
     PutImage(180,165,Gra[21]^,ColocaTipo);
     Bar(30,186,230,199);
     OutTextXY(38,190,str2(Chave));
     OutTextXY(88,190,str2(vidas));
     OutTextXY(138,190,str2(bombas));
     OutTextXY(188,190,str2(nusuper));

     if op=1 then begin
      Bar(230,170,319,199); OutTextXY(230,170,'Buy $1800');
      OutTextXY(230,180,'$'+str2(pontos));
      setcolor(1); rectangle(30,165,50,185); setcolor(3);
      if colocatipo=NotPut then setcolor(0);
     end;
     if op=2 then begin
      Bar(230,170,319,199); OutTextXY(230,170,'Buy $1500');
      OutTextXY(230,180,'$'+str2(pontos));
      setcolor(1); rectangle(80,165,100,185); setcolor(3);
      if colocatipo=NotPut then setcolor(0);
     end;
     if op=3 then begin
      Bar(230,170,319,199); OutTextXY(230,170,'Buy $1200');
      OutTextXY(230,180,'$'+str2(pontos));
      setcolor(1); rectangle(130,165,150,185); setcolor(3);
      if colocatipo=NotPut then setcolor(0);
     end;
     if op=4 then begin
      Bar(230,170,319,199); OutTextXY(230,170,'Buy $2000');
      OutTextXY(230,180,'$'+str2(pontos));
      setcolor(1); rectangle(180,165,200,185); setcolor(3);
      if colocatipo=NotPut then setcolor(0);
     end;

     RDelay(6);

     if not keypressed then t:=#0;
     if keypressed then t:=ReadKey;

     if(t=FRENTE) and (op<4) then op:=op+1;
     if(t=TRAS) and (op>1) then op:=op-1;
     if t=#27 then w:=100;

     if t=#13 then begin

     PutImage(50,120,s[4]^,ColocaTipo);

     if(op=1) and (pontos<1800) then begin PlayInit('&090&090*');
      PlayInit('o1;r3;i3;jjjkl.mn.mn.ccv.vbmbbm.jlhk.ggfddsfghj.mn.mn.'); end;
     if(op=2) and (pontos<1500) then begin PlayInit('&090&090*');
      PlayInit('o1;r3;i3;jjjkl.mn.mn.ccv.vbmbbm.jlhk.ggfddsfghj.mn.mn.'); end;
     if(op=3) and (pontos<1200) then begin PlayInit('&090&090*');
      PlayInit('o1;r3;i3;jjjkl.mn.mn.ccv.vbmbbm.jlhk.ggfddsfghj.mn.mn.'); end;
     if(op=4) and (pontos<2000) then begin PlayInit('&090&090*');
      PlayInit('o1;r3;i3;jjjkl.mn.mn.ccv.vbmbbm.jlhk.ggfddsfghj.mn.mn.'); end;

     if(op=1) and (pontos>=1800) then begin pontos:=pontos-1800; chave:=chave+1; end;
     if(op=2) and (pontos>=1500) then begin pontos:=pontos-1500; vidas:=vidas+1; end;
     if(op=3) and (pontos>=1200) then begin pontos:=pontos-1200; bombas:=bombas+1; end;
     if(op=4) and (pontos>=2000) then begin pontos:=pontos-2000; nusuper:=nusuper+1; end;

     end;


    end;

    FreeMem(s[1],142); FreeMem(s[2],142); FreeMem(s[3],142); FreeMem(s[4],142);
    FreeMem(s[5],4134); ClearDevice; t:=#0;
    setcolor(3); Money(pontos); PlayInit('*');
   End;

   procedure Final;
   var
    f : File;
    final : array[1..3] of Pointer;
    s : PathStr;
   Begin
    ClearDevice;
    s:=FSearch('FINAL.DAT','');
    if s='' then begin
     CloseGraph;
     WriteLn; WriteLn('  O arquivo FINAL.DAT nƒo foi encontrado. ');
     WriteLn('  Programa abortado.'); writeln; writeln; Halt(1);
    end;
    Assign(f,'FINAL.DAT');
    Reset(f,1);
     GetMem(final[1],84); GetMem(final[2],2008); GetMem(final[3],7706);
     BlockRead(f,final[1]^,84);
     BlockRead(f,final[2]^,2008);
     BlockRead(f,final[3]^,7706);
    Close(f);
    setcolor(WHITE);
    if colocatipo=NotPut then begin setfillstyle(SOLIDFILL,3); floodfill(1,1,1); setcolor(0);end;
    putimage(145,85,final[1]^,ColocaTipo);
    SetTextStyle(SMALLFONT,HORIZDIR,4);
    OutTextXY(5,120,'Finalmente, Bomb consegue tirar suas merecidas');
    OutTextXY(5,130,'f‚rias. E ele sabe aproveitar bem as f‚rias.');
    Pause;
    ClearDevice;
    if colocatipo=NotPut then begin setfillstyle(SOLIDFILL,3); floodfill(1,1,1); setcolor(0);end;
    PutImage(70,50,final[2]^,ColocaTipo);
    RDelay(18*3);
    cleardevice;
    PutImage(10,10,final[3]^,ColocaTipo);

    SetTextStyle(SMALLFONT,HORIZDIR,4);
    OutTextXY(235,5,'Creditos');
    OutTextXY(236,4,'  ''');
    OutTextXY(220,20,'Programador :');
    OutTextXY(220,30,' David Maziero');
    OutTextXY(220,50,'Test Players :');
    OutTextXY(220,100,' David Maziero');

    SetTextStyle(DEFAULTFONT,HORIZDIR,1);
    OutTextXY(10,175,'Obrigado por jogar Bomb 1.0');
    OutTextXY(10,185,'Copyright (c) 1997 David Maziero ');
    Pause;
     CloseGraph;
     writeln;
     writeln(' Bomb - David Maziero / DGM Inform tica');
     writeln;
     Stop;
     Halt(1);
   End;

   function veseparo : Word;
   begin
    SetTextStyle(defaultfont,horizdir,1);
    setcolor(0);
    outtextxy(81,60,'Sair (S/N) ?');
    outtextxy(80,61,'Sair (S/N) ?');
    outtextxy(79,60,'Sair (S/N) ?');
    outtextxy(80,59,'Sair (S/N) ?');
    setcolor(white);
    outtextxy(80,60,'Sair (S/N) ?');
    t:=#0;
    while (upcase(t)<>'S') and (upcase(t)<>'N') do begin
     t:=ReadKey;
    End;
    SetTextStyle(smallfont,horizdir,4);
    playinit('bbb*');
    if upcase(t)='S' then
    begin
     veseparo:=2;
     exit;
    end;
    veseparo:=1;
   end;

   procedure vesequit;
   begin
    ClearDevice;
    SetTextStyle(defaultfont,horizdir,1);
    setcolor(2);
    outtextxy(61,60,'Sair para o Dos (S/N) ?');
    outtextxy(60,61,'Sair para o Dos (S/N) ?');
    outtextxy(59,60,'Sair para o Dos (S/N) ?');
    outtextxy(60,59,'Sair para o Dos (S/N) ?');
    setcolor(white);
    outtextxy(60,60,'Sair para o Dos (S/N) ?');
    t:=#0;
    while (upcase(t)<>'S') and (upcase(t)<>'N') do begin
     t:=ReadKey;
    End;
    SetTextStyle(smallfont,horizdir,4);
    playinit('bbb*');
    if upcase(t)='S' then
    begin
     For RGra:=1 to 46 do begin
      FreeMem(Gra[RGra],132);
     end;
     CloseGraph;
     writeln;
     writeln(' Bomb - David Maziero / DGM Inform tica');
     writeln;
     Stop;
     Halt(1);
    end;
   end;

   procedure continue;
   begin
    PlayInit('r2;i2;o1;ghjbkb.ghjk.jkh.bnmjjhg.h.hghjhj.ghjn.xcvdzv.zghfjdsaaaaghbk.ag');

    SetTextStyle(defaultfont,horizdir,1);
    setcolor(0);
    outtextxy(61,60,'Continue (S/N) ?');
    outtextxy(60,61,'Continue (S/N) ?');
    outtextxy(59,60,'Continue (S/N) ?');
    outtextxy(60,59,'Continue (S/N) ?');
    setcolor(white);
    outtextxy(60,60,'Continue (S/N) ?');
    t:=#0;
    while (upcase(t)<>'S') and (upcase(t)<>'N') do begin
     t:=ReadKey;
    End;
    SetTextStyle(smallfont,horizdir,4);
    playinit('bb*');

    if upcase(t)='N' then
    begin
     closegraph;
     writeln;
     writeln(' Bomb 1.0 - David Maziero / DGM Inform tica');
     writeln;
     Halt(1);
    end;
    Fase:=1; Loca:=1; Movi:=1; Bombas:=0; Chave:=0; Vidas:=5;
    Colu:=1; Pontos:=0; Lado:=1;

   end;

   Procedure Money(po : LongInt);
   Begin
    SetTextStyle(SmallFont,HorizDir,4);
    SetUserCharSize(2,3,3,2);
    SetFillStyle(Solidfill,0);
    Bar(1,185,319,199);
    OutTextXY(5,185,'Vidas:'+str2(vidas)+'  Pontos:'+str2(Po)+'  Bombas:'+str2(bombas)+'  Chave:'+str2(chave)+
    '  Super:'+str2(NuSuper)+'  Fase:'+str2(PFase));
   End;

   Procedure StageClear;
   Begin
    PlayInit('o1;r2;i3;aasfadfsgagsfddgsfddgsfddgsfaagsfssgafssdfdgsfagdfsgafsgdfsgad');

    SetFillStyle(Solidfill,0);
    Bar(1,185,319,199);
    SetTextStyle(DEFAULTFONT,HORIZDIR,1);
    OutTextXY(5,185,'Fase Completada!');
    Pause;
    PlayInit('*');
   End;

   Procedure PoeTela;
   var
    xx,yy,rr,so : Word;
   Begin
    xx:=5; yy:=2;
    for rr:=1 to 135 do begin
     PutImage(xx,yy,Gra[bloco.condi[rr]]^,ColocaTipo);
     xx:=xx+20;
     If Bloco.Condi[rr]=20 then
      Begin
       PlayInit('s*');
       if (rr<135) and not (Bloco.Condi[rr+1]=42) and not (Bloco.Condi[rr+1]=14) then Bloco.Condi[rr+1]:=12;
       if (rr>1) and not (Bloco.Condi[rr-1]=42) and not (Bloco.Condi[rr+1]=14) then Bloco.Condi[rr-1]:=12;
       if (rr<120) and not (Bloco.Condi[rr+15]=42) and not (Bloco.Condi[rr+1]=14) then Bloco.Condi[rr+15]:=12;
       if (rr>15) and not (Bloco.Condi[rr-15]=42) and not (Bloco.Condi[rr+1]=14) then Bloco.Condi[rr-15]:=12;
      End;

     if xx>=290 then begin xx:=5; yy:=yy+20; end;
    end;
   End;
   Procedure VeMonstro;
   var
    rr,so : Word;
   Begin
    For rr:=1 to 135 do begin
     If (Bloco.Condi[rr]>=30) and (Bloco.Condi[rr]<=35) then
     Begin
      so:=Random(8)+1;
      If so=1 then Begin
       If (rr>1) and (Bloco.Condi[rr-1]=12) then begin
       if r mod 4 =0 then Bloco.Condi[rr-1]:=33;
       if r mod 6 =0 then Bloco.Condi[rr-1]:=34;
       Bloco.Condi[rr]:=12; End; End;
      If so=2 then Begin
       If (rr<135) and (Bloco.Condi[rr+1]=12) then begin
       if r mod 4 =0 then Bloco.Condi[rr+1]:=30;
       if r mod 6 =0 then Bloco.Condi[rr+1]:=31;
       Bloco.Condi[rr]:=12; End; End;
      If so=3 then Begin
       If (rr<120) and (Bloco.Condi[rr+15]=12) then begin
       if r mod 4 =0 then Bloco.Condi[rr+15]:=30;
       if r mod 6 =0 then Bloco.Condi[rr+15]:=31;
       Bloco.Condi[rr]:=12; End; End;
      If so=4 then Begin
       If (rr>15) and (Bloco.Condi[rr-15]=12) then begin
       if r mod 4 =0 then Bloco.Condi[rr-15]:=30;
       if r mod 6 =0 then Bloco.Condi[rr-15]:=31;
       Bloco.Condi[rr]:=12; End; End;
      If so=5 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=30;
       if r mod 6 =0 then Bloco.Condi[rr]:=31;End;
      If so=6 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=33;
       if r mod 6 =0 then Bloco.Condi[rr]:=34;End;
      If so=7 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=30;
       if r mod 6 =0 then Bloco.Condi[rr]:=31;End;
      If so=8 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=33;
       if r mod 6 =0 then Bloco.Condi[rr]:=34;End;
      If so=1 then begin
       If (rr>1) and (Bloco.Condi[rr-1]<=8) then begin
       if r mod 4 =0 then Bloco.Condi[rr-1]:=33;
       if r mod 6 =0 then Bloco.Condi[rr-1]:=34;
       Bloco.Condi[rr]:=12; End; End;
      If so=2 then Begin
       If (rr<135) and (Bloco.Condi[rr+1]<=8) then begin
       if r mod 4 =0 then Bloco.Condi[rr+1]:=30;
       if r mod 6 =0 then Bloco.Condi[rr+1]:=31;
       Bloco.Condi[rr]:=12; End; End;
      If so=3 then Begin
       If (rr<120) and (Bloco.Condi[rr+15]<=8) then begin
       if r mod 4 =0 then Bloco.Condi[rr+15]:=30;
       if r mod 6 =0 then Bloco.Condi[rr+15]:=31;
       Bloco.Condi[rr]:=12; End; End;
      If so=4 then Begin
       If (rr>15) and (Bloco.Condi[rr-15]<=8) then begin
       if r mod 4 =0 then Bloco.Condi[rr-15]:=30;
       if r mod 6 =0 then Bloco.Condi[rr-15]:=31;
       Bloco.Condi[rr]:=12; End; End;
      If so=5 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=30;
       if r mod 6 =0 then Bloco.Condi[rr]:=31; End;
      If so=6 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=33;
       if r mod 6 =0 then Bloco.Condi[rr]:=34; End;
      If so=7 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=30;
       if r mod 6 =0 then Bloco.Condi[rr]:=31; End;
      If so=8 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=33;
       if r mod 6 =0 then Bloco.Condi[rr]:=34; End;
     End;

     If (Bloco.Condi[rr]>=36) and (Bloco.Condi[rr]<=41) then
     Begin
      so:=Random(8)+1;
      If so=1 then Begin
       If (rr>1) and (Bloco.Condi[rr-1]=12) then begin
       if r mod 4 =0 then Bloco.Condi[rr-1]:=39;
       if r mod 6 =0 then Bloco.Condi[rr-1]:=40;
       Bloco.Condi[rr]:=12; End; End;
      If so=2 then Begin
       If (rr<135) and (Bloco.Condi[rr+1]=12) then begin
       if r mod 4 =0 then Bloco.Condi[rr+1]:=36;
       if r mod 6 =0 then Bloco.Condi[rr+1]:=37;
       Bloco.Condi[rr]:=12; End; End;
      If so=3 then Begin
       If (rr<120) and (Bloco.Condi[rr+15]=12) then begin
       if r mod 4 =0 then Bloco.Condi[rr+15]:=36;
       if r mod 6 =0 then Bloco.Condi[rr+15]:=37;
       Bloco.Condi[rr]:=12; End; End;
      If so=4 then Begin
       If (rr>15) and (Bloco.Condi[rr-15]=12) then begin
       if r mod 4 =0 then Bloco.Condi[rr-15]:=36;
       if r mod 6 =0 then Bloco.Condi[rr-15]:=37;
       Bloco.Condi[rr]:=12; End; End;
      If so=5 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=36;
       if r mod 6 =0 then Bloco.Condi[rr]:=37; End;
      If so=6 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=39;
       if r mod 6 =0 then Bloco.Condi[rr]:=40; End;
      If so=7 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=36;
       if r mod 6 =0 then Bloco.Condi[rr]:=37; End;
      If so=8 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=39;
       if r mod 6 =0 then Bloco.Condi[rr]:=40; End;
      If so=1 then Begin
      If (rr>1) and (Bloco.Condi[rr-1]<=8) then begin
       if r mod 4 =0 then Bloco.Condi[rr-1]:=39;
       if r mod 6 =0 then Bloco.Condi[rr-1]:=40;
       Bloco.Condi[rr]:=12; End; End;
      If so=2 then Begin
       If (rr<135) and (Bloco.Condi[rr+1]<=8) then begin
       if r mod 4 =0 then Bloco.Condi[rr+1]:=36;
       if r mod 6 =0 then Bloco.Condi[rr+1]:=37;
       Bloco.Condi[rr]:=12; End; End;
      If so=3 then Begin
       If (rr<120) and (Bloco.Condi[rr+15]<=8) then begin
       if r mod 4 =0 then Bloco.Condi[rr+15]:=36;
       if r mod 6 =0 then Bloco.Condi[rr+15]:=37;
       Bloco.Condi[rr]:=12; End; End;
      If so=4 then Begin
       If (rr>15) and (Bloco.Condi[rr-15]<=8) then begin
       if r mod 4 =0 then Bloco.Condi[rr-15]:=36;
       if r mod 6 =0 then Bloco.Condi[rr-15]:=37;
       Bloco.Condi[rr]:=12; End; End;
      If so=5 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=36;
       if r mod 6 =0 then Bloco.Condi[rr]:=37; End;
      If so=6 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=39;
       if r mod 6 =0 then Bloco.Condi[rr]:=40; End;
      If so=7 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=36;
       if r mod 6 =0 then Bloco.Condi[rr]:=37; End;
      If so=8 then Begin
       if r mod 4 =0 then Bloco.Condi[rr]:=39;
       if r mod 6 =0 then Bloco.Condi[rr]:=40; End;
     End;

    end;
   end;

  procedure vebomba;
  var
   rr,so : Word;
  begin
    for rr:=1 to 135 do begin
     If(Bloco.Condi[rr]=19) and (r mod 10 = 0) then
     begin
      Bloco.Condi[rr]:=12;
      PlayInit('a*');
      if (rr<135) and not (Bloco.Condi[rr+1]=42) and not (Bloco.Condi[rr+1]=14) then Bloco.Condi[rr+1]:=12;
      if (rr>1) and not (Bloco.Condi[rr-1]=42) and not (Bloco.Condi[rr+1]=14) then Bloco.Condi[rr-1]:=12;
      if (rr<120) and not (Bloco.Condi[rr+15]=42) and not (Bloco.Condi[rr+1]=14) then Bloco.Condi[rr+15]:=12;
      if (rr>15) and not (Bloco.Condi[rr-15]=42) and not (Bloco.Condi[rr+1]=14) then Bloco.Condi[rr-15]:=12;
      nosound;
     end;
     If Bloco.Condi[rr]=19 then
     begin
      PlayInit('a*');
      if (rr<135) and not (Bloco.Condi[rr+1]=42) and not (Bloco.Condi[rr+1]=14) then Bloco.Condi[rr+1]:=12;
      if (rr>1) and not (Bloco.Condi[rr-1]=42) and not (Bloco.Condi[rr+1]=14) then Bloco.Condi[rr-1]:=12;
      if (rr<120) and not (Bloco.Condi[rr+15]=42) and not (Bloco.Condi[rr+1]=14) then Bloco.Condi[rr+15]:=12;
      if (rr>15) and not (Bloco.Condi[rr-15]=42) and not (Bloco.Condi[rr+1]=14) then Bloco.Condi[rr-15]:=12;
      nosound;
     end;

     If(Bloco.Condi[rr]=46) and (r mod 6 = 0) then
     begin
      Bloco.Condi[rr]:=19;
      PlayInit('d*');
     end;
     If(Bloco.Condi[rr]=45) and (r mod 6 = 0) then
     begin
      Bloco.Condi[rr]:=46;
      PlayInit('s*');
     end;
     If(Bloco.Condi[rr]=44) and (r mod 6 = 0) then
     begin
      PlayInit('b*');
      Bloco.Condi[rr]:=45;
     end;
     If(Bloco.Condi[rr]=43) and (r mod 8 = 0) then
     begin
      Bloco.Condi[rr]:=44;
      PlayInit('b*');
     end;
     If(swi>=MaxSW) and (Bloco.Condi[rr]=24) then Begin PlayInit('f*'); Bloco.Condi[rr]:=25;End;
    end;
   End;

Procedure VePorta;
Begin
If(Lado=0) and (Bloco.Condi[Loca+1]=14) then begin Bloco.Condi[Loca+1]:=12;chave:=chave-1;PlayInit('x*');
Exit;End;
If(Lado=4) and (Bloco.Condi[Loca-1]=14) then begin Bloco.Condi[Loca-1]:=12;chave:=chave-1;PlayInit('x*');
Exit;End;
If(Lado=0) and (Bloco.Condi[Loca+15]=14) then begin Bloco.Condi[Loca+15]:=12;chave:=chave-1;PlayInit('x*');
Exit;End;
If(Lado=4) and (Bloco.Condi[Loca-15]=14) then begin Bloco.Condi[Loca-15]:=12;chave:=chave-1;PlayInit('x*');
Exit;End;
End;
 
Procedure VeTele;
Begin
     if t=FRENTE then
     begin
      if Bloco.Condi[Loca+1]=20 then Begin
       Bloco.Condi[Loca]:=12;
       For contar:=1 to 135 do begin PlayInit('n*');
        If (Bloco.Condi[contar-1]=12) and (contar<>Loca+1) and (Bloco.Condi[contar]=20) then Begin Loca:=Contar-1;t:=#0;Exit;
        End;
       end; NoSound; t:=#0;
      End; end;
     if t=TRAS then
     begin
      if Bloco.Condi[Loca-1]=20 then Begin
       Bloco.Condi[Loca]:=12;
       For contar:=1 to 135 do begin PlayInit('n*');
        If (Bloco.Condi[contar+1]=12) and (contar<>Loca-1) and (Bloco.Condi[contar]=20) then Begin Loca:=Contar+1;t:=#0;Exit;
        End;
       end; NoSound; t:=#0;
      End; end;
     if t=CIMA then
     begin
      if Bloco.Condi[Loca-15]=20 then Begin
       Bloco.Condi[Loca]:=12;
       For contar:=1 to 135 do begin PlayInit('n*');
     If (Bloco.Condi[contar+15]=12) and (contar<>Loca-15) and (Bloco.Condi[contar]=20) then Begin Loca:=Contar+15;t:=#0;Exit;
        End;
       end; NoSound; t:=#0;
      End; end;
     if t=BAIXO then
     begin
      if Bloco.Condi[Loca+15]=20 then Begin
       Bloco.Condi[Loca]:=12;
       For contar:=1 to 135 do begin PlayInit('n*');
     If (Bloco.Condi[contar-15]=12) and (contar<>Loca+15) and (Bloco.Condi[contar]=20) then Begin Loca:=Contar-15;t:=#0;Exit;
        End;
       end; NoSound; t:=#0;
      End; end;
End;


  { Rotina FazFase  ******************************  }

   Function FazFase(nomearq : String; Fase : Word) : Word;
   var
    veresai : Word;

   Begin
    For r:=1 to 135 do begin
     bloco.condi[r]:=12;
    end;
    Assign(f2,nomearq); Reset(f2);
    If Fase>filesize(f2) then begin
     Close(f2); vesequit;
    end;
    seek(f2,Fase-1);
    Read(f2,bloco);
    Close(f2);

    r:=1;
    ColocaTipo:=NotPut;
    Money(Pontos); Movi:=1; Lado:=0; swi:=0; MaxSW:=0;
    ActSu:=0; Super:=0; t:=#0;

    For r:=1 to 135 do begin
     if bloco.condi[r]=22 then MaxSW:=MaxSW+1;
     if (bloco.condi[r]>=1) and (bloco.condi[r]<=8) then LoSta:=r;
    end;
    r:=1;
    Loca:=LoSta;

    while t<>#27 do Begin
     r:=r+1;
     If r>80 then r:=1;

     If r mod 2 = 0 then Movi:=1;
     If r mod 3 = 0 then Movi:=2;

     If Loca<15 then Colu:=0;
     If(Loca>15) and (Loca<=30) then Colu:=15;
     If(Loca>30) and (Loca<=45) then Colu:=30;
     If(Loca>45) and (Loca<=60) then Colu:=45;
     If(Loca>60) and (Loca<=75) then Colu:=60;
     If(Loca>75) and (Loca<=90) then Colu:=75;
     If(Loca>90) and (Loca<=105) then Colu:=90;
     If(Loca>105) and (Loca<=120) then Colu:=105;

     Bloco.Condi[Loca]:=Movi+Lado;

     If (ColocaVet=2) and (r mod 2=0) then begin ColocaTipo:=ColocaTipo+1;end;
     If ColocaTipo>=5 then ColocaTipo:=0;

     If r mod 2 = 0 then PoeTela;

     If ActSu=0 then Begin If r mod 4 = 0 then VeMonstro;End;
     If ActSu=1 then Begin
      if r mod 2 = 0 then Super:=Super-1;
      PlayInit('v*');
     End;
     If Super<=5 then ActSu:=0;

     If r mod 2 = 0 then VeBomba;

     If r mod 2 = 0 then RDelay(1);

     if not keypressed then t:=#0;
     if keypressed then t:=ReadKey;


     If ActSu=0 then begin
     If (Bloco.Condi[Loca]>=30) and (Bloco.Condi[Loca]<=41) then
     begin
      antigo := Bloco.Condi[Loca];
      Movi:=3; Bloco.Condi[Loca]:=Movi+Lado; PoeTela;PlayInit('aaa*');
      Pause;
      Bloco.Condi[Loca]:=antigo; PoeTela;
      Bloco.Condi[Loca]:=antigo;Loca:=LoSta;PoeTela;
      Vidas:=Vidas-1;Money(Pontos);
     end; end;

     if t=#27 then
     begin
      FazFase:=17;
      veresai:=veseparo;
      if veresai=2 then Exit;
     end;

     if t='[' then ColocaTipo:=CopyPut;
     if t=']' then ColocaTipo:=NotPut;
     if t='{' then ColocaTipo:=XORPut;
     if t='}' then ColocaTipo:=oRPut;

     if t=',' then ColocaVeT:=2;
     if t='.' then ColocaVeT:=1;

     if t='b' then Shoping;
     if t=#13 then
     begin
 while keypressed do t:=ReadKey;
 t:=#0;
 opcao:=CenterBox3Op('Shop','Recome‡ar','Sair','Op‡“es','Bomb 1.0 - David Maziero / DGM Inform tica',3,3,3,1,3,2,2,2,atra,0);
 if opcao=1 then begin LimpaTeclado;Shoping;end;
 if opcao=2 then begin PFase:=1; FazFase:=0;Exit; end;
 if opcao=3 then vesequit;
     end;

     if(t=' ') and (bombas>=1) then
     begin
      If(Lado=0) and (Bloco.Condi[Loca+1]=12) then begin Bloco.Condi[Loca+1]:=43;bombas:=bombas-1;End;
      If(Lado=4) and (Bloco.Condi[Loca-1]=12) then begin Bloco.Condi[Loca-1]:=43;bombas:=bombas-1;End;
      Money(Pontos);
     end;
     if(UpCase(t)='C') and (chave>=1) then
     begin
       VePorta;
       Money(Pontos);
     end;

     VeTele;


     If ActSu=1 then begin
      If t=FRENTE then begin
        If(bloco.condi[loca+1]>=30) and (bloco.condi[loca+1]<=41) then begin t:=#0; end; end;
      If t=TRAS then begin
        If(bloco.condi[loca-1]>=30) and (bloco.condi[loca-1]<=41) then begin t:=#0; end; end;
      If t=CIMA then begin
        If(bloco.condi[loca-15]>=30) and (bloco.condi[loca-15]<=41) then begin t:=#0; end; end;
      If t=BAIXO then begin
        If(bloco.condi[loca+15]>=30) and (bloco.condi[loca+15]<=41) then begin t:=#0; end; end;
     end;

     if(UpCase(t)='S') and (NuSuper>=1) then begin ActSu:=1; Super:=55;NuSuper:=NuSuper-1;Money(pontos);end;

     if t='6' then lado:=0;
     if t='4' then lado:=4;

     if (t=FRENTE) or (t=TRAS) or (t=CIMA) or (t=BAIXO) then
     begin
      SALO:=LOCA;
      while (Bloco.Condi[Loca]>=26) and (Bloco.Condi[Loca]<=29) do begin
       Bloco.Condi[Salo]:=12;
       If Bloco.Condi[Loca]=26 then
       Begin Loca:=Loca+1; Bloco.Condi[Loca]:=3; PoeTela; Bloco.Condi[Loca-1]:=26; RDelay(2); PoeTela; End;
       If Bloco.Condi[Loca]=27 then
       Begin Loca:=Loca-1; Bloco.Condi[Loca]:=7; PoeTela; Bloco.Condi[Loca+1]:=27; RDelay(2); PoeTela; End;
       If Bloco.Condi[Loca]=28 then
       Begin Loca:=Loca-15; Bloco.Condi[Loca]:=3; PoeTela; Bloco.Condi[Loca+15]:=28; RDelay(2); PoeTela; End;
       If Bloco.Condi[Loca]=27 then
       Begin Loca:=Loca+15; Bloco.Condi[Loca]:=3; PoeTela; Bloco.Condi[Loca-15]:=29; RDelay(2); PoeTela; End;
      end;
      
     end;
     if t=FRENTE then
     Begin
      Bloco.Condi[Loca]:=12; Lado:=0;
      If (Loca=15+Colu) or (Loca=30+Colu) or (Loca=45+Colu) or (Loca=60+Colu) or (Loca=75+Colu)
      or (Loca=90+Colu) or (Loca=105+Colu) or (Loca=120+Colu) or (Loca=135+Colu) then Loca:=Loca-1;
      Loca:=Loca+1;
      If(Bloco.Condi[Loca]=9) or (Bloco.Condi[Loca]=42) then Loca:=Loca-1;
      If Bloco.Condi[Loca]=14 then Loca:=Loca-1;
      If Bloco.Condi[Loca]=25 then
       Begin
        Bloco.Condi[Loca]:=4+Lado; PoeTela;
        StageClear; FazFase:=1; Exit;
       End;
      If (Bloco.Condi[Loca]>=23) and (Bloco.Condi[Loca]<=24) then Loca:=Loca-1;
      If Bloco.Condi[Loca]=15 then Begin Pontos:=Pontos+10; Money(Pontos); End;
      if (bloco.condi[loca]=18) or (bloco.condi[loca]>=43) and (bloco.condi[loca]<=46) then Begin Bloco.Condi[Loca]:=12;
      Loca:=Loca-1; PlayInit('gg*');Bombas:=Bombas+1;
      Pontos:=Pontos+100; Money(Pontos); End;
      If Bloco.Condi[Loca]=22 then Begin Bloco.Condi[Loca]:=23;Loca:=Loca-1; PlayInit('f*');swi:=swi+1;
      Pontos:=Pontos+200; Money(Pontos); End;
      If Bloco.Condi[Loca]=13 then Begin Bloco.Condi[Loca]:=12;Loca:=Loca-1; PlayInit('f*');chave:=chave+1;
      Pontos:=Pontos+200; Money(Pontos); End;
      If Bloco.Condi[Loca]=17 then Begin Bloco.Condi[Loca]:=12;Loca:=Loca-1; PlayInit('f*');vidas:=vidas+1;
      Pontos:=Pontos+500; Money(Pontos); End;
      If (Bloco.Condi[Loca]=10) then
      Begin Bloco.Condi[Loca]:=3+Lado; PoeTela; PlayInit('h*');Vidas:=Vidas-1;Money(Pontos);
      bloco.condi[Loca]:=10;Money(Pontos); Loca:=LoSta; End;
      If (Bloco.Condi[Loca]=11) then
      Begin Bloco.Condi[Loca]:=3+Lado; PoeTela; PlayInit('f*');Vidas:=Vidas-1;Money(Pontos);
      bloco.condi[Loca]:=11;Money(Pontos); Loca:=LoSta; End;
      If Bloco.Condi[Loca]=16 then Begin Pontos:=Pontos+100; Money(Pontos); End;

      If Bloco.Condi[Loca]=21 then Begin Pontos:=Pontos+200; NuSuper:=NuSuper+1;
        PlayInit('d*');  Money(Pontos); End;

      If Bloco.Condi[Loca]=26 then Loca:=Loca+1;
      If Bloco.Condi[Loca]=27 then Loca:=Loca-1;
      If Bloco.Condi[Loca]=28 then Loca:=Loca-15;
      If Bloco.Condi[Loca]=29 then Loca:=Loca+15;
    end;
     if t=TRAS then
     Begin
      Bloco.Condi[Loca]:=12; Lado:=4;
      If (Loca=1+Colu) or (Loca=16+Colu) or (Loca=31+Colu) or (Loca=46+Colu) or (Loca=61+Colu)
      or (Loca=76+Colu) or (Loca=91+Colu) or (Loca=106+Colu) or (Loca=121+Colu) then Loca:=Loca+1;
      Loca:=Loca-1;
      If(Bloco.Condi[Loca]=9) or (Bloco.Condi[Loca]=42) then Loca:=Loca+1;
      If Bloco.Condi[Loca]=14 then Loca:=Loca+1;
      If Bloco.Condi[Loca]=25 then
       Begin
        Bloco.Condi[Loca]:=4+Lado; PoeTela;
        StageClear; FazFase:=1; Exit;
       End;
      If (Bloco.Condi[Loca]>=23) and (Bloco.Condi[Loca]<=24) then Loca:=Loca+1;
      If Bloco.Condi[Loca]=15 then Begin Pontos:=Pontos+10; Money(Pontos); End;
      if (bloco.condi[loca]=18) or (bloco.condi[loca]>=43) and (bloco.condi[loca]<=46) then Begin Bloco.Condi[Loca]:=12;
      Loca:=Loca+1;  PlayInit('f*');Bombas:=Bombas+1;
      Pontos:=Pontos+100; Money(Pontos); End;
      If Bloco.Condi[Loca]=22 then Begin Bloco.Condi[Loca]:=23;Loca:=Loca+1;  PlayInit('f*');swi:=swi+1;
      Pontos:=Pontos+200; Money(Pontos); End;
      If Bloco.Condi[Loca]=13 then Begin Bloco.Condi[Loca]:=12;Loca:=Loca+1;  PlayInit('f*');chave:=chave+1;
      Pontos:=Pontos+200; Money(Pontos); End;
      If Bloco.Condi[Loca]=17 then Begin Bloco.Condi[Loca]:=12;Loca:=Loca+1; PlayInit('f*');vidas:=vidas+1;
      Pontos:=Pontos+500; Money(Pontos); End;

      If (Bloco.Condi[Loca]=10) then
      Begin Bloco.Condi[Loca]:=3+Lado; PoeTela; PlayInit('ff*');Vidas:=Vidas-1;Money(Pontos);
      bloco.condi[Loca]:=10;Money(Pontos); Loca:=LoSta;End;
      If (Bloco.Condi[Loca]=11) then
      Begin Bloco.Condi[Loca]:=3+Lado; PoeTela; PlayInit('ff*');Vidas:=Vidas-1;Money(Pontos);
      bloco.condi[Loca]:=11;Money(Pontos); Loca:=LoSta;End;

      If Bloco.Condi[Loca]=16 then Begin Pontos:=Pontos+100; Money(Pontos); End;
      If Bloco.Condi[Loca]=21 then Begin Pontos:=Pontos+200; NuSuper:=NuSuper+1;
        PlayInit('dd*'); Money(Pontos); End;
      If Bloco.Condi[Loca]=26 then Loca:=Loca+1;
      If Bloco.Condi[Loca]=27 then Loca:=Loca-1;
      If Bloco.Condi[Loca]=28 then Loca:=Loca-15;
      If Bloco.Condi[Loca]=29 then Loca:=Loca+15;
    end;
     if t=BAIXO then
     Begin
      Bloco.Condi[Loca]:=12;
      If Loca>=120 then Loca:=Loca-15;
      Loca:=Loca+15;
      If(Bloco.Condi[Loca]=9) or (Bloco.Condi[Loca]=42) then Loca:=Loca-15;
      If Bloco.Condi[Loca]=14 then Loca:=Loca-15;
      If Bloco.Condi[Loca]=25 then
       Begin
        Bloco.Condi[Loca]:=4+Lado; PoeTela;
        StageClear; FazFase:=1; Exit;
       End;
      If (Bloco.Condi[Loca]>=23) and (Bloco.Condi[Loca]<=24) then Loca:=Loca-15;
      If Bloco.Condi[Loca]=15 then Begin Pontos:=Pontos+10; Money(Pontos); End;
      if (bloco.condi[loca]=18) or (bloco.condi[loca]>=43) and (bloco.condi[loca]<=46) then Begin Bloco.Condi[Loca]:=12;
      Loca:=Loca-15;  PlayInit('f*');Bombas:=Bombas+1;
      Pontos:=Pontos+100; Money(Pontos); End;
      If Bloco.Condi[Loca]=22 then Begin Bloco.Condi[Loca]:=23;Loca:=Loca-15; PlayInit('f*');swi:=swi+1;
      Pontos:=Pontos+200; Money(Pontos); End;
      If Bloco.Condi[Loca]=13 then Begin Bloco.Condi[Loca]:=12;Loca:=Loca-15;  PlayInit('f*');chave:=chave+1;
      Pontos:=Pontos+200; Money(Pontos); End;
      If Bloco.Condi[Loca]=17 then Begin Bloco.Condi[Loca]:=12;Loca:=Loca-15;  PlayInit('f*');vidas:=vidas+1;
      Pontos:=Pontos+500; Money(Pontos); End;

      If (Bloco.Condi[Loca]=10) then
      Begin Bloco.Condi[Loca]:=3+Lado; PoeTela; PlayInit('jj*');Vidas:=Vidas-1;Money(Pontos);
      bloco.condi[Loca]:=10;Money(Pontos); Loca:=LoSta;End;
      If (Bloco.Condi[Loca]=11) then
      Begin Bloco.Condi[Loca]:=3+Lado; PoeTela; PlayInit('jj*');Vidas:=Vidas-1;Money(Pontos);
      bloco.condi[Loca]:=11;Money(Pontos); Loca:=LoSta;End;

      If Bloco.Condi[Loca]=16 then Begin Pontos:=Pontos+100; Money(Pontos); End;
      If Bloco.Condi[Loca]=21 then Begin Pontos:=Pontos+200; NuSuper:=NuSuper+1;
        PlayInit('hh*'); Money(Pontos); End;
      If Bloco.Condi[Loca]=26 then Loca:=Loca+1;
      If Bloco.Condi[Loca]=27 then Loca:=Loca-1;
      If Bloco.Condi[Loca]=28 then Loca:=Loca-15;
      If Bloco.Condi[Loca]=29 then Loca:=Loca+15;
     End;
     if t=CIMA then
     Begin
      Bloco.Condi[Loca]:=12;
      If Loca<=15 then Loca:=Loca+15;
      Loca:=Loca-15;
      If(Bloco.Condi[Loca]=9) or (Bloco.Condi[Loca]=42) then Loca:=Loca+15;
      If Bloco.Condi[Loca]=14 then Loca:=Loca+15;
      If Bloco.Condi[Loca]=25 then
       Begin
        Bloco.Condi[Loca]:=4+Lado; PoeTela;
        StageClear; FazFase:=1; Exit;
       End;
      If (Bloco.Condi[Loca]>=23) and (Bloco.Condi[Loca]<=24) then Loca:=Loca+15;
      If Bloco.Condi[Loca]=15 then Begin Pontos:=Pontos+10; Money(Pontos); End;
      if (bloco.condi[loca]=18) or (bloco.condi[loca]>=43) and (bloco.condi[loca]<=46)
       then Begin Bloco.Condi[Loca]:=12;Loca:=Loca+15; PlayInit('f*'); Bombas:=Bombas+1;
      Pontos:=Pontos+100; Money(Pontos); End;
      If Bloco.Condi[Loca]=22 then Begin Bloco.Condi[Loca]:=23;Loca:=Loca+15;  PlayInit('f*');swi:=swi+1;
      Pontos:=Pontos+200; Money(Pontos); End;
      If Bloco.Condi[Loca]=13 then Begin Bloco.Condi[Loca]:=12;Loca:=Loca+15;  PlayInit('f*');chave:=chave+1;
      Pontos:=Pontos+200; Money(Pontos); End;
      If Bloco.Condi[Loca]=17 then Begin Bloco.Condi[Loca]:=12;Loca:=Loca+15;  PlayInit('f*');vidas:=vidas+1;
      Pontos:=Pontos+500; Money(Pontos); End;

      If (Bloco.Condi[Loca]=10) then
      Begin Bloco.Condi[Loca]:=3+Lado; PoeTela; PlayInit('gg*');Vidas:=Vidas-1;Money(Pontos);
      bloco.condi[Loca]:=10;Money(Pontos); Loca:=LoSta;End;
      If (Bloco.Condi[Loca]=11) then
      Begin Bloco.Condi[Loca]:=3+Lado; PoeTela; PlayInit('gg*');Vidas:=Vidas-1;Money(Pontos);
      bloco.condi[Loca]:=11;Money(Pontos); Loca:=LoSta;End;

      If Bloco.Condi[Loca]=16 then Begin Pontos:=Pontos+100; Money(Pontos); End;
      If Bloco.Condi[Loca]=21 then Begin Pontos:=Pontos+200; NuSuper:=NuSuper+1;
        PlayInit('ff*');  Money(Pontos); End;
      If Bloco.Condi[Loca]=26 then Loca:=Loca+1;
      If Bloco.Condi[Loca]=27 then Loca:=Loca-1;
      If Bloco.Condi[Loca]=28 then Loca:=Loca-15;
      If Bloco.Condi[Loca]=29 then Loca:=Loca+15;
     End;

      while (Bloco.Condi[Loca]>=26) and (Bloco.Condi[Loca]<=29) do begin
       If Bloco.Condi[Loca]=26 then
       Begin Loca:=Loca+1; Bloco.Condi[Loca]:=3; PoeTela; Bloco.Condi[Loca-1]:=26; RDelay(2); PoeTela; End;
       If Bloco.Condi[Loca]=27 then
       Begin Loca:=Loca-1; Bloco.Condi[Loca]:=7; PoeTela; Bloco.Condi[Loca+1]:=27; RDelay(2); PoeTela; End;
       If Bloco.Condi[Loca]=28 then
       Begin Loca:=Loca-15; Bloco.Condi[Loca]:=3; PoeTela; Bloco.Condi[Loca+15]:=28; RDelay(2); PoeTela; End;
       If Bloco.Condi[Loca]=27 then
       Begin Loca:=Loca+15; Bloco.Condi[Loca]:=3; PoeTela; Bloco.Condi[Loca-15]:=29; RDelay(2); PoeTela; End;
      end;


     If Bloco.Condi[Loca-1]=19 then  begin
      Movi:=3; Bloco.Condi[Loca]:=Movi+Lado; PoeTela;
      PlayInit('aaa*');Pause; Bloco.Condi[Loca]:=12;Loca:=LoSta;PoeTela;
      Vidas:=Vidas-1;Money(Pontos);
     end;
     If Bloco.Condi[Loca+1]=19 then  begin
      Movi:=3; Bloco.Condi[Loca]:=Movi+Lado; PoeTela;
      PlayInit('aaa*'); Pause; Bloco.Condi[Loca]:=12;Loca:=LoSta;PoeTela;
      Vidas:=Vidas-1;Money(Pontos);
     end;
     If Bloco.Condi[Loca-15]=19 then  begin
      Movi:=3; Bloco.Condi[Loca]:=Movi+Lado; PoeTela;
      PlayInit('aaa*'); Pause; Bloco.Condi[Loca]:=12;Loca:=LoSta;PoeTela;
      Vidas:=Vidas-1;Money(Pontos);
     end;
     If Bloco.Condi[Loca+15]=19 then  begin
      Movi:=3; Bloco.Condi[Loca]:=Movi+Lado; PoeTela;
      PlayInit('aaa*'); Pause; Bloco.Condi[Loca]:=12;Loca:=LoSta;PoeTela;
      Vidas:=Vidas-1;Money(Pontos);
     end;

     If ActSu=0 then begin

     If (Bloco.Condi[Loca]>=30) and (Bloco.Condi[Loca]<=41) then
     begin
      antigo := Bloco.Condi[Loca];
      Movi:=3; Bloco.Condi[Loca]:=Movi+Lado; PoeTela;PlayInit('aaa*');
      Pause;
      Bloco.Condi[Loca]:=antigo; PoeTela;
      Bloco.Condi[Loca]:=antigo;Loca:=LoSta;PoeTela;
      Vidas:=Vidas-1;Money(Pontos);
     End;
    end;

      If vidas=0 then begin FazFase:=100;Exit;End;

    end;
   End;



  { Rotina Principal  ****************************  }


  procedure CGADriverProc; external;
  {$L CGA.OBJ}
  procedure SmallFontProc; external;
  {$L LITT.OBJ}
  procedure TriplexFontProc; external;
  {$L TRIP.OBJ}

  var
   code : Integer;
   S : PathStr;
   autode : Text;
   spade : string;

  Begin

   code:=RegisterBGIDriver(@CGADriverProc);
   code:=RegisterBGIFont(@SmallFontProc);
   code:=RegisterBGIFont(@TriplexFontProc);

   Graphics(CGA,1,'');

   showdgmlogo('DGMLOGO.DAT',0,0,0);

   ClearDevice;
   SetColor(WHITE);

   { Carregando os Graficos *******************************  }

    Assign(f,'BOMB.DAT'); Reset(f,1);
    For RGra:=1 to 46 do begin
     GetMem(Gra[RGra],132); BlockRead(f,Gra[RGra]^,132);
    end; Close(f);

   { Rotina da Apresenta‡ƒo *******************************  }

     Apresenta(atra);

   { Inicializando Variaveis *****************************  }

    Fase:=1; Loca:=1; Movi:=1; Bombas:=0; Chave:=0; Vidas:=5; PFase:=1;
    ColocaTipo:=CopyPut; Colu:=1; Pontos:=0; Lado:=1;  NuSuper:=0; ColocaVet:=1;

    Randomize;

   { Rotina FazFase **************************************  }
    SetTextStyle(SmallFont,HorizDir,4);

    {  17  Esc      }
    {  1   Passo    }
    {  100 Vidas 0  }

    Play;
    PlayInit('*');
    k_lim:=0;



   PFase:=1;

   while PFase<50 do begin
    ClearDevice;
    settextstyle(DEFAULTFONT,HORIZDIR,2);
    OutTextXY(20,70,'Fase '+str2(PFase));
    Pause; ClearDevice;

    Passo:=FazFase('mapa1.map',PFase);

    if (passo=1) and (PFase=20) then Final;
    if passo=1  then PFase:=PFase+1;
    if passo=17 then vesequit;
    if Passo=100 then Continue;
   end;

    For RGra:=1 to 46 do begin
     FreeMem(Gra[RGra],132);
    end;
    CloseGraph;


  End.