{                                                       }
{  Bomb v1.0 - Arquivo de Apresenta‡ƒo                  }
{                                                       }
{  Copyright (c) 1999 David Maziero / DGM Inform tica   }
{                                                       }
{  22 de julho de 1997                                  }
{                                                       }

  Unit Apren;

  interface

  procedure Apresenta(atraso : Word);

  implementation

  Uses Crt,Dos,Graph,BombC,PlayUnit;

  procedure Apresenta(atraso : Word);
  var
   De : array[1..10] of Pointer;
   f  : File;
   s  : PathStr;
   x,y,r : Word;
   xx : Integer;
   t : Char;
   Atra : Word;
  Begin
   GetMem( De[1] , 96  ); GetMem( De[2] , 96  );
   GetMem( De[3] , 96  ); GetMem( De[4] , 114 );
   GetMem( De[5] , 114 ); GetMem( De[6] , 38  );
   GetMem( De[7] , 102 ); GetMem( De[8] , 126 );
   GetMem( De[9] , 126 ); GetMem( De[10], 126 );

   s:=FSearch('APRE.DAT','');
   if s='' then Begin
     CloseGraph; WriteLn;
     WriteLn(' Erro : Arquivo APRE.DAT nƒo encontrado.');
     WriteLn; Halt(1);
    End;

   Assign(f,'APRE.DAT'); Reset(f,1);
   BlockRead(f,De[1]^ ,96);  BlockRead(f,De[2]^ ,96);
   BlockRead(f,De[3]^ ,96);  BlockRead(f,De[4]^ ,114);
   BlockRead(f,De[5]^ ,114); BlockRead(f,De[6]^ ,38);
   BlockRead(f,De[7]^ ,102); BlockRead(f,De[8]^ ,126);
   BlockRead(f,De[9]^ ,126); BlockRead(f,De[10]^,126);
   Close(f);

   Play;
   PlayInit('*');

   x:=10;
   y:=40;
   Line(5,55,310,55);
   Line(5,128,310,128);
   SetTextStyle(SMALLFONT,HORIZDIR,4);
   OutTextXY(5,185,'Copyright (c) 1997 David Maziero / DGM Inform tica');
   atra:=1;
   If KeyPressed then begin t:=ReadKey; Atra:=0; end;

   For r:=1 to 40 do begin
    x:=x+1; PutImage(x,y,De[1]^,CopyPut); if(Atra>0) and (r mod 2 =0 ) then RDelay(1);
    x:=x+1; PutImage(x,y,De[2]^,CopyPut); if(Atra>0) and (r mod 2 =0 ) then RDelay(1);
    If KeyPressed then begin t:=ReadKey; Atra:=0; end;
   End;
   if Atra>0 then RDelay(4);
   
    SetColor(0); Line(x-2,55,x+20,55); SetColor( WHITE );
    Line(x-2,55,x-2,65); Line(x+20,55,x+20,65);
    PutImage(x,y,De[2]^,XorPut);
    PutImage(x,y,De[3]^,CopyPut);
    PutImage(x+20,y-4,De[6]^,CopyPut);
    If Not KeyPressed then begin 
     if Atra>0 then RDelay(20);
    end;
    
    PutImage(x+20,y-4,De[6]^,XorPut);
    PutImage(x,y,De[3]^,XorPut);
    Atra:=1;
   For r:=1 to 35 do begin
    y:=y+1; PutImage(x,y,De[4]^,CopyPut); if(Atra>0) and (r mod 3 =0 ) then RDelay(1);
    y:=y+1; PutImage(x,y,De[5]^,CopyPut); if(Atra>0) and (r mod 3 =0 ) then RDelay(1);
    If KeyPressed then begin t:=ReadKey; Atra:=0; end;
   End;
    PutImage(x,y,De[5]^,XorPut);
    PutImage(x,y+7,De[7]^,CopyPut);
    Sound(50); if Atra>0 then RDelay(10);
    NoSound;
    PutImage(x,y+7,De[7]^,XorPut);
    Line(5,128,310,128);
    Atra:=1;
   For r:=1 to 6 do begin
    PutImage(x,y-2,De[8]^,CopyPut); if Atra>0 then RDelay(1);
    PutImage(x,y-2,De[9]^,CopyPut); if Atra>0 then RDelay(1);
    PutImage(x,y-2,De[10]^,CopyPut);if Atra>0 then RDelay(1);
    PutImage(x,y-2,De[9]^,CopyPut); if Atra>0 then RDelay(1);
    If KeyPressed then begin t:=ReadKey; Atra:=0; end;
   End;
    PutImage(x,y-2,De[9]^,XorPut);
    PutImage(x,y+3,De[1]^,CopyPut);

    y:=60; xx:=330;
   SetTextStyle(TRIPLEXFONT,HORIZDIR,5);
   For r:=1 to 100 do begin
    xx:=xx-5;
    OutTextXY(xx,y,'Bomb'); if(Atra>0) and (r mod 3 = 0) then RDelay(1);
    SetColor(0); OutTextXY(xx,y,'Bomb'); SetColor(WHITE);
   end;
   xx:=330;
   SetTextStyle(TRIPLEXFONT,HORIZDIR,4);
   For r:=1 to 95 do begin
    xx:=xx-8;
    If KeyPressed then begin t:=ReadKey; r:=95; end;
    OutTextXY(xx,y,'DGM Inform tica'); if(Atra>0) and (r mod 3 = 0) then RDelay(1);
    SetColor(0); OutTextXY(xx,y,'DGM Inform tica'); SetColor(WHITE);
   end;
   xx:=330; y:=y+8;
   SetTextStyle(TRIPLEXFONT,HORIZDIR,3);
   For r:=1 to 70 do begin
    xx:=xx-15;
    If KeyPressed then begin t:=ReadKey; r:=70; end;
    OutTextXY(xx,y,'Copyright (c) 1997 David Maziero / DGM Inform tica'); if(Atra>0) and (r mod 3=0) then RDelay(1);
    SetColor(0); OutTextXY(xx,y,'Copyright (c) 1997 David Maziero / DGM Inform tica'); SetColor(WHITE);
   end;

   xx:=330; y:=y+8;
   SetTextStyle(TRIPLEXFONT,HORIZDIR,3);
   For r:=1 to 110 do begin
    xx:=xx-15;
    If KeyPressed then begin t:=ReadKey; r:=110; end;
    OutTextXY(xx,y,'Programador : David Maziero / Test Players : Ezio R. Grangel / Lucas M. / Flavio M. / Marcus V.');
if(Atra>0) and (r mod 3 = 0) then RDelay(1);;
    SetColor(0);
       OutTextXY(xx,y,'Programador : David Maziero / Test Players : Ezio R. Grangel / Lucas M. / Flavio M. / Marcus V.');
    SetColor(WHITE);

   end;


    y:=60; xx:=330;
   SetTextStyle(TRIPLEXFONT,HORIZDIR,6);
   For r:=1 to 50 do begin
    xx:=xx-5;
    OutTextXY(xx,y,'Bomb'); if(Atra>0) and (r mod 3 = 0) then RDelay(1);
    SetColor(0); OutTextXY(xx,y,'Bomb'); SetColor(WHITE);
   end;
    OutTextXY(xx,y,'Bomb');
    SetTextStyle(SMALLFONT,HORIZDIR,4);
    OutTextXY(xx+15,135,'Pressione ENTER...');
    LimpaTeclado;
    Pause;
    ClearDevice;

   FreeMem( De[1] , 96  ); FreeMem( De[2] , 96  );
   FreeMem( De[3] , 96  ); FreeMem( De[4] , 114 );
   FreeMem( De[5] , 114 ); FreeMem( De[6] , 38  );
   FreeMem( De[7] , 102 ); FreeMem( De[8] , 126 );
   FreeMem( De[9] , 126 ); FreeMem( De[10], 126 );
   Stop;

  End;

  End.


