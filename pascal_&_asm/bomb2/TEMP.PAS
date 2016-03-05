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

    Bomb2MapType2 = record
     tipo : Byte;  { O Tipo da fase :
                      1 - Floresta     2 - Terra      3 - Gelo
                      4 - Espacial     5 - Castelo                }
     arq : array[-10..27,-10..20] of Byte;   { Qual Arquivo ? Bmov,Basico etc }
     gra : array[-10..27,-10..20] of Byte;   { O Gr†fico dele }
     hori : array[-10..27,-10..20] of Byte;  { A orientaá∆o do gr†fico }
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
     nome  : String[10];
     vidas : Byte; { As vidas }
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
    end;

    MonsterType = record
     x,y : Byte;   { Posiá∆o Real no Tabuleiro }
     ex,ey : Word; { Posiá∆o Virtual na Tela   }
     gra : Byte;   { O Grafico }
     hori: Byte;   { A horientaá∆o }
     tipo: Byte;   { O Inimigo  por ex. o 3 Ç o verdinho }
    end;

    BombPosi = record
     x,y : Byte; { Posiá∆o Real }
     ex,ey : Word; { Posiá∆o Virtual }
     gra : Byte;   { O Grafico }
     hori: Byte;   { A horientaá∆o }
    end;

    BombNormType = record
     x,y : Byte; { Posiá∆o Real }
     gra : Byte; { O Grafico }
     tmp : Byte; { Tempo de Espera }
     tinha : array[1..4] of Byte;
    end;

  var
   NBOMB : array[1..6] of BombNormType;
   bomb : BombPosi;
   enemi: array[1..20] of MonsterType;
   Espaco : Integer;
   Imgs : array[1..5,1..90] of Pointer;
   fase2: Bomb2MapType;
   fase : Bomb2MapType2;
   comp : Bomb2CompMapType;
   sav  : Bomb2SaveFile;
   cont : Byte;
   invisible : Byte;
   pal : array[0..255,1..3] of Byte; { V†riavel de pallete DGM }
   anco : array[1..6] of Byte; { Variaveis de controle das animaá‰es }
                               { 1 e 2 - Buraco e Amassador              }

   procedure PutBack;  { Coloca o fundo da fase }
   procedure PutFront; { Coloca os items da frente }
   procedure Anima; { Efetua a animaá∆o dos gr†ficos na fase }
   procedure CarregaImgs; { Carrega para a mem¢ria os gr†ficos do jogo }
   procedure LoadImg(var f : File; var img : Pointer );
   procedure InitUnitLevel;
   procedure ApresLevel;
   procedure PutPlacar1;
   function DoFase : Byte;
   procedure LevelAnalisys;

   implementation

  Uses Crt,Dos,Dmode13h,DGMFONT,Divrf,Teclado;


  procedure InitUnitLevel;
  var
   f : file;
   x,y : Byte;
  begin
   {$I-}
    Assign(f,'BOMB2.DAT'); Reset(f,1);
    Seek(f,filesize(f)-(809-41));
    BlockRead(f,pal,sizeof(pal));
    Close(f);
   {$I+}
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
 end;

{---- PutPlacar ------------------------------------------------------------}
procedure PutPlacar1;
Begin
 Bar(0,199-18,319,199,0,vaddr);
 DGMOutText ( 45,199-5,'PTS: '+str2(sav.cash),1,vaddr,1,0,0 );

 DGMOutText ( 250,199-5,'FASE: '+str2(sav.world)+'-'+str2(sav.level),1,vaddr,1,0,0 );

 PutImageNC(5,199-18, Imgs[3,16], vaddr );
 DGMOutText ( 5+19,199-10,'X'+str2(sav.super),1,vaddr,1,0,0 );

 PutImageNC(43,199-18-5, Imgs[3,19], vaddr );
 DGMOutText ( 43+19,199-15,'X'+str2(sav.ups),1,vaddr,1,0,0 );

 PutImageNC(81,199-18-5, Imgs[3,20], vaddr );
 DGMOutText ( 81+19,199-15,'X'+str2(sav.chave),1,vaddr,1,0,0 );

 PutImageNC(119,199-18-5, Imgs[3,21], vaddr );
 DGMOutText ( 119+19,199-15,'X'+str2(sav.disco),1,vaddr,1,0,0 );

 PutImageNC(157,199-18-4, Imgs[3,22], vaddr );
 DGMOutText ( 157+19,199-14,'X'+str2(sav.dina),1,vaddr,1,0,0 );

 PutImageNC(195,199-18-5, Imgs[3,24], vaddr );
 DGMOutText ( 195+19,199-15,'X'+str2(sav.bombs),1,vaddr,1,0,0 );

 PutImageNC(235,199-18-4, Imgs[3,26], vaddr );
 DGMOutText ( 235+19,199-14,'X'+str2(sav.atomic),1,vaddr,1,0,0 );

 PutImageNC(273,199-18-5, Imgs[3,29], vaddr );
 DGMOutText ( 273+19,199-15,'X'+str2(sav.vidas),1,vaddr,1,0,0 );
End;

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

 if(invisible=0) or (invisible=1) then begin
 if(bomb.x=ex) and (bomb.y=ey) then begin
  if bomb.hori=1 then PutImage( bomb.ex, bomb.ey, Imgs[1,bomb.gra], vaddr );
  if bomb.hori=2 then PutImageI( bomb.ex, bomb.ey, Imgs[1,bomb.gra], vaddr );
  if bomb.hori=3 then PutImageI2( bomb.ex, bomb.ey, Imgs[1,bomb.gra], vaddr );
  if bomb.hori=4 then PutImageI3( bomb.ex, bomb.ey, Imgs[1,bomb.gra], vaddr );
 end; end;

 for r:=1 to cont do begin
  if(enemi[r].x=ex) and (enemi[r].y=ey) then begin
   if enemi[r].hori=1 then PutImage( enemi[r].ex, enemi[r].ey, Imgs[4,enemi[r].gra], vaddr );
   if enemi[r].hori=2 then PutImageI( enemi[r].ex, enemi[r].ey, Imgs[4,enemi[r].gra], vaddr );
   if enemi[r].hori=3 then PutImageI2( enemi[r].ex, enemi[r].ey, Imgs[4,enemi[r].gra], vaddr );
   if enemi[r].hori=4 then PutImageI3( enemi[r].ex, enemi[r].ey, Imgs[4,enemi[r].gra], vaddr );
  end;
 end;


 end;
 end;
end;


{---- Anima ----------------------------------------------------------------}
procedure Anima; { Efetua a animaá∆o dos gr†ficos na fase }
var
 x,y : Word;
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

 for y:=1 to 10 do begin
 for x:=1 to 17 do begin

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
   case fase.gra[x,y] of
    12 : fase.gra[x,y]:=13;
    13 : fase.gra[x,y]:=12;
    14 : fase.gra[x,y]:=15;
    15 : fase.gra[x,y]:=14;
    22 : fase.gra[x,y]:=23;
    23 : fase.gra[x,y]:=22;

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
procedure LevelAnalisys;
var
 r,w : word;
 x,y : Word;
begin
 for y:=1 to 10 do begin
 for x:=1 to 17 do begin
  comp.p[x,y]:=0;
  comp.d[x,y]:=1;
 end;
 end;
 for x:=1 to 6 do begin
  NBOMB[x].x:=0;
  NBOMB[x].y:=0;
  NBOMB[x].gra:=0;
  NBOMB[x].tmp:=0;
  NBomb[x].tinha[1]:=0;
  NBomb[x].tinha[2]:=0;
  NBomb[x].tinha[3]:=0;
  NBomb[x].tinha[4]:=0;
 end;

 for r:=1 to 20 do begin
  enemi[r].x:=0;    enemi[r].y:=0;     enemi[r].ex:=0;    enemi[r].ey:=0;
  enemi[r].gra:=0;  enemi[r].hori:=1;  enemi[r].tipo:=0;
 end;
  bomb.x:=1;     bomb.y:=1;      bomb.ex:=0;     bomb.ey:=0;
  bomb.gra:=1;   bomb.hori:=1;

 cont:=0;
 for y:=1 to 10 do begin
 for x:=1 to 17 do begin

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
procedure ApresLevel;
var
 f : FaseBomb;
 x,y : Integer;
 r : word;
 MM,FF;
begin
 cls(vga,0); cls(vaddr,0);
 MM:=SAV.WORLD;
 FF:=SAV.LEVEL;

{$I-}
 Assign(f,'FASE.MAP'); Reset(f);
 Seek(f, ((MM-1)*10)+(FF-1) );
 Read(f, fase2 ); Close(f);
{$I+}
 If IOResult<>0 then begin
  SetText;
  WriteLn;
  WriteLn(' Erro ao carregar fase. Erro #203 - DGM. '); WriteLn; Halt(1);
 end;

 for y:=-10 to 20 do begin
 for x:=-10 to 27 do begin
  fase.arq[x,y]:=0;
  fase.gra[x,y]:=0;
  fase.hori[x,y]:=0;
  comp.p[x,y]:=0;
  comp.d[x,y]:=1;
 end;
 end;

 fase.tipo:=fase2.tipo;
 for y:=1 to 10 do begin
 for x:=1 to 17 do begin
  fase.arq[x,y]:=fase2.arq[x,y];
  fase.gra[x,y]:=fase2.gra[x,y];
  fase.hori[x,y]:=fase2.hori[x,y];
 end;
 end;


 LevelAnalisys;
 Anima; Anima; Anima; Anima;
 PutBack;
 PutFront;
 PutPlacar1;

 flip(vaddr,vaddr2);

   for r:=25 downto 3 do begin
    flip(vaddr2,vaddr);
    DGMOutTextShadow( 80,80,' FASE  : '+str2(sav.level),1,vaddr,r,0,0,22,0 );
    DGMOutTextShadow( 80,90,' MUNDO : '+str2(sav.world),1,vaddr,r,0,0,22,0 );
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
    DGMOutTextShadow( 80+(r*13),80,' FASE  : '+str2(sav.level),1,vaddr,r,0,0,22,0 );
    DGMOutTextShadow( 80+(r*13),90,' MUNDO : '+str2(sav.world),1,vaddr,r,0,0,22,0 );
    RDelay(25);
    flip(vaddr,vga);
   end;
end;

{---- AtualizaBombs --------------------------------------------------------}
procedure AtualizaBombs;
var
 w,r : Word;
Begin

 for r:=1 to 6 do begin
  if NBomb[r].gra<>0 then begin
   Randomize;
   fase.gra[NBomb[r].x,NBomb[r].y]:=NBomb[r].gra;
   fase.arq[NBomb[r].x,NBomb[r].y]:=3;

   NBomb[r].tmp:=NBomb[r].tmp+1;
   if NBomb[r].tmp=7 then NBomb[r].gra:=4;
   if NBomb[r].tmp=14 then NBomb[r].gra:=5;
   if NBomb[r].tmp=21 then NBomb[r].gra:=6;

   if NBomb[r].tmp=30 then begin
    NBomb[r].gra:=7;
    fase.arq[NBomb[r].x,NBomb[r].y]:=3;
    fase.gra[NBomb[r].x,NBomb[r].y]:=7;
    if comp.d[NBomb[r].x-1,NBomb[r].y]=1 then begin
     if(fase.arq[NBomb[r].x-1,NBomb[r].y]<>0) and
       (comp.p[NBomb[r].x-1,NBomb[r].y]=1) then NBomb[r].tinha[1]:=1;
     fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=13;
    end;
    if comp.d[NBomb[r].x+1,NBomb[r].y]=1 then begin
     if(fase.arq[NBomb[r].x+1,NBomb[r].y]<>0) and
       (comp.p[NBomb[r].x+1,NBomb[r].y]=1) then NBomb[r].tinha[2]:=1;
     fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=13;
    end;
    if comp.d[NBomb[r].x,NBomb[r].y-1]=1 then begin
     if(fase.arq[NBomb[r].x,NBomb[r].y-1]<>0) and
       (comp.p[NBomb[r].x,NBomb[r].y-1]=1) then NBomb[r].tinha[3]:=1;
     fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=10;
    end;
    if comp.d[NBomb[r].x,NBomb[r].y+1]=1 then begin
     if(fase.arq[NBomb[r].x,NBomb[r].y+1]<>0) and
       (comp.p[NBomb[r].x,NBomb[r].y+1]=1) then NBomb[r].tinha[4]:=1;
     fase.arq[NBomb[r].x,NBomb[r].y+1]:=3; fase.gra[NBomb[r].x,NBomb[r].y+1]:=10;
    end;
   end;
   if NBomb[r].tmp=31 then begin
    NBomb[r].gra:=8;
    fase.arq[NBomb[r].x,NBomb[r].y]:=3;
    fase.gra[NBomb[r].x,NBomb[r].y]:=8;
    if comp.d[NBomb[r].x-1,NBomb[r].y]=1 then begin
     fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=14;
    end;
    if comp.d[NBomb[r].x+1,NBomb[r].y]=1 then begin
     fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=14;
    end;
    if comp.d[NBomb[r].x,NBomb[r].y-1]=1 then begin
     fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=11;
    end;
    if comp.d[NBomb[r].x,NBomb[r].y+1]=1 then begin
     fase.arq[NBomb[r].x,NBomb[r].y+1]:=3; fase.gra[NBomb[r].x,NBomb[r].y+1]:=11;
    end;
   end;
   if NBomb[r].tmp=32 then begin
    NBomb[r].gra:=9;
    fase.arq[NBomb[r].x,NBomb[r].y]:=3;
    fase.gra[NBomb[r].x,NBomb[r].y]:=9;
    if comp.d[NBomb[r].x-1,NBomb[r].y]=1 then begin
     fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=15;
    end;
    if comp.d[NBomb[r].x+1,NBomb[r].y]=1 then begin
     fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=15;
    end;
    if comp.d[NBomb[r].x,NBomb[r].y-1]=1 then begin
     fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=12;
    end;
    if comp.d[NBomb[r].x,NBomb[r].y+1]=1 then begin
     fase.arq[NBomb[r].x,NBomb[r].y+1]:=3; fase.gra[NBomb[r].x,NBomb[r].y+1]:=12;
    end;
   end;
   if NBomb[r].tmp=33 then begin
    NBomb[r].gra:=8;
    fase.arq[NBomb[r].x,NBomb[r].y]:=3;
    fase.gra[NBomb[r].x,NBomb[r].y]:=8;
    if comp.d[NBomb[r].x-1,NBomb[r].y]=1 then begin
     fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=14;
    end;
    if comp.d[NBomb[r].x+1,NBomb[r].y]=1 then begin
     fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=14;
    end;
    if comp.d[NBomb[r].x,NBomb[r].y-1]=1 then begin
     fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=11;
    end;
    if comp.d[NBomb[r].x,NBomb[r].y+1]=1 then begin
     fase.arq[NBomb[r].x,NBomb[r].y+1]:=3; fase.gra[NBomb[r].x,NBomb[r].y+1]:=11;
    end;
   end;
   if NBomb[r].tmp=34 then begin
    NBomb[r].gra:=7;
    fase.arq[NBomb[r].x,NBomb[r].y]:=3;
    fase.gra[NBomb[r].x,NBomb[r].y]:=7;
    if comp.d[NBomb[r].x-1,NBomb[r].y]=1 then begin
     fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=13;
    end;
    if comp.d[NBomb[r].x+1,NBomb[r].y]=1 then begin
     fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=13;
    end;
    if comp.d[NBomb[r].x,NBomb[r].y-1]=1 then begin
     fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=10;
    end;
    if comp.d[NBomb[r].x,NBomb[r].y+1]=1 then begin
     fase.arq[NBomb[r].x,NBomb[r].y+1]:=3; fase.gra[NBomb[r].x,NBomb[r].y+1]:=10;
    end;
   end;
   if NBomb[r].tmp=35 then begin
    comp.p[NBomb[r].x,NBomb[r].y]:=0;
    comp.d[NBomb[r].x,NBomb[r].y]:=1;
    fase.arq[NBomb[r].x,NBomb[r].y]:=0;
    NBomb[r].gra:=0; NBomb[r].tmp:=0;
    if comp.d[NBomb[r].x-1,NBomb[r].y]=1 then begin
      fase.arq[NBomb[r].x-1,NBomb[r].y]:=0;
      fase.gra[NBomb[r].x-1,NBomb[r].y]:=0;
      comp.p[NBomb[r].x-1,NBomb[r].y]:=0;
      comp.d[NBomb[r].x-1,NBomb[r].y]:=1;
      if NBOMB[r].tinha[1]=1 then begin
       w:=Random(30)+1;
       if(w>=1) and (w<=4) then begin fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=1; end;
       if(w>=5) and (w<=8) then begin fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=2; end;
       if(w=9) and (w=10)  then begin fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=16; end;
       if w=11 then begin fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=18; end;
       if w=12 then begin fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=22; end;
       if w=13 then begin fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=24; end;
       if w=14 then begin fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=26; end;
       if(w=15) and (w=16) then begin fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=28; end;
       if w=17 then begin fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=30; end;
       NBOMB[r].tinha[1]:=0;
      end;
    end;
     if comp.d[NBomb[r].x+1,NBomb[r].y]=1 then begin
      fase.arq[NBomb[r].x+1,NBomb[r].y]:=0;
      fase.gra[NBomb[r].x+1,NBomb[r].y]:=0;
      comp.p[NBomb[r].x+1,NBomb[r].y]:=0;
      comp.d[NBomb[r].x+1,NBomb[r].y]:=1;
      if NBOMB[r].tinha[2]=1 then begin
      w:=Random(30+1);
       if(w>=1) and (w<=4) then begin fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=1; end;
       if(w>=5) and (w<=8) then begin fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=2; end;
       if(w=9) and (w=10)  then begin fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=16; end;
       if w=11 then begin             fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=18; end;
       if w=12 then begin             fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=22; end;
       if w=13 then begin             fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=24; end;
       if w=14 then begin             fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=26; end;
       if(w=15) and (w=16) then begin fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=28; end;
       if w=17 then begin             fase.arq[NBomb[r].x+1,NBomb[r].y]:=3; fase.gra[NBomb[r].x+1,NBomb[r].y]:=30; end;
       NBOMB[r].tinha[2]:=0;
      end;
    end;
     if comp.d[NBomb[r].x,NBomb[r].y-1]=1 then begin
      fase.arq[NBomb[r].x,NBomb[r].y-1]:=0;
      fase.gra[NBomb[r].x,NBomb[r].y-1]:=0;
      comp.p[NBomb[r].x,NBomb[r].y-1]:=0;
      comp.d[NBomb[r].x,NBomb[r].y-1]:=1;
      if NBOMB[r].tinha[3]=1 then begin
      w:=Random(30)+1;
       if(w>=1) and (w<=4) then begin fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=1; end;
       if(w>=5) and (w<=8) then begin fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=2; end;
       if(w=9) and (w=10)  then begin fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=16; end;
       if w=11 then begin             fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=18; end;
       if w=12 then begin             fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=22; end;
       if w=13 then begin             fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=24; end;
       if w=14 then begin             fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=26; end;
       if(w=15) and (w=16) then begin fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=28; end;
       if w=17 then begin             fase.arq[NBomb[r].x,NBomb[r].y-1]:=3; fase.gra[NBomb[r].x,NBomb[r].y-1]:=30; end;
       NBOMB[r].tinha[3]:=0;
      end;
    end;
     if comp.d[NBomb[r].x,NBomb[r].y+1]=1 then begin
      fase.arq[NBomb[r].x,NBomb[r].y+1]:=0;
      fase.gra[NBomb[r].x,NBomb[r].y+1]:=0;
      comp.p[NBomb[r].x,NBomb[r].y+1]:=0;
      comp.d[NBomb[r].x,NBomb[r].y+1]:=1;
      if NBOMB[r].tinha[4]=1 then begin
      w:=Random(30)+1;
       if(w>=1) and (w<=4) then begin fase.arq[NBomb[r].x,NBomb[r].y+1]:=3; fase.gra[NBomb[r].x,NBomb[r].y+1]:=1; end;
       if(w>=5) and (w<=8) then begin fase.arq[NBomb[r].x,NBomb[r].y+1]:=3; fase.gra[NBomb[r].x,NBomb[r].y+1]:=2; end;
       if(w=9) and (w=10)  then begin fase.arq[NBomb[r].x,NBomb[r].y+1]:=3; fase.gra[NBomb[r].x,NBomb[r].y+1]:=16; end;
       if w=11 then begin             fase.arq[NBomb[r].x,NBomb[r].y+1]:=3; fase.gra[NBomb[r].x,NBomb[r].y+1]:=18; end;
       if w=12 then begin             fase.arq[NBomb[r].x,NBomb[r].y+1]:=3; fase.gra[NBomb[r].x,NBomb[r].y+1]:=22; end;
       if w=13 then begin             fase.arq[NBomb[r].x,NBomb[r].y+1]:=3; fase.gra[NBomb[r].x,NBomb[r].y+1]:=24; end;
       if w=14 then begin             fase.arq[NBomb[r].x,NBomb[r].y+1]:=3; fase.gra[NBomb[r].x,NBomb[r].y+1]:=26; end;
       if(w=15) and (w=16) then begin fase.arq[NBomb[r].x,NBomb[r].y+1]:=3; fase.gra[NBomb[r].x,NBomb[r].y+1]:=28; end;
       if w=17 then begin fase.arq[NBomb[r].x-1,NBomb[r].y]:=3; fase.gra[NBomb[r].x-1,NBomb[r].y]:=30; end;
       NBOMB[r].tinha[4]:=0;
      end;
    end;

     if comp.d[NBomb[r].x-1,NBomb[r].y]=2 then begin
      comp.d[NBomb[r].x-1,NBomb[r].y]:=1;
      if fase.gra[NBomb[r].x-1,NBomb[r].y] = 2 then fase.gra[NBomb[r].x-1,NBomb[r].y]:=3
     end;
     if comp.d[NBomb[r].x+1,NBomb[r].y]=2 then begin
      comp.d[NBomb[r].x+1,NBomb[r].y]:=1;
      if fase.gra[NBomb[r].x+1,NBomb[r].y] = 2 then fase.gra[NBomb[r].x+1,NBomb[r].y]:=3
     end;
     if comp.d[NBomb[r].x,NBomb[r].y+1]=2 then begin
      comp.d[NBomb[r].x,NBomb[r].y+1]:=1;
      if fase.gra[NBomb[r].x,NBomb[r].y+1] = 2 then fase.gra[NBomb[r].x,NBomb[r].y+1]:=3
     end;
     if comp.d[NBomb[r].x,NBomb[r].y-1]=2 then begin
      comp.d[NBomb[r].x,NBomb[r].y-1]:=1;
      if fase.gra[NBomb[r].x,NBomb[r].y-1] = 2 then fase.gra[NBomb[r].x,NBomb[r].y-1]:=3
     end;

   end;



  end;
 end;




End;


{---- DoFase ---------------------------------------------------------------}
{/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\-/-\}
function DoFase : Byte;
var
 fim : Byte;
 vanima : Byte;
 banda,banda2 : Byte;
 parado,para2,para3,para4 : Byte;
 acorda : Byte;
 work :Byte;
 intbomb : Byte;
 r : Word;
 label 1;
Begin
 saveopal;
 fim:=0;
 vanima:=1; intbomb:=0;
 banda:=0; banda2:=0; invisible:=0;
 parado:=0; para2:=0; para3:=0; para4:=0; acorda:=0;

 while (fim=0) do begin

 if t='a' then invisible:=1;

{ Piscando : Levou bordoada }
 case invisible of
  1 : invisible:=2;
  2 : invisible:=1;
 end;

{ Verificaá∆o dele parado }
  parado:=parado+1;
  if parado>105 then parado:=106;
  if parado=105 then begin
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


  vanima:=vanima+1;
  if vanima=4 then vanima:=1;

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

  AtualizaBombs;
  PutBack;
  PutFront;
  PutPlacar1;
  if vanima=1 then Anima;

  rdelay(08);
  flip(vaddr,vga);

  if t=#27 then fim:=1;


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
   intbomb:=intbomb+1;
   if intbomb>=10 then intbomb:=10;

  if(t=' ') and (banda=0) and (para2=0) and (intbomb>=3) and
    (comp.p[bomb.x,bomb.y]=0) then begin
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
      NBomb[work].tinha[1]:=0;
      NBomb[work].tinha[2]:=0;
      NBomb[work].tinha[3]:=0;
      NBomb[work].tinha[4]:=0; goto 1;
     end;
    end; { for }
   1:;
  end; { if }


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

   if t='E' then begin
    for r:=1 to 255 do SetPal(r,opal[r,1]+1,opal[r,2]+1,opal[r,3]+1);
   end;

   if t='R' then RemoveRGB(1,63,0,0);
   if t='G' then RemoveRGB(2,63,0,0);
   if t='B' then RemoveRGB(3,63,0,0);


 end; { While }


End;


End.
