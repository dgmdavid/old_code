{

   DGM PCX Library for 320x200x256 mode v1.0

   Copyright (c) 1999 David Maziero / DGM Informatica

   Data : Novembro de 1999

   Biblioteca de funcoes Graficas para formato PCX

}

UNIT DGMPCX;

Interface

Uses crt;

type
 PalType = array[0..255,1..3] of Byte;

Function  DisplayPCX    ( arq : String; where : word; dopal : Boolean ) : Boolean;
Function  DisplayPCXSize( arq : String; pos : LongInt; size : Word; where : word; dopal : Boolean ) : Boolean;
Procedure DoPCXPAL ( arq : String; pos : LongInt; size : Word; var pal : PalType );

Implementation


Procedure DoSinglePal(Col,R,G,B : Byte); assembler;
asm
   mov    dx,3c8h
   mov    al,[col]
   out    dx,al
   inc    dx
   mov    al,[r]
   out    dx,al
   mov    al,[g]
   out    dx,al
   mov    al,[b]
   out    dx,al
end;


Function DisplayPCX   ( arq : String; where : word; dopal : Boolean ) : Boolean;
Var
 f : file;
 res,loop1 : word;
 temp : pointer;
 pallette : Array[0..767] Of Byte;

Begin
  Assign (f,arq);
  Reset (f,1);
  if dopal then BEGIN
   Seek(f,FileSize(f)-768);
   BlockRead(f,pallette,768);
    For loop1:=0 to 255 do
     DoSinglePal (loop1,pallette[loop1*3] shr 2,pallette[loop1*3+1] shr 2,pallette[loop1*3+2] shr 2);
    end;
   Seek (f,128);

  GetMem(temp,65535);
  BlockRead (f,temp^,65535,res);

  asm
    push ds
    mov  ax,where
    mov  es,ax
    xor  di,di
    xor  ch,ch
    lds  si,temp
@Loop1 :
    lodsb
    mov  bl,al
    and  bl,$c0
    cmp  bl,$c0
    jne  @Single
    mov  cl,al
    and  cl,$3f
    lodsb
    rep  stosb
    jmp  @Fin
@Single :
    stosb
@Fin :
    cmp  di,63999
    jbe  @Loop1
    pop  ds
  end;
  FreeMem (temp,65535);
  Close (f);
END;

Function DisplayPCXSize( arq : String; pos : LongInt; size : Word; where : word; dopal : Boolean ) : Boolean;
Var
 f : file;
 res,loop1 : word;
 temp : pointer;
 pallette : Array[0..767] Of Byte;

Begin
  Assign (f,arq);
  Reset (f,1);
  if dopal then BEGIN
   Seek(f,pos+size-768);
   BlockRead(f,pallette,768);
    For loop1:=0 to 255 do
     DoSinglePal (loop1,pallette[loop1*3] shr 2,pallette[loop1*3+1] shr 2,pallette[loop1*3+2] shr 2);
    end;
   Seek (f,pos+128);

  GetMem(temp,size);
  BlockRead (f,temp^,size,res);

  asm
    push ds
    mov  ax,where
    mov  es,ax
    xor  di,di
    xor  ch,ch
    lds  si,temp
@Loop1 :
    lodsb
    mov  bl,al
    and  bl,$c0
    cmp  bl,$c0
    jne  @Single
    mov  cl,al
    and  cl,$3f
    lodsb
    rep  stosb
    jmp  @Fin
@Single :
    stosb
@Fin :
    cmp  di,63999
    jbe  @Loop1
    pop  ds
  end;
  FreeMem (temp,size);
  Close (f);
END;

Procedure DoPCXPAL ( arq : String; pos : LongInt; size : Word; var pal : PalType );
Var
 f : file;
 res,loop1 : word;
 temp : pointer;
 pallette : Array[0..767] Of Byte;

Begin
  Assign (f,arq);
  Reset (f,1);
  Seek(f,pos+size-768);
  BlockRead(f,pallette,768);
  For loop1:=0 to 255 do begin
   pal[loop1,1]:=pallette[loop1*3] shr 2;
   pal[loop1,2]:=pallette[loop1*3+1] shr 2;
   pal[loop1,3]:=pallette[loop1*3+2] shr 2;
 end;
  Close (f);
END;


End.
