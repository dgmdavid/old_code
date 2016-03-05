{
  Bomb v2.0

  Apresentaá∆o do Logo DGM.

  Copyright (c) 1999 David Maziero / DGM Inform†tica

  Data : Dezembro de 1999
}

  Unit DGMLOGO;

  interface

  procedure ShowTheDGMLOGO;

  implementation


  Uses Crt,Dos,DMode13H,Divrf;

  procedure ShowTheDGMLOGO;
  var
   LOGO : Pointer;
   f : File;
   ex,ey,size : Word;
   xx,r : Word;
   pal : array[0..255,1..3] of Byte;
   t : Char;
   s : PathStr;
  Begin

   s:=FSearch('BOMB2.DAT','');
   if s='' then begin
    SetText;
    WriteLn;
    WriteLn(' Arquivo BOMB2.DAT n∆o encontrado. ');
    WriteLn(' Erro n£mero #0 - DGM. ');
    Sound(220); RDelay(250); NoSound;
    WriteLn; WriteLn;
    Halt(1);
   end;

  {$I-}
   Assign(f,'BOMB2.DAT'); Reset(f,1);
   Seek(f,filesize(f)-(809-41));
   BlockRead(f,opal,sizeof(opal));
   Close(f);
  {$I+}
   If IOResult<>0 then begin
    SetText;
    WriteLn;
    WriteLn(' Erro ao ler o arquivo BOMB2.DAT.');
    WriteLn(' Erro n£mero #0.5 - DGM. ');
    Sound(220); RDelay(250); NoSound;
    WriteLn; WriteLn;
    Halt(1);
   end;

   for r:=0 to 255 do SetPal( r, opal[r,1],opal[r,2],opal[r,3] );

   s:=FSearch('DGMLOGO.IMG','');
   if s='' then begin
    SetText;
    WriteLn;
    WriteLn(' Arquivo DGMLOGO.IMG n∆o encontrado. ');
    WriteLn(' Erro n£mero #1 - DGM. ');
    Sound(220); RDelay(250); NoSound;
    WriteLn; WriteLn;
    Halt(1);
   end;

  {$I-}
   Assign(f,'DGMLOGO.img');
   Reset(f,1);
   BlockRead(f,ex,2); BlockRead(f,ey,2);
   size:=BitMapAlloc( ex, ey, LOGO );
   Seek(f,filepos(f)-4); BlockRead(f,LOGO^,size); Close(f);
  {$I+}
   If IOResult<>0 then begin
    SetText;
    WriteLn;
    WriteLn(' Houve um erro ao ler o arquivo DGMLOGO.IMG.');
    WriteLn(' Erro n£mero #2 - DGM. ');
    Sound(220); RDelay(250); NoSound;
    WriteLn; WriteLn;
    Halt(1);
   end;

   setpal(0,53,53,0);
   cls(vga,0); cls(vaddr,0);
   rdelay(500);

   xx:=2;
   for r:=2 to round(ImageSizeY(LOGO)*1.8) do begin
    r:=r+3;
    if r>=round(ImageSizeY(LOGO)*1.8) then r:=round(ImageSizeY(LOGO)*1.8);
    ScaleZNC(154-(xx div 2),100-(r div 2),xx,r,LOGO,vaddr);
    {84 34  168 68 }
    waitretrace;
    flip(vaddr,vga);
    cls(vaddr,0);
    xx:=Round(r*2.5);
    if xx>=round(ImageSizeX(LOGO)*1.8) then xx:=round(ImageSizeX(LOGO)*1.8);
   end;


   LimpaTeclado;
   xx:=0;
   while (xx<100) and (t<>#13) do begin
    if keypressed then t:=ReadKey;
    xx:=xx+1;
    Rdelay(40);
   end;

   SaveOPal;
   FadeDown(63,3,0);
   RDelay(500);

   Cls(vga,0);

   BitMapFree( LOGO );

  End;

 End.