{
   DGMLogo Unit 2.0 - by David Maziero

   DGM Inform†tica Logos

   Copyright (c) 1998 David Maziero / DGM Inform†tica

   Data : Fevereiro de 1999
}

   Unit DGMLogo;

   interface

   const

    DGM_GAME = 1;
    DGM_SIM  = 2;

   Procedure ShowDGMLogo( arq : String; pos : LongInt; tipo : Byte; video : Byte );

   implementation

   Uses Crt,Dos,Graph,writestr,PlayUnit;

   Procedure ShowDGMLogo( arq : String; pos : LongInt; tipo : Byte; video : Byte );
   var
    varia : Byte;
    a  : array[1..12] of Pointer;
    l  : array[1..6] of Pointer;
    r,w,w2,w3  : Word;
    ColaTipo,TiraTipo : Byte;
    s  : PathStr;
    nr : Word;
    erro : Byte;
    f : file;
    x,x2 : Word;
    y2 : Word;
    t : Char;
    node : Byte;
    label 1,2,3;
   Begin
     node:=0;
     Play;
     PlayInit('*');
     ClearDevice;
     if video=0 then begin ColaTipo:=CopyPut; TiraTipo:=XorPut; end;
     if video=1 then begin ColaTipo:=NotPut;  TiraTipo:=XorPut; end;
     if video=1 then begin setfillstyle(SOLIDFILL,WHITE); floodfill(1,1,1); end;
     erro:=0;
     s:=FSearch(arq,'');
     if s='' then begin
      CloseGraph;
      WriteLn;
      WriteLn(' O arquivo <',arq,'> n∆o foi encontrado. ');
      WriteLn(' Programa Abortado.');
      WriteLn; Halt(1);
     end;

     Assign(f,Arq); Reset(f,1);
     Seek(f, pos+(5*126)+150+144+(9*98)+52 );

     for r:=1 to 12 do begin
      if r<11  then GetMem(a[r],96);
      if r>=11 then GetMem(a[r],38);
      1:;
      if r<11  then BlockRead(f,a[r]^,96,nr);
      if r>=11 then BlockRead(f,a[r]^,38,nr);
     if r<11 then begin
      if nr<96 then begin
       if erro=0 then begin erro:=1; goto 1; end;
       CloseGraph;
       WriteLn; WriteLn(' Houve um erro ao ler o arquivo <',arq,'>. ');
       WriteLn(' Verifique se n∆o h† setores ruins em seu disco.  ');
       WriteLn; Halt(1);
      end;
     end;
     if r>=11 then begin
      if nr<38 then begin
       if erro=0 then begin erro:=1; goto 1; end;
       CloseGraph;
       WriteLn; WriteLn(' Houve um erro ao ler o arquivo <',arq,'>. ');
       WriteLn(' Verifique se n∆o h† setores ruins em seu disco.  ');
       WriteLn; Halt(1);
      end;
     end;
      erro:=0;
     end;

     Assign(f,Arq); Reset(f,1);
     Seek(f, pos );

     for r:=1 to 6 do begin
      if r<6 then GetMem(l[r],126);
      if r=6 then GetMem(l[r],150);
      2:;
      if r<6 then BlockRead(f,l[r]^,126,nr);
      if r=6 then BlockRead(f,l[r]^,150,nr);
      if nr<126 then begin
       if erro=0 then begin erro:=1; goto 1; end;
       CloseGraph;
       WriteLn; WriteLn(' Houve um erro ao ler o arquivo <',arq,'>. ');
       WriteLn(' Verifique se n∆o h† setores ruins em seu disco.  ');
       WriteLn; Halt(1);
      end;
      erro:=0;
     end;

     Randomize;
     varia:=random(1);

     x:=10;

     for r:=1 to 13 do begin
      if k_t[1]=#13 then node:=1;
      x:=x+2;
      PutImage(x,87,a[1]^,ColaTipo);
      if node=0 then RDelay(1);
      x:=x+2;
      PutImage(x,87,a[2]^,ColaTipo);
      if node=0 then RDelay(1);
     end;
      PutImage(x,87,a[1]^,ColaTipo);
      if node=0 then RDelay(8); { 9 }
      if k_t[1]=#13 then node:=1;
      PutImage(x,87,a[3]^,ColaTipo);
      if node=0 then RDelay(3); {4}
      PutImage(x,87,a[4]^,ColaTipo);
      if node=0 then RDelay(3); {4}

     for r:=1 to 4 do begin
      if k_t[1]=#13 then node:=1;
      PutImage(x,87,a[5]^,ColaTipo);
      if node=0 then RDelay(2); {3}
      PutImage(x,87,a[6]^,ColaTipo);
      if node=0 then RDelay(2); {3}
     end;

      if k_t[1]=#13 then node:=1;
      PutImage(x,87,a[7]^,ColaTipo);
      if node=0 then RDelay(1);
      x2:=x+23;
       PutImage(x2,89,a[11]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
       PutImage(x2-4,89,a[11]^,TiraTipo);
       PutImage(x2,89,a[12]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
      if k_t[1]=#13 then node:=1;
       PutImage(x2-4,89,a[12]^,TiraTipo);
       PutImage(x2,89,a[11]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
       PutImage(x2-4,89,a[11]^,TiraTipo);
       PutImage(x2,89,a[12]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
       PutImage(x2-4,89,a[12]^,TiraTipo);
       PutImage(x2,89,a[11]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
      if k_t[1]=#13 then node:=1;
       PutImage(x2-4,89,a[11]^,TiraTipo);
       PutImage(x2,89,a[12]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
       PutImage(x,87,a[4]^,ColaTipo);
      for r:=1 to 2 do begin
      if k_t[1]=#13 then node:=1;
       PutImage(x2-4,89,a[12]^,TiraTipo);
       PutImage(x2,89,a[11]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
       PutImage(x2-4,89,a[11]^,TiraTipo);
       PutImage(x2,89,a[12]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
      end;
       PutImage(x,87,a[3]^,ColaTipo);
      for r:=1 to 2 do begin
      if k_t[1]=#13 then node:=1;
       PutImage(x2-4,89,a[12]^,TiraTipo);
       PutImage(x2,89,a[11]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
       PutImage(x2-4,89,a[11]^,TiraTipo);
       PutImage(x2,89,a[12]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
      end;
      if k_t[1]=#13 then node:=1;
       PutImage(x,87,a[8]^,ColaTipo);
      for r:=1 to 3 do begin
       PutImage(x2-4,89,a[12]^,TiraTipo);
       PutImage(x2,89,a[11]^,ColaTipo);
      if k_t[1]=#13 then node:=1;
       if node=0 then RDelay(1);
       x2:=x2+4;
       PutImage(x2-4,89,a[11]^,TiraTipo);
       PutImage(x2,89,a[12]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
      end;

     for w:=1 to 2 do begin
      if k_t[1]=#13 then node:=1;
       PutImage(x,87,a[9]^,ColaTipo);
      for r:=1 to 2 do begin
      if k_t[1]=#13 then node:=1;
       PutImage(x2-4,89,a[12]^,TiraTipo);
       PutImage(x2,89,a[11]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
       PutImage(x2-4,89,a[11]^,TiraTipo);
       PutImage(x2,89,a[12]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
      end;
       PutImage(x,87,a[10]^,ColaTipo);
      for r:=1 to 2 do begin
      if k_t[1]=#13 then node:=1;
       PutImage(x2-4,89,a[12]^,TiraTipo);
       PutImage(x2,89,a[11]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
       PutImage(x2-4,89,a[11]^,TiraTipo);
       PutImage(x2,89,a[12]^,ColaTipo);
       if node=0 then RDelay(1);
       x2:=x2+4;
      end;
     end;
       PutImage(x2-4,89,a[12]^,TiraTipo);

     w3:=10; y2:=89;
     for w:=1 to 2 do begin
      Case w3 of
       9 : w3:=10;
       10: w3:=9;
      end;
      if k_t[1]=#13 then node:=1;
       PutImage(x,87,a[w3]^,ColaTipo);
       PutImage(x2,y2,a[w3+2]^,ColaTipo); y2:=y2+2;
       if node=0 then RDelay(2); {4}
       PutImage(x2,y2-2,a[w3+2]^,TiraTipo);
     end;
       y2:=y2+1;
       PutImage(x2,y2,a[w3+2]^,ColaTipo);

     r:=1;
     while r<90 do begin
      if k_t[1]=#13 then node:=1;
      PutImage(x,87,a[9]^,ColaTipo);
       PutImage(x2,y2,a[11]^,ColaTipo);
     for w:=1 to 2 do begin
      OutTextXY(109,r,  'INFORMATICA'); OutTextXY(113,r-3,'      '''); r:=r+8;
      if node=0 then RDelay(2);
      if video=0 then setcolor(0);
      if video=1 then setcolor(WHITE);
      OutTextXY(109,r-8,  'INFORMATICA'); OutTextXY(113,r-11,'      ''');
      if video=1 then setcolor(0);
      if video=0 then setcolor(WHITE);
     end;
      PutImage(x,87,a[10]^,ColaTipo);
       PutImage(x2,y2,a[12]^,ColaTipo);
     for w:=1 to 2 do begin
      OutTextXY(109,r,  'INFORMATICA'); OutTextXY(113,r-3,'      '''); r:=r+8;
      if k_t[1]=#13 then node:=1;
      if node=0 then RDelay(2);
      if video=0 then setcolor(0);
      if video=1 then setcolor(WHITE);
      OutTextXY(109,r-8,  'INFORMATICA'); OutTextXY(113,r-11,'      ''');
      if video=1 then setcolor(0);
      if video=0 then setcolor(WHITE);
    end;
    end;
     OutTextXY(109,105,  'INFORMATICA'); OutTextXY(113,102,'      ''');
      PutImage(x,87,a[9]^,ColaTipo);
       PutImage(x2,y2,a[11]^,ColaTipo);
      for r:=1 to 6 do begin
      if k_t[1]=#13 then node:=1;
       PutImage( 105, 70 + ((r-1)*5), l[r]^, ColaTipo);
       if r=4 then PutImage(x,87,a[10]^,ColaTipo);
       if node=0 then RDelay(1);
      end;
       if node=0 then RDelay(2);

     while keypressed do begin
      t:=ReadKey;
     end; t:=#0;

      w3:=10;
      node:=0;
      k_t[1]:=#0;

{     Play; }
     PlayInit('o1;r2;i2;knlmjnmjhbmjvgmjcfmjxdmjzsmjasmjsdmjasmjsdmjdfmjfdmjsdjmasmjmjj');

      for r:=1 to 6 do begin
       PutImage( 105, 70 + ((r-1)*5), l[r]^, TiraTipo);
      end;

     while t<>#13 do begin
      if k_t[1]=#13 then node:=1;
       if keypressed then t:=ReadKey;
       if t=#13 then goto 3;
       Case w3 of
        10 : w3:=9;
        9  : w3:=10;
       end;
       PutImage(x,87,a[w3]^,ColaTipo); w2:=6;
       PutImage(x2,y2,a[w3+2]^,ColaTipo);
       for r:=1 to 6 do begin
        PutImage( 105-w2, 70 + ((r-1)*5), l[r]^, ColaTipo); w2:=w2-1;
       end;
       if keypressed then t:=ReadKey;
       if t=#13 then goto 3;
       if node=0 then RDelay(2); w2:=6; {4}
       for r:=1 to 6 do begin
        PutImage( 105-w2, 70 + ((r-1)*5), l[r]^, TiraTipo); w2:=w2-1;
       end;
      if k_t[1]=#13 then node:=1;
       if keypressed then t:=ReadKey;
       if t=#13 then goto 3;
       Case w3 of
        10 : w3:=9;
        9  : w3:=10;
       end;
       PutImage(x,87,a[w3]^,ColaTipo); w2:=6;
       PutImage(x2,y2,a[w3+2]^,ColaTipo);
       for r:=1 to 6 do begin
        PutImage( 105, 70 + ((r-1)*5), l[r]^, ColaTipo); w2:=w2-1;
       end;
       if node=0 then RDelay(2); w2:=6;
       for r:=1 to 6 do begin
        PutImage( 105, 70 + ((r-1)*5), l[r]^, TiraTipo); w2:=w2-1;
       end;
       if k_t[1]=#13 then goto 3;
       Case w3 of
        10 : w3:=9;
        9  : w3:=10;
       end;
       PutImage(x,87,a[w3]^,ColaTipo); w2:=6;
       PutImage(x2,y2,a[w3+2]^,ColaTipo);
      if k_t[1]=#13 then node:=1;
       for r:=1 to 6 do begin
        PutImage( 105+w2, 70 + ((r-1)*5), l[r]^, ColaTipo); w2:=w2-1;
       end;
       if k_t[1]=#13 then goto 3;
       if node=0 then RDelay(2); w2:=6;
       for r:=1 to 6 do begin
        PutImage( 105+w2, 70 + ((r-1)*5), l[r]^, TiraTipo); w2:=w2-1;
       end;
       if k_t[1]=#13 then goto 3;
       Case w3 of
        10 : w3:=9;
        9  : w3:=10;
       end;
       PutImage(x,87,a[w3]^,ColaTipo); w2:=6;
       PutImage(x2,y2,a[w3+2]^,ColaTipo);
      if k_t[1]=#13 then node:=1;
       if keypressed then t:=ReadKey;
       if t=#13 then goto 3;
       for r:=1 to 6 do begin
        PutImage( 105, 70 + ((r-1)*5), l[r]^, ColaTipo); w2:=w2-1;
       end;
       if node=0 then RDelay(2); w2:=6;
       if t=#13 then goto 3;
       for r:=1 to 6 do begin
        PutImage( 105, 70 + ((r-1)*5), l[r]^, TiraTipo); w2:=w2-1;
       end;
      end;

    3:;

     for r:=1 to 6 do begin
      PutImage( 105, 70 + ((r-1)*5), l[r]^, ColaTipo); w2:=w2-1;
     end;

     r:=1;
     for r:=1 to 12 do begin
      if r<11  then GetMem(a[r],96);
      if r>=11 then GetMem(a[r],38);
     end;
     r:=1;
     for r:=1 to 6 do begin
      if r<6 then GetMem(l[r],126);
      if r=6 then GetMem(l[r],150);
     end;



    Stop;

   End;

   End.
