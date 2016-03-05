{
  TECLADO.PAS - Biblioteca de controle de Teclado

  Copyright (c) 1999 David Maziero / DGM Inform tica

  Data : 31 de Dezembro de 1999
}

  Unit Teclado;

  interface

  var
   Teclado_wait : Byte;
   Teclado_OP   : Byte;
   t : Char;
   arola    : Byte;
   rolatela : Integer;
   alerta,alerta2 : Integer;

   t_tic,t_hora,t_mim,t_sec : Integer;
   timer : Word;

  procedure Teclado_vetecla;
  procedure Teclado_Int; interrupt;
  procedure Teclado_Init;
  procedure Teclado_Done;
  procedure Teclado_InitTimer( ho,mim,sec : Word );

  implementation

  Uses Crt,Dos,dmode13h;

  var
   KbdIntVec : Procedure;
   BSAVE : Pointer;

procedure Teclado_InitTimer( ho,mim,sec : Word );
begin
 t_hora:=ho;
 t_mim:=mim;
 t_sec:=sec;
end;

{$F+}
procedure Teclado_vetecla;
begin

if timer=1 then begin
 t_tic:=t_tic+1;
 if t_tic>=18 then begin
  t_tic:=0;

  t_sec:=t_sec-1;
  if t_sec<0 then begin
   t_sec:=60;
   if t_mim=0 then t_sec:=0;
   if t_mim>0 then t_mim:=t_mim-1;
  end;
 end;
end;


 if alerta=1 then begin
  SetPal(0,alerta2,0,0);
  alerta2:=alerta2+5;
  if alerta2>=64 then begin alerta2:=63; alerta:=2; end;
 end;
 if alerta=2 then begin
  SetPal(0,alerta2,0,0);
  alerta2:=alerta2-5;
  if alerta2<=0 then begin alerta2:=1; alerta:=1; end;
 end;

 if arola=1 then begin
  c4moveto(0,rolatela);
  rolatela:=rolatela-2;
  if rolatela<1 then arola:=2;
 end;
 if arola=2 then begin
  c4moveto(0,rolatela);
  rolatela:=rolatela+2;
  if rolatela>6 then begin rolatela:=0; arola:=0; c4moveto(0,0); end;
 end;

 if not keypressed then begin
  teclado_op:=teclado_op+1;
  if teclado_op>=teclado_wait then begin teclado_op:=0; t:=#0; end;
 end;

 if keypressed then begin
  teclado_op:=0;
  t:=ReadKey;
  if keypressed then t:=ReadKey;
  if keypressed then t:=ReadKey;
  if keypressed then t:=ReadKey;
 end;
end;


procedure Teclado_Int;
begin
  Teclado_vetecla;
{  inline ($9C);
  KbdIntVec; }
end;
{$F-}

procedure Teclado_Init;
Begin
{  GetIntVec($9,@KbdIntVec);
  SetIntVec($9,Addr(Teclado_Int));}
  GetIntVec($1C,BSAVE);
  SetIntVec($1C,Addr(Teclado_Int));
  arola:=0;
  rolatela:=0;
  alerta:=0;
  alerta2:=0;
  t_tic:=0;
  timer:=0;
End;

procedure Teclado_Done;
Begin
{ SetIntVec($9,@KbdIntVec);}
 SetIntVec($1C,BSAVE);

End;

End.