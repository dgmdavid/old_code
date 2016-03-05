
  Uses Crt,Dos,Dmode13h,DGMFONT,divrf;

  var
   f : file;
   r : Integer;
   pal : array[0..255,1..3] of Byte; { V riavel de pallete DGM }
   t : char;
   p : pointer;
   r2 : Integer;
   s : SearchRec;
  begin

   SetMCGA;
   setupvirtual(1);

   Assign(f,'c:\dgm\draw7\dgmnorm.pal'); Reset(f,1); Seek(f,41);
   BlockRead(f,pal,sizeof(pal)); close(f);
   for r:=0 to 255 do SetPal(r,pal[r,1],pal[r,2],pal[r,3]);

   DGMInitFonts;

   cls(vga,0); cls(vaddr,0);

 r:=0;
 FindFirst('*.FNT',Archive,S);

 r2:=-8;

  DGMLoadFont( 1,s.name,0,2 );

 for r:=1 to 10 do begin
 r:=1;
{  DGMLoadFont( 1,S.name,0,2 ); }
  DGMOutText   ( 2,1,s.name,1,vaddr,r2,0,0 );
  DGMOutText   ( 2,50,'Espac,o : '+str2(r2),1,vaddr,r2,0,0 );
  DGMOutText   ( 2,80, 'Teste de escrita',1,vaddr,r2,0,0 );
  DGMOutText   ( 2,105,'Fontes TrueType',1,vaddr,r2,0,0 );
  DGMOutText   ( 2,130,'Retiradas do Windows',1,vaddr,r2,0,0 );
  waitretrace;
  flip(vaddr,vga);
  cls(vaddr,0);
  t:=ReadKey;
  if t=#13 then begin
   FindNext(s);
   DGMLoadFont( 1,S.name,0,2 );
  end;
  if t='+' then r2:=r2+1;
  if t='-' then r2:=r2-1;
  if t=#27 then break;
{  FindNext(s);
  if DosError<>0 then Break; }
 end;

   ReadLn;
   SetText;

  end.