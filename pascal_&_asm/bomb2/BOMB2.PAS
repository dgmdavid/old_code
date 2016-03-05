{
   Bomb v2.0

   Arquivo Principal - BOMB2.PAS

   Copyright (c) 1999 David Maziero / DGM Inform†tica

   Data : 30 de Dezembro de 1999
}

  Uses Crt,Dos,DMode13H,DGMPCX,DGMFONT,DGMLOGO,FSCR,TECLADO,BOMB2V,Divrf;


{$F+}

{---- Funá∆o Principal ------------------------------------------------------}
var
 op,w : Byte;
 s  : PathStr;
 gameover : Byte;
 sav,sav2  : Bomb2SaveFile;
 label 1,2;
Begin
 WriteLn;
 WriteLn(' Bomb v2.0 - Copyright (c) 1999 David Maziero / DGM Inform†tica ');
 WriteLn;
 RDelay(500);

{ s:=FSearch('FASE.MAP','');
 if s='' then begin
  WriteLn(' Arquivo de fases FASE.MAP n∆o encontrado.');
  WriteLn(' Erro #202 - DGM. ');
  WriteLn; WriteLn; Halt(1);
 end; }

 SetUpVirtual(1);
 SetUpVirtual(2);
 InitChain4;
 SetMCGA;

 Espaco:=-5;
 CarregaIMGs;

 ShowTheDGMLOGO;
 DGMInitFonts;
 DGMLoadFont( 1,'SMALL.FNT',0,2 );
{ DGMLoadFont( 2,'DEFAULT.FNT',0,2 ); }

 Teclado_wait:=3; Teclado_OP:=0;
 Teclado_Init;

2:;
 InitUnitLevel;

 op:=FirstScreen;
 if op=5 then goto 1;


 cls(vga,0); cls(vaddr,0);
 for w:=0 to 255 do setpal(w,pal[w,1],pal[w,2],pal[w,3]);

 op:=1;
{---- Opá∆o 1 - Novo Jogo ---------------------------------------------------}
 if op=1 then begin

  sav.nome:='                ';  sav.vidas:=6;  sav.ups:=3;       sav.atomic:=0;
  sav.bombs:=0;         sav.dina:=0;   sav.super:=0;     sav.level:=1;
  sav.world:=1;         sav.cash:=0;   sav.disco:=1;     sav.chave:=0;
  sav.bonus:=0;

  sav.level:=val2(paramstr(1));

  gameover:=0;

  while (gameover=0) do begin

   ApresLevel(sav);
   gameover:=DoFase(sav);

   { gameover=100 Ç fim de jogo!!! GAME OVER!!! }
   if gameover=100 then begin
    cls(vga,0); cls(vaddr,0);
    goto 2;
   end;

   if gameover=5 then begin { Passou de fase }
    cls(vga,0); cls(vaddr,0); fadeup(63,0,0);
    gameover:=0;
    sav.level:=sav.level+1;
    if sav.level=11 then begin
     sav.level:=1;
     sav.world:=sav.world+1;
    end;
   end;

   if gameover=6 then begin { Fase de bonus }
    cls(vga,0); cls(vaddr,0); fadeup(63,0,0);
    gameover:=0;
    sav.level:=sav.level+1;
    if sav.level=11 then begin
     sav.level:=1;
     sav.world:=sav.world+1;
    end;
    sav.bonus:=1;
    ApresLevel(sav);
    gameover:=DoFase(sav);
    cls(vga,0); cls(vaddr,0); fadeup(63,0,0);
    gameover:=0; sav.bonus:=0;
   end;


   if gameover=1 then begin
    sav.vidas:=3;
    cls(vga,0); cls(vaddr,0); fadeup(63,0,0);
    sav.ups:=sav.ups-1;
    gameover:=0;
   end;
   if gameover=2 then begin
    sav.vidas:=3;
    cls(vga,0); cls(vaddr,0); fadeup(63,0,0);
    sav.ups:=sav.ups-1;
    gameover:=0;
   end;
  end;

 end;
{----------------------------------------------------------------------------}


 1:;

 Teclado_Done;

 ShutDown(1);
 ShutDown(2);
 SetText;
 WriteLn;
 WriteLn(' Copyright (c) 1999 David Maziero / DGM Inform†tica ');
 WriteLn('Obrigado por jogar Bomb v2.0 - Thank you for playing ');
 WriteLn;
 WriteLn(' DGM. ');
 WriteLn; WriteLn;

End.
{----------------------------------------------------------------------------}