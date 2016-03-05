{$X+}
{
   Bomb v2.0 - Variaveis

   Copyright (c) 1999 David Maziero / DGM Inform†tica

   Data : 1 de Janeiro de 2000
}

  Unit BOMB2V;

  interface

  type
    Bomb2MapType = record
     tipo : Byte;  { O Tipo da fase :
                      1 - Floresta     2 - Terra      3 - Gelo
                      4 - Espacial     5 - Castelo                }
     arq : array[1..17,1..10] of Byte;   { Qual Arquivo ? Bmov,Basico etc }
     gra : array[1..17,1..10] of Byte;   { O Gr†fico dele }
     hori : array[1..17,1..10] of Byte;  { A orientaá∆o do gr†fico }
    end;

    Bomb2MapType3 = record
     arq : array[1..17,1..10] of Byte;   { Qual Arquivo ? Bmov,Basico etc }
     gra : array[1..17,1..10] of Byte;   { O Gr†fico dele }
     hori : array[1..17,1..10] of Byte;  { A orientaá∆o do gr†fico }
    end;


    FaseBomb = file of Bomb2MapType;

    Bomb2CompMapType = record
     p : array[1..17,1..10] of Byte; { 0 - Se o lugar Ç pisavel }
                                     { 1 - Se o lugar n∆o Ç pisavel }

     d : array[1..17,1..10] of Byte; { 0 - N∆o destrutivel }
                                     { 1 - Destrutivel }
                                     { 2 - 2 Hits      }
    end;

    Bomb2SaveFile = record
     nome  : String[15];
     vidas : Integer; { As vidas }
     ups   : Byte; { Os Ups   }
     atomic: Byte; { N£mero de bombas Atomic }
     bombs : Byte; {   "    de bombas super  }
     dina  : Byte; {   "    de bombas dinamite }
     super : Byte; {   "    de super }
     disco : Byte; { Disquetes }
     chave : Byte; { Chaves }
     level : Byte; { A fase  }
     world : Byte; { O mundo }
     cash  : LongInt; { Pontos ( ou Dinheiro ) }
     bonus : Byte;
    end;

    Bomb2SF = file of Bomb2SaveFile;

    MonsterType = record
     x,y : Byte;   { Posiá∆o Real no Tabuleiro }
     ex,ey : Word; { Posiá∆o Virtual na Tela   }
     gra : Byte;   { O Grafico }
     hori: Byte;   { A horientaá∆o }
     tipo: Byte;   { O Inimigo  por ex. o 3 Ç o verdinho }
     especial : Byte; { 0 se pode ser atacado }
     acao : Byte;
     acao2: Byte;
     acao3: Byte;
     tmp : Word;  { para o bicho 7 }
     vidas : Integer;
    end;


    BombPosi = record
     x,y : Byte; { Posiá∆o Real }
     ex,ey : Word; { Posiá∆o Virtual }
     gra : Byte;   { O Grafico }
     hori: Byte;   { A horientaá∆o }
     inv : Byte;   { Junto ao sup }
     sup : Byte;   { Ou no super ou morreu }
    end;

    BombNormType = record
     x,y : Byte; { Posiá∆o Real }
     gra : Byte; { O Grafico }
     tmp : Byte; { Tempo de Espera }
     tipo: Byte; { O Tipo da Bomba }
     vez : Byte; { Vezes ( s¢ atomic ) }
     esp : Byte; { 1 se o monstro for do tipo 20 ou 21 }
    end;

    TeleTransType = record
     x,y : array[1..6] of word; { Posiá∆o no mapa }
     tot : Byte; { total de teletransportes }
     stop: Byte; { em qual parou }
    end;

  var
   TELE : TELETRANSTYPE;
   NBOMB : array[1..6] of BombNormType;
   mbomb : Bomb2MapType3;
   bomb : BombPosi;
   enemi: array[1..20] of MonsterType;
   Espaco : Integer;
   Imgs : array[1..7,1..90] of Pointer;
   fase : Bomb2MapType;
   comp : Bomb2CompMapType;
   cont : Byte;
   pal : array[0..255,1..3] of Byte; { V†riavel de pallete DGM }
   anco : array[1..6] of Byte; { Variaveis de controle das animaá‰es }
                               { 1 e 2 - Buraco e Amassador              }
   especial : Byte;
   swits : Byte;
   espinho : Byte;
   para2,para3,para4 : Byte; { * }
   speed : Word;
   defmov : array[1..10] of Byte;
   deff   : Byte;
   passboss : Byte;
   passbonus : Byte;

   procedure PutBack;  { Coloca o fundo da fase }
   procedure PutFront; { Coloca os items da frente }
   procedure Anima; { Efetua a animaá∆o dos gr†ficos na fase }
   procedure CarregaImgs; { Carrega para a mem¢ria os gr†ficos do jogo }
   procedure LoadImg(var f : File; var img : Pointer );
   procedure InitUnitLevel;
   procedure ApresLevel( var sav : Bomb2SaveFile );
   procedure PutPlacar1( sav2 : Bomb2SaveFile );
   function DoFase( var sav : Bomb2SaveFile ) : Byte;
   procedure LevelAnalisys( var sav : Bomb2SaveFile);
   procedure TiraBombVida( var sav : Bomb2SaveFile );

   implementation

  Uses Crt,Dos,Dmode13h,DGMFONT,Divrf,Teclado;

{$F+}


{ Controle de movimentaá∆o de monstros }
  procedure MovEnemi( var sav : bomb2savefile );
  var
   r : Word;
   w : Word;
   work : word;
  label 1,2,3,4,5;
  begin

   for r:=1 to 20 do begin

    if enemi[r].tipo<>0 then begin

    { Auto-destruiá∆o do inimigo 7 }
{      if enemi[r].tipo=7 then enemi[r].tmp:=enemi[r].tmp+1;
      if enemi[r].tmp>=300 then begin
       enemi[r].acao:=10; enemi[r].acao2:=0; enemi[r].acao3:=0;
      end; }

     if(enemi[r].acao=0) and (deff=1) then begin
      case enemi[r].gra of
       1 : enemi[r].gra:=2;
       2 : enemi[r].gra:=1;
       10 : enemi[r].gra:=11;
       11 : enemi[r].gra:=10;
       19 : enemi[r].gra:=20;
       20 : enemi[r].gra:=19;
       28 : enemi[r].gra:=29;
       29 : enemi[r].gra:=28;
       37 : enemi[r].gra:=38;
       38 : enemi[r].gra:=37;
       46 : enemi[r].gra:=47;
       47 : enemi[r].gra:=46;
       55 : enemi[r].gra:=56;
       56 : enemi[r].gra:=55;
       61 : enemi[r].gra:=62;
       62 : enemi[r].gra:=61;
       70 : enemi[r].gra:=71;
       71 : enemi[r].gra:=70;
       79 : enemi[r].gra:=80;
       80 : enemi[r].gra:=79;
      end;
     end;

     { Atacando }
     if enemi[r].acao=10 then begin
      if enemi[r].tipo<>7 then begin
       enemi[r].acao2:=enemi[r].acao2+1;
       if(enemi[r].acao2>=1) and (enemi[r].acao2<=2) then enemi[r].gra:=defmov[enemi[r].tipo]+8;
       if(enemi[r].acao2>=3) and (enemi[r].acao2<=4) then enemi[r].gra:=defmov[enemi[r].tipo]+9;
       if enemi[r].acao2=4 then begin
        enemi[r].acao2:=1;
        enemi[r].acao3:=enemi[r].acao3+1;
       end;
       if enemi[r].acao3>=5 then begin
        enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].acao3:=0;
       end;
      end; { tipo <>7 }

      if enemi[r].tipo=7 then begin
        enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].acao3:=0;
        enemi[r].gra:=0; enemi[r].tipo:=0;
        for work:=1 to 6 do begin
         if(NBomb[work].gra<>0) and (enemi[r].x=NBomb[work].x) and
           (enemi[r].y=NBomb[work].y) then goto 1;
         end;
        for work:=1 to 6 do begin
         if NBOMB[work].gra=0 then begin
          NBomb[work].x:=enemi[r].x;
          NBomb[work].y:=enemi[r].y;
          NBomb[work].gra:=7;
          NBomb[work].tmp:=39;
          NBOmb[work].tipo:=1;
          NBomb[work].vez:=0; goto 1;
         end;
        end; { for }
        1:;
        enemi[r].x:=0; enemi[r].y:=0;
        goto 2;
      end; { tipo = 7 }

     end;

     { Morrendo }
     if enemi[r].acao=15 then begin
      if enemi[r].tipo<>7 then begin
       enemi[r].acao2:=enemi[r].acao2+1;
       if(enemi[r].acao2>=1) and (enemi[r].acao2<=4)  then enemi[r].gra:=defmov[enemi[r].tipo]+5;
        if(enemi[r].acao2>=5) and (enemi[r].acao2<=8)  then enemi[r].gra:=defmov[enemi[r].tipo]+6;
        if(enemi[r].acao2>=9) and (enemi[r].acao2<=12) then enemi[r].gra:=defmov[enemi[r].tipo]+7;
        if enemi[r].acao2=12 then begin
        enemi[r].acao2:=5;
        enemi[r].acao3:=enemi[r].acao3+1;
       end;
       if enemi[r].acao3>=4 then begin
        enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].acao3:=0;
        enemi[r].x:=0; enemi[r].y:=0; enemi[r].gra:=0; enemi[r].tipo:=0;
        sav.cash:=sav.cash+200;
       end;
      end;
      if enemi[r].tipo=7 then begin
        enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].acao3:=0;
        enemi[r].gra:=0; enemi[r].tipo:=0;
        for work:=1 to 6 do begin
         if(NBomb[work].gra<>0) and (enemi[r].x=NBomb[work].x) and
           (enemi[r].y=NBomb[work].y) then goto 3;
         end;
        for work:=1 to 6 do begin
         if NBOMB[work].gra=0 then begin
          NBomb[work].x:=enemi[r].x;
          NBomb[work].y:=enemi[r].y;
          NBomb[work].gra:=7;
          NBomb[work].tmp:=39;
          NBOmb[work].tipo:=1;
          NBomb[work].vez:=0; goto 3;
         end;
        end; { for }
        3:;
        enemi[r].x:=0; enemi[r].y:=0;
        goto 2;
      end; { tipo = 7 }

    end;

     { Andando }
     if enemi[r].acao=1 then begin
      enemi[r].acao2:=enemi[r].acao2+1;
      enemi[r].ex:=enemi[r].ex+6;
      if enemi[r].acao2=1 then enemi[r].gra:=defmov[enemi[r].tipo]+3;
      if enemi[r].acao2=2 then enemi[r].gra:=defmov[enemi[r].tipo]+4;
      if enemi[r].acao2=3 then enemi[r].gra:=defmov[enemi[r].tipo]+3;
      if enemi[r].acao2=3 then begin
       enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].gra:=defmov[enemi[r].tipo]+1;
       enemi[r].ey:=0+((enemi[r].y-1)*18);
       enemi[r].ex:=5+((enemi[r].x-1)*18);
      end;
      if enemi[r].acao2=1 then begin
       enemi[r].x:=enemi[r].x+1;
      end;
    end; { acao=1 }

    if enemi[r].acao=2 then begin
      enemi[r].acao2:=enemi[r].acao2+1;
      enemi[r].ex:=enemi[r].ex-6;
      if enemi[r].acao2=1 then enemi[r].gra:=defmov[enemi[r].tipo]+3;
      if enemi[r].acao2=2 then enemi[r].gra:=defmov[enemi[r].tipo]+4;
      if enemi[r].acao2=3 then enemi[r].gra:=defmov[enemi[r].tipo]+3;
      if enemi[r].acao2=3 then begin
       enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].gra:=defmov[enemi[r].tipo]+1; enemi[r].x:=enemi[r].x-1;
       enemi[r].ey:=0+((enemi[r].y-1)*18);
       enemi[r].ex:=5+((enemi[r].x-1)*18);
      end;
    end; { acao=2 }

     if enemi[r].acao=3 then begin
      enemi[r].acao2:=enemi[r].acao2+1;
      enemi[r].ey:=enemi[r].ey+6;
      if enemi[r].acao2=1 then enemi[r].gra:=defmov[enemi[r].tipo]+3;
      if enemi[r].acao2=2 then enemi[r].gra:=defmov[enemi[r].tipo]+4;
      if enemi[r].acao2=3 then enemi[r].gra:=defmov[enemi[r].tipo]+3;
      if enemi[r].acao2=3 then begin
       enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].gra:=defmov[enemi[r].tipo]+1;
       enemi[r].ey:=0+((enemi[r].y-1)*18);
       enemi[r].ex:=5+((enemi[r].x-1)*18);
      end;
      if enemi[r].acao2=1 then begin
       enemi[r].y:=enemi[r].y+1;
      end;
    end; { acao=3 }

    if enemi[r].acao=4 then begin
      enemi[r].acao2:=enemi[r].acao2+1;
      enemi[r].ey:=enemi[r].ey-6;
      if enemi[r].acao2=1 then enemi[r].gra:=defmov[enemi[r].tipo]+3;
      if enemi[r].acao2=2 then enemi[r].gra:=defmov[enemi[r].tipo]+4;
      if enemi[r].acao2=3 then enemi[r].gra:=defmov[enemi[r].tipo]+3;
      if enemi[r].acao2=3 then begin
       enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].gra:=defmov[enemi[r].tipo]+1; enemi[r].y:=enemi[r].y-1;
       enemi[r].ey:=0+((enemi[r].y-1)*18);
       enemi[r].ex:=5+((enemi[r].x-1)*18);
      end;
    end; { acao=4 }


    if(enemi[r].acao=0) and (enemi[r].especial=0) then begin
     w:=random(20);
     if(w=1) and (enemi[r].x<17) and (comp.p[enemi[r].x+1,enemi[r].y]<>1)
      then begin enemi[r].acao:=1; enemi[r].hori:=1; end;
     if(w=2) and (enemi[r].x>1) and (comp.p[enemi[r].x-1,enemi[r].y]<>1)
      then begin enemi[r].acao:=2; enemi[r].hori:=2; end;
     if(w=3) and (enemi[r].y<10) and (comp.p[enemi[r].x,enemi[r].y+1]<>1)
      then enemi[r].acao:=3;
     if(w=4) and (enemi[r].y>1) and (comp.p[enemi[r].x,enemi[r].y-1]<>1)
      then enemi[r].acao:=4;

     if(w=5) and (enemi[r].tipo=1) and (random(15)=1) then begin
        enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].acao3:=0;
        for work:=1 to 6 do begin
         if(NBomb[work].gra<>0) and (enemi[r].x=NBomb[work].x) and
           (enemi[r].y=NBomb[work].y) then goto 4;
         end;
        for work:=1 to 6 do begin
         if NBOMB[work].gra=0 then begin
          NBomb[work].x:=enemi[r].x;
          NBomb[work].y:=enemi[r].y;
          NBomb[work].gra:=3;
          NBomb[work].tmp:=0;
          NBOmb[work].tipo:=1;
          NBomb[work].vez:=0;
          NBomb[work].esp:=15;   goto 4;
         end;
        end; { for }

       4:;
      end;

     if (w=5) and (enemi[r].tipo=4) and (random(5)=1) then begin
      w:=random(5);
      if(w=0) and (comp.p[enemi[r].x-1,enemi[r].y]=0) and (enemi[r].x-1>=1) then begin
       fase.arq[enemi[r].x-1,enemi[r].y]:=5;
       fase.gra[enemi[r].x-1,enemi[r].y]:=28;
       comp.p[enemi[r].x-1,enemi[r].y]:=1;
       comp.d[enemi[r].x-1,enemi[r].y]:=1;
      end;
      if(w=1) and (comp.p[enemi[r].x+1,enemi[r].y]=0) and (enemi[r].x+1<=17) then begin
       fase.arq[enemi[r].x+1,enemi[r].y]:=5;
       fase.gra[enemi[r].x+1,enemi[r].y]:=28;
       comp.p[enemi[r].x+1,enemi[r].y]:=1;
       comp.d[enemi[r].x+1,enemi[r].y]:=1;
      end;
      if(w=2) and (comp.p[enemi[r].x,enemi[r].y-1]=0) and (enemi[r].y-1>=1) then begin
       fase.arq[enemi[r].x,enemi[r].y-1]:=5;
       fase.gra[enemi[r].x,enemi[r].y-1]:=28;
       comp.p[enemi[r].x,enemi[r].y-1]:=1;
       comp.d[enemi[r].x,enemi[r].y-1]:=1;
      end;
      if(w=3) and (comp.p[enemi[r].x,enemi[r].y+1]=0) and (enemi[r].y+1<=10) then begin
       fase.arq[enemi[r].x,enemi[r].y+1]:=5;
       fase.gra[enemi[r].x,enemi[r].y+1]:=28;
       comp.p[enemi[r].x,enemi[r].y+1]:=1;
       comp.d[enemi[r].x,enemi[r].y+1]:=1;
      end;
      5:;
     end;

    end;

   { Encontrando Bomb }
    if(enemi[r].acao<>15) and (enemi[r].x=bomb.x) and (enemi[r].y=bomb.y) then begin
     if enemi[r].acao<>10 then begin
      if enemi[r].tipo<>7 then begin
       enemi[r].acao:=10; enemi[r].acao2:=0; enemi[r].acao3:=0;
       if(especial=0) and (bomb.inv=0) then begin
        bomb.gra:=12;
        sav.vidas:=sav.vidas-1;
        bomb.inv:=1; bomb.sup:=44;
       end;
      end;
      if enemi[r].tipo=7 then begin
       enemi[r].acao:=10; enemi[r].acao2:=0; enemi[r].acao3:=0;
       if(especial=0) and (bomb.inv=0) then begin
        bomb.gra:=12;
       end;
      end;
     end;
    end;

    if(enemi[r].acao<>15) and (enemi[r].x-1=bomb.x) and (enemi[r].y=bomb.y) and
      (enemi[r].acao<>10) and (enemi[r].tipo=7) then begin
       enemi[r].acao:=10; enemi[r].acao2:=0; enemi[r].acao3:=0;
       if(especial=0) and (bomb.inv=0) then begin
        bomb.gra:=12;
       end;
    end;
    if(enemi[r].acao<>15) and (enemi[r].x+1=bomb.x) and (enemi[r].y=bomb.y) and
      (enemi[r].acao<>10) and (enemi[r].tipo=7) then begin
       enemi[r].acao:=10; enemi[r].acao2:=0; enemi[r].acao3:=0;
       if(especial=0) and (bomb.inv=0) then begin
        bomb.gra:=12;
       end;
    end;
    if(enemi[r].acao<>15) and (enemi[r].x=bomb.x) and (enemi[r].y+1=bomb.y) and
      (enemi[r].acao<>10) and (enemi[r].tipo=7) then begin
       enemi[r].acao:=10; enemi[r].acao2:=0; enemi[r].acao3:=0;
       if(especial=0) and (bomb.inv=0) then begin
        bomb.gra:=12;
       end;
    end;
    if(enemi[r].acao<>15) and (enemi[r].x=bomb.x) and (enemi[r].y-1=bomb.y) and
      (enemi[r].acao<>10) and (enemi[r].tipo=7) then begin
       enemi[r].acao:=10; enemi[r].acao2:=0; enemi[r].acao3:=0;
       if(especial=0) and (bomb.inv=0) then begin
        bomb.gra:=12;
       end;
    end;


   end; { tipo <>0 }


    2:;
  end; { for }

end; { procedure }



{***************************************************************************}

{ Controle de movimentaá∆o dos chefes }
  procedure MovChefe( var sav : bomb2savefile );
  var
   r : Word;
   w : Word;
   work : word;
  label 1,2,3,4,5;
  begin
     r:=1;
    if enemi[r].tipo=20 then begin

     if(enemi[r].acao<=4) and (deff=1) then begin
      enemi[r].tmp:=enemi[r].tmp+1;
      if enemi[r].tmp=1 then enemi[r].gra:=1;
      if enemi[r].tmp=2 then enemi[r].gra:=2;
      if enemi[r].tmp=3 then enemi[r].gra:=3;
      if enemi[r].tmp=4 then begin enemi[r].gra:=2; enemi[r].tmp:=0; end;
     end;

     { Levando }
     if enemi[r].acao=15 then begin
       enemi[r].acao2:=enemi[r].acao2+1;
        if(enemi[r].acao2>=1) and (enemi[r].acao2<=4)  then enemi[r].gra:=4;
        if(enemi[r].acao2>=5) and (enemi[r].acao2<=8)  then enemi[r].gra:=5;
        if enemi[r].acao2=8 then begin
         enemi[r].acao2:=1;
         enemi[r].acao3:=enemi[r].acao3+1;
        end;
       if enemi[r].acao3>=4 then begin
        enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].acao3:=0;
        enemi[r].especial:=0;
        enemi[r].vidas:=enemi[r].vidas-1;
        if enemi[r].vidas<=0 then begin
         enemi[r].acao:=50; enemi[r].acao2:=0; enemi[r].acao3:=0;
        end;
       end;
    end;

      { Morrendo }
     if enemi[r].acao=50 then begin
       timer:=0;
       enemi[r].acao2:=enemi[r].acao2+1;
        if enemi[r].ex<=220 then enemi[r].ex:=enemi[r].ex+2;
        if enemi[r].ex>=221 then enemi[r].ex:=enemi[r].ex+1;
        if(enemi[r].acao2>=1) and (enemi[r].acao2<=4)  then enemi[r].gra:=6;
        if(enemi[r].acao2>=5) and (enemi[r].acao2<=8)  then enemi[r].gra:=7;
        if enemi[r].acao2=8 then begin
         enemi[r].acao2:=1;
         enemi[r].acao3:=enemi[r].acao3+1;
        end;
       if enemi[r].ex>=319 then begin
        enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].acao3:=0;
         enemi[r].x:=0; enemi[r].y:=0; enemi[r].gra:=0; enemi[r].tipo:=0;
         sav.cash:=sav.cash+2000; passboss:=1;
        end;
     end;

     { Andando }
     if enemi[r].acao=1 then begin
      enemi[r].acao2:=enemi[r].acao2+1;
      enemi[r].ex:=enemi[r].ex+6;
      if enemi[r].acao2=3 then begin
       enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].gra:=defmov[enemi[r].tipo]+1;
       enemi[r].ey:=0+((enemi[r].y-1)*18);
       enemi[r].ex:=5+((enemi[r].x-1)*18);
      end;
      if enemi[r].acao2=1 then begin
       enemi[r].x:=enemi[r].x+1;
      end;
    end; { acao=1 }

    if enemi[r].acao=2 then begin
      enemi[r].acao2:=enemi[r].acao2+1;
      enemi[r].ex:=enemi[r].ex-6;
      if enemi[r].acao2=3 then begin
       enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].gra:=defmov[enemi[r].tipo]+1; enemi[r].x:=enemi[r].x-1;
       enemi[r].ey:=0+((enemi[r].y-1)*18);
       enemi[r].ex:=5+((enemi[r].x-1)*18);
      end;
    end; { acao=2 }

     if enemi[r].acao=3 then begin
      enemi[r].acao2:=enemi[r].acao2+1;
      enemi[r].ey:=enemi[r].ey+6;
      if enemi[r].acao2=3 then begin
       enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].gra:=defmov[enemi[r].tipo]+1;
       enemi[r].ey:=0+((enemi[r].y-1)*18);
       enemi[r].ex:=5+((enemi[r].x-1)*18);
      end;
      if enemi[r].acao2=1 then begin
       enemi[r].y:=enemi[r].y+1;
      end;
    end; { acao=3 }

    if enemi[r].acao=4 then begin
      enemi[r].acao2:=enemi[r].acao2+1;
      enemi[r].ey:=enemi[r].ey-6;
      if enemi[r].acao2=3 then begin
       enemi[r].acao:=0; enemi[r].acao2:=0; enemi[r].gra:=defmov[enemi[r].tipo]+1; enemi[r].y:=enemi[r].y-1;
       enemi[r].ey:=0+((enemi[r].y-1)*18);
       enemi[r].ex:=5+((enemi[r].x-1)*18);
      end;
    end; { acao=4 }


    if(enemi[r].acao=0) and (enemi[r].especial=0) then begin
     w:=random(10);
     if(w=1) and (enemi[r].x<16) and (comp.p[enemi[r].x+1,enemi[r].y]<>1)
      then begin enemi[r].acao:=1; enemi[r].hori:=1; end;
     if(w=2) and (enemi[r].x>1) and (comp.p[enemi[r].x-1,enemi[r].y]<>1)
      then begin enemi[r].acao:=2; enemi[r].hori:=2; end;
     if(w=3) and (enemi[r].y<9) and (comp.p[enemi[r].x,enemi[r].y+1]<>1)
      then enemi[r].acao:=3;
     if(w=4) and (enemi[r].y>1) and (comp.p[enemi[r].x,enemi[r].y-1]<>1)
      then enemi[r].acao:=4;

     if w=5 then begin
      w:=random(4)+1;
      if(w=1) and (enemi[r].x<16) and (comp.p[enemi[r].x+1,enemi[r].y]<>1)
       then begin enemi[r].acao:=1; enemi[r].hori:=1; end;
      if(w=2) and (enemi[r].x>1) and (comp.p[enemi[r].x-1,enemi[r].y]<>1)
       then begin enemi[r].acao:=2; enemi[r].hori:=2; end;
      if(w=3) and (enemi[r].y<9) and (comp.p[enemi[r].x,enemi[r].y+1]<>1)
       then enemi[r].acao:=3;
      if(w=4) and (enemi[r].y>1) and (comp.p[enemi[r].x,enemi[r].y-1]<>1)
       then enemi[r].acao:=4;

        for work:=1 to 6 do begin
         if(NBomb[work].gra<>0) and (enemi[r].x=NBomb[work].x) and
           (enemi[r].y=NBomb[work].y) then goto 4;
         end;
        for work:=1 to 6 do begin
         if NBOMB[work].gra=0 then begin
          NBomb[work].x:=enemi[r].x;
          NBomb[work].y:=enemi[r].y;
          NBomb[work].gra:=3;
          NBomb[work].tmp:=0;
          w:=random(6);
          NBOmb[work].tipo:=1;
          if(w>=0) and (w<=3) then NBOmb[work].tipo:=1;
          if w=4 then NBOmb[work].tipo:=2;
          if w=5 then NBOmb[work].tipo:=3;
          NBomb[work].vez:=0;
          NBomb[work].esp:=15;
          goto 4;
         end;
        end; { for }
       4:;
    end;
   end;

   { Encontrando Bomb }
  if enemi[r].acao<>50 then begin
    if(enemi[r].acao<>15) and (enemi[r].x=bomb.x)   and (enemi[r].y=bomb.y)   or
      (enemi[r].acao<>15) and (enemi[r].x+1=bomb.x) and (enemi[r].y=bomb.y)   or
      (enemi[r].acao<>15) and (enemi[r].x=bomb.x)   and (enemi[r].y+1=bomb.y) or
      (enemi[r].acao<>15) and (enemi[r].x+1=bomb.x) and (enemi[r].y+1=bomb.y)
     then begin
     if enemi[r].acao<>10 then begin
       if(especial=0) and (bomb.inv=0) then begin
        bomb.gra:=12;
        sav.vidas:=sav.vidas-1;
        bomb.inv:=1; bomb.sup:=44;
       end;
     end;
    end;
  end;

{    if(enemi[r].acao<>15) and (enemi[r].x-1=bomb.x) and (enemi[r].y=bomb.y) and
      (enemi[r].acao<>10) and (enemi[r].tipo=7) then begin
       enemi[r].acao:=10; enemi[r].acao2:=0; enemi[r].acao3:=0;
       if(especial=0) and (bomb.inv=0) then begin
        bomb.gra:=12;
       end;
    end;
    if(enemi[r].acao<>15) and (enemi[r].x+1=bomb.x) and (enemi[r].y=bomb.y) and
      (enemi[r].acao<>10) and (enemi[r].tipo=7) then begin
       enemi[r].acao:=10; enemi[r].acao2:=0; enemi[r].acao3:=0;
       if(especial=0) and (bomb.inv=0) then begin
        bomb.gra:=12;
       end;
    end;
    if(enemi[r].acao<>15) and (enemi[r].x=bomb.x) and (enemi[r].y+1=bomb.y) and
      (enemi[r].acao<>10) and (enemi[r].tipo=7) then begin
       enemi[r].acao:=10; enemi[r].acao2:=0; enemi[r].acao3:=0;
       if(especial=0) and (bomb.inv=0) then begin
        bomb.gra:=12;
       end;
    end;
    if(enemi[r].acao<>15) and (enemi[r].x=bomb.x) and (enemi[r].y-1=bomb.y) and
      (enemi[r].acao<>10) and (enemi[r].tipo=7) then begin
       enemi[r].acao:=10; enemi[r].acao2:=0; enemi[r].acao3:=0;
       if(especial=0) and (bomb.inv=0) then begin
        bomb.gra:=12;
       end;
    end;
}

   end; { tipo <>0 }


    2:;

end; { procedure }







   procedure TiraBombVida( var sav : Bomb2SaveFile );
   begin
    if(especial=0) and (bomb.inv=0) then begin
{     sav.vidas:=sav.vidas-1; }
{     bomb.inv:=1; bomb.sup:=44; }
     especial:=2;
     para2:=30; para3:=0; para4:=0;
    end;
   end;

  procedure InitUnitLevel;
  var
   f : file;
   x,y,r : Byte;
   a,b,c,d : Word;
   e,f2,g,h : Word;
   speeds : Integer;
  begin
   {$I-}
    Assign(f,'BOMB2.DAT'); Reset(f,1);
    Seek(f,filesize(f)-(809-41));
    BlockRead(f,pal,sizeof(pal));
    Close(f);
   {$I+}

  defmov[1] :=0;
  defmov[2] :=9;
  defmov[3] :=18;
  defmov[4] :=27;
  defmov[5] :=36;
  defmov[6] :=45;
  defmov[7] :=54;
  defmov[8] :=60;
  defmov[9] :=69;
  defmov[10]:=78;

  fase.tipo:=1;
  for y:=1 to 10 do begin
  for x:=1 to 17 do begin
   fase.arq[x,y]:=0;
   fase.gra[x,y]:=0;
   fase.hori[x,y]:=1;
   comp.p[x,y]:=0;
   comp.d[x,y]:=0;
  end;
  end;
  for x:=1 to 6 do anco[x]:=0;
  speed:=08;

  cls(vaddr,0); cls(vga,0); cls(vaddr2,0);
  GetTime(a,b,c,d);
  SetTime(0,0,0,0);
  for r:=1 to 8 do begin
   flip(vaddr2,vaddr);
   flip(vaddr,vaddr2);
   flip(vaddr2,vga);
  end;
  GetTime(e,f2,g,h);
  SetTime(a,b,c,d);
  if g<1 then begin
   speeds:=100-(h*4);
   if speeds<0 then speed:=0;
   if speeds>=0 then speed:=speeds;
  end;


 end;

function LZ(w : Word) : String;
var
  s : String;
begin
  Str(w:0,s);
  if Length(s) = 1 then
    s := '0' + s;
  LZ := s;
end;

function LZ2(w : Word) : String;
var
  s : String;
begin
  Str(w:0,s);
  if Length(s) = 1 then
    s := '00' + s;
  if Length(s) = 2 then
    s := '0' + s;
  LZ2 := s;
end;

{---- PutPlacar ------------------------------------------------------------}
procedure PutPlacar1( sav2 : Bomb2SaveFile );
var w : Word;
Begin

 if sav2.vidas>99  then sav2.vidas:=99;
 if sav2.ups>99    then sav2.ups:=99;
 if sav2.bombs>99  then sav2.bombs:=99;
 if sav2.chave>99  then sav2.chave:=99;
 if sav2.disco>99  then sav2.disco:=99;
 if sav2.dina>99   then sav2.dina:=99;
 if sav2.atomic>99 then sav2.atomic:=99;
 if sav2.super>99  then sav2.super:=99;

 Bar(0,199-18,319,199,0,vaddr);
 DGMOutText ( 45,199-5,'PTS: '+str2(sav2.cash),1,vaddr,1,0,0 );

 DGMOutText ( 155,199-5,'TEMPO : '+LZ(t_mim)+':'+LZ(t_sec),1,vaddr,1,0,0 );

 DGMOutText ( 250,199-5,'FASE: '+LZ(sav2.world)+'-'+LZ(sav2.level),1,vaddr,1,0,0 );

 PutImageNC(5,199-18, Imgs[3,16], vaddr );
 DGMOutText ( 5+19,199-10,'X'+LZ(sav2.super),1,vaddr,1,0,0 );

 PutImageNC(43,199-18-5, Imgs[3,19], vaddr );
 DGMOutText ( 43+19,199-15,'X'+LZ(sav2.ups),1,vaddr,1,0,0 );

 PutImageNC(81,199-18-5, Imgs[3,20], vaddr );
 DGMOutText ( 81+19,199-15,'X'+LZ(sav2.chave),1,vaddr,1,0,0 );

 PutImageNC(119,199-18-5, Imgs[3,21], vaddr );
 DGMOutText ( 119+19,199-15,'X'+LZ(sav2.disco),1,vaddr,1,0,0 );

 PutImageNC(157,199-18-4, Imgs[3,22], vaddr );
 DGMOutText ( 157+19,199-14,'X'+LZ(sav2.dina),1,vaddr,1,0,0 );

 PutImageNC(195,199-18-5, Imgs[3,24], vaddr );
 DGMOutText ( 195+19,199-15,'X'+LZ(sav2.bombs),1,vaddr,1,0,0 );

 PutImageNC(235,199-18-4, Imgs[3,26], vaddr );
 DGMOutText ( 235+19,199-14,'X'+LZ(sav2.atomic),1,vaddr,1,0,0 );

 PutImageNC(273,199-18-5, Imgs[3,29], vaddr );
 DGMOutText ( 273+19,199-15,'X'+LZ(sav2.vidas),1,vaddr,1,0,0 );
End;


procedure FindExit;
var
 x,y : Word;
begin
 for y:=1 to 10 do begin
 for x:=1 to 17 do begin
   if(fase.arq[x,y]=2) and (fase.gra[x,y]=10) then fase.gra[x,y]:=11;
 end;
 end;
end;



{---- CarregaImgs -----------------------------------------------------------}
procedure CarregaImgs; { Carrega para a mem¢ria os gr†ficos do jogo }
var
 f : file;
 s : PathStr;
 r : Word;
Begin

{$I-}
 { Arquivo 1 - Bmov.dat }
 Assign(f,'BOMB2.DAT'); Reset(f,1);
 for r:=1 to 24 do LoadImg(f,Imgs[1,r]);
 { Arquivo 2 - Basico.dat }
 for r:=1 to 35 do LoadImg(f,Imgs[2,r]);
 { Arquivo 3 - Items.dat }
 for r:=1 to 31 do LoadImg(f,Imgs[3,r]);
 { Arquivo 4 - Monstro.dat }
 for r:=1 to 87 do LoadImg(f,Imgs[4,r]);
 { Arquivo 5 - Cena.dat }
 for r:=1 to 55 do LoadImg(f,Imgs[5,r]);
 Seek(f,filesize(f)-13211);
 for r:=1 to 9 do LoadImg(f,Imgs[6,r]);
 Seek(f,filesize(f)-19538);
 for r:=1 to 19 do LoadImg(f,Imgs[7,r]);

 Seek(f,filesize(f)-(809-41));
 BlockRead(f,pal,sizeof(pal));
 Close(f);
{$I+}
 If IOResult<>0 then begin
  SetText;
  WriteLn;
  WriteLn(' Erro ao carregar imagems. Erro #50. ');
  WriteLn(' DGM.');
  WriteLn; WriteLn; Halt(1);
 end;

End;

{---- LoadImg ---------------------------------------------------------------}
procedure LoadImg(var f : File; var img : Pointer );
var
 size,ex,ey : Word;
Begin
 ex:=0; ey:=0;
 BlockRead(f,ex,2); BlockRead(f,ey,2);
 Seek(f,filepos(f)-4);
 size:=BitMapAlloc(ex,ey,img);
 BlockRead(f,img^,size);
end;

{---- PutBack ---------------------------------------------------------------}
procedure PutBack;  { Coloca o fundo da fase }
var
 x,y,w : Word;
Begin
 w:=1;
 for y:=1 to 10 do begin
 for x:=1 to 17 do begin
  PutImageNC( 5+(x-1)*18, 0+(y-1)*18, Imgs[5, 1+((fase.tipo-1)*11)+(w-1)] ,vaddr);
  case w of
   1 : w:=2;
   2 : w:=1;
  end;
 end;
 end;
end;

{---- PutFront --------------------------------------------------------------}
procedure PutFront; { Coloca os items da frente }
var
 ex,ey,w,r : Word;
 def : Integer;
Begin
 w:=1; def:=0;
 for ey:=1 to 10 do begin
 for ex:=1 to 17 do begin

  if fase.arq[ex,ey]<>0 then begin

   if fase.arq[ex,ey]=1 then def:=0;
   if fase.arq[ex,ey]=2 then def:=espaco;
   if fase.arq[ex,ey]=3 then def:=(espaco-2);
   if fase.arq[ex,ey]=4 then def:=0;
   if fase.arq[ex,ey]=5 then def:=espaco;

   if fase.hori[ex,ey]=1 then PutImage( 5+(ex-1)*18, def+(ey-1)*18, Imgs[fase.arq[ex,ey],fase.gra[ex,ey]] ,vaddr);
   if fase.hori[ex,ey]=2 then PutImageI( 5+(ex-1)*18, def+(ey-1)*18, Imgs[fase.arq[ex,ey],fase.gra[ex,ey]] ,vaddr);
   if fase.hori[ex,ey]=3 then PutImageI2( 5+(ex-1)*18, def+(ey-1)*18, Imgs[fase.arq[ex,ey],fase.gra[ex,ey]] ,vaddr);
   if fase.hori[ex,ey]=4 then PutImageI3( 5+(ex-1)*18, def+(ey-1)*18, Imgs[fase.arq[ex,ey],fase.gra[ex,ey]] ,vaddr);

  end;

  if MBOMB.arq[ex,ey]<>0 then begin
   PutImage( 5+(ex-1)*18, 0+(ey-1)*18, Imgs[MBOMB.arq[ex,ey],MBOMB.gra[ex,ey]] ,vaddr);
  end;

 if bomb.gra>0 then begin
 if(bomb.inv=0) or (bomb.inv=1) then begin
 if(bomb.x=ex) and (bomb.y=ey) then begin
  if bomb.hori=1 then PutImage( bomb.ex, bomb.ey, Imgs[1,bomb.gra], vaddr );
  if bomb.hori=2 then PutImageI( bomb.ex, bomb.ey, Imgs[1,bomb.gra], vaddr );
  if bomb.hori=3 then PutImageI2( bomb.ex, bomb.ey, Imgs[1,bomb.gra], vaddr );
  if bomb.hori=4 then PutImageI3( bomb.ex, bomb.ey, Imgs[1,bomb.gra], vaddr );
 end; end; end;

 for r:=1 to cont do begin
  if(enemi[r].x=ex) and (enemi[r].y=ey) then begin
   if enemi[r].tipo<>0 then begin
    if enemi[r].tipo<20 then begin
    if enemi[r].hori=1 then PutImage( enemi[r].ex, enemi[r].ey, Imgs[4,enemi[r].gra], vaddr );
    if enemi[r].hori=2 then PutImageI( enemi[r].ex, enemi[r].ey, Imgs[4,enemi[r].gra], vaddr );
    if enemi[r].hori=3 then PutImageI2( enemi[r].ex, enemi[r].ey, Imgs[4,enemi[r].gra], vaddr );
    if enemi[r].hori=4 then PutImageI3( enemi[r].ex, enemi[r].ey, Imgs[4,enemi[r].gra], vaddr );
    end;
   end;
  end;
 end;


 end;
 end;

    if enemi[1].tipo=20 then begin
    if enemi[1].hori=1 then PutImage( enemi[1].ex, enemi[1].ey, Imgs[6,enemi[1].gra], vaddr );
    if enemi[1].hori=2 then PutImageI( enemi[1].ex, enemi[1].ey, Imgs[6,enemi[1].gra], vaddr );
    if enemi[1].hori=3 then PutImageI2( enemi[1].ex, enemi[1].ey, Imgs[6,enemi[1].gra], vaddr );
    if enemi[1].hori=4 then PutImageI3( enemi[1].ex, enemi[1].ey, Imgs[6,enemi[1].gra], vaddr );
    end;

 line(4,0,4,179,0,vaddr);
 line(311,0,311,179,0,vaddr);

end;


{---- Anima ----------------------------------------------------------------}
procedure Anima; { Efetua a animaá∆o dos gr†ficos na fase }
var
 x,y,w : Word;
Begin

  if anco[1]=4 then anco[1]:=0;
  if anco[1]=3 then anco[1]:=4;
  if anco[1]=2 then anco[1]:=3;
  if anco[1]=0 then begin
   anco[2]:=anco[2]+1;
  end;
  if(anco[2]=3) and (anco[1]=0) then begin
   anco[1]:=1; anco[2]:=anco[2]-1;
  end;
  if anco[1]=1 then begin
   anco[2]:=anco[2]-1;
  end;
  if(anco[2]=0) and (anco[1]=1) then begin
   anco[1]:=2;
  end;

  espinho:=espinho+1;
  if espinho=5 then espinho:=0;

  Randomize;

 for y:=1 to 10 do begin
 for x:=1 to 17 do begin


  { mov do laser }
  if fase.arq[x,y]=2 then begin
   if fase.gra[x,y]=30 then begin
    case fase.hori[x,y] of
      1 : fase.hori[x,y]:=4;
      4 : fase.hori[x,y]:=1;
      2 : fase.hori[x,y]:=3;
      3 : fase.hori[x,y]:=2;
    end;
   end;
   if fase.gra[x,y]=31 then begin
    case fase.hori[x,y] of
      1 : fase.hori[x,y]:=2;
      2 : fase.hori[x,y]:=1;
      3 : fase.hori[x,y]:=4;
      4 : fase.hori[x,y]:=3;
    end;
   end;
   if fase.gra[x,y]=32 then begin
    case fase.hori[x,y] of
      1 : fase.hori[x,y]:=3;
      3 : fase.hori[x,y]:=1;
      2 : fase.hori[x,y]:=4;
      4 : fase.hori[x,y]:=2;
    end;
   end;
   if fase.gra[x,y]=33 then begin
    case fase.hori[x,y] of
      1 : fase.hori[x,y]:=2;
      2 : fase.hori[x,y]:=1;
      3 : fase.hori[x,y]:=4;
      4 : fase.hori[x,y]:=3;
    end;
   end;
  end;


  { movimentaá∆o do †cido }
  if fase.arq[x,y]=2 then begin

  if random(24)=1 then begin
   if(fase.gra[x,y]>=12) and (fase.gra[x,y]<=15) then begin
    fase.arq[x,y]:=2; fase.gra[x,y]:=34; fase.hori[x,y]:=1;
   end; end;
  if random(20)=1 then begin
   if(fase.gra[x,y]=34) or (fase.gra[x,y]=35) then begin
    comp.d[x,y]:=0; comp.p[x,y]:=2;
    w:=random(4);
    if w=0 then begin
     if x>1 then begin
      if fase.arq[x-1,y]=0 then begin
       fase.arq[x-1,y]:=2; fase.gra[x-1,y]:=12; fase.hori[x-1,y]:=2;
       comp.p[x-1,y]:=2; comp.d[x-1,y]:=0;
      end; end;
     end; {w=0}
    if w=1 then begin
     if x<17 then begin
      if fase.arq[x+1,y]=0 then begin
       fase.arq[x+1,y]:=2; fase.gra[x+1,y]:=12; fase.hori[x+1,y]:=1;
       comp.p[x+1,y]:=2; comp.d[x+1,y]:=0;
      end; end;
     end; {w=1}
    if w=2 then begin
     if y>1 then begin
      if fase.arq[x,y-1]=0 then begin
       fase.arq[x,y-1]:=2; fase.gra[x,y-1]:=14; fase.hori[x,y-1]:=3;
       comp.p[x,y-1]:=2; comp.d[x,y-1]:=0;
      end; end;
     end; {w=2}
    if w=3 then begin
     if y<10 then begin
      if fase.arq[x,y+1]=0 then begin
       fase.arq[x,y+1]:=2; fase.gra[x,y+1]:=14; fase.hori[x,y+1]:=1;
       comp.p[x,y+1]:=2; comp.d[x,y+1]:=0;
      end; end;
     end; {w=2}
   end; {=35}
   end;

  end;


  if fase.arq[x,y]=5 then begin
   case fase.gra[x,y] of
    7 : fase.gra[x,y]:=8;
    8 : fase.gra[x,y]:=7;
    9 : fase.gra[x,y]:=10;
    10: fase.gra[x,y]:=9;
    11+7 : fase.gra[x,y]:=11+8;
    11+8 : fase.gra[x,y]:=11+7;
    11+9 : fase.gra[x,y]:=11+10;
    11+10: fase.gra[x,y]:=11+9;
    22+7 : fase.gra[x,y]:=22+8;
    22+8 : fase.gra[x,y]:=22+7;
    22+9 : fase.gra[x,y]:=22+10;
    22+10: fase.gra[x,y]:=22+9;
    33+7 : fase.gra[x,y]:=33+8;
    33+8 : fase.gra[x,y]:=33+7;
    33+9 : fase.gra[x,y]:=33+10;
    33+10: fase.gra[x,y]:=33+9;
    44+7 : fase.gra[x,y]:=44+8;
    44+8 : fase.gra[x,y]:=44+7;
    44+9 : fase.gra[x,y]:=44+10;
    44+10: fase.gra[x,y]:=44+9;
  end;
  end;

  if fase.arq[x,y]=2 then begin
   if espinho=1 then begin
    case fase.gra[x,y] of
     22 : fase.gra[x,y]:=23;
     23 : fase.gra[x,y]:=22;
    end;
   end;
   case fase.gra[x,y] of
    12 : fase.gra[x,y]:=13;
    13 : fase.gra[x,y]:=12;
    14 : fase.gra[x,y]:=15;
    15 : fase.gra[x,y]:=14;

    24 : fase.gra[x,y]:=24+anco[2];
    25 : fase.gra[x,y]:=24+anco[2];
    26 : fase.gra[x,y]:=24+anco[2];

    27 : fase.gra[x,y]:=27+anco[2];
    28 : fase.gra[x,y]:=27+anco[2];
    29 : fase.gra[x,y]:=27+anco[2];

    34 : fase.gra[x,y]:=35;
    35 : fase.gra[x,y]:=34;
   end;
  end;

  if fase.arq[x,y]=3 then begin
   case fase.gra[x,y] of
    16 : fase.gra[x,y]:=17;
    17 : fase.gra[x,y]:=16;
    18 : fase.gra[x,y]:=19;
    19 : fase.gra[x,y]:=18;

    28 : fase.gra[x,y]:=29;
    29 : fase.gra[x,y]:=28;

    30 : fase.gra[x,y]:=31;
    31 : fase.gra[x,y]:=30;

   end;
  end;

 end;
 end;

end;

{---- LevelAnalisys --------------------------------------------------------}
procedure LevelAnalisys( var sav : Bomb2SaveFile);
var
 r,w : word;
 x,y : Word;
begin
 for y:=1 to 10 do begin
 for x:=1 to 17 do begin
  comp.p[x,y]:=0;
  comp.d[x,y]:=1;

  MBOMB.gra[x,y]:=0;
  MBOMB.arq[x,y]:=0;
  MBOMB.hori[x,y]:=1;
 end;
 end;
 for x:=1 to 6 do begin
  NBOMB[x].x:=0;
  NBOMB[x].y:=0;
  NBOMB[x].gra:=0;
  NBOMB[x].tmp:=0;
  NBOMB[x].esp:=0;

  TELE.x[x]:=0;
  TELE.y[x]:=0;
 end;
  TELE.tot:=0;
  TELE.stop:=1;

 for r:=1 to 20 do begin
  enemi[r].x:=0;    enemi[r].y:=0;     enemi[r].ex:=0;    enemi[r].ey:=0;
  enemi[r].gra:=0;  enemi[r].hori:=1;  enemi[r].tipo:=0;
  enemi[r].especial:=0;
  enemi[r].acao:=0;
  enemi[r].acao2:=0;
  enemi[r].acao3:=0;
  enemi[r].tmp:=0;
 end;
  bomb.x:=1;     bomb.y:=1;      bomb.ex:=0;     bomb.ey:=0;
  bomb.gra:=1;   bomb.hori:=1;   bomb.sup:=0;    bomb.inv:=0;

 espinho:=0;
 cont:=0; swits:=0;
 for y:=1 to 10 do begin
 for x:=1 to 17 do begin

  if(fase.arq[x,y]=2) and (fase.gra[x,y]=16) and (TELE.tot<6) then begin
   TELE.tot:=TELE.tot+1;
   TELE.x[TELE.tot]:=x;
   TELE.y[TELE.tot]:=y;
  end;

  if fase.arq[x,y]=2 then begin
   case fase.gra[x,y] of
    7 : swits:=swits+1;
   end;
  end;

  if fase.arq[x,y]=2 then begin
   case fase.gra[x,y] of
    1 : comp.p[x,y]:=1;
    2 : comp.p[x,y]:=1;
    3 : comp.p[x,y]:=1;
    4 : comp.p[x,y]:=1;
    5 : comp.p[x,y]:=1;
    7 : comp.p[x,y]:=2;
    8 : comp.p[x,y]:=2;
    9 : comp.p[x,y]:=2;
    10: comp.p[x,y]:=2;
    11: comp.p[x,y]:=2;
    12: comp.p[x,y]:=2;
    13: comp.p[x,y]:=2;
    14: comp.p[x,y]:=2;
    15: comp.p[x,y]:=2;
    16: comp.p[x,y]:=2;
    17: comp.p[x,y]:=2;
    18: comp.p[x,y]:=2;
    19: comp.p[x,y]:=2;
    20: comp.p[x,y]:=2;
    21: comp.p[x,y]:=2;
    22: comp.p[x,y]:=2;
    23: comp.p[x,y]:=2;
    24: comp.p[x,y]:=2;
    25: comp.p[x,y]:=2;
    26: comp.p[x,y]:=2;
    27: comp.p[x,y]:=2;
    28: comp.p[x,y]:=2;
    29: comp.p[x,y]:=2;
    30: comp.p[x,y]:=1;
    31: comp.p[x,y]:=1;
    32: comp.p[x,y]:=1;
    33: comp.p[x,y]:=1;
    34: comp.p[x,y]:=2;
    35: comp.p[x,y]:=2;
    12: comp.p[x,y]:=2;
    13: comp.p[x,y]:=2;
    14: comp.p[x,y]:=2;
    15: comp.p[x,y]:=2;
   end;
  end;

  if fase.arq[x,y]=5 then begin
    case fase.gra[x,y] of
     3 : comp.p[x,y]:=1;
     4 : comp.p[x,y]:=1;
     5 : comp.p[x,y]:=1;
     6 : comp.p[x,y]:=1;
     7 : comp.p[x,y]:=2;
     8 : comp.p[x,y]:=2;
     9 : comp.p[x,y]:=2;
     10: comp.p[x,y]:=2;
     11: comp.p[x,y]:=2;
     11+3 : comp.p[x,y]:=1;
     11+4 : comp.p[x,y]:=1;
     11+5 : comp.p[x,y]:=1;
     11+6 : comp.p[x,y]:=1;
     11+7 : comp.p[x,y]:=2;
     11+8 : comp.p[x,y]:=2;
     11+9 : comp.p[x,y]:=2;
     11+10: comp.p[x,y]:=2;
     11+11: comp.p[x,y]:=2;
     22+3 : comp.p[x,y]:=1;
     22+4 : comp.p[x,y]:=1;
     22+5 : comp.p[x,y]:=1;
     22+6 : comp.p[x,y]:=1;
     22+7 : comp.p[x,y]:=2;
     22+8 : comp.p[x,y]:=2;
     22+9 : comp.p[x,y]:=2;
     22+10: comp.p[x,y]:=2;
     22+11: comp.p[x,y]:=2;
     33+3 : comp.p[x,y]:=1;
     33+4 : comp.p[x,y]:=1;
     33+5 : comp.p[x,y]:=1;
     33+6 : comp.p[x,y]:=1;
     33+7 : comp.p[x,y]:=2;
     33+8 : comp.p[x,y]:=2;
     33+9 : comp.p[x,y]:=2;
     33+10: comp.p[x,y]:=2;
     33+11: comp.p[x,y]:=2;
     44+3 : comp.p[x,y]:=1;
     44+4 : comp.p[x,y]:=1;
     44+5 : comp.p[x,y]:=1;
     44+6 : comp.p[x,y]:=1;
     44+7 : comp.p[x,y]:=2;
     44+8 : comp.p[x,y]:=2;
     44+9 : comp.p[x,y]:=2;
     44+10: comp.p[x,y]:=2;
     44+11: comp.p[x,y]:=2;
    end;
  end;

  if fase.arq[x,y]=2 then begin
    case fase.gra[x,y] of
     2 : comp.d[x,y]:=2;
     4 : comp.d[x,y]:=0;
     5 : comp.d[x,y]:=0;
     7 : comp.d[x,y]:=0;
     8 : comp.d[x,y]:=0;
     9 : comp.d[x,y]:=0;
     10: comp.d[x,y]:=0;
     11: comp.d[x,y]:=0;
     12: comp.d[x,y]:=0;
     13: comp.d[x,y]:=0;
     14: comp.d[x,y]:=0;
     15: comp.d[x,y]:=0;
     16: comp.d[x,y]:=0;
     17: comp.d[x,y]:=0;
     18: comp.d[x,y]:=0;
     19: comp.d[x,y]:=0;
     20: comp.d[x,y]:=0;
     21: comp.d[x,y]:=0;
     22: comp.d[x,y]:=0;
     23: comp.d[x,y]:=0;
     24: comp.d[x,y]:=0;
     25: comp.d[x,y]:=0;
     26: comp.d[x,y]:=0;
     27: comp.d[x,y]:=0;
     28: comp.d[x,y]:=0;
     29: comp.d[x,y]:=0;
     30: comp.d[x,y]:=0;
     31: comp.d[x,y]:=0;
     32: comp.d[x,y]:=0;
     33: comp.d[x,y]:=0;
     34: comp.d[x,y]:=0;
     34: comp.d[x,y]:=0;
    end;
  end;

  if fase.arq[x,y]=5 then begin
    case fase.gra[x,y] of
     3 : comp.d[x,y]:=0;
     7 : comp.d[x,y]:=0;
     8 : comp.d[x,y]:=0;
     9 : comp.d[x,y]:=0;
     10: comp.d[x,y]:=0;
     11: comp.d[x,y]:=0;
     11+3 : comp.d[x,y]:=0;
     11+7 : comp.d[x,y]:=0;
     11+8 : comp.d[x,y]:=0;
     11+9 : comp.d[x,y]:=0;
     11+10: comp.d[x,y]:=0;
     11+11: comp.d[x,y]:=0;
     22+3 : comp.d[x,y]:=0;
     22+7 : comp.d[x,y]:=0;
     22+8 : comp.d[x,y]:=0;
     22+9 : comp.d[x,y]:=0;
     22+10: comp.d[x,y]:=0;
     22+11: comp.d[x,y]:=0;
     33+3 : comp.d[x,y]:=0;
     33+7 : comp.d[x,y]:=0;
     33+8 : comp.d[x,y]:=0;
     33+9 : comp.d[x,y]:=0;
     33+10: comp.d[x,y]:=0;
     33+11: comp.d[x,y]:=0;
     44+3 : comp.d[x,y]:=0;
     44+7 : comp.d[x,y]:=0;
     44+8 : comp.d[x,y]:=0;
     44+9 : comp.d[x,y]:=0;
     44+10: comp.d[x,y]:=0;
     44+11: comp.d[x,y]:=0;
    end;
  end;



  if fase.arq[x,y]=1 then begin
   bomb.x:=x;
   bomb.y:=y;
   bomb.ex:=5+((x-1)*18);
   bomb.ey:=0+((y-1)*18);
   fase.arq[x,y]:=0;

   if(sav.level=10) and (fase.gra[x,y]=2) then begin
    cont:=1;
    enemi[1].x:=x;
    enemi[1].y:=y;
    enemi[1].ex:=5+((x-1)*18);
    enemi[1].ey:=0+((y-1)*18);
    enemi[1].gra:=1;
    enemi[1].hori:=1;
    enemi[1].tipo:=20;
    enemi[1].especial:=0;
    enemi[1].acao :=0;
    enemi[1].acao2:=0;
    enemi[1].acao3:=0;
    enemi[1].tmp:=0;
    enemi[1].vidas:=4; { vidas do chefe de fase }
   end;

  end;

  if fase.arq[x,y]=4 then begin
   cont:=cont+1;
   enemi[cont].x:=x;
   enemi[cont].y:=y;
   enemi[cont].ex:=5+((x-1)*18);
   enemi[cont].ey:=0+((y-1)*18);
   enemi[cont].gra:=fase.gra[x,y];
   enemi[cont].hori:=fase.hori[x,y];
   if(fase.gra[x,y]>=1 ) and (fase.gra[x,y]<=9 ) then enemi[cont].tipo:=1;
   if(fase.gra[x,y]>=10) and (fase.gra[x,y]<=18) then enemi[cont].tipo:=2;
   if(fase.gra[x,y]>=19) and (fase.gra[x,y]<=27) then enemi[cont].tipo:=3;
   if(fase.gra[x,y]>=28) and (fase.gra[x,y]<=36) then enemi[cont].tipo:=4;
   if(fase.gra[x,y]>=37) and (fase.gra[x,y]<=45) then enemi[cont].tipo:=5;
   if(fase.gra[x,y]>=46) and (fase.gra[x,y]<=54) then enemi[cont].tipo:=6;
   if(fase.gra[x,y]>=55) and (fase.gra[x,y]<=60) then enemi[cont].tipo:=7;
   if(fase.gra[x,y]>=61) and (fase.gra[x,y]<=69) then enemi[cont].tipo:=8;
   if(fase.gra[x,y]>=70) and (fase.gra[x,y]<=78) then enemi[cont].tipo:=9;
   if(fase.gra[x,y]>=79) and (fase.gra[x,y]<=87) then enemi[cont].tipo:=10;
   fase.arq[x,y]:=0;
  end;

 end;
 end;

end;


{---- ApresLevel -----------------------------------------------------------}
procedure ApresLevel( var sav : Bomb2SaveFile );
var
 f : FaseBomb;
 x,y : Integer;
 r : word;
 MM,FF : Word;
begin
 cls(vga,0); cls(vaddr,0);
 MM:=sav.world;
 FF:=sav.level;

 for y:=1 to 10 do begin
 for x:=1 to 17 do begin
  fase.arq[x,y]:=0;
  fase.gra[x,y]:=0;
  fase.hori[x,y]:=1;
  comp.p[x,y]:=0;
  comp.d[x,y]:=1;
 end;
 end;

if sav.bonus=0 then begin
{$I-}
 Assign(f,'level\florest.map'); Reset(f);
 Seek(f, ((MM-1)*10)+(FF-1) );
 Read(f, fase ); Close(f);
{$I+}
 If IOResult<>0 then begin
  SetText;
  WriteLn;
  WriteLn(' Erro ao carregar fase. Erro #203 - DGM. '); WriteLn; Halt(1);
 end;

 swits:=0; espinho:=0;
 LevelAnalisys(sav);
 Anima; Anima; Anima; Anima;
 saveopal;
 blackout;
 PutBack;
 PutFront;
 timer:=1;
 Teclado_InitTimer( 0,6,0 );
 if sav.level=10 then Teclado_InitTimer( 0,9,0 );
 PutPlacar1(sav);

 flip(vaddr,vaddr2);
 flip(vaddr2,vga);
 fadeup(63,1,0);

   for r:=25 downto 3 do begin
    flip(vaddr2,vaddr);
    DGMOutTextShadow( 80,80,' FASE  : '+str2(FF),1,vaddr,r,0,0,22,0 );
    DGMOutTextShadow( 80,90,' MUNDO : '+str2(MM),1,vaddr,r,0,0,22,0 );
    if ff=10 then
     DGMOutTextShadow( 80,105,' CHEFE DE FASE',1,vaddr,r,0,0,22,0 );

    RDelay(25);
    flip(vaddr,vga);
   end;
   LimpaTeclado;
   r:=0;
   while (r<100) and (t<>#13) do begin
    if keypressed then t:=ReadKey;
    r:=r+1;
    Rdelay(20);
   end;
   for r:=3 to 20 do begin
    flip(vaddr2,vaddr);
    DGMOutTextShadow( 80+(r*13),80,' FASE  : '+str2(FF),1,vaddr,r,0,0,22,0 );
    DGMOutTextShadow( 80+(r*13),90,' MUNDO : '+str2(MM),1,vaddr,r,0,0,22,0 );
    if ff=10 then
     DGMOutTextShadow( 80+(r*13),105,' CHEFE DE FASE',1,vaddr,r,0,0,22,0 );
    RDelay(25);
    flip(vaddr,vga);
   end;

    Teclado_InitTimer( 0,6,0 );
   if sav.level=10 then Teclado_InitTimer( 0,9,0 );
    timer:=1;
    PutPlacar1(sav);
end;

if sav.bonus=1 then begin
{$I-}
 Assign(f,'BONUS.MAP'); Reset(f);
 Seek(f, (MM-1) );
 Read(f, fase ); Close(f);
{$I+}
 If IOResult<>0 then begin
  SetText;
  WriteLn;
  WriteLn(' Erro ao carregar fase. Erro #203 - DGM. '); WriteLn; Halt(1);
 end;

 swits:=0; espinho:=0;
 LevelAnalisys(sav);
 Anima; Anima; Anima; Anima;
 saveopal;
 blackout;
 PutBack;
 PutFront;
 timer:=1;
 Teclado_InitTimer( 0,1,0 );

 PutPlacar1(sav);

 flip(vaddr,vaddr2);
 flip(vaddr2,vga);
 fadeup(63,1,0);

   for r:=25 downto 3 do begin
    flip(vaddr2,vaddr);
    DGMOutTextShadow( 80,80,' FASE DE B^ONUS!!!',1,vaddr,r,0,0,22,0 );
    DGMOutTextShadow( 80,90,' MUNDO : '+str2(MM),1,vaddr,r,0,0,22,0 );

    RDelay(25);
    flip(vaddr,vga);
   end;
   LimpaTeclado;
   r:=0;
   while (r<100) and (t<>#13) do begin
    if keypressed then t:=ReadKey;
    r:=r+1;
    Rdelay(20);
   end;
   for r:=3 to 20 do begin
    flip(vaddr2,vaddr);
    DGMOutTextShadow( 80,80,' FASE DE B^ONUS!!!',1,vaddr,r,0,0,22,0 );
    DGMOutTextShadow( 80,90,' MUNDO : '+str2(MM),1,vaddr,r,0,0,22,0 );
    RDelay(25);
    flip(vaddr,vga);
   end;

    Teclado_InitTimer( 0,1,0 );
    timer:=1;
    PutPlacar1(sav);
end;

end;

{---- DoExplosion -----------------------------------------------------------}
function DoExplosion( x,y : Integer; c,est : Byte; var sav : bomb2savefile; ro : Word  ) : Byte;
var
 r : Word;
 wo,w: Byte;
 ve : Byte;
 label 1,2;
begin
 ve:=0; wo:=0; w:=0;
 if(x<1) or (x>17) or (y<1) or (y>10) then Exit;


{ gotoxy(1,1);
 directvideo:=false;
for r:=1 to 4 do
 write( NBomb[r].esp,'-',NBOmb[r].tmp,' * ');
 readln; }



 if fase.arq[x,y]<>0 then ve:=1;

{
 if(MBOMB.gra[x,y]>=7) and (MBOMB.gra[x,y]<=9) then goto 2;
}

 if comp.p[x,y]=2 then begin
   ve:=0;
  if est<4 then begin
   if c=1 then begin MBOMB.arq[x,y]:=3; MBOMB.gra[x,y]:=10+(est-1); end;
   if c=2 then begin MBOMB.arq[x,y]:=3; MBOMB.gra[x,y]:=13+(est-1); end;
  end;
  if est=4 then begin
   MBOMB.arq[x,y]:=0;
   MBOMB.gra[x,y]:=0;
  end;
 end;

{ Ve se pegou o chefe }
 if(enemi[1].tipo=20) and (est=3) and (NBomb[ro].esp=0) then begin
   if(enemi[1].x=x) and (enemi[1].y=y) and (enemi[1].acao<=4) then begin
    if(enemi[1].tipo=20) and (NBomb[ro].esp=0) and (enemi[1].acao<=4) then begin
     enemi[1].acao:=15;
     enemi[1].acao2:=0; enemi[1].acao3:=0;
     enemi[1].especial:=1;
    end;
   end;
   if(enemi[1].x+1=x) and (enemi[1].y=y) and (enemi[1].acao<=4) then begin
    if(enemi[1].tipo=20) and (NBomb[ro].esp=0) then begin
     enemi[1].acao:=15;
     enemi[1].acao2:=0; enemi[1].acao3:=0;
     enemi[1].especial:=1;
    end;
   end;
   if(enemi[1].x=x) and (enemi[1].y+1=y) and (enemi[1].acao<=4) then begin
    if(enemi[1].tipo=20) and (NBomb[ro].esp=0) then begin
     enemi[1].acao:=15;
     enemi[1].acao2:=0; enemi[1].acao3:=0;
     enemi[1].especial:=1;
    end;
   end;
   if(enemi[1].x+1=x) and (enemi[1].y+1=y) and (enemi[1].acao<=4) then begin
    if(enemi[1].tipo=20) and (NBomb[ro].esp=0) then begin
     enemi[1].acao:=15;
     enemi[1].acao2:=0; enemi[1].acao3:=0;
     enemi[1].especial:=1;
    end;
   end;
 end;

{ Pega no inimigo }

if(enemi[1].tipo<20) and (NBomb[ro].esp=0) then begin
 for r:=1 to cont do begin
  if enemi[r].tipo<>0 then begin
   if(enemi[r].x=x) and (enemi[r].y=y) and (enemi[r].acao<>15) then begin
    if enemi[r].tipo<20 then begin
     enemi[r].acao:=15;
     enemi[r].acao2:=0; enemi[r].acao3:=0;
     enemi[r].especial:=1;
    end;
   end;
  end;
end;
end;


{ Normal das bombas }
 if(est=1) and (comp.d[x,y]=1) then begin
  if c=1 then begin MBOMB.arq[x,y]:=3; MBOMB.gra[x,y]:=10; end;
  if c=2 then begin MBOMB.arq[x,y]:=3; MBOMB.gra[x,y]:=13; end;
 end;
 if(est=2) and (comp.d[x,y]=1) then begin
  if c=1 then begin MBOMB.arq[x,y]:=3; MBOMB.gra[x,y]:=11; end;
  if c=2 then begin MBOMB.arq[x,y]:=3; MBOMB.gra[x,y]:=14; end;
 end;
 if(est=3) and (comp.d[x,y]=1) then begin
  if c=1 then begin MBOMB.arq[x,y]:=3; MBOMB.gra[x,y]:=12; end;
  if c=2 then begin MBOMB.arq[x,y]:=3; MBOMB.gra[x,y]:=15; end;
 end;
 if(est=4) and (comp.d[x,y]=1) then begin
  MBomb.arq[x,y]:=0;
  MBomb.gra[x,y]:=0;
  MBomb.hori[x,y]:=1;
  fase.gra[x,y]:=0;
  fase.hori[x,y]:=1;
  comp.p[x,y]:=0;
  comp.d[x,y]:=1;
  if fase.arq[x,y]<>0 then begin
    if(fase.arq[x,y]=3) and (fase.gra[x,y]<=2) or
      (fase.arq[x,y]=3) and (fase.gra[x,y]>=16) and (fase.gra[x,y]<=31) then begin
       fase.arq[x,y]:=0; fase.gra[x,y]:=0; goto 1;
      end;
    fase.arq[x,y]:=0;

{    Randomize; }
    wo:=0;
    wo:=Random(45);
    if(wo>=1) and (wo<=6)  then begin fase.arq[x,y]:=3; fase.gra[x,y]:=1; end;
    if(wo>=7) and (wo<=10) then begin fase.arq[x,y]:=3; fase.gra[x,y]:=2; end;
    if(wo=11) or (wo=12)  then begin fase.arq[x,y]:=3; fase.gra[x,y]:=16; end;
    if wo=13 then begin               fase.arq[x,y]:=3; fase.gra[x,y]:=18; end;
    if wo=14 then begin               fase.arq[x,y]:=3; fase.gra[x,y]:=22; end;
    if wo=15 then begin               fase.arq[x,y]:=3; fase.gra[x,y]:=24; end;
    if wo=16 then begin               fase.arq[x,y]:=3; fase.gra[x,y]:=26; end;
    if(wo=17) or (wo=18)  then begin fase.arq[x,y]:=3; fase.gra[x,y]:=28; end;
    if wo=19 then begin               fase.arq[x,y]:=3; fase.gra[x,y]:=30; end;
   1:;
  end;
 end;

 2:;
 if(est=4) and (comp.d[x,y]=2) then begin
  ve:=0;
  MBomb.arq[x,y]:=0;
  MBomb.gra[x,y]:=0;
  MBomb.hori[x,y]:=1;
  comp.d[x,y]:=1;
  if fase.gra[x,y]=2 then fase.gra[x,y]:=3;
 end;
 if(est=4) and (fase.arq[x,y]=2) and (fase.gra[x,y]=8) then begin
  fase.gra[x,y]:=9;
  swits:=swits-1;
  if swits=0 then FindExit;
 end;
 if(est=4) and (fase.arq[x,y]=2) and (fase.gra[x,y]=7) then begin
  fase.gra[x,y]:=8;
 end;

 for r:=1 to 6 do begin
  if(NBomb[r].x=x) and (NBomb[r].y=y) and (NBomb[r].tmp<40) then begin
   NBomb[r].tmp:=39;  end;
 end;

 if(bomb.x=x) and (bomb.y=y) and (bomb.inv=0) then begin
  TiraBombVida(sav);
 end;

 DoExplosion:=ve;
end;


{---- AtualizaBombs --------------------------------------------------------}
procedure AtualizaBombs( var sav : Bomb2SaveFile );
var
 w,r : Word;
 ve,ve2 : Byte;
 w2 : Integer;
 label 2;
Begin

 for r:=1 to 6 do begin

  if NBomb[r].gra<>0 then begin
   Randomize;
{   MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
   MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3; }

   if NBomb[r].tipo=1 then begin

    NBomb[r].tmp:=NBomb[r].tmp+1;
    if(NBomb[r].tmp>=1) and (NBomb[r].tmp<10) then begin
     NBomb[r].gra:=3;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;
    if(NBomb[r].tmp>=10) and (NBomb[r].tmp<20) then begin
     NBomb[r].gra:=4;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;
    if(NBomb[r].tmp>=20) and (NBomb[r].tmp<30) then begin
     NBomb[r].gra:=5;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;
    if(NBomb[r].tmp>=30) and (NBomb[r].tmp<40) then begin
     NBomb[r].gra:=6;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;

    if NBomb[r].tmp=40 then begin
     NBomb[r].gra:=7;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
{     ve:=DoExplosion( NBomb[r].x, NBomb[r].y, 3,1,sav,r); }
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,1,sav,r ); ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,1,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,1,sav,r ); ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,1,sav,r );
    end;
    if NBomb[r].tmp=41 then begin
     NBomb[r].gra:=8;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,2,sav,r ); ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,2,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,2,sav,r ); ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,2,sav,r );
    end;
    if NBomb[r].tmp=42 then begin
     NBomb[r].gra:=9;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,3,sav,r ); ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,3,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,3,sav,r ); ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,3,sav,r );
    end;
    if NBomb[r].tmp=43 then begin
     NBomb[r].gra:=8;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,2,sav,r ); ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,2,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,2,sav,r ); ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,2,sav,r );
    end;
    if NBomb[r].tmp=44 then begin
     NBomb[r].gra:=7;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,1,sav,r ); ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,1,sav ,r);
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,1,sav,r ); ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,1,sav ,r);
    end;
    if NBomb[r].tmp=45 then begin
     ve:=DoExplosion( NBomb[r].x, NBomb[r].y,   2,4,sav,r );
     NBomb[r].gra:=0;
     NBomb[r].tmp:=0;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=0;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=0;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,4,sav,r ); ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,4,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,4,sav,r ); ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,4,sav,r );
     NBomb[r].esp:=0;
    end;

   end; { if tipo 1 }


   if NBomb[r].tipo=2 then begin

    NBomb[r].tmp:=NBomb[r].tmp+1;
    if(NBomb[r].tmp>=1) and (NBomb[r].tmp<10) then begin
     NBomb[r].gra:=22;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;
    if(NBomb[r].tmp>=10) and (NBomb[r].tmp<20) then begin
     NBomb[r].gra:=23;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;
    if(NBomb[r].tmp>=20) and (NBomb[r].tmp<30) then begin
     NBomb[r].gra:=22;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;
    if(NBomb[r].tmp>=30) and (NBomb[r].tmp<40) then begin
     NBomb[r].gra:=23;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;

    if NBomb[r].tmp=40 then begin
     NBomb[r].gra:=7;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,1,sav,r );
     if ve=0 then DoExplosion( NBomb[r].x-2, NBomb[r].y,   2,1,sav,r );
     ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,1,sav,r );
     if ve=0 then DoExplosion( NBomb[r].x+2, NBomb[r].y,   2,1,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+2, 1,1,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-2, 1,1,sav,r );
    end;
    if NBomb[r].tmp=41 then begin
     NBomb[r].gra:=8;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,2,sav,r );
     if ve=0 then DoExplosion( NBomb[r].x-2, NBomb[r].y,   2,2,sav,r );
     ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,2,sav,r );
     if ve=0 then DoExplosion( NBomb[r].x+2, NBomb[r].y,   2,2,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+2, 1,2,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-2, 1,2,sav,r );
    end;
    if NBomb[r].tmp=42 then begin
     NBomb[r].gra:=9;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,3,sav,r );
     if ve=0 then DoExplosion( NBomb[r].x-2, NBomb[r].y,   2,3,sav,r );
     ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,3,sav,r );
     if ve=0 then DoExplosion( NBomb[r].x+2, NBomb[r].y,   2,3,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,3,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+2, 1,3,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,3,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-2, 1,3,sav,r );
    end;
    if NBomb[r].tmp=43 then begin
     NBomb[r].gra:=8;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,2,sav,r );
     if ve=0 then DoExplosion( NBomb[r].x-2, NBomb[r].y,   2,2,sav,r );
     ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,2,sav,r );
     if ve=0 then DoExplosion( NBomb[r].x+2, NBomb[r].y,   2,2,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+2, 1,2,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-2, 1,2,sav,r );
    end;
    if NBomb[r].tmp=44 then begin
     NBomb[r].gra:=7;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,1,sav,r );
     if ve=0 then DoExplosion( NBomb[r].x-2, NBomb[r].y,   2,1,sav,r );
     ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,1,sav,r );
     if ve=0 then DoExplosion( NBomb[r].x+2, NBomb[r].y,   2,1,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+2, 1,1,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-2, 1,1,sav,r );
    end;
    if NBomb[r].tmp=45 then begin
     ve:=DoExplosion( NBomb[r].x, NBomb[r].y,   2,4,sav,r );
     NBomb[r].gra:=0;
     NBomb[r].tmp:=0;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=0;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=0;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,4,sav,r );
     if ve=0 then DoExplosion( NBomb[r].x-2, NBomb[r].y,   2,4,sav,r );
     ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,4,sav,r );
     if ve=0 then DoExplosion( NBomb[r].x+2, NBomb[r].y,   2,4,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,4,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+2, 1,4,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,4,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-2, 1,4,sav,r );
     NBomb[r].esp:=0;
    end;

   end; { if tipo 2 }


   if NBomb[r].tipo=3 then begin

    NBomb[r].tmp:=NBomb[r].tmp+1;
    if(NBomb[r].tmp>=1) and (NBomb[r].tmp<10) then begin
     NBomb[r].gra:=24;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;
    if(NBomb[r].tmp>=10) and (NBomb[r].tmp<20) then begin
     NBomb[r].gra:=25;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;
    if(NBomb[r].tmp>=20) and (NBomb[r].tmp<30) then begin
     NBomb[r].gra:=24;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;
    if(NBomb[r].tmp>=30) and (NBomb[r].tmp<40) then begin
     NBomb[r].gra:=25;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;

    if NBomb[r].tmp=40 then begin
     NBomb[r].gra:=7;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x-2, NBomb[r].y,   2,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x-3, NBomb[r].y,   2,1,sav,r );
     ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x+2, NBomb[r].y,   2,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x+3, NBomb[r].y,   2,1,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+2, 1,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+3, 1,1,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-2, 1,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-3, 1,1,sav,r );
    end;
    if NBomb[r].tmp=41 then begin
     NBomb[r].gra:=8;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x-2, NBomb[r].y,   2,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x-3, NBomb[r].y,   2,2,sav,r );
     ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x+2, NBomb[r].y,   2,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x+3, NBomb[r].y,   2,2,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+2, 1,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+3, 1,2,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-2, 1,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-3, 1,2,sav,r );
    end;
    if NBomb[r].tmp=42 then begin
     NBomb[r].gra:=9;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,3,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x-2, NBomb[r].y,   2,3,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x-3, NBomb[r].y,   2,3,sav,r );
     ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,3,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x+2, NBomb[r].y,   2,3,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x+3, NBomb[r].y,   2,3,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,3,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+2, 1,3,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+3, 1,3,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,3,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-2, 1,3,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-3, 1,3,sav,r );
    end;
    if NBomb[r].tmp=43 then begin
     NBomb[r].gra:=8;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x-2, NBomb[r].y,   2,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x-3, NBomb[r].y,   2,2,sav,r );
     ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x+2, NBomb[r].y,   2,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x+3, NBomb[r].y,   2,2,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+2, 1,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+3, 1,2,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-2, 1,2,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-3, 1,2,sav,r );
    end;
    if NBomb[r].tmp=44 then begin
     NBomb[r].gra:=7;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x-2, NBomb[r].y,   2,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x-3, NBomb[r].y,   2,1,sav,r );
     ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x+2, NBomb[r].y,   2,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x+3, NBomb[r].y,   2,1,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+2, 1,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+3, 1,1,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-2, 1,1,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-3, 1,1,sav,r );
    end;
    if NBomb[r].tmp=45 then begin
     ve:=DoExplosion( NBomb[r].x, NBomb[r].y,   2,4,sav,r );
     NBomb[r].gra:=0;
     NBomb[r].tmp:=0;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=0;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=0;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     ve:=DoExplosion( NBomb[r].x-1, NBomb[r].y,   2,4,sav,r );
     if ve=0 then ve2:=DoExplosion( NBomb[r].x-2, NBomb[r].y,   2,4,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x-3, NBomb[r].y,   2,4,sav,r );
     ve:=DoExplosion( NBomb[r].x+1, NBomb[r].y,   2,4,sav,r );
     if ve=0 then ve2:=DoExplosion( NBomb[r].x+2, NBomb[r].y,   2,4,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x+3, NBomb[r].y,   2,4,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+1, 1,4,sav,r );
     if ve=0 then ve2:=DoExplosion( NBomb[r].x,   NBomb[r].y+2, 1,4,sav,r );
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+3, 1,4,sav,r );
     ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-1, 1,4,sav,r );
     if ve=0 then ve2:=DoExplosion( NBomb[r].x,   NBomb[r].y-2, 1,4 ,sav,r);
     if ve=0 then ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-3, 1,4 ,sav,r);
     NBomb[r].esp:=0;
    end;

   end; { if tipo 3 }

   if NBomb[r].tipo=4 then begin

    NBomb[r].tmp:=NBomb[r].tmp+1;
    if(NBomb[r].tmp>=1) and (NBomb[r].tmp<10) then begin
     NBomb[r].gra:=26;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;
    if(NBomb[r].tmp>=10) and (NBomb[r].tmp<20) then begin
     NBomb[r].gra:=27;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;
    if(NBomb[r].tmp>=20) and (NBomb[r].tmp<30) then begin
     NBomb[r].gra:=26;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;
    if(NBomb[r].tmp>=30) and (NBomb[r].tmp<40) then begin
     NBomb[r].gra:=27;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
    end;

    if NBomb[r].tmp=40 then begin
     arola:=1; rolatela:=0;
     NBomb[r].gra:=7;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x-w2, NBomb[r].y,   2,1,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x+w2, NBomb[r].y,   2,1,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-w2, 1,1,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+w2, 1,1,sav,r );
    end;
    if NBomb[r].tmp=41 then begin
     NBomb[r].gra:=8;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x-w2, NBomb[r].y,   2,2,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x+w2, NBomb[r].y,   2,2,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-w2, 1,2,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+w2, 1,2,sav,r );
    end;
    if NBomb[r].tmp=42 then begin
     NBomb[r].gra:=9;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x-w2, NBomb[r].y,   2,3,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x+w2, NBomb[r].y,   2,3,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-w2, 1,3,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+w2, 1,3,sav,r );
    end;
    if NBomb[r].tmp=43 then begin
     NBomb[r].gra:=8;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x-w2, NBomb[r].y,   2,2,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x+w2, NBomb[r].y,   2,2,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-w2, 1,2,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+w2, 1,2,sav,r );
    end;
    if NBomb[r].tmp=44 then begin
     NBomb[r].gra:=7;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=3;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x-w2, NBomb[r].y,   2,1,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x+w2, NBomb[r].y,   2,1,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-w2, 1,1,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+w2, 1,1,sav,r );
    end;
    if NBomb[r].tmp=45 then begin
     ve:=DoExplosion( NBomb[r].x, NBomb[r].y,   2,4,sav,r );
     if NBomb[r].vez=0 then begin
      NBomb[r].vez:=1;
      NBomb[r].tmp:=30;
      goto 2;
     end;
     NBomb[r].gra:=0;
     NBomb[r].tmp:=0;
     MBOMB.gra[NBomb[r].x,NBomb[r].y]:=0;
     MBOMB.arq[NBomb[r].x,NBomb[r].y]:=0;
     MBOMB.hori[NBomb[r].x,NBomb[r].y]:=1;
     2:;
     if(bomb.x=NBomb[r].x) and (bomb.y=NBomb[r].y) and (bomb.inv=0) then begin
      TiraBombVida(sav);
     end;
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x-w2, NBomb[r].y,   2,4,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x+w2, NBomb[r].y,   2,4,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x,   NBomb[r].y-w2, 1,4,sav,r );
     for w2:=1 to 10 do ve:=DoExplosion( NBomb[r].x,   NBomb[r].y+w2, 1,4,sav,r );
     NBomb[r].esp:=0;
    end;

   end; { if tipo 4 }

  end; { If gra<>0 }


 end; { for }


End;

procedure DestroiPorta( x,y : Word );
begin
 fase.gra[x,y]:=0;
 fase.arq[x,y]:=0;
 comp.p[x,y]:=0;
 comp.d[x,y]:=1;
end;

procedure RegulaSpeed;
var
 back : Word;
begin
 timer:=0;
 flip(vaddr,vaddr2);
 t:=#0;
 back:=speed;
 while(t<>#13) do begin
  bar(60,60,260,140,24,vaddr);
  rectangle(60,60,260,140,57,vaddr);
  rectangle(59,59,261,141,55,vaddr);
  rectangle(61,61,259,139,22,vaddr);
   DGMOutTextShadow( 65,65,'REGULAGEM DE VELOCIDADE',1,vaddr,1,0,0,2,0 );
{   DGMOutTextShadow( 65,65,str2(MemAvail),1,vaddr,1,0,0,2,0 ); }
   DGMOutTextShadow( 104,120,'ATRASO DE '+LZ2(speed)+' MSEC',1,vaddr,1,0,0,2,0 );

   DGMOutTextShadow( 71,89,'R''APIDO',1,vaddr,1,0,0,2,0 );
   DGMOutTextShadow( 220,89,'LENTO',1,vaddr,1,0,0,2,0 );

   line(70,99,250,99,57,vaddr);
   line(70,100,250,100,57,vaddr);
   line(70,101,250,101,57,vaddr);
   bar(70+(round(speed*1.755)),95,75+(round(speed*1.755)),106,2,vaddr);

   rdelay(80);
   flip(vaddr,vga);

   if(t='+') and (speed<100) then speed:=speed+1;
   if(t='-') and (speed>0)   then speed:=speed-1;

   if(t=FRENTE) and (speed<100) then speed:=speed+1;
   if(t=TRAS  ) and (speed>0)   then speed:=speed-1;

   if(t='*') and (speed<=90) then speed:=speed+10;
   if(t='/') and (speed>=10)   then speed:=speed-10;

   if t=#27 then begin speed:=back; break; end;

 end;
 flip(vaddr2,vaddr);
 timer:=1;
 t:=#0;
end;


procedure Opcao( var sav : Bomb2SaveFile);
var
 back : Word;
 op : Word;
 opx : word;
 opy : Word;
 w,r,w2,w3 : Word;
 s : PathStr;
 sav2 : bomb2savefile;
 f : Bomb2SF;
 wait : Word;
 saida : Byte;
 t2 : char;
 label 1,2,5;
begin
 timer:=0;
 flip(vaddr,vaddr2);
1:;
 t:=#0;

 opy:=85;
 opx:=85;
 w:=1;
 op:=1;
 w2:=0; wait:=0;

 for r:=53 to 150 do begin
  bar(50,50,270,r,24,vaddr);
  rectangle(50,50,270,r,57,vaddr);
  rectangle(49,49,271,r+1,55,vaddr);
  rectangle(51,51,269,r-1,22,vaddr);
  r:=r+6;
  if r>150 then r:=150;
  rdelay(10);
  flip(vaddr,vga);
 end;

  bar(50,50,270,150,24,vaddr);
  rectangle(50,50,270,150,57,vaddr);
  rectangle(49,49,271,151,55,vaddr);
  rectangle(51,51,269,149,22,vaddr);
  DGMOutTextShadow( 55,55,'OPC,{OES GERAIS',1,vaddr,1,0,0,2,0 );
  DGMOutTextShadow( 105,85, '(S) SALVAR JOGO',1,vaddr,1,0,0,2,0 );
  DGMOutTextShadow( 105,95, '(C) CARREGAR JOGO',1,vaddr,1,0,0,2,0 );
  DGMOutTextShadow( 105,105,'(R) REINICIAR',1,vaddr,1,0,0,2,0 );
  DGMOutTextShadow( 105,115,'(X) SAIR DO JOGO',1,vaddr,1,0,0,2,0 );

  DGMOutTextShadow( 55,140,'<ENTER> CONFIRMA  <ESC> SAI DO MENU',1,vaddr,1,0,0,2,0 );

  limpateclado; t:=#0;
   Teclado_OP   :=Teclado_wait; t:=#0;

 saida:=1; wait:=0;
 while saida=1 do begin

  wait:=wait+1;
  if(t=#13) and (wait>=4) then saida:=2;

  if w=1 then begin
   opx:=opx+1;
   if opx>=95 then begin opx:=95; w:=2; end;
  end;
  if w=2 then begin
   opx:=opx-1;
   if opx<=90 then begin opx:=90; w:=1; end;
  end;

  if w2=1 then begin
   w3:=w3+1;
   opy:=opy+1;
   if w3>=10 then w2:=0;
  end;
  if w2=2 then begin
   w3:=w3+1;
   opy:=opy-1;
   if w3>=10 then w2:=0;
  end;

  if w2=0 then opy:=85+((op-1)*10);

  bar(opx-6,opy-2,opx+8,opy+7,24,vaddr);
  DGMOutTextShadow( opx-5,opy,'->',1,vaddr,1,0,0,2,0 );

   rdelay(35);
   flip(vaddr,vga);

  if w2=0 then begin
   if(t=BAIXO) and (op<4) then begin w2:=1; w3:=0; op:=op+1; end;
   if(t=CIMA ) and (op>1) then begin w2:=2; w3:=0; op:=op-1; end;
   if UpCase(t)='S' then begin
    op:=1; t:=#13;
   end;
  end;

   if t=#27 then begin break; end;

 end;

    if op=1 then goto 2;

 flip(vaddr2,vaddr);
 timer:=1;
 t:=#0;
 exit;


{ Salvando jogo ***********************************************************}
 2:;
 t:=#0;

 opy:=75;
 opx:=85;
 w:=1;
 op:=1;
 w2:=0;
 for r:=53 to 150 do begin
  bar(50,50,270,r,57,vaddr);
  rectangle(50,50,270,r,24,vaddr);
  rectangle(49,49,271,r+1,22,vaddr);
  rectangle(51,51,269,r-1,55,vaddr);
  r:=r+6;
  if r>150 then r:=150;
  rdelay(10);
  flip(vaddr,vga);
 end;

  bar(50,50,270,150,57,vaddr);
  rectangle(50,50,270,150,24,vaddr);
  rectangle(49,49,271,151,22,vaddr);
  rectangle(51,51,269,149,55,vaddr);

  DGMOutTextShadow( 55,55,'SALVAR JOGO',1,vaddr,1,0,0,2,0 );

 for r:=1 to 5 do begin
  s:=FSearch('BOMB2'+LZ2(r)+'.SAV','');
  if s='' then begin
   DGMOutTextShadow( 105,75+((r-1)*10),'SEM GRAVAC,{AO',1,vaddr,2,0,0,2,0 );
  end else begin
   Assign(f,'BOMB2'+LZ2(r)+'.SAV'); Reset(f);
   Read(f,sav2); close(f);
   DGMOutTextShadow( 105,75+((r-1)*10),sav2.nome,1,vaddr,2,0,0,2,0 );
  end;
 end;

  DGMOutTextShadow( 55,140,'<ENTER> SALVA  <ESC> VOLTA AO MENU',1,vaddr,1,0,0,2,0 );

 while(t<>#27) do begin

  if w=1 then begin
   opx:=opx+1;
   if opx>=95 then begin opx:=95; w:=2; end;
  end;
  if w=2 then begin
   opx:=opx-1;
   if opx<=90 then begin opx:=90; w:=1; end;
  end;

  if w2=1 then begin
   w3:=w3+1;
   opy:=opy+1;
   if w3>=10 then w2:=0;
  end;
  if w2=2 then begin
   w3:=w3+1;
   opy:=opy-1;
   if w3>=10 then w2:=0;
  end;

  if w2=0 then opy:=75+((op-1)*10);

  bar(opx-6,opy-2,opx+8,opy+7,57,vaddr);
  DGMOutTextShadow( opx-5,opy,'->',1,vaddr,1,0,0,2,0 );

   rdelay(35);
   flip(vaddr,vga);

  if w2=0 then begin
   if(t=BAIXO) and (op<5) then begin w2:=1; w3:=0; op:=op+1; end;
   if(t=CIMA ) and (op>1) then begin w2:=2; w3:=0; op:=op-1; end;
   if UpCase(t)='S' then begin
    op:=1; t:=#13;
   end;
  end;

  if t=#13 then begin
   bar(opx-6,opy-2,opx+8,opy+7,57,vaddr);
   DGMOutTextShadow( opx-5,opy,'**',1,vaddr,1,0,0,2,0 );
   t2:=#0; r:=1;
   limpateclado;
   while(t2<>#13) or (t2<>#27) do begin
    5:;
    bar(104,72+((op-1)*10),215,83+((op-1)*10),57,vaddr);
    DGMOutTextShadow( 105,75+((op-1)*10), sav.nome ,1,vaddr,2,0,0,2,0 );
    DGMOutTextShadow( 105+((r-1)*7),75+((op-1)*10), '_' ,1,vaddr,2,0,0,2,0 );

    flip(vaddr,vga);

    t2:=ReadKey;

    if t2=#27 then goto 2;
    if t2=#13 then begin
     if(sav.nome<>'') and (sav.nome<>'               ') and
       (sav.nome<>' ') and (sav.nome<>'  ') and (sav.nome<>'   ') and
       (sav.nome<>'    ') and (sav.nome<>'     ') and (sav.nome<>'      ') and
       (sav.nome<>'       ') and (sav.nome<>'        ') and(sav.nome<>'         ') and
       (sav.nome<>'          ') and (sav.nome<>'           ') and (sav.nome<>'            ') and
       (sav.nome<>'             ') and  (sav.nome<>'              ') then begin
      Assign(f,'BOMB2'+LZ2(op)+'.SAV'); Rewrite(f);
      Write(f,sav); close(f); goto 2;
     end else begin goto 2; end;
    end;

    if t2=#8 then begin
     if r>1 then begin
      Delete(sav.nome,r-1,1);
      r:=r-1;
     end;
     goto 5;
    end;
    if t2=#0 then begin
     t2:=ReadKey;
     if t2=#0 then t2:=ReadKey;
    end else begin
     if(t2<>#13) and (t2<>#27) then begin
      if r<=15 then begin
       Insert(Upcase(t2),sav.nome,r);
       r:=r+1;
      end;
     end;
    end;

   end;

  end;

   if t=#27 then begin break; end;

 end;
 goto 1;

end;



{---- DoFase ---------------------------------------------------------------}
{/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\}
function DoFase( var sav : Bomb2SaveFile ) : Byte;
var
 fim : Byte;
 vanima : Byte;
 banda,banda2 : Byte;
 parado : Byte;
 acorda : Byte;
 work :Byte;
 intbomb : Byte;
 r : Word;
 lasx,lasy,prox,proy : Byte;
 label 1,3;
Begin

 deff:=1;
 fim:=0;
 vanima:=1; intbomb:=0;
 banda:=0; banda2:=0; especial:=0;
 parado:=0; para2:=0; para3:=0; para4:=0; acorda:=0;
 lasx:=0; lasy:=0; prox:=0; proy:=0;
 passboss:=0;
 passbonus:=0;

 while (fim=0) do begin

 deff:=deff+1;
 if deff=3 then deff:=1;

{ Piscando : Levou bordoada }

 case bomb.inv of
  1 : bomb.inv:=2;
  2 : bomb.inv:=1;
 end;
 if bomb.inv>0 then bomb.sup:=bomb.sup-1;
 if bomb.sup<=1 then begin
  bomb.inv:=0; bomb.sup:=0;
 end;

{ Teletransporte }
 if especial=5 then begin
  especial:=6;
  para2:=50; para3:=0; para4:=0;
 end;

 if para2=50 then begin
  para3:=para3+1;
  if(para3>=1) and (para3<=4) then begin
   fase.gra[lasx,lasy]:=17;
   bomb.gra:=0;
  end;
  if(para3>=4) and (para3<=8) then begin
   fase.gra[lasx,lasy]:=16;
   fase.gra[prox,proy]:=17;
   bomb.gra:=0;
  end;
  if(para3>=8) and (para3<=12) then begin
   fase.gra[prox,proy]:=16;
   bomb.x:=prox; bomb.y:=proy; bomb.gra:=1;
   bomb.ex:=5+((bomb.x-1)*18); bomb.ey:=0+((bomb.y-1)*18);
   para2:=0; especial:=0; banda:=0; banda2:=0;
   if(comp.p[prox,proy-1]=0) and (proy-1>0) then banda:=4;
   if(comp.p[prox,proy+1]=0) and (proy+1<11) then banda:=3;
   if(comp.p[prox+1,proy]=0) and (prox+1<18) then banda:=1;
   if(comp.p[prox-1,proy]=0) and (prox-1>0) then banda:=2;
  end;
 end;


{ Comemorando a passagem de level }
 if especial=3 then begin
  timer:=0;
  bomb.inv:=0; bomb.sup:=0;
  para2:=40; para3:=0; para4:=0;
  especial:=2;
 end;

 if para2=40 then begin
  para3:=para3+1;
  if(para3>=1) and (para3<=2)  then bomb.gra:=13;
  if(para3>=3) and (para3<=4)  then bomb.gra:=14;
  if(para3>=5) and (para3<=6)  then bomb.gra:=15;
  if(para3>=7) and (para3<=8)  then bomb.gra:=14;
  if para3>=8 then begin
   para4:=para4+1; para3:=0;
  end;
  if para4=7 then begin
    PutPlacar1(sav);
    flip(vaddr,vaddr2);
    for r:=25 downto 3 do begin
     flip(vaddr2,vaddr);
     DGMOutTextShadow( 80,85,' FASE COMPLETADA!',1,vaddr,r,0,0,22,0 );
     RDelay(25);
     flip(vaddr,vga);
    end;
    LimpaTeclado;
    r:=0;
    while (r<100) and (t<>#13) do begin
     if keypressed then t:=ReadKey;
      r:=r+1;
     Rdelay(30);
    end;
    saveopal; fadedown(63,3,0);
    if passbonus=1 then begin
     DOFase:=6; Exit;
    end;
    DOFase:=5; exit;
  end;
 end;





{ Ele sendo queimando }
 if para2=30 then begin
  para3:=para3+1;
  if(para3>=1) and (para3<6 )  then bomb.gra:=16;
  if(para3>=6) and (para3<12)  then bomb.gra:=17;
  if(para3>=12) and (para3<16) then bomb.gra:=18;
  if(para3>=16) and (para3<20) then bomb.gra:=19;
  if(para3>=19) then begin
   para4:=para4+1;
   para3:=12;
   if para4>=4 then begin
    especial:=0; para2:=0; para3:=0; para4:=0;
    bomb.inv:=1; bomb.sup:=44; bomb.gra:=1; parado:=0;
    sav.vidas:=sav.vidas-1;
   if sav.vidas<0 then sav.vidas:=0;
   if sav.vidas=0 then begin
    especial:=1;
    bomb.inv:=0; bomb.sup:=0;
    if para2<>15 then begin para2:=15; para3:=0; para4:=1; end;
   end;
   end;
  end;
 end;

{ Verificaá∆o de quando ele morre }
 if sav.vidas<0 then sav.vidas:=0;
 if sav.vidas=0 then begin
  timer:=0;
  especial:=1;
  bomb.inv:=0; bomb.sup:=0;
  if para2<>15 then begin para2:=15; para3:=0; para4:=1; end;
 end;

 if para2=15 then begin
  bomb.ex:=5+((bomb.x-1)*18);
  para3:=para3+1;
  if(para3>=1) and (para3<9)    then bomb.gra:=20;
  if(para3>=9) and (para3<24)   then bomb.gra:=21;

  if(para3>=24) and (para3 mod 3 = 0 ) then bomb.ey:=bomb.ey-1;
  if(para3>=24) and (para3<28) then bomb.gra:=22;
  if(para3>=32) and (para3<36) then bomb.gra:=23;
  if(para3>=36) and (para3<40) then bomb.gra:=24;
  if(para3>=40) and (para3<44) then bomb.gra:=23;
  if para3=44 then begin
   para3:=24;
   bomb.gra:=23;
   para4:=para4+1;
   if para4<4 then para3:=24;
   if para4>=4 then para3:=48;
  end;

  if(para3>=44) and (sav.ups=0) then begin
    PutPlacar1(sav);
    flip(vaddr,vaddr2); para3:=0; para2:=0;
    for r:=25 downto 3 do begin
     if para2=0 then begin
       para3:=para3+1;
       if para3>=8 then begin para3:=10; para2:=1; end;
     end;
     if para2=1 then begin
       para3:=para3-1;
       if para3<=1 then begin para3:=0; para2:=0; end;
     end;
     flip(vaddr2,vaddr);
     DGMOutTextShadow( 90,85+(para3*2),' FIM DE JOGO ',1,vaddr,r,0,0,22,0 );
     RDelay(25);
     flip(vaddr,vga);
    end;
    LimpaTeclado;
    r:=0;
    while (r<100) and (t<>#13) do begin
     if keypressed then t:=ReadKey;
      r:=r+1;
     Rdelay(20);
    end;
   saveopal; fadedown(63,2,0); DOFase:=100; exit;
  end;

  if para3>=44 then begin saveopal; fadedown(63,2,0); DOFase:=1; exit; end;
 end;

if especial=0 then begin
{ Verificaá∆o dele parado }
  parado:=parado+1;
  if parado>105 then parado:=106;
  if(parado=105) and (para2<>10) then begin
   para2:=1;
  end;
  if para2=1 then begin
   bomb.gra:=7;
   para3:=para3+1;
   if para3=8 then begin para2:=2; para3:=0; end;
  end;
  if para2=2 then begin
   bomb.gra:=8;
   para3:=para3+1;
   if para3=8 then begin para2:=3; para3:=0; end;
  end;
  if para2=3 then begin
   if para4=0 then bomb.gra:=9;
   if para4=1 then bomb.gra:=10;
   para3:=para3+1;
   if para3=5 then begin
    para3:=0;
    case para4 of
     0 : para4:=1;
     1 : para4:=0;
    end;
   end;
  end;
end; { especial = 0 }

  vanima:=vanima+1;
  if vanima=4 then vanima:=1;

if especial=0 then begin
  if(vanima=1) and (para2=0) and (banda=0) then begin
   case bomb.gra of
    1 : bomb.gra:=3;
    2 : bomb.gra:=4;
    3 : bomb.gra:=2;
    4 : bomb.gra:=1;
   end;
   if bomb.hori=1 then begin
    case bomb.gra of
     3 : bomb.ex:=bomb.ex-1;
     2 : bomb.ex:=bomb.ex+1;
     4 : bomb.ex:=bomb.ex-1;
     1 : bomb.ex:=bomb.ex+1;
    end; end;
   if bomb.hori=2 then begin
    case bomb.gra of
     3 : bomb.ex:=bomb.ex+1;
     2 : bomb.ex:=bomb.ex-1;
     4 : bomb.ex:=bomb.ex+1;
     1 : bomb.ex:=bomb.ex-1;
    end; end;

  end;
end; { especial }

  AtualizaBombs(sav);
  PutBack;
  PutFront;
  PutPlacar1(sav);
  if vanima=1 then Anima;
 if sav.level<10 then MovEnemi(sav);
 if sav.level=10 then MovChefe(sav);
 if sav.level=10 then begin
  line(311,0,311,179,0,vaddr);
  bar(311,0,320,179,0,vaddr);
 end;

  rdelay(speed);
  flip(vaddr,vga);

  if t=#27 then fim:=1;

if especial=0 then begin

 { Controle de aá‰es e anda }
  if para2=10 then begin
   acorda:=acorda+1;
   if acorda>=4 then begin acorda:=0; bomb.gra:=1; para2:=0; end;
  end;


  if banda=1 then begin
   bomb.ex:=bomb.ex+6;
   banda2:=banda2+1;
   if banda2=1 then bomb.gra:=5;
   if banda2=2 then bomb.gra:=6;
   if banda2=3 then bomb.gra:=5;
   if banda2=3 then begin
    banda:=0; banda2:=0; bomb.gra:=1; { bomb.x:=bomb.x+1; }
    bomb.ey:=0+((bomb.y-1)*18);
    bomb.ex:=5+((bomb.x-1)*18);
   end;
   if banda2=1 then begin
    bomb.x:=bomb.x+1;
   end;

  end;

  if banda=2 then begin
   bomb.ex:=bomb.ex-6;
   banda2:=banda2+1;
   if banda2=1 then bomb.gra:=5;
   if banda2=2 then bomb.gra:=6;
   if banda2=3 then bomb.gra:=5;
   if banda2=3 then begin
    banda:=0; banda2:=0; bomb.gra:=1;  bomb.x:=bomb.x-1;
    bomb.ey:=0+((bomb.y-1)*18);
    bomb.ex:=5+((bomb.x-1)*18);
   end;
  end;

  if banda=3 then begin
   bomb.ey:=bomb.ey+6;
   banda2:=banda2+1;
   if banda2=1 then bomb.gra:=5;
   if banda2=2 then bomb.gra:=6;
   if banda2=3 then bomb.gra:=5;
   if banda2=3 then begin
    banda:=0; banda2:=0; bomb.gra:=1; { bomb.y:=bomb.y+1; }
    bomb.ey:=0+((bomb.y-1)*18);
    bomb.ex:=5+((bomb.x-1)*18);
   end;
   if banda2=1 then bomb.y:=bomb.y+1;
  end;

  if banda=4 then begin
   bomb.ey:=bomb.ey-6;
   banda2:=banda2+1;
   if banda2=1 then bomb.gra:=5;
   if banda2=2 then bomb.gra:=6;
   if banda2=3 then bomb.gra:=5;
   if banda2=3 then begin
    banda:=0; banda2:=0; bomb.gra:=1;  bomb.y:=bomb.y-1;
    bomb.ey:=0+((bomb.y-1)*18);
    bomb.ex:=5+((bomb.x-1)*18);
   end;
  end;


 { Ve se est† em cima das setas }
if banda=0 then begin
 if(fase.arq[bomb.x,bomb.y]=2) and (fase.gra[bomb.x,bomb.y]=18) then begin
  if(fase.hori[bomb.x,bomb.y]=1) or (fase.hori[bomb.x,bomb.y]=4) then begin
   if comp.p[bomb.x+1,bomb.y]<>1 then begin
    bomb.ex:=5+((bomb.x-1)*18); bomb.ey:=0+((bomb.y-1)*18);
    banda2:=0; banda:=1; bomb.hori:=1;
   end;
  end;
  if(fase.hori[bomb.x,bomb.y]=2) or (fase.hori[bomb.x,bomb.y]=3) then begin
   if comp.p[bomb.x-1,bomb.y]<>1 then begin
    bomb.ex:=5+((bomb.x-1)*18); bomb.ey:=0+((bomb.y-1)*18);
   banda2:=0; banda:=2; bomb.hori:=2; end;
  end;
 end;

 if(fase.arq[bomb.x,bomb.y]=2) and (fase.gra[bomb.x,bomb.y]=19) then begin
  if(fase.hori[bomb.x,bomb.y]=1) or (fase.hori[bomb.x,bomb.y]=2) then begin
   if comp.p[bomb.x,bomb.y-1]<>1 then begin
    bomb.ex:=5+((bomb.x-1)*18); bomb.ey:=0+((bomb.y-1)*18);
    banda2:=0; banda:=4; end;
  end;
  if(fase.hori[bomb.x,bomb.y]=3) or (fase.hori[bomb.x,bomb.y]=4) then begin
   if comp.p[bomb.x,bomb.y+1]<>1 then begin
    bomb.ex:=5+((bomb.x-1)*18); bomb.ey:=0+((bomb.y-1)*18);
    banda2:=0; banda:=3; end;
  end;
 end;

 if(fase.arq[bomb.x,bomb.y]=2) and (fase.gra[bomb.x,bomb.y]=20) then begin
  if fase.hori[bomb.x,bomb.y]=1 then begin
   if comp.p[bomb.x+1,bomb.y-1]<>1 then begin bomb.x:=bomb.x+1;
    bomb.ex:=5+((bomb.x-1)*18);bomb.ey:=0+((bomb.y-1)*18);
     banda2:=0; banda:=4; end;
  end;
  if fase.hori[bomb.x,bomb.y]=2 then begin
   if comp.p[bomb.x-1,bomb.y-1]<>1 then begin bomb.x:=bomb.x-1;
    bomb.ex:=5+((bomb.x-1)*18);bomb.ey:=0+((bomb.y-1)*18);
    banda2:=0; banda:=4; end;
  end;
  if fase.hori[bomb.x,bomb.y]=3 then begin
   if comp.p[bomb.x-1,bomb.y+1]<>1 then begin bomb.x:=bomb.x-1;
    bomb.ex:=5+((bomb.x-1)*18);bomb.ey:=0+((bomb.y-1)*18);
    banda2:=0; banda:=3; end;
  end;
  if fase.hori[bomb.x,bomb.y]=4 then begin
   if comp.p[bomb.x+1,bomb.y+1]<>1 then begin bomb.x:=bomb.x+1;
    bomb.ex:=5+((bomb.x-1)*18);  bomb.ey:=0+((bomb.y-1)*18);
    banda2:=0; banda:=3; end;
  end;
 end;
end;




{ Controle de teclas }
  if(t=FRENTE) and (bomb.x<17) and (banda=0) and (para2=0) then begin
   if comp.p[bomb.x+1,bomb.y]<>1 then begin banda:=1; bomb.hori:=1; end;
  end;
  if(t=TRAS) and (bomb.x>1) and (banda=0) and (para2=0) then begin
   if comp.p[bomb.x-1,bomb.y]<>1 then begin banda:=2; bomb.hori:=2; end;
  end;
  if(t=BAIXO) and (bomb.y<10) and (banda=0) and (para2=0) then begin
   if comp.p[bomb.x,bomb.y+1]<>1 then banda:=3;
  end;
  if(t=CIMA) and (bomb.y>1) and (banda=0) and (para2=0) then begin
   if comp.p[bomb.x,bomb.y-1]<>1 then banda:=4;
  end;

  if(t='4') and (banda=0) and (para2=0) then begin bomb.hori:=2; bomb.ex:=5+((bomb.x-1)*18); end;
  if(t='6') and (banda=0) and (para2=0) then begin bomb.hori:=1; bomb.ex:=5+((bomb.x-1)*18); end;

  if(t<>#0) and (para2=0) then begin
   parado:=0;
  end;
  if(t<>#0) and (para2>0) and (para2<=3) then begin
   parado:=0; para2:=10;
   bomb.gra:=11;
  end;

 { Soltar Bomba Normal }
   intbomb:=intbomb+2; { 1 }
   if intbomb>=10 then intbomb:=10;
   intbomb:=4;

  if(t=' ') and (banda=0) and (para2=0) and (intbomb>=3) and
    (comp.p[bomb.x,bomb.y]<>1) then begin
    intbomb:=0;
    for work:=1 to 6 do begin
     if(NBomb[work].gra<>0) and (bomb.x=NBomb[work].x) and
       (bomb.y=NBomb[work].y) then goto 1;
    end;
    for work:=1 to 6 do begin
     if NBOMB[work].gra=0 then begin
      NBomb[work].x:=bomb.x;
      NBomb[work].y:=bomb.y;
      NBomb[work].gra:=3;
      NBomb[work].tmp:=0;
      NBOmb[work].tipo:=1;
      NBomb[work].vez:=0;
      NBomb[work].esp:=0;
      goto 1;
     end;
    end; { for }
   1:;
  end; { if }

  if(UpCase(t)='D') and (banda=0) and (para2=0) and (intbomb>=3) and
    (comp.p[bomb.x,bomb.y]<>1) and (sav.dina>0) then begin
    intbomb:=0;
    for work:=1 to 6 do begin
     if(NBomb[work].gra<>0) and (bomb.x=NBomb[work].x) and
       (bomb.y=NBomb[work].y) then goto 1;
    end;
    for work:=1 to 6 do begin
     if NBOMB[work].gra=0 then begin
      NBomb[work].x:=bomb.x;
      NBomb[work].y:=bomb.y;
      NBomb[work].gra:=22;
      NBomb[work].tmp:=0;
      NBOmb[work].tipo:=2;
      NBomb[work].vez:=0;
      NBomb[work].esp:=0;
      sav.dina:=sav.dina-1;  goto 1;
     end;
    end; { for }
  end; { if }

  if(UpCase(t)='A') and (banda=0) and (para2=0) and (intbomb>=3) and
    (comp.p[bomb.x,bomb.y]<>1) and (sav.atomic>0) then begin
    intbomb:=0;
    for work:=1 to 6 do begin
     if(NBomb[work].gra<>0) and (bomb.x=NBomb[work].x) and
       (bomb.y=NBomb[work].y) then goto 1;
    end;
    for work:=1 to 6 do begin
     if NBOMB[work].gra=0 then begin
      NBomb[work].x:=bomb.x;
      NBomb[work].y:=bomb.y;
      NBomb[work].gra:=26;
      NBomb[work].tmp:=0;
      NBOmb[work].tipo:=4;
      NBomb[work].vez:=0;
      NBomb[work].esp:=0;
      sav.atomic:=sav.atomic-1;  goto 1;
     end;
    end; { for }
  end; { if }

  if(UpCase(t)='S') and (banda=0) and (para2=0) and (intbomb>=3) and
    (comp.p[bomb.x,bomb.y]<>1) and (sav.bombs>0) then begin
    intbomb:=0;
    for work:=1 to 6 do begin
     if(NBomb[work].gra<>0) and (bomb.x=NBomb[work].x) and
       (bomb.y=NBomb[work].y) then goto 1;
    end;
    for work:=1 to 6 do begin
     if NBOMB[work].gra=0 then begin
      NBomb[work].x:=bomb.x;
      NBomb[work].y:=bomb.y;
      NBomb[work].gra:=24;
      NBomb[work].tmp:=0;
      NBOmb[work].tipo:=3;
      NBomb[work].vez:=0;
      NBomb[work].esp:=0;
      sav.bombs:=sav.bombs-1;  goto 1;
     end;
    end; { for }
  end; { if }


 { Ve se est† abrindo a porta }
 if(UpCase(t)='C') and (sav.chave>=1) then begin
  if(fase.arq[bomb.x-1,bomb.y  ]=2) and (fase.gra[bomb.x-1,bomb.y  ]=5) then begin sav.chave:=sav.chave-1;
   DestroiPorta( bomb.x-1,bomb.y   ); goto 3; end;
  if(fase.arq[bomb.x+1,bomb.y  ]=2) and (fase.gra[bomb.x+1,bomb.y  ]=5) then begin sav.chave:=sav.chave-1;
   DestroiPorta( bomb.x+1,bomb.y   ); goto 3; end;
  if(fase.arq[bomb.x  ,bomb.y+1]=2) and (fase.gra[bomb.x  ,bomb.y+1]=5) then begin sav.chave:=sav.chave-1;
   DestroiPorta( bomb.x  ,bomb.y+1 ); goto 3; end;
  if(fase.arq[bomb.x  ,bomb.y-1]=2) and (fase.gra[bomb.x  ,bomb.y-1]=5) then begin sav.chave:=sav.chave-1;
   DestroiPorta( bomb.x  ,bomb.y-1 ); goto 3; end;
  3:;
 end;

 { No computador }
 if(UpCase(t)='!') and (sav.disco>=1) and (fase.arq[bomb.x,bomb.y]=2) and
   (fase.gra[bomb.x,bomb.y]=21) then begin
   sav.disco:=sav.disco-1;
    PutPlacar1(sav);
    flip(vaddr,vaddr2);
    for r:=25 downto 3 do begin
     flip(vaddr2,vaddr);
     DGMOutTextShadow( 07,85,' VOC^E GANHOU ACESSO A FASE DE B^ONUS!!! ',1,vaddr,r,0,0,22,0 );
     RDelay(25);
     flip(vaddr,vga);
    end;
    LimpaTeclado;
    r:=0;
    while (r<100) and (t<>#13) do begin
     if keypressed then t:=ReadKey;
      r:=r+1;
     Rdelay(20);
    end;
    for r:=3 to 25 do begin
     flip(vaddr2,vaddr);
     DGMOutTextShadow( 07+(r*3),85,' VOC^E GANHOU ACESSO A FASE DE B^ONUS!!! ',1,vaddr,r,0,0,22,0 );
     RDelay(25);
     flip(vaddr,vga);
    end;
    flip(vaddr2,vaddr);
    passbonus:=1;
 end;




 { Ve se est† no †cido }
  If Fase.arq[bomb.x,bomb.y]=2 then begin
   if(fase.gra[bomb.x,bomb.y]>=12) and (fase.gra[bomb.x,bomb.y]<=15) or
     (fase.gra[bomb.x,bomb.y]=34) or (fase.gra[bomb.x,bomb.y]=35) then
    begin
      {TiraBombVida(sav); }
      if(especial=0) and (bomb.inv=0) then begin
       bomb.gra:=12;
       sav.vidas:=sav.vidas-1;
       bomb.inv:=1; bomb.sup:=44;
     end;
    end;
   END;

 { Verifica se ele caiu no buraco ou no espremedor ou nos espinhos }
  If Fase.arq[bomb.x,bomb.y]=2 then begin
   if fase.gra[bomb.x,bomb.y]=23 then BEGIN
    bomb.gra:=12;
    {TiraBombVida(sav); }
    if(especial=0) and (bomb.inv=0) then begin
     sav.vidas:=sav.vidas-1;
     bomb.inv:=1; bomb.sup:=44;
    end;
   END;

   { Caiu no buraco }
   if(fase.gra[bomb.x,bomb.y]=26) and (bomb.ex>=(5+((bomb.x-1)*18)-6)) and
     (bomb.ey>=(0+((bomb.y-1)*18)-8)) then begin
    bomb.ex:=5+((bomb.x-1)*18);
    bomb.ey:=0+((bomb.y-1)*18);

    for r:=1 to 15 do begin
     bomb.gra:=0;
     AtualizaBombs(sav);
     PutBack;
     PutFront;
     PutPlacar1(sav);
     vanima:=vanima+1;
     if vanima mod 3 = 0 then r:=r-1;
     if vanima=4 then vanima:=1;
     anco[2]:=1;
     if vanima=1 then Anima;

      scale(bomb.ex + (r div 2),bomb.ey + (r div 5),18-r,18-r, Imgs[1,12],vaddr);

     rdelay(speed); { 08 }
     flip(vaddr,vga);
    end;
    rdelay(650);

    if sav.ups=0 then begin
     PutPlacar1(sav);
     flip(vaddr,vaddr2); para3:=0; para2:=0;
     for r:=25 downto 3 do begin
      if para2=0 then begin
        para3:=para3+1;
        if para3>=8 then begin para3:=10; para2:=1; end;
      end;
      if para2=1 then begin
        para3:=para3-1;
        if para3<=1 then begin para3:=0; para2:=0; end;
      end;
      flip(vaddr2,vaddr);
      DGMOutTextShadow( 90,85+(para3*2),' FIM DE JOGO ',1,vaddr,r,0,0,22,0 );
      RDelay(25);
      flip(vaddr,vga);
     end;
     LimpaTeclado;
     r:=0;
     while (r<100) and (t<>#13) do begin
      if keypressed then t:=ReadKey;
       r:=r+1;
      Rdelay(20);
     end;
     saveopal; fadedown(63,2,0); DOFase:=100; exit;
    end;

    saveopal;
    fadedown(63,2,0);
    DoFase:=2;
    Exit;
   end;

   { Caiu no espremedor }
   if(fase.gra[bomb.x,bomb.y]=29) and (bomb.ex>=(5+((bomb.x-1)*18)-6)) and
     (bomb.ey>=(0+((bomb.y-1)*18)-8)) then begin
    bomb.ex:=5+((bomb.x-1)*18);
    bomb.ey:=0+((bomb.y-1)*18);

    for r:=1 to 15 do begin
     bomb.gra:=0;
     AtualizaBombs(sav);
     PutBack;
     PutFront;
     PutPlacar1(sav);
     vanima:=vanima+1;

     if vanima=4 then vanima:=1;

     if vanima=1 then Anima;

      scale(bomb.ex + (r div 2),bomb.ey-2,18-r,18, Imgs[1,12],vaddr);

     rdelay(round(speed*1.3)); { 08 }
     flip(vaddr,vga);
    end;
    rdelay(650);
   if sav.ups=0 then begin
    PutPlacar1(sav);
    flip(vaddr,vaddr2); para3:=0; para2:=0;
    for r:=25 downto 3 do begin
     if para2=0 then begin
       para3:=para3+1;
       if para3>=8 then begin para3:=10; para2:=1; end;
     end;
     if para2=1 then begin
       para3:=para3-1;
       if para3<=1 then begin para3:=0; para2:=0; end;
     end;
     flip(vaddr2,vaddr);
     DGMOutTextShadow( 90,85+(para3*2),' FIM DE JOGO ',1,vaddr,r,0,0,22,0 );
     RDelay(25);
     flip(vaddr,vga);
    end;
    LimpaTeclado;
    r:=0;
    while (r<100) and (t<>#13) do begin
     if keypressed then t:=ReadKey;
      r:=r+1;
     Rdelay(20);
    end;
   saveopal; fadedown(63,2,0); DOFase:=100; exit;
   end;
    saveopal;
    fadedown(63,2,0);
    DoFase:=2;
    Exit;
   end;

  end;

 { Verificaá∆o se ele pegou algum item }
  If Fase.arq[bomb.x,bomb.y]=3 then begin
   if Fase.gra[bomb.x,bomb.y]=1 then begin fase.arq[bomb.x,bomb.y]:=0; sav.cash:=sav.cash+10; end;
   if Fase.gra[bomb.x,bomb.y]=2 then begin fase.arq[bomb.x,bomb.y]:=0; sav.cash:=sav.cash+100; end;

   if(Fase.gra[bomb.x,bomb.y]=16) or (Fase.gra[bomb.x,bomb.y]=17) then
   begin fase.arq[bomb.x,bomb.y]:=0; sav.super:=sav.super+1; end;

   if(Fase.gra[bomb.x,bomb.y]=18) or (Fase.gra[bomb.x,bomb.y]=19) then
   begin fase.arq[bomb.x,bomb.y]:=0; sav.ups:=sav.ups+1; end;

   if Fase.gra[bomb.x,bomb.y]=20 then begin fase.arq[bomb.x,bomb.y]:=0; sav.chave:=sav.chave+1; end;
   if Fase.gra[bomb.x,bomb.y]=21 then begin fase.arq[bomb.x,bomb.y]:=0; sav.disco:=sav.disco+1; end;
   if Fase.gra[bomb.x,bomb.y]=22 then begin fase.arq[bomb.x,bomb.y]:=0; sav.dina:=sav.dina+1; end;
   if Fase.gra[bomb.x,bomb.y]=24 then begin fase.arq[bomb.x,bomb.y]:=0; sav.bombs:=sav.bombs+1; end;
   if Fase.gra[bomb.x,bomb.y]=26 then begin fase.arq[bomb.x,bomb.y]:=0; sav.atomic:=sav.atomic+1; end;

   if(Fase.gra[bomb.x,bomb.y]=28) or (Fase.gra[bomb.x,bomb.y]=29) then
   begin fase.arq[bomb.x,bomb.y]:=0; sav.vidas:=sav.vidas+1; end;

   if(Fase.gra[bomb.x,bomb.y]=30) or (Fase.gra[bomb.x,bomb.y]=31) then
   begin fase.arq[bomb.x,bomb.y]:=0; sav.cash:=sav.cash+200; end;

  end; { If }


   if Fase.arq[bomb.x,bomb.y]=2 then begin
    if fase.gra[bomb.x,bomb.y]=11 then begin
     bomb.ex:=5+((bomb.x-1)*18);
     bomb.ey:=0+((bomb.y-1)*18);
     especial:=3; para2:=0; para3:=0; para4:=0; banda:=0;
    end;
   end;


   if banda=0 then begin
    if(fase.arq[bomb.x,bomb.y]=2) and (fase.gra[bomb.x,bomb.y]=16) then begin
     for r:=1 to 6 do begin
      if(TELE.x[r]=bomb.x) and (TELE.y[r]=bomb.y) then break;
     end;
     TELE.stop:=r;
     TELE.stop:=TELE.stop+1;
     if TELE.stop>TELE.tot then TELE.stop:=1;
     especial:=5;
     lasx:=bomb.x; lasy:=bomb.y;
     prox:=tele.x[tele.stop]; proy:=tele.y[tele.stop];
    end;
   end;


   if(UpCase(t)='X') and (sav.super>0) and (bomb.inv=0) then begin
    bomb.inv:=1;
    bomb.sup:=70;
    sav.super:=sav.super-1;
   end;


end; { especial = 0 }


   if UpCase(t)='E' then RegulaSpeed;
   if t=#13 then Opcao(sav);

   if t='R' then RemoveRGB(1,63,0,0);
   if t='G' then RemoveRGB(2,63,0,0);
   if t='B' then RemoveRGB(3,63,0,0);

   if t='q' then begin alerta:=1; arola:=1; rolatela:=0; end;

   { Se o timer zerou }

   if(t_mim=0) and (t_sec=0) then begin
    PutPlacar1(sav);
    flip(vaddr,vaddr2);
    for r:=25 downto 3 do begin
     flip(vaddr2,vaddr);
     DGMOutTextShadow( 80,85,' ACABOU SEU TEMPO!!! ',1,vaddr,r,0,0,22,0 );
     RDelay(25);
     flip(vaddr,vga);
    end;
    LimpaTeclado;
    r:=0;
    while (r<100) and (t<>#13) do begin
     if keypressed then t:=ReadKey;
      r:=r+1;
     Rdelay(30);
    end;
    saveopal;
    fadedown(63,3,0);
    DoFase:=2;
    Exit;
  end;

   if(sav.level=10) and (passboss=1) then begin
    PutPlacar1(sav);
    flip(vaddr,vaddr2);
    for r:=25 downto 3 do begin
     flip(vaddr2,vaddr);
     DGMOutTextShadow( 65,85,' VOC^E VENCEU O CHEFE!!! ',1,vaddr,r,0,0,22,0 );
     RDelay(25);
     flip(vaddr,vga);
    end;
    LimpaTeclado;
    r:=0;
    while (r<100) and (t<>#13) do begin
     if keypressed then t:=ReadKey;
      r:=r+1;
     Rdelay(30);
    end;
    saveopal;
    fadedown(63,3,0);
    DoFase:=5;
    Exit;
  end;





  if t<>#0 then t:=#0;


 end; { While }


End;


End.
