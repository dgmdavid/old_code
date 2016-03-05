{
  DGMSBDSP v1.0

  Bibliteca basica para playback de samples WAV de 8bit-mono.
  placa Sound Blaster DSP

  ++funcao de Timer com hardware Pit Chip,
                        para SB_MAXCH soms ao mesmo tempo.++

  Copyright (c) 20000 David Maziero / DGM Informatica

  Data : 21/10/2000
}

{$S-,F+,B-,R-,G+}
{$IFDEF DPMI}
{$C FIXED PRELOAD PERMANENT}
{$ENDIF}

Unit DGMSBDSP;

Interface

{ constantes para o timer }
const  TIMERINTR = $08;
       PIT_FREQ = $1234DD;
       SB_MAXCH = 16; { default para 16 canais, mude se necess rio }
       SB_SLOW  = 1;
       SB_FAST  = 2;

type
 SoundStruct = record
  sege,ofe : Word; { segmento e offset do pointer de som }
  size     : Word; { tamanho do som }
  vm,vd    : Byte; { volume-multiplier/volume-divisor }
  act      : Byte; { 0- nÆo est  sendo repro.(pare) / 1- est  (repro) }
  pos      : Word; { a posi‡Æo do som/ se pos>=size act ser  zerado }
  is       : Byte; { se h  um som aqui!, caso contr rio, nem tenta tocar se act=1 }
  modo     : Byte; { o modo como ser  reproduzido :
                      0- uma s¢ vez  /  1- continuo  / 2 - modo job      }
  rate     : Word; { a taxa de incrementa‡Ço do som }
  pos2     : LongInt; { a posi‡Æo do som }
 end;

var
 SB_vocs : array[1..SB_MAXCH] of SoundStruct;

 SB_bload : Word; { bytes a ler de uma vez no Long-Playback (por segundo) }
 SB_lpon  : Byte; { se o LP est  ativo ou nÆo }
 SB_lppos : LongInt; { a posi‡Æo do LP }
 SB_lppos2: LongInt; { a posi‡Æo do LP }
 SB_lptax : word; { a taxa }
 SB_lpti  : Byte; { contagem dos ticks do LP }
 SB_lpfpos: LongInt; { a posi‡Æo no arquivo }
 SB_lpfile: file;
 SB_lpm,SB_lpd,SB_lppara : Byte;
 SB_snd : array[0..1] of Pointer;
 SB_qsnd: Byte;

 SB_TFRE : Word;
 SB_TFRE2: Word;

 SB_DETECTED : Boolean; { SB foi detectado? }
 SB_SPEED    : Byte;  { SB_FAST ou SB_SLOW }

{ ativa servi‡os do RATE-GENERATOR }
Procedure SetTimer( frequency : word );
Procedure RESetTimer( frequency : word );

{ desativa o timer }
Procedure CleanUpTimer;

{ reseta valores dos canais de som - deve ser executado primeiro! }
Procedure ResetChannels;

{ atribui um som a um canal }
Procedure SetChannel( ch : Byte; s,o,si : Word; m,d,mo : Byte; rate : word );

{ reproduz esse canal }
Procedure PlayChannel( ch,mo : Byte; rate : word );

{ fun‡Æo do DGM LONG-PLAYBACK }
procedure SetUpLP( bytes : Word ); { aloca mem¢ria para SB_snd[1 e 2] (buffeer) }
procedure PlayLP ( nome : String; pos : LongInt; bload : Word; vm,vd : Byte; tax : word );
procedure StopLP;
procedure PauseLP;
procedure ContinueLP;
function IsPlayLP : Boolean; { se o LP est  ativo atualmente }

{ interrompe o canal, reseta a posi‡Æo para 0 }
Procedure StopChannel( ch : Byte );

{ para de tocar o canal }
Procedure PauseChannel(ch : Byte );

{ continua de onde parou }
Procedure ContinueChannel(ch : Byte );

{ muda a propriedade de vol.multiplier e vol.divisor do canal }
Procedure SetMDChannel( ch : Byte; m,d : Byte );

{ verifica se um canal est  sendo reproduzido atualmente }
function IsPlaying( ch : Byte ) : Boolean;

{ Retorna TRUE se resetou o chip DSP, ou FALSE se nÆo ( a¡ o base est  errado )
  base : 1- 210h, 2- 220h etc  }
function SBResetDSP(base : word) : boolean;

{ Escreve no chip DAC }
procedure SBWriteDAC(level : byte);

{ ReadDAC le o n¡vel do microfone }
function SBReadDAC : byte;
procedure SBWriteDSP(value : byte);

{ SpeakerOn torna os soms aud¡veis }
function SBSpeakerOn: byte;

{ SpeakerOff torna os som inaud¡veis }
function SBSpeakerOff: byte;

{ fun‡Æo para para e continuar reprodu‡Æo de soms pelo DMA }
procedure SBDMAStop;
procedure SBDMAContinue;

{ Reproduz um som pelo DMA }
procedure SBPlayback(sound : Pointer; size : word; frequency : word);

{ modifica o controle mestre de volume }
procedure SBSetMasterVol( vol : Byte );
procedure SBSetVoiceVol( vol : Byte );
procedure SBSetFMVol( vol : Byte );
procedure SBSetCDVol( vol : Byte );

Implementation


Uses Crt,Dos;

var      DSP_RESET : word;
     DSP_READ_DATA : word;
    DSP_WRITE_DATA : word;
  DSP_WRITE_STATUS : word;
    DSP_DATA_AVAIL : word;
    DSP_BASE       : word;

 { vari veis para o timer }
    BIOSTimerHandler : procedure;
    clock_ticks, counter : longint;
    timer_media : Word;



Procedure ResetChannels;
var
 r : Byte;
begin

 for r:=1 to SB_MAXCH do begin
  SB_vocs[r].sege:=0;
  SB_vocs[r].ofe :=0;
  SB_vocs[r].size:=0;
  SB_vocs[r].vm  :=1;
  SB_vocs[r].vd  :=1;
  SB_vocs[r].act :=0;
  SB_vocs[r].pos :=0;
  SB_vocs[r].is  :=0;
  SB_vocs[r].modo:=0;
  SB_vocs[r].rate:=1;
  SB_vocs[r].pos2:=0;
 end;

 SB_bload :=0;
 SB_lpon  :=0;
 SB_lppos :=0;
 SB_lppos2:=0;
 SB_lpti  :=0;
 SB_lpfpos:=0;
 SB_lppara:=0;
 SB_qsnd:=0;

end;

procedure StopLP;
begin
 SB_bload :=0;
 SB_lpon  :=0;
 SB_lppos :=0;
 SB_lppos2:=0;
 SB_lpti  :=0;
 SB_lpfpos:=0;
 SB_lppara:=0;
 SB_qsnd:=0;
end;

procedure PauseLP;
begin
 if SB_bload>0 then SB_lpon:=0;
end;

procedure ContinueLP;
begin
 if SB_bload>0 then SB_lpon:=1;
end;

function IsPlayLP : Boolean;
Begin
 if SB_lpon=1 then begin
  IsPlayLP:=TRUE;
 end else IsPlayLP:=FALSE;

End;


procedure SetUpLP( bytes : Word );
begin
 GetMem( SB_snd[0], bytes );
 GetMem( SB_snd[1], bytes );
end;

procedure PlayLP ( nome : String; pos : LongInt; bload : Word; vm,vd : Byte; tax : word );
begin
 if vd=0 then vd:=1;
 if vm=0 then vm:=1;

 SB_lpm:=vm;
 SB_lpd:=vd;

 SB_lpon  :=0;
 SB_lppos :=0;
 SB_lppos2:=0;
 SB_lptax:=tax;
 SB_lpti  :=0;
 SB_lpfpos:=pos;
 SB_bload:=bload;
 SB_lppara:=0;
 SB_qsnd:=0;

 Assign(SB_lpfile, nome ); Reset(SB_lpfile,1); Seek(SB_lpfile,pos);
  BlockRead(SB_lpfile, SB_snd[0]^, bload );
  BlockRead(SB_lpfile, SB_snd[1]^, bload );

 SB_lpon  :=1;

end;




Procedure SetChannel( ch : Byte; s,o,si : Word; m,d,mo : Byte; rate : Word );
Begin
  if m=0 then m:=1;
  if d=0 then d:=1;
  if ch>SB_MAXCH then Exit;
  SB_vocs[ch].sege:=s;
  SB_vocs[ch].ofe :=o;
  SB_vocs[ch].size:=si;
  SB_vocs[ch].vm  :=m;
  SB_vocs[ch].vd  :=d;
  SB_vocs[ch].act :=0;
  SB_vocs[ch].pos :=0;
  SB_vocs[ch].is  :=1; { yes! }
  SB_vocs[ch].modo:=mo;
  SB_vocs[ch].rate:=rate;
  SB_vocs[ch].pos2:=0;
End;

function IsPlaying( ch : Byte ) : Boolean;
Begin

 if SB_vocs[ch].act=1 then begin
  IsPlaying:=TRUE;
 end else IsPlaying:=FALSE;

End;

Procedure SetMDChannel( ch : Byte; m,d : Byte );
Begin
 if m=0 then m:=1;
 if d=0 then d:=1;
 if ch>SB_MAXCH then Exit;
 SB_vocs[ch].vm:=m;
 SB_vocs[ch].vd:=d;
End;

Procedure PlayChannel( ch,mo : Byte; rate : word );
Begin
 if ch>SB_MAXCH then Exit;
 SB_vocs[ch].act:=1;
 SB_vocs[ch].pos:=0;
 SB_vocs[ch].rate:=rate;
 SB_vocs[ch].pos2:=0;
 SB_vocs[ch].modo:=mo;
End;

Procedure StopChannel( ch : Byte );
Begin
 if ch>SB_MAXCH then Exit;
 if SB_vocs[ch].modo=0 then begin
  SB_vocs[ch].act:=0;
  SB_vocs[ch].pos:=0;
  SB_vocs[ch].pos2:=0;
 end;
 if SB_vocs[ch].modo=1 then begin
  SB_vocs[ch].modo:=0;
 end;

End;

Procedure PauseChannel( ch : Byte );
Begin
 if ch>SB_MAXCH then Exit;
 SB_vocs[ch].act:=0;
End;

Procedure ContinueChannel( ch : Byte );
Begin
 if ch>SB_MAXCH then Exit;
 SB_vocs[ch].act:=1;
End;


procedure SBreadNextTrack;
var
 nr : Word;
begin
  if SB_qsnd=1 then BlockRead(SB_lpfile, SB_snd[0]^, SB_bload,nr );
  if SB_qsnd=0 then BlockRead(SB_lpfile, SB_snd[1]^, SB_bload,nr );
  if nr<SB_bload then begin
   SB_bload:=nr;
   SB_lppara:=1+SB_qsnd;
   Close(SB_lpfile);
  end;
end;

{$F+,S-}
procedure TimerHandler; Interrupt;
var
 w,w2,w3 : Byte;
 nr : Word;
begin

inline($FA); {cli}

 timer_media:=0; w2:=1; w3:=0;
 for w:=1 to SB_MAXCH do begin

  if (SB_vocs[w].act=1) and (SB_vocs[w].is=1) then begin

   w2:=w2+1; w3:=w3+1;

   timer_media:=timer_media +
   ((Mem[ SB_vocs[w].sege:SB_vocs[w].ofe + SB_vocs[w].pos ]) * SB_vocs[w].vm ) div SB_vocs[w].vd;

  if SB_SPEED=SB_SLOW then begin
   SB_vocs[w].pos2:=SB_vocs[w].pos2 + SB_vocs[w].rate;
   SB_vocs[w].pos:=MemW[seg(SB_vocs[w].pos2):ofs(SB_vocs[w].pos2)+1];
  end else begin
   SB_vocs[w].pos:=SB_vocs[w].pos+1;
  end;

   if SB_vocs[w].pos>=SB_vocs[w].size then begin
    SB_vocs[w].pos:=0;
    SB_vocs[w].pos2:=0;
    if SB_vocs[w].modo=0 then SB_vocs[w].act:=0;
   end;

  end;

 end;


 { ve se o longplayback est  ativo }
 if SB_lpon=1 then begin
  w2:=w2+1; w3:=w3+1;
  timer_media:=timer_media +
  (( Mem[ SEG(SB_snd[SB_qsnd]^):OFS(SB_snd[SB_qsnd]^)+SB_lppos]) * SB_lpm ) div SB_lpd ;
  SB_lppos2:=SB_lppos2+SB_lptax;
  SB_lppos:= MemW[SEG(SB_lppos2):OFS(SB_lppos2)+1];

  if SB_lppos>=SB_bload then begin
    SB_lppos:=0;
    SB_lppos2:=0;
     case SB_qsnd of
      0 : SB_qsnd:=1;
      1 : SB_qsnd:=0;
     end;
     SB_lpti:=100;
  end;

  if SB_lppara>0 then begin
   SB_lppara:=SB_lppara-1;
   if SB_lppara=SB_qsnd then SB_lpon:=0;
  end;
 end;


  if w2>2 then w2:=w2-1;

  timer_media:=timer_media div w2;

  if w3>0 then begin
   if timer_media<=255 then begin
    SBWriteDAC( Lo(timer_media) );
   end else SBWriteDAC( 255 );
  end;


  { Adjust the count of clock ticks }
  clock_ticks := clock_ticks + counter;

  { Is it time for the BIOS handler to do it's thang? }
  if clock_ticks >= $10000 then
    begin

      { Yep! So adjust the count and call the BIOS handler }
      clock_ticks := clock_ticks - $10000;

      asm
        pushf
      end;
      inline($FB); {sti}
      BIOSTimerHandler;
    end

  { If not then just acknowledge the interrupt }
  else
    Port[$20] := $20;

 { ve se o LP vai p/ o pr¢x track }
 if (SB_lpon=1) and (SB_lpti=100) then begin
  SB_lpti:=0;
  SBREADNEXTTRACK;
{  if SB_qsnd=1 then BlockRead(SB_lpfile, SB_snd[0]^, SB_bload,nr );
  if SB_qsnd=0 then BlockRead(SB_lpfile, SB_snd[1]^, SB_bload,nr );
  if nr<SB_bload then begin
   SB_bload:=nr;
   SB_lppara:=1+SB_qsnd;
   Close(SB_lpfile);
  end; }
 end;

end;


Procedure WORKSetTimer(x : word); assembler;
Asm
  cli
  mov  al,$36
  out  $43,al
  jmp  @1
@1:mov  ax,[x]
  out  $40,al
  jmp  @2
@2:mov  al,ah
  out  $40,al
  jmp  @3
@3:sti
End;


Procedure SetTimer( frequency : word );
begin
 if SB_DETECTED then begin
  { Do some initialization }
  clock_ticks := 0;
  counter := $1234DD div frequency;
  SB_TFRE:=counter;
  SB_TFRE2:=frequency;

  { Store the current BIOS handler and set up our own }
  GetIntVec(TIMERINTR, @BIOSTimerHandler);
  SetIntVec(TIMERINTR, Addr(TimerHandler) );

  { Set the PIT channel 0 frequency }
{ Port[$43] := $36;}  { 34h }
{  Port[$40] := counter mod 256;
  Port[$40] := counter div 256; }

{  Port[$43] := $B4;
  Port[$42] := lo(counter);
  Port[$42] := hi(counter);}

  WORKSetTimer( counter );
 end;
end;

Procedure RESetTimer( frequency : word );
begin
 if SB_DETECTED then begin
  { Do some initialization }
{  clock_ticks := 0; }
  counter := $1234DD div frequency;
  SB_TFRE:=counter;
  SB_TFRE2:=frequency;

  { Store the current BIOS handler and set up our own }
{  GetIntVec(TIMERINTR, @BIOSTimerHandler);
  SetIntVec(TIMERINTR, Addr(TimerHandler) ); }

  { Set the PIT channel 0 frequency }
 { Port[$43] := $36; } { 34h }
{  Port[$40] := counter mod 256;
  Port[$40] := counter div 256;    }
  WORKSetTimer( counter );
 end;
end;


Procedure CleanUpTimer;
begin
 if SB_DETECTED then begin
  { Restore the normal clock frequency }
{  Port[$43] := $36;
  Port[$40] := 0;
  Port[$40] := 0; }
  WORKSetTimer( 0 );

  { Restore the normal ticker handler }
  SetIntVec(TIMERINTR, @BIOSTimerHandler);
 end;
end;




{* fun‡äes do SB DSP ********************************************************}
function SBResetDSP(base : word) : boolean;
begin
  base := base * $10;
  { Calcula o endere‡o das portas }
  DSP_BASE := base;
  DSP_RESET := base + $206;
  DSP_READ_DATA := base + $20A;
  DSP_WRITE_DATA := base + $20C;
  DSP_WRITE_STATUS := base + $20C;
  DSP_DATA_AVAIL := base + $20E;
  { Reseta DSP }
  Port[DSP_RESET] := 1;
  Delay(50);
  Port[DSP_RESET] := 0;
  Delay(50);
 if(Port[DSP_DATA_AVAIL] And $80 = $80) And
     (Port[DSP_READ_DATA] = $AA) then
  begin
    SBResetDSP := true;
    SB_DETECTED:= TRUE;
  end else begin
    SBResetDSP := false;
    SB_DETECTED:= FALSE;
  end;
end;

procedure SBWriteDSP(value : byte);
begin
  while Port[DSP_WRITE_STATUS] And $80 <> 0 do;
  Port[DSP_WRITE_DATA] := value;
end;

function SBReadDSP : byte;
begin
  while Port[DSP_DATA_AVAIL] and $80 = 0 do;
  SBReadDSP := Port[DSP_READ_DATA];
end;

procedure SBWriteDAC(level : byte);
begin
  SBWriteDSP($10);
  SBWriteDSP(level);
end;

function SBReadDAC : byte;
begin
  SBWriteDSP($20);
  SBReadDAC := SBReadDSP;
end;

function SBSpeakerOn: byte;
begin
  SBWriteDSP($D1);
end;

function SBSpeakerOff: byte;
begin
  SBWriteDSP($D3);
end;

procedure SBDMAContinue;
begin
  SBWriteDSP($D4);
end;

procedure SBDMAStop;
begin
  SBWriteDSP($D0);
end;

procedure SBPlayback(sound : Pointer; size : word; frequency : word);
var time_constant : word;
     page, offset : word;
begin
 if SB_DETECTED then begin

  SBSpeakerOn;
  size := size - 1;
  { Set up the DMA chip }
  offset := Seg(sound^) Shl 4 + Ofs(sound^);
  page := (Seg(sound^) + Ofs(sound^) shr 4) shr 12;
  Port[$0A] := 5;
  Port[$0C] := 0;
  Port[$0B] := $49;
  Port[$02] := Lo(offset);
  Port[$02] := Hi(offset);
  Port[$83] := page;
  Port[$03] := Lo(size);
  Port[$03] := Hi(size);
  Port[$0A] := 1;

  { Set the playback frequency }
  time_constant := 256 - 1000000 div frequency;
  SBWriteDSP($40);
  SBWriteDSP(time_constant);

  { Set the playback type (8-bit) }
  SBWriteDSP($14);
  SBWriteDSP(Lo(size));
  SBWriteDSP(Hi(size));
 end;
end;

procedure SBSetMasterVol( vol : Byte );
Begin
 if SB_DETECTED then begin
  Port[ DSP_base + $204 ] := $22;
  Port[ DSP_base + $205 ] := vol;
 end;
End;

procedure SBSetVoiceVol( vol : Byte );
Begin
 if SB_DETECTED then begin
  Port[ DSP_base + $204 ] := $04;
  Port[ DSP_base + $205 ] := vol;
 end;
End;

procedure SBSetFMVol( vol : Byte );
Begin
 if SB_DETECTED then begin
  Port[ DSP_base + $204 ] := $26;
  Port[ DSP_base + $205 ] := vol;
 end;
End;

procedure SBSetCDVol( vol : Byte );
Begin
 if SB_DETECTED then begin
  Port[ DSP_base + $204 ] := $28;
  Port[ DSP_base + $205 ] := vol;
 end;
End;


begin
 { algumas inicializa‡äes }
 SB_DETECTED:=FALSE;
 SB_SPEED:=SB_FAST;

 ResetChannels;

end.
