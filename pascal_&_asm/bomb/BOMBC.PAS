{
  Bomb v1.0 - Fun‡äes Complementares 
                                     
   Copyright (c)1997 David Maziero / DGM Inform tica
}    

    Unit BOMBC;

    interface

    uses
     Crt, Dos, Graph;

    const
     FRENTE  =  #77;
     TRAS    =  #75;
     BAIXO   =  #80;
     CIMA    =  #72;

     function Str2(L : LongInt) : string;
     procedure WriteOut(X,Y : Integer ; S : string);
     procedure WriteTime(X,Y : Integer; A,B,C,D : Word);
     procedure Graphics(GraphMode,GraphType : Integer; Bgi : String);
     procedure OutTextCenter(x,y : Word; text : String);
     function LoadBitMap(nome : String; var img : Pointer) : Word ;
    procedure FreeBitMap(nome : String; var img : Pointer);
     function perg( abc : String ) : Char;
     procedure LimpaTeclado;
     procedure Pause;


     implementation

     function Str2(L : LongInt) : string;
     var
     S : string;
     begin
     Str(L, S);
     Str2 := S;
     end;

     procedure WriteOut(X,Y : Integer ; S : string);
     begin
     OutTextXY(X, Y, S);
     end;

     procedure WriteTime(X,Y : Integer ; A,B,C,D : Word);
     begin
      WriteOut(X, Y, Str2(A)+':'+Str2(B)+':'+Str2(C)+'.'+Str2(D));
     end;

     procedure Graphics(GraphMode,GraphType : Integer; Bgi : String);
     Var
         gm,gt : Integer;
     begin
      gm := GraphMode;
      gt := GraphType;
      InitGraph(gm,gt,Bgi);
     end;

     procedure Pause;
     var
      espera : Char;
     Begin
      espera :=#0;
      While espera <> #13 do Begin espera := ReadKey; End;
     End;

     procedure OutTextCenter(x,y : Word; text : String);
     var
      ts : TextSettingsType;
     begin
      GetTextSettings(ts);
      SetTextJustify(CenterText, CenterText);
      OutTextXY(Succ(GetMaxX) div 2-10+x,
                Succ(GetMaxY) div 2+y,text);
      with ts do
      begin
       SetTextJustify(Horiz,Vert);
      end;
     end;

     function LoadBitMap(nome : String; var img : Pointer) : Word;
     var
      fileimg : File;
      size : Word;
     Begin
      Assign(fileimg,nome); Reset(fileimg,1);
      size:=FileSize(fileimg);

      GetMem(img,size);

      Reset(fileimg,size);
      BlockRead(fileimg,img^,1);
      Close(fileimg);

      LoadBitMap:=size;

     End;

    procedure FreeBitMap(nome : String; var img : Pointer);
     var
      fileimg : File;
      size : Word;
     Begin
      Assign(fileimg,nome); Reset(fileimg,1);
      size:=FileSize(fileimg);
      Close(fileimg);
      FreeMem(img,size);
     End;

     function perg( abc : String ) : Char;
     var
      def : array[1..50] of String[1];
      r,rr : Word;
      t : Char;
     Begin
      For r:=1 to 50 do def[r]:=Copy(abc,r,1);
      rr:=0; r:=1;
      while rr=0 do begin
       t:=ReadKey;
       for r:=1 to 50 do begin
        if t=def[r] then rr:=r;
       end;
      end;
      Perg:=t;
     End;

     procedure LimpaTeclado;
     var
      t : Char;
     Begin
      while keypressed do begin
       t:=ReadKey;
      end;
     End;

     end.
