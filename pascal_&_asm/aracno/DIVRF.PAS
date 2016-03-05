{
  DGM Unit v2.0

  DIVRF.INT - Diverses Functions Unit

  Copyright (c) 1999 David Maziero / DGM Informatica

  Data : 22 de Marco de 1999
}

  Unit DIVRF;

  interface

  const
   FRENTE  =  #77;
   TRAS    =  #75;
   BAIXO   =  #80;
   CIMA    =  #72;
   pFRENTE =  77;
   pTRAS   =  75;
   pBAIXO  =  80;
   pCIMA   =  72;

  function  Str2(L : LongInt) : string;
  function  Val2(S : String) : LongInt;
  function  perg( abc : String ) : Char;
  procedure Pause;
  procedure LimpaTeclado;
  procedure WriteHexByte( b : Byte );
  procedure WriteHexWord( w : Word );
  function  LZero(w : Word; zeros : Byte ) : String;


  implementation

  Uses Crt;

  function LZero(w : Word; zeros : Byte ) : String;
  var
    s,s2 : String;
    r : Word;
  begin
    Str(w:0,s);
    s2:='';
 if Length(s)<zeros then
   for r:=1 to zeros-Length(s) do s2:=s2+'0';
     s := s2+s;
    LZero := s;
  end;


  procedure WriteHexByte( b : Byte );
  const
   he : array[0..15] of Char = ( '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
  begin
   write( he[(b shr 4)] );
   write( he[(b and $F)] );
  end;

  procedure WriteHexWord(w: Word);
  const
   hexChars: array [0..$F] of Char =
     '0123456789ABCDEF';
  begin
   Write(hexChars[Hi(w) shr 4],
         hexChars[Hi(w) and $F],
         hexChars[Lo(w) shr 4],
         hexChars[Lo(w) and $F]);
  end;



  function Str2(L : LongInt) : string;
  var
   S : string;
  begin
   Str(L, S);
   Str2 := S;
  end;

  function Val2(S : String) : LongInt;
  var
   code : Integer;
   i    : LongInt;
  begin
   Val(s,i,code);
   Val2:=i;
  end;

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

  procedure Pause;
  var
   espera : Char;
  Begin
   espera :=#0;
   LimpaTeclado;
   While espera <> #13 do Begin espera := ReadKey; End;
  End;

  procedure LimpaTeclado;
  var
   t : Char;
  Begin
   while keypressed do begin
    t:=ReadKey;
   end;
  End;

  End.
