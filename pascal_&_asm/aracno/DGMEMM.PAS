{ DGM EMM library v1.0

  Copyright (c) 2000 David Maziero / DGM Informatica

  Data : 27/10/2000
}

 Unit DGMEMM;

 interface

 var
  emmVersion : Word;
  emmError   : Byte;

 function  emmGetVersion : Word;
 function  emmGetPageFrameSegment : Word;
 function  emmGetAvailablePages : Word;
 function  emmAllocPages( Pages : Word) : Integer;
 procedure emmFreePages( handle : Integer );
 function  emmMapPage( handle : Integer; pfPage : Byte; PageNbr : Word ) : Integer;
 function  emmGetError : Integer;


 implementation

{ Obt‚m a vers„o do EMM.
  Devolve no formato 0x0X0Y (onde X ‚ vers„o e Y revis„o). }

function  emmGetVersion : Word; assembler;
Asm
  mov     [emmError],0    { Inicializa flag de erro...    }
  mov     ah,46h
  int     67h             { Invoca o EMM                  }
  or      ah,ah           { Testa o sucesso da fun‡„o...  }
  jz      @@no_error
  mov     [emmError],ah   { Poe erro no flag...           }
  mov     ax,-1           { ... e retorna != 0.           }
  jmp     @@done
@@no_error:
  mov     ah,al            { Prepara formato da vers„o.   }
{  and     ax,111100001111b }{ A fun‡„o 46h do EMM devolve  }
  mov     [emmVersion],ax  { no formato BCD... por isso   }
@@done:                    {   precisamos formatar...     }

end;

{ Fun‡„o: Obt‚m o segmento do Page Frame. }
function  emmGetPageFrameSegment : Word; assembler;
Asm
  mov     ah,41h      { Usa a fun‡„o 41h do EMM }
  int     67h         { Chama o EMM             }
  mov     ax,bx       { Poe o segmento em AX    }
                      { Fun‡„o 41h coloca o segmento do }
                      { "Page Frame" em BX.             }
end;

{ Fun‡„o: Obt‚m o n£mero de p ginas dispon¡veis na mem¢ria. }
function  emmGetAvailablePages : Word; assembler;
Asm
  mov     ah,42h
  int     67h     { Invoca o EMM. }
  mov     ax,bx   { Poe p ginas disponiveis em AX. }
end;

{ Aloca p ginas e devolve handle.                   }
{ Obs: Devolve -1 se houve erro na aloca‡ao e seta  }
{      a vari vel emmError.                         }
function  emmAllocPages( Pages : Word) : Integer; assembler;
Asm
  mov     [emmError],0    { Inicializa flag de erros... }
  mov     bx,[Pages]      { BX = n£mero de p ginas a alocar }
  mov     ah,43h
  int     67h             { Invoca o EMM.           }
  or      ah,ah           { Verifica erro do EMM.   }
  jz      @@no_error
  mov     [emmError],ah   { Poe erro na vari vel emmError }
  mov     dx,-1
@@no_error:
  mov     ax,dx           { retorna c¢digo de erro. }
                          { ou o handle. }
end;

{ Libera p ginas alocadas. }
procedure emmFreePages( handle : Integer ); assembler;
Asm
  mov     dx,[handle]
  mov     ah,45h
  int     67h
end;

{ Mapeia uma p gina no Page Frame.
; Onde: handle ‚ o valor devolvido pela fun‡„o de aloca‡„o de
;       p ginas.
;       pfPage ‚ o n£mero da p gina do Page Frame (0 at‚ 3).
;       PageNbr  ‚ o n£mero da p gina a ser colocada no
;       Page Frame (0 at‚ m ximo - 1).
  Devolve -1 se ocorreu erro e seta a vari vel emmError.       }
function  emmMapPage( handle : Integer; pfPage : Byte; PageNbr : Word ) : Integer; assembler;
asm
  mov     [emmError],0
  mov     ah,44h
  mov     al,[pfPage]
  mov     bx,[PageNbr]
  mov     dx,[handle]
  int     67h
  or      ah,ah
  jz      @@no_error
  mov     [emmError],ah
  mov     ah,-1
@@no_error:
  mov     al,ah
end;

{ Retorna com o erro do EMM. }
function  emmGetError : Integer; assembler;
asm
  mov   ax,[word ptr emmError]
  retf
END;

END.
