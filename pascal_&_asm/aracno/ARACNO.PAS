{
  ARACNOFIBIA v1.0.2 - by DGM Informatica

  Copyright (c) 2000 David Maziero / DGM Informatica

  Data : 04/10/2000
}

 Uses DMode13H,DGMFont,Divrf,DGMSBDSP,crt,dos;

 const
   jogoname = '  *** DGM ARACNOFOBIA v1.0 revis∆o 2 ***    ';
   jogodesc = ' ** N«O DEIXE QUE AS ARANHAS TE PEGUE!!! ** ';
   jogodesc2= ' ** CAUTION WITH THE SPIDERS!!!          ** ';
   copyr    = ' ** COPYRIGHT (C) 2000 DAVID MAZIERO / DGM INFORMATICA ** ';
   direitos = ' ** ESTE JOGO ê UM FREEWARE E PODE SER DISTRIBUIDO LIVREMENTE ** ';
   sugest   = ' ** EM CASO DE BUGs OU SUGESTOES MANDE UM E-MAIL PARA ** ';
   direitos2= ' ** THIS GAME IS A FREEWARE AND CAN BE FREE DISTRIBUTED       ** ';
   sugest2  = ' ** IN CASE OF BUGs OR SUGESTIONS SEND A E-MAIL AT ** ';

   ssize : array[1..4] of Word = ( 10000, 8810, 7942, 2748 );

 type
  recordestype = record
   nome : array[1..10] of String[10];
   ho,mi,se : array[1..10] of Byte;
  end;

 var
  sound  : array[1..3] of Pointer; { pointer para o buffer de som! }
  pal    : array[0..255,1..3] of Byte;
  spider : array[1..2] of Pointer;
  voce   : array[1..4] of Pointer;
  tiro   : array[1..2] of Pointer;
  aracno,fobia : Pointer;
  Teia   : Pointer;
  f      : file;
  r      : Word;
  ex,ey,size : Word;
  mil,sec,hora,mim,pa : Byte;
  save1c : Pointer;
  rec    : recordestype;
  recf   : file of recordestype;
  stop   : Byte;

 label erro;

function PZ(w : Word) : String;
var
  s : String;
begin
  Str(w:0,s);
  if Length(s) = 1 then
    s := '0' + s;
  PZ := s;
end;

 {**************************************************************************}
 procedure ZoomNome;
 var
  sx,sy : Word;
  x,y   : Word;
  ssy   : Real;
  t     : Char;
 begin

  cls(vaddr2,0); cls(vaddr,0);

  { le o ARACNO sound }
  Assign(f,'ARACNOF.DAT');
  Reset(f,1); Seek(f,filesize(f)-29500);
  BlockRead(f,Sound[1]^,ssize[1]);

  SBPlayback( Sound[1], ssize[1], 6000 );
  sy:=2; ssy:=2;
  for sx:=2 to ImageSizeX(aracno) do begin
   ScaleZNC(35,15,sx,sy,aracno,vga);
   WaitRetrace;
   ssy:=ssy+(ImageSizeY(aracno)/ImageSizeX(aracno));
   sy:=Round(ssy);
  end;
  flip(vga,vaddr2);

  BlockRead(f,Sound[1]^,ssize[2]);
  close(f);
  SBPlayback( Sound[1], ssize[2], 6000 );
  sy:=2; ssy:=2;
  for sx:=2 to ImageSizeX(fobia) do begin
   flip(vaddr2,vaddr);
   Scale(65,35+(sx div 3),sx,sy,fobia,vaddr);
   WaitRetrace;
   flip(vaddr,vga);
   ssy:=ssy+(ImageSizeY(fobia)/ImageSizeX(fobia));
   sy:=Round(ssy);
  end;
  flip(vga,vaddr2);

  for sy:=1 to 180 do begin
   flip(vaddr2,vaddr);
   DGMOutText( 5,sy, 'COPYRIGHT (C) 2000 DAVID MAZIERO / DGM INFORM''ATICA',1,vaddr,1,0,0);
   WaitRetrace;
   flip(vaddr,vga);
  end;
  flip(vga,vaddr2);

  sx:=0; sy:=1;


  LimpaTeclado; t:=#0;

  while (t<>#13) do begin
   if keypressed then begin
    t:=ReadKey;
    if t=#0 then t:=ReadKey;
   end;
   if sy=1 then sx:=sx+1;
   if sy=2 then sx:=sx-1;
   if sx>240 then sy:=2;
   if sx<10  then sy:=1;
   flip(vaddr2,vaddr);
   DGMOutText( sx,104, 'PRESS.<ENTER>',1,vaddr,1,0,4+ sx div 32);
   flip(vaddr,vga);
   WaitRetrace;
  end;
  flip(vaddr,vga);

  for sy:=1 to 255 do begin
   for sx:=1 to 18 do begin
    PutImageZ((sx-1)*18,sy-(sx*3),spider[random(2)+1],vga);
   end;
   WaitRetrace;
  end;

  FadeDown(63,2,0);
  cls(vga,0); cls(vaddr,0); cls(vaddr2,0);
  FadeUp(63,0,0);

 end;
 {**************************************************************************}


 {**************************************************************************}
 procedure START;
 var
  sx,sy : Integer;
 begin

  cls(vaddr2,0); cls(vaddr,0);

  for sx:=-20 to 25 do begin
   cls(vaddr,0);
   DGMOutText( 25,80, 'PRONTO?',2,vaddr,sx,0,12);
   flip(vaddr,vga);
   WaitRetrace;
  end;
  for sx:=24 downto -12 do begin
   cls(vaddr,0);
   DGMOutText( 25,80, 'PRONTO?',2,vaddr,sx,0,12);
   flip(vaddr,vga);
   WaitRetrace;
  end;
  for sx:=-11 to 0 do begin
   cls(vaddr,0);
   DGMOutText( 25,80, 'PRONTO?',2,vaddr,sx,0,12);
   flip(vaddr,vga);
   WaitRetrace;
  end;
   DGMOutText( 15,180, 'PRESSIONE <ENTER> PARA JOGAR',1,vga,1,0,0);
   PAUSE;
   FadeDown(63,1,0);
   cls(vga,0); cls(vaddr,0);
   FadeUp(63,0,0);


 end;
 {**************************************************************************}


 procedure GERENCIARECORDES; forward;

 {**************************************************************************}
 procedure BEGINGAME;
 var
   x,r2 : Word;
   r    : Integer;
   gun  : array[1..5]  of Byte;
   gunx : array[1..10] of Word;
   guny : array[1..10] of LongInt;
   spsy : array[1..17] of Byte;
   t    : Char;
   mx,move,mx2 : Byte;
   ba,espe,level : Byte;
   nuntiro : Byte;
   bk,bk2  : Byte;
   nunchao : Byte;

 label fim,morre,conti,inicio;

 Begin
  inicio:

   LimpaTeclado;

   for r:=1 to 3 do begin
    gun[r]:=0; gunx[r]:=0; guny[r]:=0;
   end;
   for r:=1 to 17 do spsy[r]:=0;


   x:=150;
   cls(vga,0); cls(vaddr,0); cls(vaddr2,0);
   PutImage(0,0,teia,vaddr2);

   hora:=0; mim:=0; sec:=0; mx:=0; mx2:=0; move:=1; espe:=0;
   level:=20; ba:=1; nuntiro:=1; bk:=0; bk2:=0; stop:=0;
   pa:=0;

   While (t<>#27) do begin


{     if (sec=20) and (sec<>bk2) then begin
      bk2:=sec;  }

     if pa>=20 then begin
      pa:=0;
      if nuntiro<10 then nuntiro:=nuntiro+1;
      if level>=2 then level:=level-1;
     end;
{     if sec>20 then bk2:=0; }

    espe:=espe+1;
    if espe>100 then espe:=0;
    if espe mod 20 = 0 then begin
     case ba of
      1 : ba:=2;
      2 : ba:=1;
     end;
    end;

    flip(vaddr2,vaddr);

     nunchao:=0;
     for r:=1 to 17 do begin
      Line(16+(r-1)*18,0,16+(r-1)*18,spsy[r],2,vaddr);
      PutImage(7+(r-1)*18,spsy[r],spider[random(2)+1],vaddr);
      if espe mod level = 0 then begin
       if random(4)=1 then begin
        if spsy[r]<175 then spsy[r]:=spsy[r]+random(3)+1;
        if spsy[r]>=175 then spsy[r]:=175;
       end;
      end;
      if spsy[r]=175 then nunchao:=nunchao+1;
     end;

     for r:=1 to nuntiro do begin

      if gun[r]=1 then begin
       PutImage(gunx[r],guny[r],tiro[ba],vaddr);
       guny[r]:=guny[r]-2;
       if guny[r]<0 then gun[r]:=0;

       for r2:=1 to 17 do begin

        if (gunx[r]>=(6+(r2-1)*18)) and (gunx[r]<=(6+(r2-1)*18)+20) and
           (guny[r]>=spsy[r2]) and (guny[r]<=spsy[r2]+18) or
           (gunx[r]+8>=(6+(r2-1)*18)) and (gunx[r]+8<=(6+(r2-1)*18)+20) and
           (guny[r]>=spsy[r2]) and (guny[r]<=spsy[r2]+18) then begin
            if spsy[r2]>11 then begin
             spsy[r2]:=spsy[r2]-10; end else begin
             spsy[r2]:=0;
            end;
            gun[r]:=0;
           end;
       end;


      end;

     end;

      PutImage(x,175,voce[move],vaddr);
      if (mx2=1) and (espe mod 3 = 0) then begin
       Case move of
        1 : move:=2;
        2 : move:=3;
        3 : move:=4;
        4 : mx2:=0;
       end;
       if mx2=0 then begin
        {d† o tiro}
        move:=1;
        for r:=1 to nuntiro do begin
         if gun[r]=0 then begin
          SBPlayback( Sound[3], ssize[4], 11000 );
          gun[r]:=1; gunx[r]:=x; guny[r]:=157; break;
         end;
        end;
       end;
      end;


      Bar(0,193,320,200,18,vaddr);
      DGMOutText(2,194,'TEMPO: '+PZ(hora)+':'+PZ(mim)+'.'+PZ(sec)+'  LEVEL:'+PZ((20-level)+1)+'  N.TIROS:'+PZ(nuntiro)+
      '   ARANHAS :'+PZ(nunchao),1,vaddr,1,0,0);


     flip(vaddr,vga); WaitRetrace;

     if not KeyPressed then t:=#0;
     if KeyPressed then begin
      t:=ReadKey;
      if t=#0 then t:=ReadKey;
     end;

     if t=FRENTE then mx:=1;
     if t=TRAS   then mx:=2;
     if(t=BAIXO) or (t=CIMA) then mx:=0;
     if (t=' ') and (mx2=0) then mx2:=1;

     if t=#27 then goto fim;
     conti:

     if mx=1 then x:=x+2;
     if mx=2 then x:=x-2;

     if x<7 then x:=7;
     if x>295 then x:=295;

     if nunchao>=8 then goto morre;

     if t='G' then level:=1;

   end;

  goto fim;

  {Quando 8 aranhas atingem o solo}
  morre:
   stop:=1;

   SBPlayback( Sound[2], ssize[3], 8000 );

   for r:=-25 to 205 do begin
    for r2:=0 to 320 do begin
     line(r2,r-1,r2,r+random(25),22,vga);
    end;
    waitretrace;
   end;
   for r:=0 to 80 do begin
    cls(vaddr,22);
    DGMOutText(90,r,'GAME OVER',2,vaddr,-6,0,0);
    flip(vaddr,vga);
    WaitRetrace;
   end;
   RDelay(1500);
   for r:=-25 to 205 do begin
    for r2:=0 to 320 do begin
     line(r2,r-1,r2,r+random(25),0,vga);
    end;
    waitretrace;
   end;

    GERENCIARECORDES;
    START;
    goto inicio;

  fim:
   stop:=1;
   flip(vga,vaddr2);
   for r:=0 to 70 do begin
    r:=r+1;
    if r>70 then r:=70;
    flip(vaddr2,vaddr);
    DGMOutText(35,r,   'Quer mesmo parar?',2,vaddr,-6,0,0);
    DGMOutText(35,r+20,'      (S/N)      ',2,vaddr,-6,0,0);
    WaitRetrace;
    flip(vaddr,vga);
   end;
   t:=PERG('sSnN');
   if(t='n') or (t='N') then begin
    PutImage(0,0,teia,vaddr2); stop:=0;
    goto conti;
   end;

   RemoveRGB(2,63,1,0);
   RemoveRGB(3,63,1,0);
   RemoveRGB(1,63,2,0);
   RDelay(500);
   SetText;

   WriteLn;
   WriteLn(' Mem¢ria restante : ',MEMAVAIL);

   SetIntVec($1C,save1c);
   ShutDown(1); ShutDown(2);
   BitMapFree(spider[1]); BitMapFree(spider[2]);
   BitMapFree(tiro[1]);   BitMapFree(tiro[2]);
   BitMapFree(voce[1]);   BitMapFree(voce[2]);   BitMapFree(voce[3]); BitMapFree(voce[4]);
   BitMapFree(aracno);    BitMapFree(fobia);     BitMapFree(teia);

   WriteLn;
   WriteLn(' Obrigado por jogar ARACNOFOBIA - DGM    ');
   WriteLn(' Thank you for playing ARACNOFOBIA - DGM ');
   WriteLn;
   WriteLn;
   Halt(1);

 End;
 {**************************************************************************}


 {**************************************************************************}
 procedure GERENCIARECORDES;
 var
  f : file;
  s : PathStr;
  r : Byte;
  tot : LongInt;
  pos : Byte;
  t : Char;
  d : Byte;
  nome : String[10];
 label 100,200;
 begin
  stop:=1;
  d:=1;
 200:;
  cls(vaddr,0); cls(vaddr2,0); cls(vga,0);


  s:=FSearch('ARACNO.REC','');
  if s='' then begin
   for r:=1 to 10 do begin
    rec.nome[r]:='ANONIMO   ';
    rec.ho[r]  :=0;
    rec.mi[r]  :=0;
    rec.se[r]:=60-(r*6)+1;
   end;
   {$I-}
    Assign(recf,'ARACNO.REC');
    ReWrite(recf);
    Write(recf,rec);
    close(recf);
   {$I+}
{    if IOResult<>0 then TENTADENOVO; }

  end else begin
    Assign(recf,'ARACNO.REC'); Reset(recf);
    Read(recf,rec); close(recf);
{    if IOResult<>0 then TENTADENOVO; }
  end;

   FadeDown(63,0,0);

   DGMOutText(55,1,'Tabela de Recordes',2,vaddr2,-9,0,12);
  for r:=22 to 200 do
   line(1,r,319,r,23-(r div 25),vaddr2);
   flip(vaddr2,vga);
   FadeUp(63,3,0);

  for r:=1 to 10 do begin

   DGMOutText(80,35+(r-1)*10,PZ(r)+': '+rec.nome[r]+' - '+PZ(rec.ho[r])+':'++PZ(rec.mi[r])+'.'+PZ(rec.se[r]),
              1,vga,1,0,0);
   WaitRetrace;
   RDelay(100);

  end;

  pos:=0;
  for r:=10 downto 1 do begin
   tot:=(hora*600)+(mim*60)+sec;
   if tot> (rec.ho[r]*600)+(rec.mi[r]*60)+rec.se[r] then pos:=r;
  end;


 if d=1 then begin

  if pos<>0 then begin
   DGMOutText(80,150,'VOC^E FICOU NA '+PZ(pos)+' POSIC,{AO!!! ',1,vga,1,0,0);
   DGMOutText(115,160,PZ(hora)+':'+PZ(mim)+'.'+PZ(sec),1,vga,1,0,0);

   DGMOutText(45,170,'ENTRE COM O SEU NOME : ',1,vga,1,0,0);
   flip(vga,vaddr2);


   r:=0;
   t:=#0;
   LimpaTeclado;
   nome:='';
   while (t<>#13) do begin
{    r:=r+1; }
    if r>10 then r:=10;

    flip(vaddr2,vaddr);
    DGMOutText(185,170,nome,1,vaddr,1,0,0);
    flip(vaddr,vga);
    WaitRetrace;

    t:=ReadKey;
    if t=#0 then begin
     t:=ReadKey; r:=r-1;
     goto 100;
    end else begin
     if (t=#8) and (r>=1) then begin
      delete(nome,r,1);
      r:=r-1; goto 100;
     end;
      if t<>#13 then begin nome:=nome+t; r:=r+1; end;
     end;
    100:;
   end;
   if length(nome)<10 then begin
    for r:=1 to 10-length(nome) do nome:=nome+' ';
   end;

   if pos<10 then begin
    for r:=10 downto pos do begin
     rec.nome[r]:=rec.nome[r-1];
     rec.ho[r]:=rec.ho[r-1];
     rec.mi[r]:=rec.mi[r-1];
     rec.se[r]:=rec.se[r-1];
    end;
   end;


   rec.nome[pos]:=nome;
   rec.ho[pos]:=hora;
   rec.mi[pos]:=mim;
   rec.se[pos]:=sec;


   {$I-}
    Assign(recf,'ARACNO.REC');
    ReWrite(recf);
    Write(recf,rec);
    close(recf);
   {$I+}
{    if IOResult<>0 then TENTADENOVO; }

    d:=0; goto 200;

   end; { pos<>0 }
  end; { d = 1 }


  LimpaTeclado;
  Pause;

 end;



 {**************************************************************************}


 {**************************************************************************}
 {$F+}
  procedure INCSEC; interrupt;
  Begin
   if stop=0 then begin
    mil:=mil+1;
    if mil>=18 then begin
     mil:=0;
     sec:=sec+1;
     pa:=pa+1;

     if sec>=60 then begin
      mim:=mim+1; sec:=0;
      if mim>=60 then begin
       hora:=hora+1; mim:=0;
      end;
     end;
     end;
   end;
  End;
 {$F-}
 {**************************************************************************}


 var
  yes : Byte;

 Begin

  { verifica a existància da placa de som }
  yes:=1; { sim }

  if not SBResetDSP(2) then begin
   if not SBResetDSP(1) then begin
    if not SBResetDSP(3) then begin
     if not SBResetDSP(4) then begin
      if not SBResetDSP(5) then begin
       yes:=0; {n∆o}
      end; {4}
     end; {4}
    end; {3}
   end; {1}
  end; {2}


  if yes=1 then begin
   WriteLn;
   WriteLn(' Placa de som encontrada. ');
   RDelay(500); end else begin
   WriteLn;
   WriteLn(' Placa de som n∆o encontrada. ');
   RDelay(500);
  end;

  { inicializa buffer de som em 10Kb, um pouco maior que o maior som! }
  GetMem( Sound[1], 10100 );

  GetMem( Sound[2], ssize[3] );
  GetMem( Sound[3], ssize[4] );

  SetMCGA;
  SetUpVirtual(1);
  SetUpVirtual(2);
  cls(vga,0); cls(vaddr,0); cls(vaddr2,0);

  DGMInitFonts;
  Randomize;


  mil:=0; sec:=0; hora:=0; stop:=0;
  GetIntVec($1C,save1c);
  SetIntVec($1C,addr(INCSEC));


  {$I-}
   Assign(f,'ARACNOF.DAT'); Reset(f,1); Seek(f,41);
   BlockRead(f,pal,sizeof(pal)); close(f);
  {$I+}

erro:
   if IOResult<>0 then begin
    SetText;
    WriteLn;
    WriteLn(' Erro ao ler o arquivo ARACNOF.DAT. ');
    WriteLn(' Verifique se o disco n∆o est† danificado, ou este arquivo ');
    WriteLn(' existe. ');
    WriteLn('   *** by DGM *** '); WriteLn; WriteLn;
    Halt(1);
   end;

    for r:=0 to 255 do SetPal(r,pal[r,1],pal[r,2],pal[r,3]);
    SaveOPal; SaveVPal;


  {$I-}
   Assign(f,'ARACNOF.DAT'); Reset(f,1);Seek(f,809);
   ex:=0; ey:=0; BlockRead(f,ex,2); BlockRead(f,ey,2);
   size:=BitMapAlloc( ex, ey, spider[1] );
   Seek(f,filepos(f)-4); BlockRead(f,spider[1]^,size);
   ex:=0; ey:=0; BlockRead(f,ex,2); BlockRead(f,ey,2);
   size:=BitMapAlloc( ex, ey, spider[2] );
   Seek(f,filepos(f)-4); BlockRead(f,spider[2]^,size);
   ex:=0; ey:=0; BlockRead(f,ex,2); BlockRead(f,ey,2);
   size:=BitMapAlloc( ex, ey, voce[1] );
   Seek(f,filepos(f)-4); BlockRead(f,voce[1]^,size);
   ex:=0; ey:=0; BlockRead(f,ex,2); BlockRead(f,ey,2);
   size:=BitMapAlloc( ex, ey, voce[2] );
   Seek(f,filepos(f)-4); BlockRead(f,voce[2]^,size);
   ex:=0; ey:=0; BlockRead(f,ex,2); BlockRead(f,ey,2);
   size:=BitMapAlloc( ex, ey, voce[3] );
   Seek(f,filepos(f)-4); BlockRead(f,voce[3]^,size);
   ex:=0; ey:=0; BlockRead(f,ex,2); BlockRead(f,ey,2);
   size:=BitMapAlloc( ex, ey, voce[4] );
   Seek(f,filepos(f)-4); BlockRead(f,voce[4]^,size);
   ex:=0; ey:=0; BlockRead(f,ex,2); BlockRead(f,ey,2);
   size:=BitMapAlloc( ex, ey, tiro[1] );
   Seek(f,filepos(f)-4); BlockRead(f,tiro[1]^,size);
   ex:=0; ey:=0; BlockRead(f,ex,2); BlockRead(f,ey,2);
   size:=BitMapAlloc( ex, ey, tiro[2] );
   Seek(f,filepos(f)-4); BlockRead(f,tiro[2]^,size);
   ex:=0; ey:=0; BlockRead(f,ex,2); BlockRead(f,ey,2);
   size:=BitMapAlloc( ex, ey, aracno );
   Seek(f,filepos(f)-4); BlockRead(f,aracno^,size);
   ex:=0; ey:=0; BlockRead(f,ex,2); BlockRead(f,ey,2);
   size:=BitMapAlloc( ex, ey, fobia );
   Seek(f,filepos(f)-4); BlockRead(f,fobia^,size);
   ex:=0; ey:=0; BlockRead(f,ex,2); BlockRead(f,ey,2);
   size:=BitMapAlloc( ex, ey, teia );
   Seek(f,filepos(f)-4); BlockRead(f,teia^,size);

   DGMLoadFont( 1, 'ARACNOF.DAT', filepos(f), 2);
   DGMLoadFont( 2, 'ARACNOF.DAT', filepos(f)+2367, 4);

   Seek(f,filesize(f)-29500+10000+8810);
   BlockRead(f,Sound[2]^,ssize[3]);
   BlockRead(f,Sound[3]^,ssize[4]);

   Close(f);
  {$I+}
   if IOResult<>0 then goto erro;



   RDelay(500);

   ZoomNome;
   Rdelay(500);
   START;

   BEGINGAME;

   LimpaTeclado;
{   ReadLn;

   SetIntVec($1C,save1c);
   ShutDown(1); ShutDown(2);
   BitMapFree(spider[1]); BitMapFree(spider[2]);
   BitMapFree(tiro[1]);   BitMapFree(tiro[2]);
   BitMapFree(voce[1]);   BitMapFree(voce[2]);   BitMapFree(voce[3]); BitMapFree(voce[4]);
   BitMapFree(aracno);    BitMapFree(fobia);     BitMapFree(teia);
 }

 End.
