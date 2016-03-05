{
  PlayUnit v1.0 - Unidade geradora de m£sica de fundo

  Copyright (c) 1999 David Maziero / DGM Inform tica
}

  Unit PlayUnit;

  interface

  var
   k_t : array[1..18] of Char;
   k_t2: array[1..18] of Char;
   k_tt: array[1..18] of Word;
   k_lim : Word;
   BSave : Pointer;

  procedure PlayInit(IMu : String);
  procedure Play;
  procedure Play2; interrupt;
  procedure Stop;
  procedure SSetTime1( ho,mi,se,hu : Byte );
  procedure GGetTime1( var ho,mi,se,hu : Byte );
  procedure SSetTime2( ho,mi,se,hu : Byte );
  procedure GGetTime2( var ho,mi,se,hu : Byte );
  function  IsMusic : Byte;
  procedure InitPCont;
  procedure RDelay( t : Byte );
  procedure ResetKeys;

  implementation

  Uses Crt,Dos;

  var
     Mu : String;
     Duracao : Word;
     Intervalo : Word;
     Oitava : Word;
     Cont   : Word;
     Cint   : Word;
     Nota   : Word;
     k_vezes : Byte;
     k_lt    : Byte;
     t_vezes : Byte;
     m_vezes : Byte;
     m_ve2   : Byte;
     ve,ve2,ve3,ve4 : Byte;
     hora,min,sec,hund : Byte;
     hora2,min2,sec2,hund2 : Byte;
     final : Byte;
     exclusive : Byte;

   function IsMusic : Byte;
   Begin
    IsMusic:=final;
   End;

   procedure SSetTime1( ho,mi,se,hu : Byte );
   Begin
    hora:=ho;
    min:=mi;
    sec:=se;
    hund:=hu;
    ve:=0; ve2:=0;
   End;

   procedure SSetTime2( ho,mi,se,hu : Byte );
   Begin
    hora2:=ho;
    min2:=mi;
    sec2:=se;
    hund2:=hu;
    ve3:=0; ve4:=0;
   End;

   procedure GGetTime1( var ho,mi,se,hu : Byte );
   Begin
    ho:=hora;
    mi:=min;
    se:=sec;
    hu:=hund;
   End;

   procedure GGetTime2( var ho,mi,se,hu : Byte );
   Begin
    ho:=hora2;
    mi:=min2;
    se:=sec2;
    hu:=hund2;
   End;

  {$F+}
  procedure Play2;
  var
   n : String[5];
   fre : Word;
   r,rr : String;
   w : Byte;
   code : Integer;
   er,err : Word;
   label 1;
  Begin

{*** M¢dulo de Tempo (1 e 2) ***********************************************}

    t_vezes:=t_vezes+1;

    ve:=ve+1;
    hund:=hund+5;

    if ve=18 then hund:=0;

    if ve2<5 then begin
     if ve=18 then begin
      ve:=0;
      ve2:=ve2+1;
      sec:=sec+1;
      if sec=60 then begin sec:=0; min:=min+1; end;
      if min=60 then begin min:=0; hora:=hora+1; end;
     end;
    end;

    if ve2>=5 then begin
     if ve=19 then begin
      ve:=0;
      ve2:=0;
      sec:=sec+1;
      if sec=60 then begin sec:=0; min:=min+1; end;
      if min=60 then begin min:=0; hora:=hora+1; end;
     end;
    end;

    ve3:=ve3+1;
    hund2:=hund2+5;

    if ve3=18 then hund2:=0;

    if ve4<5 then begin
     if ve3=18 then begin
      ve3:=0;
      ve4:=ve4+1;
      sec2:=sec2+1;
      if sec2=60 then begin sec2:=0; min2:=min2+1; end;
      if min2=60 then begin min2:=0; hora2:=hora2+1; end;
     end;
    end;

    if ve4>=5 then begin
     if ve3=19 then begin
      ve3:=0;
      ve4:=0;
      sec2:=sec2+1;
      if sec2=60 then begin sec2:=0; min2:=min2+1; end;
      if min2=60 then begin min2:=0; hora2:=hora2+1; end;
     end;
    end;

{*** Fim do M¢dulo de Tempo (1 e 2) ****************************************}

{*** M¢dulo de Teclado *****************************************************}

   if k_lim>0 then begin
    k_vezes:=k_vezes+1;

    if k_vezes>=k_lim then
    begin
     for w:=1 to 18 do k_t[w]:=#0;
     for w:=1 to 18 do k_t2[w]:=#0;
     for w:=1 to 18 do k_tt[w]:=0;
     k_vezes:=0; k_lt:=0;
    end;

    if KeyPressed then begin

     for w:=18 downto 2 do k_t[w]:=k_t[w-1];
     for w:=18 downto 2 do k_t2[w]:=k_t2[w-1];
     for w:=18 downto 2 do k_tt[w]:=k_tt[w-1];

     k_t[1]:=ReadKey;
     if k_lt<18 then k_lt:=k_lt+1;
     k_t2[1]:=#0;
     k_tt[1]:=0;
     for w:=2 to 18 do
      if k_t[w]<>#0 then begin w:=18; k_tt[1]:=k_vezes; end;
     if k_t[1]=#0 then begin k_t[1]:=ReadKey; k_t2[1]:='*'; end;
     k_vezes:=0;

    end;
   end;

{*** Fim do M¢dulo de Teclado **********************************************}


   if final=0 then begin
    If (Cont=0) and (Cint=1) then begin n := Mu[Nota];end;

     if n='*' then begin nosound; final:=1; exclusive:=0; goto 1; end;
     if n='#' then exclusive:=1;
     if(n='@') and (nota>1) then exclusive:=0;

    if m_vezes=0 then begin
     If n='^' then Begin
       Nota:=Nota+1; rr:=Mu[Nota]; r:='';
       while rr<>';' do Begin
         r:=r+Mu[Nota]; Nota:=Nota+1;
         rr:=Mu[Nota];  end;
        Val(r, m_vezes ,code); Cont:=0; Cint:=1; m_ve2:=0;
      end;
     end
     else
     begin
      If n='^' then Begin
        Nota:=Nota+1; rr:=Mu[Nota]; r:='';
        while rr<>';' do Begin
          r:=r+Mu[Nota]; Nota:=Nota+1;
          rr:=Mu[Nota];  end;
          Cont:=0; Cint:=1;
       end;
     end;

     If n='R' then Begin
       Nota:=Nota+1; rr:=Mu[Nota]; r:='';
       while rr<>';' do Begin
         r:=r+Mu[Nota]; Nota:=Nota+1;
         rr:=Mu[Nota];  end;
        Val(r, Duracao ,code); Cont:=0; Cint:=1;
      end;
     If n='I' then Begin
       Nota:=Nota+1; rr:=Mu[Nota]; r:='';
       while rr<>';' do Begin
         r:=r+Mu[Nota]; Nota:=Nota+1;
         rr:=Mu[Nota];  end;
        Val(r, Intervalo ,code); Cont:=0; Cint:=1;
      end;
     If n='O' then Begin
       Nota:=Nota+1; rr:=Mu[Nota]; r:='';
       while rr<>';' do Begin
         r:=r+Mu[Nota]; Nota:=Nota+1;
         rr:=Mu[Nota];  end;
        Val(r, Oitava ,code); Cont:=0; Cint:=1;
      end;

    If (n='O') or (n='I') or (n='R') or (n=' ') or (n='^') then
    Begin
     Nota:=Nota+1;
     If Nota=Length(Mu)+1 then Nota:=1;
     If (Cont=0) and (Cint=1) then begin n := Mu[Nota];end;
    End;

     If (cint=1) and (cont=0) then begin

     if n='&' then begin
      Nota:=Nota+1; r:='';
      r:=r+Mu[Nota]; Nota:=Nota+1;
      r:=r+Mu[Nota]; Nota:=Nota+1;
      r:=r+Mu[Nota];
      Val(r, Fre ,code);
      Sound( Fre );
     end;

     If n='A' then Sound( 30  + Oitava * 50);
     If n='S' then Sound( 50  + Oitava * 50);
     If n='D' then Sound( 77  + Oitava * 50);
     If n='F' then Sound( 99  + Oitava * 50);
     If n='G' then Sound( 120 + Oitava * 50);
     If n='H' then Sound( 166 + Oitava * 50);
     If n='J' then Sound( 190 + Oitava * 50);
     If n='K' then Sound( 220 + Oitava * 50);
     If n='L' then Sound( 266 + Oitava * 50);
     If n='Z' then Sound( 333 + Oitava * 50);
     If n='X' then Sound( 435 + Oitava * 50);
     If n='C' then Sound( 444 + Oitava * 50);
     If n='V' then Sound( 490 + Oitava * 50);
     If n='B' then Sound( 533 + Oitava * 50);
     If n='N' then Sound( 585 + Oitava * 50);
     If n='M' then Sound( 600 + Oitava * 50);
     If n='Q' then Sound( 150 + Oitava * 50);
     If n='W' then Sound( 200 + Oitava * 50);
     If n='E' then Sound( 555 + Oitava * 50);
     If n='T' then Sound( 595 + Oitava * 50);
     If n='Y' then Sound( 615 + Oitava * 50);
     If n='U' then Sound( 355 + Oitava * 50);
     If n='P' then Sound( 395 + Oitava * 50);
     If n='.' then NoSound;
     If n=',' then Sound(29);
     If n='?' then Sound(Random(600));
     If n='!' then Sound(Random(300)+300);
     If n='[' then sound(Random(2000));
     If n=']' then sound(Random(5000));

   End;
   If Cont<Duracao then begin Cont:=Cont+1;Cint:=0;end;
   If (Cont=Duracao) and (Cint<Intervalo) then Begin cint:=cint+1;End;
   If Cint=Intervalo then Begin Cont:=0;Cint:=1;nota:=nota+1;End;
   If Cint>=2 then NoSound;
   If Nota=Length(Mu)+1 then Nota:=1;
   If Nota=1 then begin
    If m_vezes>0 then m_ve2:=m_ve2+1;
    If(m_vezes>0) and (m_ve2>=m_vezes) then begin m_vezes:=0; m_ve2:=0; final:=1; nosound; end;
   end;
  end;
   1:;
  End;   { Play2 }
  {$F-}

  procedure InitPCont;
  begin
   t_vezes:=0;
  end;

  Procedure RDelay( t : Byte );
  Begin
   InitPCont;
   while t_vezes<=t do begin end;
  End;

  procedure PlayInit(IMu : String);
  var
   scan : Byte;
   Ssca : String;
   r,rr : String;
   i    : Word;
   code : Integer;
  Begin
    If Copy(IMu,1,1)='@' then exclusive:=0;

   if exclusive=0 then begin
    Cont := 0; Nota :=1; Cint :=1;
    Duracao:=2;
    Intervalo:=2;
    Oitava:=1;
    m_vezes:=0; m_ve2:=0;
    Mu := IMu;
    if Mu[1]='#' then exclusive:=1;
    if Mu[2]='#' then exclusive:=1;
    For scan :=1 to length(Mu) do    { Converte para UpCase }
     Begin
      Mu[scan] := UpCase(Mu[scan]);
     End;
    final:=0;
   end;
  End;   { Init }

  procedure Play;
  var r : Byte;
  Begin
   Cont := 0; Nota :=1; Cint :=1; exclusive:=0;
   final:=1; m_vezes:=0; m_ve2:=0;
   hora:=0; min:=0; sec:=0; ve:=0; ve2:=0;
   hora2:=0; min2:=0; sec2:=0; ve3:=0; ve4:=0;
   k_lt:=0; k_lim:=18*2;
   for r:=1 to 18 do k_t[r]:=#0;
   for r:=1 to 18 do k_t2[r]:=#0;
   for r:=1 to 18 do k_tt[r]:=0;
   k_vezes:=0;
   GetIntVec($1C,BSave);
   SetIntVec($1C,Addr(Play2));
  End;   { Play }

  procedure Stop;
  Begin
   final:=1;
   NoSound;
   SetIntVec($1C,BSave);
   NoSound;
  End;   { Stop }

  procedure ResetKeys;
  var r : Byte;
  Begin
   k_lt:=0;
   for r:=1 to 18 do k_t[r]:=#0;
   for r:=1 to 18 do k_t2[r]:=#0;
   for r:=1 to 18 do k_tt[r]:=0;
   k_vezes:=0;
  End;



  End.