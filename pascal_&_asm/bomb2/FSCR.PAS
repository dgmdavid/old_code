{
   Bomb v2.0

   Arquivo do Inicio - FSCR.PAS

   Copyright (c) 1999 David Maziero / DGM Inform tica

   Data : 30 de Dezembro de 1999
}

  Unit FSCR;

  interface

  Function FirstScreen : Byte;

  implementation

  Uses Crt,Dos,DMode13H,Divrf,DGMPCX,DGMFONT,TECLADO,BOMB2V;

  Function FirstScreen : Byte;
  var
   f : File;
   r : Word;
   by,y,x,op : Word;
   w,w2 : Word;
   sec : Byte;
   a,b,c,d,bd : word;
   t2 : Char;
   label 1,2,3,4,5;
  Begin
   cls(vga,0); cls(vaddr,0);

  1:;
    DisplayPCXSize('BOMB2.DAT', 77256,25480,vaddr2,TRUE);
    SaveOPal;
    BlackOut;
    DGMOutTextShadow( 4,192,'COPYRIGHT (C) 1999 DAVID MAZIERO / DGM INFORM''ATICA',1,vaddr2,1,0, 1, 2, 0 );
    flip(vaddr2,vga);
    FadeUp(63,2,0);
    RDelay(600);

    flip(vaddr2,vaddr);
    DGMOutTextShadow( 125,105,'NOVO JOGO',1,vaddr,1,0, 1,2, 0 );
    DGMOutTextShadow( 125,115,'CONTINUAR',1,vaddr,1,0, 1,2, 0 );
    DGMOutTextShadow( 125,125,'CR''EDITOS',1,vaddr,1,0, 1,2, 0 );
    DGMOutTextShadow( 125,135,'INSTRUC,{OES',1,vaddr,1,0, 1,2, 0 );
    DGMOutTextShadow( 125,145,'SAIR',1,vaddr,1,0, 1,2, 0 );

    flip(vaddr,vga);
    flip(vaddr,vaddr2);

    t:=#0; y:=105; op:=1;
    x:=110; w:=1; w2:=0; by:=0;
    sec:=0; bd:=0;
    GetTime(a,b,c,d);

    repeat

     flipxy(90,100,35,51,vaddr2,vaddr);

     DGMOutTextShadow( x,y,'->',1,vaddr,1,0, 1,2, 0 );

 {    waitretrace; }
     RDelay(35);
     flipxy(90,100,35,51,vaddr,vga);

     if w=1 then begin
      x:=x-1;
      if x<=105 then begin x:=104; w:=2; end;
     end;
     if w=2 then begin
      x:=x+1;
      if x>=110 then begin x:=110; w:=1; end;
     end;

     if w2=1 then begin
      by:=by+1;
      y:=y+1;
      if by=10 then w2:=0;
     end;
     if w2=2 then begin
      by:=by+1;
      y:=y-1;
      if by=10 then w2:=0;
     end;

{     if not keypressed then t:=#0; }

    if keypressed then sec:=0;

    if w2=0 then begin
     if(t=CIMA)  and (op>1) then begin by:=0; op:=op-1; w2:=2; end;
     if(t=BAIXO) and (op<5) then begin by:=0; op:=op+1; w2:=1; end;
     if(t=TRAS)  and (op>1) then begin by:=0; op:=op-1; w2:=2; end;
     if(t=FRENTE) and (op<5) then begin by:=0; op:=op+1; w2:=1; end;
    end;

    bd:=c;
    GetTime(a,b,c,d);
    if c<>bd then sec:=sec+1;
    if sec>=14 then begin
     sec:=0;
     FadeDown(63,1,0);
     goto 2;
    end;

    until t=#13;

    FadeDown(63,2,0);

    if op=3 then goto 4;
    if op=4 then goto 5;

    FirstScreen:=op;
    Exit;

 2:; { Inicio da apresenta‡Æo }

    cls(vga,0); cls(vaddr,0);

    t:=#0;

 { Q1.PCX }
    DisplayPCXSize('BOMB2.DAT', 102736,45024,vaddr2,TRUE);
    SaveOPal; BlackOut; flip(vaddr2,vga);
    FadeUp(63,2,0);
    RDelay(1000);
    DGMOutTextShadow( 10,175,'BOMB ESTUDAVA NA FACULDADE DA BOMBL^ANDIA,',1,vga,1,0, 230-2,-2, 0 );
    DGMOutTextShadow( 10,185,'COM SEU MELHOR AMIGO, JACK TNT...',1,vga,1,0, 230-2,-2, 0 );

   LimpaTeclado;
   r:=0;
   while (r<100) and (t2<>#13) do begin
    if keypressed then t2:=ReadKey;
    r:=r+1;
    Rdelay(45);
   end;

{    RDelay(4500); }

    FadeDown(63,2,0); cls(vga,0);
    if t2=#13 then goto 3;

 { Q2.PCX }
    DisplayPCXSize('BOMB2.DAT', 147760,36447,vaddr2,TRUE);
    SaveOPal; BlackOut; flip(vaddr2,vga);
    FadeUp(63,2,0);
    RDelay(1000);
    DGMOutTextShadow( 10,165,'CERTO DIA, NA AULA DE QU''IMICA, UMA PEQUENA BOMBA',1,vga,1,0, 238-2,-2, 0 );
    DGMOutTextShadow( 10,175,'FEITA POR BOMB EXPLODIU ACIDENTALMENTE CONTRA O ',1,vga,1,0, 238-2,-2, 0 );
    DGMOutTextShadow( 10,185,'ROSTO DE SEU AMIGO JACK TNT...',1,vga,1,0, 238-2,-2, 0 );
{    if t<>#0 then goto 3;
    RDelay(9000);  }
   LimpaTeclado;
   r:=0;
   while (r<100) and (t2<>#13) do begin
    if keypressed then t2:=ReadKey;
    r:=r+1;
    Rdelay(90);
   end;

    FadeDown(63,2,0); cls(vga,0);
    if t2=#13 then goto 3;

 { Q3.PCX }
    DisplayPCXSize('BOMB2.DAT', 184207,41121,vaddr2,TRUE);
    SaveOPal; BlackOut; flip(vaddr2,vga);
    FadeUp(63,2,0);
    RDelay(1000);
    DGMOutTextShadow( 08,155,'MAS, NA MENTE DE JACK TNT, AQUILO N{AO FOI UM ',1,vga,1,0, 232-2,-2, 0 );
    DGMOutTextShadow( 08,165,'ACIDENTE. JACK DAVA EM CIMA DA NAMORADA DE SEU',1,vga,1,0, 232-2,-2, 0 );
    DGMOutTextShadow( 08,175,'AMIGO BOMB, ENT{AO PENSOU QUE AQUILO HAVIA SIDO',1,vga,1,0, 232-2,-2, 0 );
    DGMOutTextShadow( 08,185,'UM AVISO DE BOMB, JACK PERDEU UM OLHO NO ACIDENTE...',1,vga,1,0, 232-2,-2, 0 );
{    if t<>#0 then goto 3;
    RDelay(13500); }
   LimpaTeclado;
   r:=0;
   while (r<100) and (t2<>#13) do begin
    if keypressed then t2:=ReadKey;
    r:=r+1;
    Rdelay(135);
   end;

    FadeDown(63,2,0); cls(vga,0);
    if t2=#13 then goto 3;

 { Q4.PCX }
    DisplayPCXSize('BOMB2.DAT', 225328,49622,vaddr2,TRUE);
    SaveOPal; BlackOut; flip(vaddr2,vga);
    FadeUp(63,2,0);
    RDelay(1000);
    DGMOutTextShadow( 10,155,'JACK PASSOU MESES NO HOSPITAL, ENQUANTO BOMB ',1,vga,1,0, 227-2,-2, 0 );
    DGMOutTextShadow( 10,165,'CONCLUIA A FACULDADE. DEPOIS DE SE RECUPERAR, ',1,vga,1,0, 227-2,-2, 0 );
    DGMOutTextShadow( 10,175,'JACK, J''A COM UM OLHO MEC^ANICO, TEM EM SUA  ',1,vga,1,0, 227-2,-2, 0 );
    DGMOutTextShadow( 10,185,'MENTE APENAS UMA COISA : VINGANC,A... ',1,vga,1,0, 227-2,-2, 0 );
{    if t<>#0 then goto 3;
    RDelay(13000); }
   LimpaTeclado;
   r:=0;
   while (r<100) and (t2<>#13) do begin
    if keypressed then t2:=ReadKey;
    r:=r+1;
    Rdelay(130);
   end;

    FadeDown(63,2,0); cls(vga,0);
    if t2=#13 then goto 3;

 { Q5.PCX }
    DisplayPCXSize('BOMB2.DAT', 274950,24389,vaddr2,TRUE);
    SaveOPal; BlackOut; flip(vaddr2,vga);
    FadeUp(63,2,0);
    RDelay(1000);
    DGMOutTextShadow( 10,175,'ENT{AO JACK DECIDE SE VINGAR : ',1,vga,1,0, 227-2,-2, 0 );
    DGMOutTextShadow( 10,185,'ELE RAPTA A NAMORADA DE BOMB... ',1,vga,1,0, 227-2,-2, 0 );
{    if t<>#0 then goto 3;
    RDelay(4500); }
   LimpaTeclado;
   r:=0;
   while (r<100) and (t2<>#13) do begin
    if keypressed then t2:=ReadKey;
    r:=r+1;
    Rdelay(45);
   end;

    FadeDown(63,2,0); cls(vga,0);
    if t2=#13 then goto 3;

 { Q6.PCX }
    DisplayPCXSize('BOMB2.DAT', 299339,25213,vaddr2,TRUE);
    SaveOPal; BlackOut; flip(vaddr2,vga);
    FadeUp(63,2,0);
    RDelay(1000);
    DGMOutTextShadow( 10,175,'E AGORA BOMB TER''A QUE ENFRENTAR MUITOS',1,vga,1,0, 227-2,-2, 0 );
    DGMOutTextShadow( 10,185,'DESAFIOS PARA RESGATAR SUA NAMORADA! ',1,vga,1,0, 227-2,-2, 0 );
{    if t<>#0 then goto 3;
    RDelay(5000); }
   LimpaTeclado;
   r:=0;
   while (r<100) and (t2<>#13) do begin
    if keypressed then t2:=ReadKey;
    r:=r+1;
    Rdelay(50);
   end;
    FadeDown(63,3,0); cls(vga,0);

3:;
   cls(vga,0); cls(vaddr,0);
   for r:=0 to 255 do SetPal( r, pal[r,1],pal[r,2],pal[r,3] );
   RDelay(400);

   for r:=20 downto 1 do begin

    DGMOutText ( 45,80, 'DGM INFORM''ATICA APRESENTA :',1,vaddr,r,0,22 );
    DGMOutTextShadow( 45,95,'          BOMB 2             ',1,vaddr,r,0,0,22,0 );

    RDelay(30);
    flip(vaddr,vga);
    cls(vaddr,0);
   end;

   LimpaTeclado;
   r:=0;
   while (r<100) and (t<>#13) do begin
    if keypressed then t:=ReadKey;
    r:=r+1;
    Rdelay(40);
   end;

    fadedown(63,4,0);
    cls(vga,0);

    goto 1;

    FadeDown(63,2,0); cls(vga,0);
    goto 1;


 4:; { Cr‚ditos }

   cls(vga,0); cls(vaddr,0);
   for r:=0 to 255 do SetPal( r, pal[r,1],pal[r,2],pal[r,3] );
   RDelay(400);

   for r:=20 downto 1 do begin

    DGMOutText ( 10,10,'BOMB vers{ao 2.0 :',1,vaddr,r,0,22 );

    DGMOutText ( 15,30,'CRIAC,{AO E PROGRAMAC,{AO',1,vaddr,r,0,22 );
    DGMOutText ( 20,40,'DAVID GUSTAVO MAZIERO',1,vaddr,r,0,0 );

    DGMOutText ( 15,60,'IMAGEMS E GR''AFICOS',1,vaddr,r,0,22 );
    DGMOutText ( 20,70,'POR DAVID G. MAZIERO',1,vaddr,r,0,0 );
    DGMOutText ( 25,80,'COM : ADOBE PHOTOSHOP E DGM DRAW v7.0',1,vaddr,r,0,0 );

    DGMOutText ( 15,100,'"TEST PLAYERS"',1,vaddr,r,0,22 );
    DGMOutText ( 20,110,'LUCAS F. MAZIERO',1,vaddr,r,0,0 );
    DGMOutText ( 20,120,'''EZIO R. GRANGEL',1,vaddr,r,0,0 );
    DGMOutText ( 20,130,'FLAVIO A. MAZIEIRO',1,vaddr,r,0,0 );
    DGMOutText ( 20,140,'MAICON PIRES',1,vaddr,r,0,0 );

    DGMOutText ( 10,160,'COPYRIGHT (C) 1999 DAVID MAZIERO / DGM INFORM''ATICA',1,vaddr,r,0,22 );

    RDelay(25);
    flip(vaddr,vga);
    cls(vaddr,0);

   end;

   pause;

   for r:=1 to 20 do begin

    DGMOutText ( 10,10,'BOMB vers{ao 2.0 :',1,vaddr,r,0,22 );

    DGMOutText ( 15,30,'CRIAC,{AO E PROGRAMAC,{AO',1,vaddr,r,0,22 );
    DGMOutText ( 20,40,'DAVID GUSTAVO MAZIERO',1,vaddr,r,0,0 );

    DGMOutText ( 15,60,'IMAGEMS E GR''AFICOS',1,vaddr,r,0,22 );
    DGMOutText ( 20,70,'POR DAVID G. MAZIERO',1,vaddr,r,0,0 );
    DGMOutText ( 25,80,'COM : ADOBE PHOTOSHOP E DGM DRAW v7.0',1,vaddr,r,0,0 );

    DGMOutText ( 15,100,'"TEST PLAYERS"',1,vaddr,r,0,22 );
    DGMOutText ( 20,110,'LUCAS F. MAZIERO',1,vaddr,r,0,0 );
    DGMOutText ( 20,120,'''EZIO R. GRANGEL',1,vaddr,r,0,0 );
    DGMOutText ( 20,130,'FLAVIO A. MAZIEIRO',1,vaddr,r,0,0 );
    DGMOutText ( 20,140,'MAICON PIRES',1,vaddr,r,0,0 );


    DGMOutText ( 10,160,'COPYRIGHT (C) 1999 DAVID MAZIERO / DGM INFORM''ATICA',1,vaddr,r,0,22 );

    RDelay(25);
    flip(vaddr,vga);
    cls(vaddr,0);
    FadeDown(4,0,0);
   end;
    FadeDown(63,0,0);
   cls(vga,0);

   goto 1;

 5:; { Instru‡äes }

   cls(vga,0); cls(vaddr,0);
   for r:=0 to 255 do SetPal( r, pal[r,1],pal[r,2],pal[r,3] );
   RDelay(400); saveopal;

   for r:=20 downto 1 do begin

    DGMOutText ( 10,10,'BOMB vers{ao 2.0 :',1,vaddr,r,0,22 );

    DGMOutText ( 15,20,'INSTRUC,{OES GERAIS DO JOGO',1,vaddr,r,0,22 );
    DGMOutText ( 15,25,'-------------------------',1,vaddr,r,0,22 );

    DGMOutText ( 15,40 ,'A MOVIMENTAC,{AO DE BOMB ''E FEITA ATRAVES DAS SETAS.',1,vaddr,r,0,0 );
    DGMOutText ( 15,50 ,'PARA VIRA-LO PARA OUTRA DIREC,{AO, TECLE (4) OU (6).',1,vaddr,r,0,0 );
    DGMOutText ( 15,60 ,'PARA SOLTAR AS BOMBAS NORMAIS TECLE <ESPAC,O>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,70 ,'P/ SOLTAR AS BOMBAS DINAMITE TECLE <D>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,80 ,'P/ SOLTAR AS BOMBAS TORPEDO TECLE <S>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,90 ,'P/ SOLTAR AS BOMBAS AT^OMICAS TECLE <A>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,100,'P/ ABRIR AS PORTAS COM A CHAVE TECLE <C>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,110,'P/ ATIVAR O ITEM DE INVENCIBILIDADE TECLE <X>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,120,'P/ ACESSAR O COMPUTADOR UTILIZE A TECLA <!>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,130,'P/ ACESSAR AS CONFIGURAC,{OES DE VELOCIDADE DO',1,vaddr,r,0,0 );
    DGMOutText ( 15,140,'JOGO, PRESSIONE <E>.',1,vaddr,r,0,0 );

    DGMOutText ( 15,155,'BOMB ''E COMPOSTO DE 45 FASES, SENDO 9 DE CADA ',1,vaddr,r,0,0 );
    DGMOutText ( 15,165,'CENARIO E UM CHEFE DE FASE PARA CADA CEN''ARIO,',1,vaddr,r,0,0 );
    DGMOutText ( 15,175,'NO TOTAL DE 5 CHEFES E O CHEFE FINAL, JACK TNT,',1,vaddr,r,0,0 );
    DGMOutText ( 15,185,'NUMA ASSIRRADA DISPUTA MANO-A-MANO.',1,vaddr,r,0,0 );

    DGMOutText ( 265,193,'PR''OX...',1,vaddr,r,0,0 );


    RDelay(25);
    flip(vaddr,vga);
    cls(vaddr,0);

   end;

   pause;

   for r:=1 to 20 do begin

    DGMOutText ( 10,10,'BOMB vers{ao 2.0 :',1,vaddr,r,0,22 );

    DGMOutText ( 15,20,'INSTRUC,{OES GERAIS DO JOGO',1,vaddr,r,0,22 );
    DGMOutText ( 15,25,'-------------------------',1,vaddr,r,0,22 );
    DGMOutText ( 15,40 ,'A MOVIMENTAC,{AO DE BOMB ''E FEITA ATRAVES DAS SETAS.',1,vaddr,r,0,0 );
    DGMOutText ( 15,50 ,'PARA VIRA-LO PARA OUTRA DIREC,{AO, TECLE (4) OU (6).',1,vaddr,r,0,0 );
    DGMOutText ( 15,60 ,'PARA SOLTAR AS BOMBAS NORMAIS TECLE <ESPAC,O>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,70 ,'P/ SOLTAR AS BOMBAS DINAMITE TECLE <D>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,80 ,'P/ SOLTAR AS BOMBAS TORPEDO TECLE <S>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,90 ,'P/ SOLTAR AS BOMBAS AT^OMICAS TECLE <A>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,100,'P/ ABRIR AS PORTAS COM A CHAVE TECLE <C>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,110,'P/ ATIVAR O ITEM DE INVENCIBILIDADE TECLE <X>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,120,'P/ ACESSAR O COMPUTADOR UTILIZE A TECLA <!>.',1,vaddr,r,0,0 );
    DGMOutText ( 15,130,'P/ ACESSAR AS CONFIGURAC,{OES DE VELOCIDADE DO',1,vaddr,r,0,0 );
    DGMOutText ( 15,140,'JOGO, PRESSIONE <E>.',1,vaddr,r,0,0 );

    DGMOutText ( 15,155,'BOMB ''E COMPOSTO DE 45 FASES, SENDO 9 DE CADA ',1,vaddr,r,0,0 );
    DGMOutText ( 15,165,'CENARIO E UM CHEFE DE FASE PARA CADA CEN''ARIO,',1,vaddr,r,0,0 );
    DGMOutText ( 15,175,'NO TOTAL DE 5 CHEFES E O CHEFE FINAL, JACK TNT,',1,vaddr,r,0,0 );
    DGMOutText ( 15,185,'NUMA ASSIRRADA DISPUTA MANO-A-MANO.',1,vaddr,r,0,0 );

    DGMOutText ( 265,193,'PR''OX...',1,vaddr,r,0,0 );

    RDelay(25);
    flip(vaddr,vga);
    cls(vaddr,0);
    FadeDown(4,0,0);
   end;
    FadeDown(63,0,0);
    cls(vga,0); cls(vaddr,0);

    FadeUp(63,0,0);

   for r:=20 downto 1 do begin

    DGMOutText ( 10,10,'BOMB vers{ao 2.0 :',1,vaddr,r,0,22 );

    DGMOutText ( 15,20,'INSTRUC,{OES GERAIS DO JOGO',1,vaddr,r,0,22 );
    DGMOutText ( 15,25,'-------------------------',1,vaddr,r,0,22 );

    DGMOutText ( 15,40 ,'O OBJETIVO DO JOGO ''E SIMPLES : VOC^E TER''A QUE',1,vaddr,r,0,0 );
    DGMOutText ( 15,50 ,'DESTRUIR OS ENCAPSULAMENTOS DE VIDRO DOS "SWITS" ',1,vaddr,r,0,0 );
    DGMOutText ( 15,60 ,'COM UMA BOMBA, E DEPOIS ACIONA-LOS, COM OUTRA',1,vaddr,r,0,0 );
    DGMOutText ( 15,70 ,'BOMBA. FEITO ISSO EM TODOS OS "SWITS" DA FASE, O',1,vaddr,r,0,0 );
    DGMOutText ( 15,80 ,'"EXIT" IR''A SE ABRIR, PERMITINDO COM QUE VOC^E',1,vaddr,r,0,0 );
    DGMOutText ( 15,90 ,'PASSE PARA A PR''OXIMA FASE.',1,vaddr,r,0,0 );
    DGMOutText ( 15,110 ,'BOA DIVERS{AO!!!',1,vaddr,r,0,0 );


    RDelay(25);
    flip(vaddr,vga);
    cls(vaddr,0);

   end;

   pause;

   for r:=1 to 20 do begin

    DGMOutText ( 10,10,'BOMB vers{ao 2.0 :',1,vaddr,r,0,22 );

    DGMOutText ( 15,20,'INSTRUC,{OES GERAIS DO JOGO',1,vaddr,r,0,22 );
    DGMOutText ( 15,25,'-------------------------',1,vaddr,r,0,22 );

    DGMOutText ( 15,40 ,'O OBJETIVO DO JOGO ''E SIMPLES : VOC^E TER''A QUE',1,vaddr,r,0,0 );
    DGMOutText ( 15,50 ,'DESTRUIR OS ENCAPSULAMENTOS DE VIDRO DOS "SWITS" ',1,vaddr,r,0,0 );
    DGMOutText ( 15,60 ,'COM UMA BOMBA, E DEPOIS ACIONA-LOS, COM OUTRA',1,vaddr,r,0,0 );
    DGMOutText ( 15,70 ,'BOMBA. FEITO ISSO EM TODOS OS "SWITS" DA FASE, O',1,vaddr,r,0,0 );
    DGMOutText ( 15,80 ,'"EXIT" IR''A SE ABRIR, PERMITINDO COM QUE VOC^E',1,vaddr,r,0,0 );
    DGMOutText ( 15,90 ,'PASSE PARA A PR''OXIMA FASE.',1,vaddr,r,0,0 );
    DGMOutText ( 15,110 ,'BOA DIVERS{AO!!!',1,vaddr,r,0,0 );

    RDelay(25);
    flip(vaddr,vga);
    cls(vaddr,0);
    FadeDown(4,0,0);
   end;
    FadeDown(63,0,0);
    cls(vga,0); cls(vaddr,0);

   goto 1;


  End;

  End.
