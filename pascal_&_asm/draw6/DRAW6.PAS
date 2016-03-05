{
   DRAW vers∆o 6.0

   Copyright (c) 1998 David Maziero / DGM Inform†tica

   Autor    : David Gustavo Maziero
   Programa : DRAW v6.0 Ç um utilit†rio para a criaá∆o de gr†ficos
              para uso no Turbo Pascal 6.0 ou superior.
              DRAW v6.0 pode criar imagems IMG (n∆o compactivel com
              qualquer outro programa que utilize a mesma extens∆o),
              e pode criar tambÇm v†rios outros tipos de arquivos,
              tais como : MOV (coordenadas de pontos x e y),
              PAS (cria fontes com os gr†ficos feitos com comandos
              do Turbo Pascal 6.0), C (cria fontes dos gr†ficos com
              os comandos do Turbo C 2.0)

   Data : 06 de Janeiro de 1999
}

   Uses Crt,Dos,Graph,Readgrrr,BGIDriv,BGIFont;

   const
    FRENTE  =  #77;
    TRAS    =  #75;
    BAIXO   =  #80;
    CIMA    =  #72;

    Cores : array[0..15] of String =
     ( 'Preto', 'Azul', 'Verde', 'Ciano', 'Vermelho', 'Magenta', 'Marrom',
       'Cinza Claro', 'Cinza Escuro', 'Azul Claro', 'Verde Claro', 'Ciano Claro',
       'Vermelho Claro', 'Magenta Claro', 'Amarelo', 'Branco' );
    Fills : array[0..11] of String =
     ( 'Vazio', 'Solido', 'Linha', 'LtSlash', 'Slash', 'BkSlash', 'LtBkSlash',
       'Hatch', 'XHatch', 'Interleave', 'WideDot', 'CloseDot' );
    Fontes : array[0..4] of String =
     ( 'Default', 'Triplex', 'Small', 'SansSerif', 'Gothic' );
    Justs : array[0..1] of String =
     ( 'Horizontal', 'Vertical' );
    Tipoput : array[0..4] of String =
     ( 'Copy', 'Xor', 'Or', 'And', 'Not' );


   type

    Draw6AllTypes = record

     x, y, xx, yy : Word;     { As coordenadas x e y, xx e yy         }
     cor          : Byte;     { A core (dos pontos)                   }
     bk1, bk2     : Byte;     { As cores de fundo                     }
     bk3, bk4     : Byte;
     bk5, bk6     : Byte;
     bk7, bk8     : Byte;
     bk9          : Byte;
     ax, ay       : Byte;
     i            : Byte;     { Se o ponto est† ou n∆o visivel        }
     g            : Byte;     { Se o ponto deixa marca ao ser movido  }
     espe         : Byte;     { A espessura do ponto ( 1, 4 ou 9 )    }
     fill, corf   : Byte;     { O tipo e cor do preenchimento         }
     corb         : Byte;     { A cor da borda                        }
     bmask        : Byte;     { A cor que a borracha apaga (0=todas)  }
     radix, radiy : Word;     { Os tamanhos x e y do circulo          }
     stan, endan  : Word;     { O angulo inicial e final do arco      }
     top3d        : Word;     { O tamanho do topo do BAR3D            }
     ttexto, just : Byte;     { O tipo da letra e a justificaá∆o      }
     texto        : String[80];
     chx1, chx2   : Byte;     { O tamanho da letra (SETUSERCHARSIZE)  }
     chy1, chy2   : Byte;     { SETUSERCHARSIZE(chx1,chx2,chy1,chy2 ) }
     maxx, maxy   : Word;     { O tamanho m†ximo da tela (x,y)        }
     maxc         : Byte;     { O m†ximo de cores                     }
     gm, gt       : Integer;  { O modo gr†fico                        }
     objeto       : String;   { O modo do objeto sendo posto          }

    End;

    PASType = record
     tipo       : Byte;    { o tipo do desenho                              }
     x,y        : Word;    { as coordenadas                                 }
     xx,yy      : Word;
     cor,corb   : Byte;    { a cor                                          }
     rax,ray    : Byte;    { raios x e y ou top3d                           }
     stan,endan : Word;    { rax,ray,stan e endan pode ser do USERCHARSIZE  }
     fill,corf  : byte;    { pode ser texto e just                          }
     texto      : String[80];
    end;

{  1- ponto   2- quadrado  3- linha  4- circulo  }

   PtrPasType = array[1..250] of PasType;
   PPPasType = ^PtrPasType;


   BaseBitMapType = record
    tx,ty : Word;
    c : array[1..64000] of Byte;
   end;

   BitMapType = ^BaseBitMapType;

   var
    tela1,tela2,tela3,tela4 : Pointer;
    tela5,tela6,tela7,tela8 : Pointer;
    voltar : Byte;
    a : Draw6AllTypes;
    sair : Boolean;
    PAS : PPPasType;
    mPAS : Word;
    tipo : Byte;
    defname : String;


   procedure SalvaTela( var a : Draw6AllTypes ); forward;
   procedure PoeTela( var a : Draw6AllTypes ); forward;
   procedure GravaTela( var a : Draw6AllTypes ); forward;
   procedure VoltaTela( var a : Draw6AllTypes ); forward;
   procedure Comentario( var a : Draw6AllTypes; li1,li2 : String ); forward;
   procedure ToUpCase( var s : String ); forward;
   procedure ComTela( var a : Draw6AllTypes ); forward;
   procedure DrawTela( var a : Draw6AllTypes ); forward;
   procedure InitModeGraph( var a : Draw6AllTypes ); forward;
   function Perg( s : String ) : Char; forward;
   procedure LimpaT; forward;
   procedure ShowCarac( var a : Draw6AllTypes ); forward;
   function Str2(L : LongInt) : string; forward;
   function Str3(L : Real) : string; forward;
   procedure Pause; forward;
   procedure ZoomEfect( var a : Draw6AllTypes ); forward;
   procedure AxeitaTam2( mess : String; vert : Word ); forward;
   function PedeNome( mess : String; tipo : char ) : String; forward;
   procedure BasiComs( t : char; var a : Draw6AllTypes; s : String ); forward;
   Procedure MoveImg( var a : Draw6AllTypes; var img : Pointer ); forward;
   procedure PutBitMap( x,y : Word; img : BitMapType; sizex,sizey : Real; i : Byte; inc : Real ); forward;
   Procedure MoveBitMap( var a : Draw6AllTypes; var img : BitMapType ); forward;


{---- GeEfe -----------------------------------------------------------------}
   procedure GeEfe( var a : Draw6AllTypes );
   var
    img : BitMapType;
    eex,eey,eexx,eeyy : Word;
    bk,r,ex,ey : Word;
    lo  : Byte;
   begin
    if a.y<a.yy then begin eey:=a.y; eeyy:=a.yy; end;
    if a.y>a.yy then begin eey:=a.yy; eeyy:=a.y; end;
    if a.x<a.xx then begin eex:=a.x; eexx:=a.xx; end;
    if a.x>a.xx then begin eex:=a.xx; eexx:=a.x; end;

    GetMem( img, 150+ (eeyy-eey)*(eexx-eex) );

    r:=1; lo:=0;
    img^.tx:=0; img^.ty:=1;

    for ey:=eey to eeyy do begin
     for ex:=eex to eexx do begin
      bk:=GetPixel( ex, ey );
      img^.c[r]:=bk;
      r:=r+1;
      if lo=0 then img^.tx:=img^.tx+1;
     end;
      img^.ty:=img^.ty+1; lo:=1;
    end;

     img^.tx:=(eexx-eex)+1;
     img^.ty:=(eeyy-eey)+1;

    MoveBitMap( a, img );

    FreeMem( img, 150+ (eeyy-eey)*(eexx-eex) );

    a.objeto:='recorta';

   end;

{---- PutBitMap -----------------------------------------------------------------}
    procedure PutBitMap( x,y : Word; img : BitMapType; sizex,sizey : Real; i : Byte; inc : Real );
    var
     ex,ey : Real;
     dx : Word;
     ix,iy : Real;
     r : Word;
     n : ShortInt;
     incx,incy : Real;
    begin

     ex:=x; ey:=y; dx:=0; n:=0;
     ix:=x; iy:=y;
     incx:= inc/img^.tx;
     incy:= inc/img^.ty;


     if i=2 then n:=-1;

     for r:=1 to (img^.tx * img^.ty)+1 do begin

      if img^.c[r]>n then begin
       if(sizex>=0) and (sizey>=0) then begin
        if(sizex<=1) and (sizey<=1) then PutPixel( round(ex),round(ey), img^.c[r] );
        if(sizex>1)  and (sizey<=1) then begin
         setcolor(img^.c[r]); line( round(ex), round(ey), round(ex+sizex)-1, round(ey) ); end;
        if(sizex<=1)  and (sizey>1) then begin
         setcolor(img^.c[r]); line( round(ex), round(ey), round(ex), round(ey+sizey)-1 ); end;
        if(sizex>1)  and (sizey>1) then begin
           setfillstyle( a.fill, img^.c[r] );
          bar( round(ex), round(ey), round((ex+sizex)-1), round((ey+sizey)-1) ); end;
       end;

       if(sizex<0) and (sizey<0) then begin
        if(sizex>=-1) and (sizey>=-1) then PutPixel( round(ex),round(ey), img^.c[r] );
        if(sizex<-1)  and (sizey>=-1) then begin
         setcolor(img^.c[r]); line( round(ex), round(ey), round(ex-sizex), round(ey) ); end;
        if(sizex>=-1)  and (sizey<-1) then begin
         setcolor(img^.c[r]); line( round(ex), round(ey), round(ex), round(ey-sizey) ); end;
        if(sizex<-1)  and (sizey<-1) then begin
           setfillstyle( a.fill, img^.c[r] );
          bar( round(ex), round(ey), round((ex-sizex)-1), round((ey-sizey)-1) ); end;
       end;

       if sizex<0 then begin
        PutPixel( round(ex),round(ey), img^.c[r] );
       end;

      end;

       ex:=ex+sizex;
       ey:=ey+incy;
       dx:=dx+1;

       if dx=img^.tx then begin
        ix:=ix-incx;
        dx:=0;
        ey:=iy;
        ey:=ey+sizey;
        ex:=ix;
        iy:=iy+sizey;

       end;

     end;

    end;

{---- GeRec -----------------------------------------------------------------}
    procedure GeRec( var a : Draw6AllTypes );
    var
     size : Word;
     img  : Pointer;
    begin
     DrawTela(a);
     size:=ImageSize( a.x, a.y, a.xx, a.yy );
     GetMem( img, size );
     GetImage( a.x, a.y, a.xx, a.yy, img^ );
     MoveImg( a, img );
     FreeMem( img, size );
     a.objeto:='recorta';
    end;

{---- MoveImg ---------------------------------------------------------------}

    Procedure MoveImg( var a : Draw6AllTypes; var img : Pointer );
    var
     t : Char;
     tipo : Byte;
    Begin
     LimpaT;
     tipo:=CopyPut;

     t:=#0;
     while t<>#27 do begin

     Comentario(a, 'Mover Imagem : ('+str2(a.x)+','+str2(a.y)+') tipo='+Tipoput[tipo]+' ','');

     SalvaTela(a);

     PutImage( a.x, a.y, img^, tipo );

     t:=ReadKey;

     PoeTela(a);
     BasiComs(t,a,'b');
     if(t='+') and (tipo<4) then tipo:=tipo+1;
     if(t='-') and (tipo>0) then tipo:=tipo-1;

     if t=#13 then begin
      PutImage( a.x, a.y, img^, tipo );
     end;

     end;

   end;

{---- MoveBitMap ------------------------------------------------------------}

    Procedure MoveBitMap( var a : Draw6AllTypes; var img : BitMapType );
    var
     t : Char;
     tipo : Byte;
     sizex,sizey : Real;
     inc : Real;
     i : Byte;
    Begin
     LimpaT; i:=1; inc:=0;
     sizex:=1; sizey:=1;
     t:=#0; a.fill:=SOLIDFILL;

     while t<>#27 do begin

     Comentario(a, 'Efeito : ('+str2(a.x)+','+str2(a.y)+') size=('+str3(sizex)+','+str3(sizey)+') inc='+str3(inc)+
                   ' i='+str2(i)+' ','');

     SalvaTela(a);

     PutBitMap( a.x, a.y, img, sizex,sizey, i, inc );

     t:=ReadKey;

     PoeTela(a);
     BasiComs(t,a,'b');

     if t='+' then begin sizex:=sizex+0.1; sizey:=sizey+0.1; end;
     if t='-' then begin sizex:=sizex-0.1; sizey:=sizey-0.1; end;

     if t='*' then begin sizex:=sizex+0.05; sizey:=sizey+0.05; end;
     if t='/' then begin sizex:=sizex-0.05; sizey:=sizey-0.05; end;

     if t=']' then begin sizex:=sizex+0.01; sizey:=sizey+0.01; end;
     if t='[' then begin sizex:=sizex-0.01; sizey:=sizey-0.01; end;

     if t='}' then inc:=inc+0.5;
     if t='{' then inc:=inc-0.5;

     if(t='i') and (i=1) then begin t:=#0; i:=2; end;
     if(t='i') and (i=2) then begin t:=#0; i:=1; end;

     if t='a' then sizex:=sizex-0.1;
     if t='s' then sizex:=sizex+0.1;
     if t='w' then sizey:=sizey-0.1;
     if t='z' then sizey:=sizey+0.1;

     if t='A' then sizex:=sizex-0.05;
     if t='S' then sizex:=sizex+0.05;
     if t='W' then sizey:=sizey-0.05;
     if t='Z' then sizey:=sizey+0.05;

     if t='D' then sizex:=sizex-1;
     if t='F' then sizex:=sizex+1;
     if t='R' then sizey:=sizey-1;
     if t='C' then sizey:=sizey+1;

     if t=#13 then begin
      PutBitMap( a.x, a.y, img, sizex,sizey, i, inc );
     end;

     end;

   end;

{---- Val2 ------------------------------------------------------------------}
   function Val2( s : String ) : LongInt;
   var
    code : Integer;
    i    : LongInt;
   begin
    Val( s, i, code );
    if code<>0 then i:=0;
    Val2:=i;
   end;


{---- Carrega ---------------------------------------------------------------}
   procedure Carrega( var a : Draw6AllTypes );
   var
    nome  : string;
    S     : PathStr;
    size  : Word;
    f     : File;
    pos   : LongInt;
    pos2  : Word;
    cont  : Word;
    cont2 : Word;
    b1,b2 : ^Word;
    img   : Pointer;
    t,t2,tt2  : Char;
    t3 : String;
    re    : Byte;
    r     : Word;
    mes   : String;
    nr,nw : Word;
    tcont : Word;
    letam : Byte;
    label 1,2;
   Begin
    nome:=PedeNome( 'Entre com o nome do arquivo a ser carregado :', 'I' );
    if nome='' then Exit;

    re:=0;
    pos2:=1;

    S:=FSearch( nome, '' );

    if s='' then begin
     Comentario(a,'O arquivo <'+nome+'> nÉo foi encontrado.','');
     Pause;
     Exit;
    end;

    2:;
     GetMem(b1,2); GetMem(b2,2);
   {$I-}
     Assign(f,nome); Reset(f,1);
     cont:=0;
     while not eof(f) do begin
      pos:=filepos(f); cont:=cont+1;
      BlockRead(f,b1^,2,nr);
      BlockRead(f,b2^,2,nr);
      size:=ImageSize( 0, 0, b1^, b2^ );
      Seek(f,pos+size);
      if IOResult<>0 then begin
       Comentario(a,'Houve um erro ao ler o arquivo <'+nome+'>. Verifique se os ',
                    'gr†ficos dele foram gravados no mesmo modo gr†fico que est† sendo usado. ');
       Pause; FreeMem(b1,2); FreeMem(b2,2); Exit;
      end;
     end;
     Close(f);
   {$I+}
     FreeMem(b1,2); FreeMem(b2,2);

    if cont<10 then letam:=1;
    if(cont>=10) and (cont<100) then letam:=2;
    if cont>=100 then letam:=3;
    Case letam of
     1 :  Comentario(a,'O arquivo <'+nome+'> possui '+str2(cont)+' imagems. ',
                       'Qual imagem vocà deseja carregar ? (1/'+str2(cont)+') ');
     2 :  Comentario(a,'O arquivo <'+nome+'> possui '+str2(cont)+' imagems. ',
                       'Qual imagem vocà deseja carregar ? (01/'+str2(cont)+') ');
     3 :  Comentario(a,'O arquivo <'+nome+'> possui '+str2(cont)+' imagems. ',
                       'Qual imagem vocà deseja carregar ? (001/'+str2(cont)+') ');
    end;

     mes:='';
     tcont:=cont;
      for r:=1 to cont do mes:=mes+ str2(r);
    letam:=1;
    if cont<10 then letam:=1;
    if(cont>=10) and (cont<100) then letam:=2;
    if cont>=100 then letam:=3;

    if cont=1 then t3:='1';
    if cont>1 then begin
{     t:=Perg('0'+mes+chr(27));
     if t=#27 then Exit;
     t2:=Perg('0'+mes+chr(27));
     if t2=#27 then Exit;
     tt2:=Perg('0'+mes+chr(27));
     if t2=#27 then Exit; }

     t:=' '; t2:=' '; tt2:=' ';
     t:=Perg('0123456789'+chr(27));
     if t=#27 then Exit;

     if letam>1 then begin
      t2:=Perg('0123456789'+chr(27));
      if t2=#27 then Exit;
     end;

     if letam>2 then begin
      tt2:=Perg('0123456789'+chr(27));
      if tt2=#27 then Exit;
     end;

     t3:=t;
     if letam>1 then t3:=t3+t2;
     if letam>2 then t3:=t3+tt2;
    end;


     cont2:=0;
     cont2:=Val2(t3);

     if cont2=0 then Exit;
     if cont2>cont then Exit;

     DrawTela(a);

     GetMem(b1,2); GetMem(b2,2);
   {$I-}
     Assign(f,nome); Reset(f,1);
     cont:=0;
     while not eof(f) do begin
      pos:=filepos(f); cont:=cont+1;
      BlockRead(f,b1^,2,nr);
      BlockRead(f,b2^,2,nr);
      size:=ImageSize( 0, 0, b1^, b2^ );
      if cont2<>cont then Seek(f,pos+size);

      if cont2=cont then begin
       Seek(f,pos);
       GetMem(img,size);
       BlockRead(f,img^,size);
       goto 1;
      end;
      if IOResult<>0 then begin
       Comentario(a,'Houve um erro ao ler o arquivo <'+nome+'>. Verifique se os ',
                    'gr†ficos dele foram gravados no mesmo modo gr†fico que est† sendo usado. ');
       Pause; FreeMem(b1,2); FreeMem(b2,2); Exit;
      end;
     end;
     1:;
     Close(f);
   {$I+}
     FreeMem(b1,2); FreeMem(b2,2);

      MoveImg( a, img );
      FreeMem(img,size);

     if tcont>1 then goto 2;

   End;



{---- Salva -----------------------------------------------------------------}
   procedure Salva( var a : Draw6AllTypes );
   var
    nome  : string;
    S     : PathStr;
    size  : Word;
    f     : File;
    pos   : LongInt;
    pos2  : Word;
    cont  : Word;
    b1,b2 : ^Word;
    img   : Pointer;
    t     : Char;
    re    : Byte;
   Begin
    nome:=PedeNome( 'Entre com o nome do arquivo a ser salvo :', 'I' );
    if nome='' then Exit;

    re:=0;
    pos2:=1;

    S:=FSearch( nome, '' );

    if s<>'' then begin
     GetMem(b1,2); GetMem(b2,2);
   {$I-}
     Assign(f,nome); Reset(f,1);
     cont:=0;
     while not eof(f) do begin
      pos:=filepos(f); cont:=cont+1;
      BlockRead(f,b1^,2);
      BlockRead(f,b2^,2);
      size:=ImageSize( 0, 0, b1^, b2^ );
      Seek(f,pos+size);
      if IOResult<>0 then begin
       Comentario(a,'Houve um erro ao ler o arquivo <'+nome+'>. Verifique se os ',
                    'gr†ficos dele foram gravados no mesmo modo gr†fico que est† sendo usado. ');
       Pause; FreeMem(b1,2); FreeMem(b2,2); Exit;
      end;
     end;
     Close(f);
   {$I+}
     FreeMem(b1,2); FreeMem(b2,2);

     Comentario(a,'O arquivo <'+nome+'> j† existe. E possui '+str2(cont)+' imagems. ',
                  'Deseja Reescreve-lo ou gravar a imagem no Final do arquivo ? (R/F) ');
     t:=Perg('rRfF'+chr(27)+chr(13));
     if t=#27 then Exit;
     if(t='f') or (t='F') or (t=#13) then begin re:=1; pos2:=cont+1; end;

    end;


     DrawTela(a);
     size:=ImageSize( a.x, a.y, a.xx, a.yy );
     GetMem( img, size );
     GetImage( a.x, a.y, a.xx, a.yy, img^ );

    Assign(f,nome);
    if re=0 then ReWrite(f,1);
    if re=1 then begin
     Reset(f,1);
     Seek(f,filesize(f));
    end;

     BlockWrite( f, img^, size );
     Close(f);

     FreeMem( img, size );

     Delay(200);

    Assign(f,nome);
    Reset(f,1);
    Comentario(a,'O arquivo <'+nome+'> foi salvo, tamanho total : '+str2(filesize(f))+' ',
                 'A imagem, de tamanho '+str2(size)+' , foi salva na posicÉo '+str2(pos2));
    Close(f);
    Pause;

   End;

{---- AdicionaArquivos ------------------------------------------------------}
   procedure AdicionaArquivos( var a : Draw6AllTypes );
   var
    nome  : string;
    S     : PathStr;
    size  : Word;
    f,f2  : File;
    pos   : LongInt;
    pos2  : Word;
    cont  : Word;
    b1,b2 : ^Word;
    img   : Pointer;
    t     : Char;
    re    : Byte;
    nr,nw : Word;
    arqs  : Byte;
    buf   : Array[1..2048] of Char;
    nomes : array[1..50] of String[100];
    porc,r,w  : Byte;
    ocu : Byte;
   Begin

    for r:=1 to 50 do nomes[r]:='';

    nome:=PedeNome( 'Entre com o nome do arquivo para qual serÉo adicionados os arquivos :', 'I' );
    if nome='' then Exit;

    re:=0;
    pos2:=1;

    S:=FSearch( nome, '' );

    if s<>'' then begin

     Comentario(a,'O arquivo <'+nome+'> j† existe.   ',
                  'Deseja Reescreve-lo ou adicionar no Final do arquivo ? (R/F) ');
     t:=Perg('rRfF'+chr(27)+chr(13));
     if t=#27 then Exit;
     if(t='f') or (t='F') or (t=#13) then begin re:=1; pos2:=cont+1; end;

    end;

     Assign(f,nome);
     if re=0 then ReWrite(f,1);
     if re=1 then begin
      Reset(f,1);
      Seek(f,filesize(f));
     end;

    arqs:=1;
    limpaT; t:=#0;
    while t<>#13 do begin
     Comentario(a,'N£mero de arquivos a serem adicionados : '+str2(arqs)+'  ','');
     t:=ReadKey;
     if(t='+') and (arqs<50) then arqs:=arqs+1;
     if(t='-') and (arqs>1 ) then arqs:=arqs-1;
     if t=#27 then begin a.objeto:='ponto'; Exit; End;
    end;

    for r:=1 to arqs do begin

     nomes[r]:=PedeNome( str2(r)+'# Arquivo a ser adicionado :  ', 'i' );
     if nomes[r]='' then begin a.objeto:='ponto'; Exit; end;

     S:=FSearch( nomes[r], '' );
     if s='' then begin
      Comentario(a,'Arquivo <'+nomes[r]+'> nÉo encontrado.  ','');
      Pause; r:=r-1;
     end;

    if r>1 then begin
     ocu:=0;
     for w:=1 to r-1 do begin
      if nomes[r]=nomes[w] then begin
       Comentario(a,'Arquivo <'+nomes[r]+'> j† incluido.  ','');
       Pause; ocu:=1;
      end;
     end;
     if ocu=1 then r:=r-1;
    end;

    end;

    for r:=1 to arqs do begin

     porc:=(100 div arqs)*r;
     Comentario(a,' '+str2(porc)+'% conclu°do...          ',nome+' + '+nomes[r]+'  ');
     Delay(200);

      Assign( f2, nomes[r] );
      Reset(f2,1);

      repeat
       BlockRead(f2,buf,SizeOf(buf),nr);
       BlockWrite(f,buf,nr,nw);
       until (nr = 0) or (nw <> nr);

      Close(f2);

    end;

     Close(f);

   End;

{---- AllScr ----------------------------------------------------------------}
   procedure AllScr( var a : Draw6AllTypes );
   begin
    SetViewPort(0,0,a.maxx,a.maxy,ClipOn);
   end;

{---- GravaTela -------------------------------------------------------------}
   procedure GravaTela( var a : Draw6AllTypes );
   var size1,size2,size3,size4 : Word;
   begin
{    size1:= ImageSize( 0, 0, a.maxx div 2, (a.maxy-27) div 2 );
    size2:= ImageSize( (a.maxx div 2)+1, 0, a.maxx, (a.maxy-27) div 2 );
    size3:= ImageSize( 0, ((a.maxy-27) div 2)+1, a.maxx div 2, a.maxy-27 );
    size4:= ImageSize( (a.maxx div 2)+1, ((a.maxy-27) div 2)+1 , a.maxx, a.maxy-27 );
    if voltar=0 then begin
     GetMem( tela5, size1 ); GetMem( tela6, size2 );GetMem( tela7, size3 ); GetMem( tela8, size4 );
    end;
    GetImage( 0, 0, a.maxx div 2, (a.maxy-27) div 2, tela5^ );
    GetImage( (a.maxx div 2)+1, 0, a.maxx, (a.maxy-27) div 2, tela6^ );
    GetImage( 0, ((a.maxy-27) div 2)+1, a.maxx div 2, a.maxy-27, tela7^ );
    GetImage( (a.maxx div 2)+1, ((a.maxy-27) div 2)+1 , a.maxx, a.maxy-27, tela8^ );
    voltar:=1; }
   end;

{---- VoltaTela ---------------------------------------------------------------}
   procedure VoltaTela( var a : Draw6AllTypes );
   var size1,size2,size3,size4 : Word;
   begin
{    size1:= ImageSize( 0, 0, a.maxx div 2, (a.maxy-27) div 2 );
    size2:= ImageSize( (a.maxx div 2)+1, 0, a.maxx, (a.maxy-27) div 2 );
    size3:= ImageSize( 0, ((a.maxy-27) div 2)+1, a.maxx div 2, a.maxy-27 );
    size4:= ImageSize( (a.maxx div 2)+1, ((a.maxy-27) div 2)+1 , a.maxx, a.maxy-27 );
    PutImage( 0, 0, tela5^, CopyPut );
    PutImage( (a.maxx div 2)+1, 0, tela6^, CopyPut );
    PutImage( 0, ((a.maxy-27) div 2)+1, tela7^, CopyPut );
    PutImage( (a.maxx div 2)+1, ((a.maxy-27) div 2)+1 , tela8^, CopyPut );
    FreeMem( tela5, size1 ); FreeMem( tela6, size2 ); FreeMem( tela7, size3 ); FreeMem( tela8, size4 );
    voltar:=0; }
   end;

{---- AxeitaTam -------------------------------------------------------------}
   procedure AxeitaTam( mess : String );
   var r,mx,dx,my,dy : Word;
   begin
    SetTextStyle( SMALLFONT, HORIZDIR, 4 );
    SetColor( WHITE );
    mx:=1; dx:=30; my:=1; dy:=30; r:=1;
    while r=1 do begin
     SetUserCharSize( mx, dx, my, dy );
     if TextWidth(mess) < a.maxx then mx:=mx+1;
     if TextHeight('H')< 10     then my:=my+1;
     if(TextWidth(mess) >= a.maxx ) and
       (TextHeight('H')>= 10 ) then r:=2;
    end;
     SetUserCharSize( mx, dx, my, dy );
   end;

{---- AxeitaTam2 ------------------------------------------------------------}
   procedure AxeitaTam2( mess : String; vert : Word );
   var r,mx,dx,my,dy : Word;
   begin
    if mess='' then exit;
    mx:=1; dx:=30; my:=1; dy:=30; r:=1;
    while r=1 do begin
     SetUserCharSize( mx, dx, my, dy );
     if TextWidth(mess) < a.maxx then mx:=mx+1;
     if TextHeight('H')< vert    then my:=my+1;
     if(TextWidth(mess) >= a.maxx ) and
       (TextHeight('H')>= vert ) then r:=2;
    end;
     SetUserCharSize( mx, dx, my, dy );
   end;

{---- PedeNome --------------------------------------------------------------}
   function PedeNome( mess : String; tipo : char ) : String;
   var
    nome : String;
    P : PathStr;
    D : DirStr;
    N : NameStr;
    E : ExtStr;
    li2 : String;
   Begin
    ComTela(a);

     AxeitaTam( mess );
     OutTextXY( 1, 1,  mess );

    li2:='HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH';

    AxeitaTam( li2 );
    if tipo<>'i' then nome:=readgraph( 1,13, 'Nome :', TextWidth('H'),defname, 50);
    if tipo='i'  then nome:=readgraph( 1,13, 'Nome :', TextWidth('H'),'', 50);
    P:=nome;
    defname:=nome;
    ToUpCase(defname);
    FSplit(P, D, N, E);
    if N = '' then N:='';

  if N<>'' then begin
   if tipo='P' then begin
    if E = '' then E:='.PAS';
   end;
   if tipo='C' then begin
    if E = '' then E:='.C';
   end;
   if(tipo='I') or (tipo='i') then begin
    if E = '' then E:='.IMG';
   end;
   if tipo='M' then begin
    if E = '' then E:='.MOV';
   end;
  end;

    P := D + N + E;
    nome:=P;
    ToUpCase(nome);
{    defname:=nome; }

    PedeNome:=nome;

   End;

{---- PedeTexto -------------------------------------------------------------}
   function PedeTexto( mess : String ) : String;
   var
    texto : String;
    li2 : String;
   Begin
    ComTela(a);

     AxeitaTam( mess );
     OutTextXY( 1, 1,  mess );

    li2:='HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH';

    AxeitaTam( li2 );
    texto:=readgraph( 1,13, 'Texto :', TextWidth('H'),'', 50);

    PedeTexto:=texto;

   End;


{---- SalvaPASC -------------------------------------------------------------}
   procedure SalvaPASC;
   var
    r : Word;
    nome : String;
    f : Text;
    t : Char;
    P : PathStr;
    D : DirStr;
    N : NameStr;
    E : ExtStr;
    inic : Byte;
   begin
    if mpas=0 then begin
     Comentario(a,'Nao existe nenhum gr†fico para ser gravado.','');
     Pause;
     Exit;
    end;

    inic:=0;
    nome:=PedeNome( 'Entre com o nome do arquivo PAS ou C (default PAS) :','P');
    FSplit( nome,D,N,E );

    Assign(f,nome);
    P:=FSearch( nome, '' );

    if P='' then begin
     ReWrite(f);
     Comentario(a,'O arquivo <'+nome+'> foi criado.     ','Deseja gravar s¢ o Grafico ou incluir Programa completo ? (G/P)');
     t:=Perg('GPgp'+chr(27));
     if t=#27 then begin close(f); erase(f); Exit; end;
     if(t='p') or (t='P') then begin
      inic:=1;
      if E='.PAS' then begin
       WriteLn(f,'{ Programa Gr†fico - DRAW vers∆o 6.0 }');
       WriteLn(f,'{ Copyright (c) 1999 David Maziero / DGM Inform†tica }'); WriteLn(f);
       WriteLn(f,'  Uses Crt,Dos,Graph; ');  WriteLn(f);
       WriteLn(f,'  var ');
       WriteLn(f,'   gm,gt : Integer; ');
       WriteLn(f,'   path  : String; ');  WriteLn(f);
       WriteLn(f,'  begin');
       if a.gm=CGA     then WriteLn(f,'   gm:=CGA;');
       if a.gm=EGA     then WriteLn(f,'   gm:=EGA;');
       if a.gm=EGA64   then WriteLn(f,'   gm:=EGA64;');
       if a.gm=VGA     then WriteLn(f,'   gm:=VGA;');
       if a.gm=HERCMONO then WriteLn(f,'   gm:=HERCMONO;');
       if a.gm=IBM8514 then WriteLn(f,'   gm:=IBM8514;');
       WriteLn(f,'   gt:=',a.gt,'; ' );
       WriteLn(f,'   path:=''C:\TP\BGI''; { ê o diretorio mais comun em que possa } ');
       WriteLn(f,'                      { conter os drivers de v°deo, altere-o  } ');
       WriteLn(f,'                      { se for necess†rio                     } ');
       WriteLn(f,'   InitGraph( gm, gt, path ); ');  WriteLn(f);
      end;
      if E='.C' then begin
       WriteLn(f,'/* Programa Gr†fico - DRAW vers∆o 6.0 ');
       WriteLn(f,'   Copyright (c) 1999 David Maziero / DGM Inform†tica */'); WriteLn(f);
       WriteLn(f,'#include "conio.h" ');
       WriteLn(f,'#include "graphics.h" '); WriteLn(f);
       WriteLn(f,'int gm,gt;');
       WriteLn(f,'char *path;'); WriteLn(f);
       WriteLn(f,'void main()'); WriteLn(f,'{ ');
       if a.gm=CGA     then WriteLn(f,'   gm=CGA;');
       if a.gm=EGA     then WriteLn(f,'   gm=EGA;');
       if a.gm=EGA64   then WriteLn(f,'   gm=EGA64;');
       if a.gm=VGA     then WriteLn(f,'   gm=VGA;');
       if a.gm=HERCMONO then WriteLn(f,'   gm=HERCMONO;');
       if a.gm=IBM8514 then WriteLn(f,'   gm=IBM8514;');
       WriteLn(f,'   gt=',a.gt,'; ');
       WriteLn(f,'   path="C:\\TC\\BGI"; /* ê o diretorio mais comun em que possa */ ');
       WriteLn(f,'                       /* conter os drivers de v°deo, altere-o  */ ');
       WriteLn(f,'                       /* se for necess†rio                     */ ');
       WriteLn(f,'   initgraph( &gm, &gt, path ); '); WriteLn(f);
      end;

     end;

    end;

    if P<>'' then begin
     Comentario(a,'O arquivo <'+nome+'> j† existe.     ','Deseja Sobreescreve-lo ou gravar no Final ? (S/F)');
     t:=Perg('SFsf'+chr(27));
     if t=#27 then Exit;
     if(t='s') or (t='S') then ReWrite(f);
     if(t='f') or (t='F') then Append(f);
    end;


    for r:=1 to mpas do begin

     if PAS^[r].tipo=1 then
      WriteLn(f,'   putpixel( ',PAS^[r].x,', ',PAS^[r].y,', ',PAS^[r].cor,' ); ');

     if(PAS^[r].tipo>=2) and (PAS^[r].tipo<=9) or (PAS^[r].tipo=12) then begin
      if(r=1) or (r>1) and (PAS^[r-1].cor<>PAS^[r].cor) then
       WriteLn(f,'   setcolor( ',PAS^[r].cor,' ); ');
     end;

     if(PAS^[r].tipo=3) or (PAS^[r].tipo=4) or (PAS^[r].tipo=8) or (PAS^[r].tipo=9) or
       (PAS^[r].tipo=10) then begin
      WriteLn(f, '   setfillstyle( ',PAS^[r].fill,', ',PAS^[r].corf,' ); ');
     end;

     if PAS^[r].tipo=2 then
       WriteLn(f,'   rectangle( ',PAS^[r].x,', ',PAS^[r].y,', ',PAS^[r].xx,', ',PAS^[r].yy,' ); ');

     if PAS^[r].tipo=3 then begin
       WriteLn(f,'   bar( ',PAS^[r].x,', ',PAS^[r].y,', ',PAS^[r].xx,', ',PAS^[r].yy,' ); ');
       WriteLn(f,'   rectangle( ',PAS^[r].x,', ',PAS^[r].y,', ',PAS^[r].xx,', ',PAS^[r].yy,' ); ');
     end;

     if PAS^[r].tipo=4 then
       WriteLn(f,'   bar3d( ',PAS^[r].x,', ',PAS^[r].y,', ',PAS^[r].xx,', ',PAS^[r].yy,', ',PAS^[r].rax,', TopOn ); ');

     if PAS^[r].tipo=5 then
       WriteLn(f,'   line( ',PAS^[r].x,', ',PAS^[r].y,', ',PAS^[r].xx,', ',PAS^[r].yy,' ); ');

     if PAS^[r].tipo=6 then
       WriteLn(f,'   circle( ',PAS^[r].x,', ',PAS^[r].y,', ',PAS^[r].rax,' ); ');

     if PAS^[r].tipo=7 then
       WriteLn(f,'   arc( ',PAS^[r].x,', ',PAS^[r].y,', ',PAS^[r].stan,', ',PAS^[r].endan,', ',PAS^[r].rax,' ); ');

     if PAS^[r].tipo=8 then
       WriteLn(f,'   pieslice( ',PAS^[r].x,', ',PAS^[r].y,', ',PAS^[r].stan,', ',PAS^[r].endan,', ',PAS^[r].rax,' ); ');

     if PAS^[r].tipo=9 then
       WriteLn(f,'   sector( ',PAS^[r].x,', ',PAS^[r].y,', ',PAS^[r].stan,', ',PAS^[r].endan,', ',
       PAS^[r].rax,', ',PAS^[r].ray,' ); ');

     if PAS^[r].tipo=10 then
       WriteLn(f,'   floodfill( ',PAS^[r].x,', ',PAS^[r].y,', ',PAS^[r].corb,' ); ');

     if PAS^[r].tipo=12 then begin
       WriteLn(f,'   SetTextStyle( ',PAS^[r].fill,', ',PAS^[r].corf,', ',PAS^[r].rax,' ); ');
        if (PAS^[r].ray>0) or (PAS^[r].stan>0) or (PAS^[r].endan>0) then
         WriteLn(f,'   SetUserCharSize( ',PAS^[r].rax,', ',PAS^[r].ray,', ',PAS^[r].stan,', ',PAS^[r].endan,' ); ');
       WriteLn(f,'   OutTextXY( ',PAS^[r].x,', ',PAS^[r].y,', ''',PAS^[r].texto,''' ); ');

     end;

    end;

     if inic=1 then begin
      if E='.PAS' then begin
       WriteLn(f);
       WriteLn(f,'   ReadLn;');
       WriteLn(f);
       WriteLn(f,'  End.');
       WriteLn(f);
      end;
      if E='.C' then begin
       WriteLn(f);
       WriteLn(f,'   getch();');
       WriteLn(f);
       WriteLn(f,'}');
       WriteLn(f);
      end;
     end;

     Close(f);

   end;

{---- SalvaTela -------------------------------------------------------------}
   procedure SalvaTela( var a : Draw6AllTypes );
   var size1,size2,size3,size4 : Word;
   begin
    DrawTela(a);
    size1:= ImageSize( 0, 0, a.maxx div 2, (a.maxy-27) div 2 );
    size2:= ImageSize( (a.maxx div 2)+1, 0, a.maxx, (a.maxy-27) div 2 );
    size3:= ImageSize( 0, ((a.maxy-27) div 2)+1, a.maxx div 2, a.maxy-27 );
    size4:= ImageSize( (a.maxx div 2)+1, ((a.maxy-27) div 2)+1 , a.maxx, a.maxy-27 );
    GetMem( tela1, size1 ); GetMem( tela2, size2 );GetMem( tela3, size3 ); GetMem( tela4, size4 );
    GetImage( 0, 0, a.maxx div 2, (a.maxy-27) div 2, tela1^ );
    GetImage( (a.maxx div 2)+1, 0, a.maxx, (a.maxy-27) div 2, tela2^ );
    GetImage( 0, ((a.maxy-27) div 2)+1, a.maxx div 2, a.maxy-27, tela3^ );
    GetImage( (a.maxx div 2)+1, ((a.maxy-27) div 2)+1 , a.maxx, a.maxy-27, tela4^ );
   end;

{---- PoeTela ---------------------------------------------------------------}
   procedure PoeTela( var a : Draw6AllTypes );
   var size1,size2,size3,size4 : Word;
   begin
    DrawTela(a);
    size1:= ImageSize( 0, 0, a.maxx div 2, (a.maxy-27) div 2 );
    size2:= ImageSize( (a.maxx div 2)+1, 0, a.maxx, (a.maxy-27) div 2 );
    size3:= ImageSize( 0, ((a.maxy-27) div 2)+1, a.maxx div 2, a.maxy-27 );
    size4:= ImageSize( (a.maxx div 2)+1, ((a.maxy-27) div 2)+1 , a.maxx, a.maxy-27 );
    PutImage( 0, 0, tela1^, CopyPut );
    PutImage( (a.maxx div 2)+1, 0, tela2^, CopyPut );
    PutImage( 0, ((a.maxy-27) div 2)+1, tela3^, CopyPut );
    PutImage( (a.maxx div 2)+1, ((a.maxy-27) div 2)+1 , tela4^, CopyPut );
    FreeMem( tela1, size1 ); FreeMem( tela2, size2 ); FreeMem( tela3, size3 ); FreeMem( tela4, size4 );
   end;

{---- Comentario ------------------------------------------------------------}
   procedure Comentario( var a : Draw6AllTypes; li1,li2 : String );
   Begin
    ComTela(a);
    if length(li2)=0 then li2:=li2+'                               ';
    li2:=li2+'   M: '+str2(memavail)+' ';
    AxeitaTam( li1 );
    OutTextXY( 1, 1,  li1 );
    AxeitaTam( li2 );
    OutTextXY( 1, 13, li2 );
    DrawTela(a);
   End;

{---- ToUpCaseo -------------------------------------------------------------}
  procedure ToUpCase( var s : String );
  var i : Word;
  begin
   for i := 1 to Length(s) do s[i] := UpCase(s[i]);
  end;

{---- ComTela ---------------------------------------------------------------}
   procedure ComTela( var a : Draw6AllTypes );
   begin
    SetViewPort(0,a.maxy-26,a.maxx,a.maxy,ClipOn);
    ClearViewPort; SetColor(WHITE); Line(0,1,a.maxx,1);
   end;

{---- DrawTela --------------------------------------------------------------}
   procedure DrawTela( var a : Draw6AllTypes );
   begin
    SetViewPort(0,0,a.maxx,a.maxy-27,ClipOn);
   end;

{---- InitModeGraph ---------------------------------------------------------}
  procedure InitModeGraph( var a : Draw6AllTypes );
  var
   t    : Char;
   s    : String[2];
   op   : Byte;
   code : Integer;
   label 1;
  Begin
   WriteLn;
   WriteLn(' DRAW v6.0 - Copyright (c) 1998 David Maziero / DGM Inform†tica '); WriteLn;
   WriteLn(' Entre com o modo gr†fico :'); WriteLn;
   WriteLn('  01 - CGA      320x200 4 cores ');
   WriteLn('  02 - CGA      640x200 2 cores ( preto e branco ) ');
   WriteLn('  03 - HERC     720x348 2 cores ( preto e branco ) ');
   WriteLn('  04 - EGA      640x200 16 cores ');
   WriteLn('  05 - EGA      640x350 16 cores ');
   WriteLn('  06 - EGA64    640x200 16 cores ');
   WriteLn('  07 - EGA64    640x350 16 cores ');
   WriteLn('  08 - VGA      640x200 16 cores ');
   WriteLn('  09 - VGA      640x350 16 cores ');
   WriteLn('  10 - VGA      640x480 16 cores ');
   WriteLn('  11 - IBM8514  640x480 16 cores ');
   WriteLn('  12 - IBM8514 1024x768 16 cores '); WriteLn;
   Write  (' Modo recomendado : ');
   DetectGraph( a.gm, a.gt );
   if a.gm=CGA then WriteLn(' CGA - 01 ou 02');
   if a.gm=EGA then WriteLn(' EGA - 04 ou 05');
   if a.gm=HERCMONO then WriteLn(' HERC - 03 ');
   if a.gm=VGA then WriteLn(' VGA - 08, 09 ou 10 ');
   if a.gm=IBM8514 then WriteLn(' IBM8514 - 11 ou 12 ');
   Write(' Opá∆o : ');
   1:;
   t:=Perg('01'+Chr(27));
   Write( t );
   if t=#27 then begin WriteLn; WriteLn; Halt(1); end;
   s:='';
   s:=s+t;
   t:=Perg('0123456789'+Chr(27));
   Write( t );
   if t=#27 then begin WriteLn; WriteLn; Halt(1); end;
   s:=s+t;

   Val( s, op, code );

   if(op=0) or (op>12) then begin
    sound(220); delay(200); NoSound;
    GotoXY( 10, whereY );
    Write('    '); GotoXY( 10, whereY ); goto 1;
   end;

   if op=1  then begin a.gm:=CGA; a.gt:=1; end;
   if op=2  then begin a.gm:=CGA; a.gt:=CGAHi; end;
   if op=3  then begin a.gm:=HERCMONO; a.gt:=HERCMONOHi; end;
   if op=4  then begin a.gm:=EGA; a.gt:=EGALo; end;
   if op=5  then begin a.gm:=EGA; a.gt:=EGAHi; end;
   if op=6  then begin a.gm:=EGA64; a.gt:=EGA64Lo; end;
   if op=7  then begin a.gm:=EGA64; a.gt:=EGA64Hi; end;
   if op=8  then begin a.gm:=VGA; a.gt:=VGALo; end;
   if op=9  then begin a.gm:=VGA; a.gt:=VGAMed; end;
   if op=10 then begin a.gm:=VGA; a.gt:=VGAHi; end;
   if op=11 then begin a.gm:=IBM8514; a.gt:=IBM8514Lo; end;
   if op=12 then begin a.gm:=IBM8514; a.gt:=IBM8514Hi; end;

   InitGraph( a.gm, a.gt, '' );

   If GraphResult <> grOk then begin
    WriteLn;
    WriteLn(' Houve um erro ao inicializar os gr†ficos, verifique se o seu adaptador de');
    WriteLn(' v°deo Ç o mesmo que o especificado, caso n∆o for, utilize o que Ç compati-');
    WriteLn(' vel. Se mesmo assim n∆o funcionar, entre em contato com :');
    WriteLn('  David Gustavo Maziero - DGM Inform†tica ');
    WriteLn;
    Halt(1);
   end;

  End;

{---- Perg ------------------------------------------------------------------}
  function Perg( s : String ) : Char;
  var
   op : array[1..255] of Char;
   r,a  : Word;
   t  : Char;
  Begin
   LimpaT; a:=1;
   while a=1 do begin
    t:=ReadKey;
    for r:=1 to Length(s) do begin
     if t=s[r] then a:=2;
    end;
    if a=1 then begin sound(220); delay(200); nosound; end;
   end;
   Perg:=t;
  End;

{---- LimpaT ----------------------------------------------------------------}
  procedure LimpaT;
  var t : Char;
  Begin
   while keypressed do t:=ReadKey;
  End;

{---- ShowCarac -------------------------------------------------------------}
  procedure ShowCarac( var a : Draw6AllTypes );
  var mx,dx,my,dy,r,size : Byte;
  Begin

   SetColor(GREEN); Rectangle(0,0,a.maxx,a.maxy);
   SetColor(RED);   Rectangle(1,1,a.maxx-1,a.maxy-1);  SetColor(WHITE);

   mx:=1; dx:=18; my:=1; dy:=12; r:=1;

   SetColor( GREEN ); SetTextStyle(TRIPLEXFONT,HORIZDIR,1);

   while r=1 do begin

    SetUserCharSize( mx, dx, my, dy );
    OutTextXY(a.maxx div 10, a.maxy div 20, 'DRAW 6.0');
    delay(40); setcolor(0);
    OutTextXY(a.maxx div 10, a.maxy div 20, 'DRAW 6.0');
    SetColor( GREEN );

    if a.maxx div 9>=TextWidth('H') then mx:=mx+1;
    if a.maxy div 2>=TextHeight('H') then my:=my+1;

    if(a.maxx div 9<TextWidth('H')) and
      (a.maxy div 2<TextHeight('H')) then r:=2;
   end;

   OutTextXY(a.maxx div 10, a.maxy div 20, 'DRAW 6.0');
   OutTextXY(a.maxx div 10+1, a.maxy div 20-1, 'DRAW 6.0');
   OutTextXY(a.maxx div 10+2, a.maxy div 20-2, 'DRAW 6.0');
   SetColor(WHITE);
   OutTextXY(a.maxx div 10+3, a.maxy div 20-3, 'DRAW 6.0');
   OutTextXY(a.maxx div 10+4, a.maxy div 20-4, 'DRAW 6.0');

   SetTextStyle(SMALLFONT,HORIZDIR,size);
   size:=1;
   repeat
    size:=size+1;
    SetTextStyle(SMALLFONT,HORIZDIR,size);
   until (a.maxx div 50)<=TextWidth('H');

   OutTextXY( a.maxx div 50, a.maxy-round(TextHeight('H')*1.5), 'Copyright (c) 1998 David Maziero / DGM Inform†tica');

   Pause;

  End;

{---- Str2 ------------------------------------------------------------------}
  function Str2(L : LongInt) : string;
  var S : string;
  begin
   Str(L, S); Str2 := S;
  End;

{---- Str3 ------------------------------------------------------------------}
  function Str3(L : Real) : string;
  var S : string;
  begin
   Str(L:3:3, S); Str3 := S;
  End;

{---- Pause -----------------------------------------------------------------}
  procedure Pause;
  var t : Char;
  Begin
   LimpaT;
   while t<>chr(13) do t:=ReadKey;
  End;

{---- BasiComs --------------------------------------------------------------}
{                                         }
{ b = comandos b†sicos (FRENTE,CIMA etc)  }
{ x = comandos com XX e YY                }
{ c = cores com + e -                     }
{ C = cores com * e /                     }
{ á = cores com n e m                     }
{ B = cor borda com , e .                 }
{ r = radiusX com + e -                   }
{ R = radiusY com * e /                   }
{ s = stan e endan com a,s,w,z            }
{ f = fill e cor fill com .,<>            }
{ F = texto e just com .,<>               }
{ 3 = top3d com * e /                     }
{                                         }

  procedure BasiComs( t : char; var a : Draw6AllTypes; s : String );
  var p : Byte;
  begin

   for p:=1 to Length(s) do begin

    if s[p]='b' then begin
     if(t=FRENTE) and (a.x < a.maxx-a.ax)    then a.x:=a.x+ a.ax;
     if(t=TRAS)   and (a.x >= 0+a.ax )        then a.x:=a.x- a.ax;
     if(t=BAIXO)  and (a.y < a.maxy-26-a.ay) then a.y:=a.y+ a.ay;
     if(t=CIMA)   and (a.y >= 0+a.ay )        then a.y:=a.y- a.ay;
     if(t='6') and (a.x < a.maxx-(a.ax*5))       then a.x:=a.x+(a.ax*5);
     if(t='4') and (a.x >= 0+(a.ax*5) )          then a.x:=a.x-(a.ax*5);
     if(t='2') and (a.y < a.maxy-26-(a.ay*5))    then a.y:=a.y+(a.ay*5);
     if(t='8') and (a.y >= 0+(a.ay*5) )          then a.y:=a.y-(a.ay*5);
     if(t='7') and (a.x > 0+a.ax ) and (a.y > 0+a.ay ) then begin a.x:=a.x-a.ax; a.y:=a.y-a.ay; end;
     if(t='9') and (a.x < a.maxx-a.ax ) and (a.y > 0+a.ay ) then begin a.x:=a.x+a.ax; a.y:=a.y-a.ay; end;
     if(t='3') and (a.x < a.maxx-a.ax ) and (a.y < a.maxy-26-a.ay ) then begin a.x:=a.x+a.ax; a.y:=a.y+a.ay; end;
     if(t='1') and (a.x > 0+a.ax ) and (a.y < a.maxy-26-a.ay ) then begin a.x:=a.x-a.ax; a.y:=a.y+a.ay; end;
     if t=#27 then a.objeto:='ponto';
    end;

    if s[p]='x' then begin
     if(t='s') and (a.xx < a.maxx-a.ax)    then a.xx:=a.xx+ a.ax;
     if(t='a') and (a.xx >= 0+a.ax )       then a.xx:=a.xx- a.ax;
     if(t='z') and (a.yy < a.maxy-26-a.ay) then a.yy:=a.yy+ a.ay;
     if(t='w') and (a.yy >= 0+a.ay )       then a.yy:=a.yy- a.ay;
     if(t='S') and (a.xx < a.maxx-(a.ax*5))       then a.xx:=a.xx+(a.ax*5);
     if(t='A') and (a.xx >= 0+(a.ax*5) )          then a.xx:=a.xx-(a.ax*5);
     if(t='Z') and (a.yy < a.maxy-26-(a.ay*5))    then a.yy:=a.yy+(a.ay*5);
     if(t='W') and (a.yy >= 0+(a.ay*5) )          then a.yy:=a.yy-(a.ay*5);
    end;

    if s[p]='c' then begin
     if(t='+') and (a.cor<a.maxc) then a.cor:=a.cor+1;
     if(t='-') and (a.cor>0)      then a.cor:=a.cor-1;
    end;

    if s[p]='B' then begin
     if(t=',') and (a.corb<a.maxc) then a.corb:=a.corb+1;
     if(t='.') and (a.corb>0)      then a.corb:=a.corb-1;
    end;

    if s[p]='á' then begin
     if(t='n') and (a.cor<a.maxc) then a.cor:=a.cor+1;
     if(t='m') and (a.cor>0)      then a.cor:=a.cor-1;
    end;

    if s[p]='C' then begin
     if(t='*') and (a.cor<a.maxc) then a.cor:=a.cor+1;
     if(t='/') and (a.cor>0)      then a.cor:=a.cor-1;
    end;

    if s[p]='r' then begin
     if t='+' then a.radix:=a.radix+1;
     if(t='-') and (a.radix>0) then a.radix:=a.radix-1;
    end;

    if s[p]='R' then begin
     if t='*' then a.radiy:=a.radiy+1;
     if(t='/') and (a.radiy>0) then a.radiy:=a.radiy-1;
    end;

    if s[p]='s' then begin
     if(t='w') and (a.endan>0)   then a.endan:=a.endan-1;
     if(t='z') and (a.endan<360) then a.endan:=a.endan+1;
     if(t='a') and (a.stan>0) then a.stan:=a.stan-1;
     if(t='s') and (a.stan<360) then a.stan:=a.stan+1;
     if(t='W') and (a.endan>5)   then a.endan:=a.endan-5;
     if(t='Z') and (a.endan<355) then a.endan:=a.endan+5;
     if(t='A') and (a.stan>5) then a.stan:=a.stan-5;
     if(t='S') and (a.stan<355) then a.stan:=a.stan+5;
    end;

    if s[p]='f' then begin
     if(t='.') and (a.fill<11) then a.fill:=a.fill+1;
     if(t=',') and (a.fill>0)  then a.fill:=a.fill-1;
     if(t='>') and (a.corf<a.maxc) then a.corf:=a.corf+1;
     if(t='<') and (a.corf>0)      then a.corf:=a.corf-1;
    end;

    if s[p]='F' then begin
     if(t='.') and (a.ttexto<4) then a.ttexto:=a.ttexto+1;
     if(t=',') and (a.ttexto>0) then a.ttexto:=a.ttexto-1;
     if(t='>') and (a.just<1)   then a.just:=a.just+1;
     if(t='<') and (a.just>0)   then a.just:=a.just-1;
    end;

    if s[p]='3' then begin
     if t='*' then a.top3d:=a.top3d+1;
     if(t='/') and (a.top3d>0) then a.top3d:=a.top3d-1;
   end;


   end;

  end;

{---- ControlObj ------------------------------------------------------------}
  procedure ControlObj( var a : Draw6AllTypes );
  var
   t : Char;
   exi : String;
   ex,ey : Word;
   eex,eey : Word;
   eexx,eeyy : Word;
  begin
   t:=#0;

{----- Obj Ponto ------------------------------------------------------------}
   if a.objeto='ponto' then begin

    Comentario(a,'Ponto : ('+str2(a.x)+','+str2(a.y)+') cor='+cores[a.cor]+' ('+str2(a.i)+','
                 +str2(a.g)+','+str2(a.espe)+')','');

    if a.g=2 then a.bk1:=GetPixel( a.x, a.y );
    PutPixel( a.x, a.y, a.cor );

    t:=ReadKey;

    tipo:=1;

    if a.i=2 then putpixel( a.x, a.y, 0 );
    if a.g=2 then putpixel( a.x, a.y, a.bk1 );

    BasiComs(t,a,'bc');

    if t=#13 then begin
     mPAS:=mPAS+1;
     PAS^[mpas].tipo:=1;
     PAS^[mpas].x:=a.x;
     PAS^[mpas].y:=a.y;
     PAS^[mpas].cor:=a.cor;
    end;

    if t='`' then begin mPAS:=0; cleardevice; end;

    if(t='i') and (a.i=1) then begin a.i:=2; t:=#0; end;
    if(t='i') and (a.i=2) then begin a.i:=1; t:=#0; end;
    if(t='o') and (a.g=1) then begin a.g:=2; t:=#0; end;
    if(t='o') and (a.g=2) then begin a.g:=1; t:=#0; end;

    if t='p' then SalvaPASC;

    if t='q' then begin GravaTela(a); a.objeto:='quadrado'; tipo:=2;  a.xx:=a.x; a.yy:=a.y; end;
    if t='l' then begin GravaTela(a); a.objeto:='linha';    tipo:=5;  a.xx:=a.x; a.yy:=a.y; end;
    if t='c' then begin GravaTela(a); a.objeto:='circulo';  tipo:=6;  end;
    if t='f' then begin GravaTela(a); a.objeto:='fill';     tipo:=10; end;
    if t='a' then begin GravaTela(a); a.objeto:='borracha'; tipo:=11; a.xx:=a.x+5; a.yy:=a.y+5; a.corb:=0; end;
    if t='@' then begin a.objeto:='zoom'; end;
    if t='t' then begin a.texto:=PedeTexto('Entre com o texo a ser exibido : '); a.objeto:='texto';    tipo:=12; end;
    if t='s' then begin a.xx:=a.x; a.yy:=a.y; a.objeto:='salva'; end;
    if t='z' then Carrega(a);
    if t='r' then begin a.xx:=a.x; a.yy:=a.y; GravaTela(a); a.objeto:='recorta'; tipo:=20; a.xx:=a.x; a.yy:=a.y; end;
    if t='x' then begin a.xx:=a.x; a.yy:=a.y; GravaTela(a); a.objeto:='recorta'; tipo:=21; a.xx:=a.x; a.yy:=a.y; end;
    if t='&' then AdicionaArquivos(a);

    if(t='V') and (voltar=1) then VoltaTela(a);

    if t='!' then sair:=TRUE;

   end;

{----- Obj Quadrado ------------------------------------------------------------}
   if a.objeto='quadrado' then begin

    if tipo=2 then exi:='Quadrado';
    if tipo=3 then exi:='Quadrado Preenchido';
    if tipo=4 then exi:='Quadrado 3D';

    Comentario(a, exi+' : ('+str2(a.x)+','+str2(a.y)+','+str2(a.xx)+','+str2(a.yy)+') cor='+cores[a.cor]+' ',
                  'top3d='+str2(a.top3d)+' fill='+fills[a.fill]+' corf='+cores[a.corf]+'  '  );
     SalvaTela(a);

      SetColor( a.cor ); SetFillStyle( a.fill, a.corf );
      if tipo=2 then Rectangle( a.x, a.y, a.xx, a.yy );
      if tipo=3 then begin Bar( a.x, a.y, a.xx, a.yy ); Rectangle( a.x, a.y, a.xx, a.yy ); end;
      if tipo=4 then Bar3D( a.x, a.y, a.xx, a.yy, a.top3d, TopOn );

    t:=ReadKey;

     PoeTela(a);
     BasiComs(t,a,'bcxf3');

     if(t='[') and (tipo>2) then tipo:=tipo-1;
     if(t=']') and (tipo<4) then tipo:=tipo+1;

    if t=#13 then begin
      SetColor( a.cor ); SetFillStyle( a.fill, a.corf );
      if tipo=2 then Rectangle( a.x, a.y, a.xx, a.yy );
      if tipo=3 then begin Bar( a.x, a.y, a.xx, a.yy ); Rectangle( a.x, a.y, a.xx, a.yy ); end;
      if tipo=4 then Bar3D( a.x, a.y, a.xx, a.yy, a.top3d, TopOn );

     mPAS:=mPAS+1;
     PAS^[mpas].tipo:=tipo;
     PAS^[mpas].x:=a.x;   PAS^[mpas].y:=a.y;
     PAS^[mpas].xx:=a.xx; PAS^[mpas].yy:=a.yy;
     PAS^[mpas].cor:=a.cor; PAS^[mpas].rax:=a.top3d;
     PAS^[mpas].fill:=a.fill; PAS^[mpas].corf:=a.corf;

    end;

   end;

{----- Obj Linha ------------------------------------------------------------}
   if a.objeto='linha' then begin

    Comentario(a, 'Linha : ('+str2(a.x)+','+str2(a.y)+','+str2(a.xx)+','+str2(a.yy)+') cor='+cores[a.cor]+' ','');

    SalvaTela(a);

      SetColor( a.cor );
      Line( a.x, a.y, a.xx, a.yy );

    t:=ReadKey;

     PoeTela(a);
     BasiComs(t,a,'bcx');

    if t=#13 then begin
     SetColor( a.cor );
     Line( a.x, a.y, a.xx, a.yy );

     mPAS:=mPAS+1;
     PAS^[mpas].tipo:=tipo;
     PAS^[mpas].x:=a.x;   PAS^[mpas].y:=a.y;
     PAS^[mpas].xx:=a.xx; PAS^[mpas].yy:=a.yy;
     PAS^[mpas].cor:=a.cor;

     a.xx:=a.x; a.yy:=a.y;
    end;

   end;

{----- Obj Circulo ----------------------------------------------------------}
   if a.objeto='circulo' then begin

    if tipo=6 then exi:='Circulo';
    if tipo=7 then exi:='Arc';
    if tipo=8 then exi:='Pieslice';
    if tipo=9 then exi:='Sector';

    Comentario(a, exi+' : ('+str2(a.x)+','+str2(a.y)+') radius=('+str2(a.radix)+','+str2(a.radiy)+') cor='+cores[a.cor]+' ',
                  ' angle=('+str2(a.stan)+','+str2(a.endan)+') fill='+str2(a.fill)+' corf='+cores[a.corf]);

    SalvaTela(a);

     SetColor( a.cor );
     SetFillStyle( a.fill, a.corf );
     if tipo=6 then circle( a.x, a.y, a.radix );
     if tipo=7 then arc( a.x, a.y, a.stan, a.endan, a.radix );
     if tipo=8 then pieslice( a.x, a.y, a.stan, a.endan, a.radix );
     if tipo=9 then sector( a.x, a.y, a.stan, a.endan, a.radix, a.radiy);

    t:=ReadKey;

     PoeTela(a);
     BasiComs(t,a,'brRfás');

     if(t='[') and (tipo>6) then tipo:=tipo-1;
     if(t=']') and (tipo<9) then tipo:=tipo+1;

    if t=#13 then begin
     SetColor( a.cor );
     SetFillStyle( a.fill, a.corf );
     if tipo=6 then circle( a.x, a.y, a.radix );
     if tipo=7 then arc( a.x, a.y, a.stan, a.endan, a.radix );
     if tipo=8 then pieslice( a.x, a.y, a.stan, a.endan, a.radix );
     if tipo=9 then sector( a.x, a.y, a.stan, a.endan, a.radix, a.radiy);

     mPAS:=mPAS+1;
     PAS^[mpas].tipo:=tipo;
     PAS^[mpas].x:=a.x;
     PAS^[mpas].y:=a.y;
     PAS^[mpas].cor:=a.cor; PAS^[mpas].rax:=a.radix;
     PAS^[mpas].ray:=a.radiy;
     PAS^[mpas].fill:=a.fill; PAS^[mpas].corf:=a.corf;
     PAS^[mpas].stan:=a.stan; PAS^[mpas].endan:=a.endan;

    end;

   end;

{----- Obj Fill --------------------------------------------------------------}
   if a.objeto='fill' then begin
    a.corb:=a.cor;
    Comentario(a, 'Preenchimento : ('+str2(a.x)+','+str2(a.y)+') fill='+fills[a.fill]+' ',
                  ' corf='+cores[a.corf]+' corb='+cores[a.corb]+'   ');

    SalvaTela(a);

     SetFillStyle( a.fill, a.corf );
     floodfill( a.x, a.y, a.corb );

    t:=ReadKey;

     PoeTela(a);
     BasiComs(t,a,'bcf');

    if t=#13 then begin
     SetFillStyle( a.fill, a.corf );
     floodfill( a.x, a.y, a.corb );

     mPAS:=mPAS+1;
     PAS^[mpas].tipo:=tipo;
     PAS^[mpas].x:=a.x;
     PAS^[mpas].y:=a.y;
     PAS^[mpas].cor:=a.cor;
     PAS^[mpas].fill:=a.fill;
     PAS^[mpas].corf:=a.corf;
     PAS^[mpas].corb:=a.corb;

    end;

   end;

{----- Obj Borracha ---------------------------------------------------------}
   if a.objeto='borracha' then begin
    a.bmask:=a.cor;
    Comentario(a, 'Borracha : ('+str2(a.x)+','+str2(a.y)+') bmask='+cores[a.cor]+' corp='+cores[a.corb],'');

    SalvaTela(a);

     SetFillStyle( SOLIDFILL, 0 );
     if a.cor>0 then SetColor( a.cor  );
     if a.cor=0 then SetColor( a.maxc );
     SetWriteMode(XorPut);
     Line( a.x, a.y, a.xx, a.y );
     Line( a.x, a.y, a.x, a.yy );
     Line( a.xx, a.y, a.xx, a.yy );
     Line( a.x, a.yy, a.xx, a.yy );
     setwritemode(CopyPut);

    t:=ReadKey;

     PoeTela(a);
     BasiComs(t,a,'bxBc');

    if t=#13 then begin
     SetFillStyle( SOLIDFILL, a.corb );

     if a.cor=0 then Bar( a.x, a.y, a.xx, a.yy );

     if a.cor>0 then begin

       if a.y<a.yy then begin eey:=a.y; eeyy:=a.yy; end;
       if a.y>a.yy then begin eey:=a.yy; eeyy:=a.y; end;
       if a.x<a.xx then begin eex:=a.x; eexx:=a.xx; end;
       if a.x>a.xx then begin eex:=a.xx; eexx:=a.x; end;

       for ey:=eey to eeyy do begin
        for ex:=eex to eexx do begin
         if GetPixel( ex, ey )=a.cor then PutPixel( ex, ey, a.corb );
        end;
       end;
     end;

    end;

   end;

{----- Obj Zoom -------------------------------------------------------------}
   if a.objeto='zoom' then begin

    Comentario(a, 'Zoom : ('+str2(a.x)+','+str2(a.y)+','+str2(a.xx)+','+str2(a.yy)+')   ','');

    SalvaTela(a);

     SetColor( WHITE );
     rectangle( a.x, a.y, a.x + 63, a.y + 34 );

    t:=ReadKey;

     PoeTela(a);
     BasiComs(t,a,'b');

     if t=#13 then ZoomEfect( a );

   end;

{----- Obj Texto ------------------------------------------------------------}
   if a.objeto='texto' then begin

    Comentario(a, 'Texto : ('+str2(a.x)+','+str2(a.y)+') font='+fontes[a.ttexto]+' just='+justs[a.just],
                  ' size=('+str2(a.chx1)+','+str2(a.chx2)+','+str2(a.chy1)+','+str2(a.chy2)+')    ');

    SalvaTela(a);

      SetColor( a.cor );
      SetTextStyle( a.ttexto, a.just, a.chx1 );
      if(a.chx2>0) or (a.chy1>0) or (a.chy2>0) then SetUserCharSize( a.chx1, a.chx2, a.chy1, a.chy2 );
      OutTextXY( a.x, a.y, a.texto );

    t:=ReadKey;

     PoeTela(a);
     BasiComs(t,a,'bcF');

     if t='s' then a.chx1:=a.chx1+1;
     if(t='a') and (a.chx1>0) then a.chx1:=a.chx1-1;

     if t='A' then a.chx2:=a.chx2+1;
     if(t='S') and (a.chx2>0) then a.chx2:=a.chx2-1;

     if t='z' then a.chy1:=a.chy1+1;
     if(t='w') and (a.chy1>0) then a.chy1:=a.chy1-1;

     if t='W' then a.chy2:=a.chy2+1;
     if(t='Z') and (a.chy2>0) then a.chy2:=a.chy2-1;

    if t=#13 then begin
     SetColor( a.cor );
     SetTextStyle( a.ttexto, a.just, a.chx1 );
     if(a.chx2>0) or (a.chy1>0) or (a.chy2>0) then SetUserCharSize( a.chx1, a.chx2, a.chy1, a.chy2 );
     OutTextXY( a.x, a.y, a.texto );
     mPAS:=mPAS+1;
     PAS^[mpas].tipo:=tipo;
     PAS^[mpas].x:=a.x;   PAS^[mpas].y:=a.y;
     PAS^[mpas].cor:=a.cor;
     PAS^[mpas].texto:=a.texto;
     PAS^[mpas].fill:=a.ttexto;
     PAS^[mpas].corf:=a.just;
     PAS^[mpas].rax:=a.chx1;
     PAS^[mpas].ray:=a.chx2;
     PAS^[mpas].stan:=a.chy1;
     PAS^[mpas].endan:=a.chy2;
    end;

   end;

{----- Obj Salva ------------------------------------------------------------}
   if a.objeto='salva' then begin

    Comentario(a, 'Salvar : ('+str2(a.x)+','+str2(a.y)+','+str2(a.xx)+','+str2(a.yy)+') size='
                  +Str2( ImageSize(a.x,a.y,a.xx,a.yy) ),'');

{    SalvaTela(a); }

    SetColor( WHITE );
    SetWriteMode(XorPut);
    Rectangle( a.x, a.y, a.xx, a.yy );
    SetWriteMode(CopyPut);

    t:=ReadKey;

    SetColor( WHITE );
    SetWriteMode(XorPut);
    Rectangle( a.x, a.y, a.xx, a.yy );
    SetWriteMode(CopyPut);

{     PoeTela(a); }


     BasiComs(t,a,'bx');

    if t=#13 then Salva( a );

   end;

{----- Obj Recorta ------------------------------------------------------------}
   if a.objeto='recorta' then begin

    if tipo=20 then
     Comentario(a, 'Recortar Imagem : ('+str2(a.x)+','+str2(a.y)+','+str2(a.xx)+','+str2(a.yy)+') size='
                   +Str2( ImageSize(a.x,a.y,a.xx,a.yy) ),'');

       if a.y<a.yy then begin eey:=a.y; eeyy:=a.yy; end;
       if a.y>a.yy then begin eey:=a.yy; eeyy:=a.y; end;
       if a.x<a.xx then begin eex:=a.x; eexx:=a.xx; end;
       if a.x>a.xx then begin eex:=a.xx; eexx:=a.x; end;

    if tipo=21 then begin
     Comentario(a, 'Efeito / Recortar : ('+str2(a.x)+','+str2(a.y)+','+str2(a.xx)+','+str2(a.yy)+') size='
                   +Str2( (eexx-eex)*(eeyy-eey)  ),'');

     if (eexx-eex)*(eeyy-eey)>64000 then begin
      if a.y>a.yy then a.y:=a.y-5;
      if a.yy>a.y then a.yy:=a.yy-5;
     end;
    end;

{    SalvaTela(a); }

    SetColor( WHITE );
    SetWriteMode(XorPut);
    Rectangle( a.x, a.y, a.xx, a.yy );
    SetWriteMode(CopyPut);

    t:=ReadKey;

    SetColor( WHITE );
    SetWriteMode(XorPut);
    Rectangle( a.x, a.y, a.xx, a.yy );
    SetWriteMode(CopyPut);

{     PoeTela(a); }

     BasiComs(t,a,'bx');

    if t=#13 then begin
     if tipo=20 then GeRec( a );
     if tipo=21 then GeEfe( a );
    end;

    end;

   end;



{---- ZoomEfect -------------------------------------------------------------}
  procedure ZoomEfect( var a : Draw6AllTypes );
  type
   BaseZoom = record
    c : Byte;
   end;
   Zoom2 = array[1..2108] of BaseZoom;
   ZoomType = ^Zoom2;
  var
   dex,dey,ex,ey,bk,r : Word;
   t : Char;
   z : ZoomType;
   pu : Byte;
  begin
   pu:=0;
   SalvaTela( a );
    GetMem( z, 2108 );
    dex:=a.maxx div 63;
    dey:=(a.maxy-26) div 34;

   r:=1;
   for ey:=a.y to a.y+33 do begin
    for ex:=a.x to a.x+61 do begin
     bk:=GetPixel( ex, ey );
     z^[r].c:=bk;
     r:=r+1;
    end;
   end;

   ClearDevice;
   setcolor(WHITE);
{   for r:=1 to 63 do begin
    line( (r*dex)-dex, 0, (r*dex)-dex, 34*dey );
   end;
   for r:=1 to 35 do begin
    line( 0, (r*dey)-dey, 62*dex, (r*dey)-dey );
   end;}

   r:=1;
   for ey:=0 to 33 do begin
    for ex:=0 to 61 do begin
     SetFillStyle( SOLIDFILL, z^[r].c );
     bar( (ex*dex)+1, (ey*dey)+1, (ex*dex)+dex-1, (ey*dey)+dey-1 );
     r:=r+1;
    end;
   end;



   LimpaT; t:=#0;
   ex:=0; ey:=0;

   while t<>#13 do begin

    bk:=GetPixel( (ex*dex)+1, (ey*dey)+1 );

    Comentario(a,'Zoom : ('+str2(ex)+','+str2(ey)+') cor='+cores[a.cor]+' bkcor='+cores[bk]+' '+str2(pu),'');

    if bk=0 then setcolor( WHITE );
    if bk=a.maxc then setcolor( 0 );
    if(bk>0) and (bk<a.maxc) then setcolor(bk+1);
    circle( (ex*dex)+(dex div 2)+1, (ey*dey)+(dey div 2)+1 ,1 );

    t:=ReadKey;

    setcolor( bk );
    circle( (ex*dex)+(dex div 2)+1, (ey*dey)+(dey div 2)+1 ,1 );

    if pu=1 then begin
     SetFillStyle( SOLIDFILL, a.cor );
     bar( (ex*dex)+1, (ey*dey)+1, (ex*dex)+dex-1, (ey*dey)+dey-1 );
    end;

    BasiComs(t,a,'c');

    if(t=FRENTE) and (ex<61) then ex:=ex+1;
    if(t=TRAS)   and (ex>0)  then ex:=ex-1;
    if(t=BAIXO)  and (ey<33) then ey:=ey+1;
    if(t=CIMA)   and (ey>0)  then ey:=ey-1;

    if(t='5') and (pu=0) then begin t:=#0; pu:=1; end;
    if(t='5') and (pu=1) then begin t:=#0; pu:=0; end;

    if t=#8 then begin
     SetFillStyle( SOLIDFILL, 0 );
     bar( (ex*dex)+1, (ey*dey)+1, (ex*dex)+dex-1, (ey*dey)+dey-1 );
    end;

    if t=' ' then begin
     SetFillStyle( SOLIDFILL, a.cor );
     bar( (ex*dex)+1, (ey*dey)+1, (ex*dex)+dex-1, (ey*dey)+dey-1 );
    end;

    if t=#27 then begin cleardevice; PoeTela(a); Exit; end;

   end;

   r:=1;
   for ey:=0 to 33 do begin
    for ex:=0 to 61 do begin
     bk:=GetPixel( (ex*dex)+1, (ey*dey)+1 );
     z^[r].c:=bk;
     r:=r+1;
    end;
   end;
   ClearDevice;
   PoeTela(a);

   r:=1;
   for ey:=a.y to a.y+33 do begin
    for ex:=a.x to a.x+61 do begin
     PutPixel( ex, ey, z^[r].c );
     r:=r+1;
    end;
   end;
    FreeMem( z, 2108 );

  end;


{---* Principal *------------------------------------------------------------}


procedure Abort(Msg : string);
begin
  Writeln(Msg, ': ', GraphErrorMsg(GraphResult));
  Halt(1);
end;

  Begin

  if RegisterBGIdriver(@CGADriverProc) < 0 then
    Abort('CGA');
  if RegisterBGIdriver(@EGAVGADriverProc) < 0 then
    Abort('EGA/VGA');
  if RegisterBGIdriver(@HercDriverProc) < 0 then
    Abort('Herc');
  if RegisterBGIdriver(@ATTDriverProc) < 0 then
    Abort('AT&T');
  if RegisterBGIdriver(@PC3270DriverProc) < 0 then
    Abort('PC 3270');

  if RegisterBGIfont(@GothicFontProc) < 0 then
    Abort('Gothic');
  if RegisterBGIfont(@SansSerifFontProc) < 0 then
    Abort('SansSerif');
  if RegisterBGIfont(@SmallFontProc) < 0 then
    Abort('Small');
  if RegisterBGIfont(@TriplexFontProc) < 0 then
    Abort('Triplex');

   InitModeGraph(a);

   mPas:=0;
   voltar:=0;

   with a do
   begin

     x:=50; y:=50; xx:=50; yy:=50;
     cor:=GetMaxColor;
     bk1:=0; bk2:=0; bk3:=0; bk4:=0; bk5:=0; bk6:=0; bk7:=0; bk8:=0; bk9:=0;
     ax:=1; ay:=1; i:=1; g:=1; espe:=1;
     fill:=0; corf:=GetMaxColor-1; corb:=GetMaxColor; bmask:=0;
     radix:=1; radiy:=0; stan:=0; endan:=360;
     top3d:=0; ttexto:=DEFAULTFONT; just:=HORIZDIR; texto:='';
     chx1:=1; chx2:=0; chy1:=0; chy2:=0;
     maxx:=GetMaxX; maxy:=GetMaxY; maxc:=GetMaxColor;
     objeto:='ponto';

   end;

   ShowCarac(a);
   ClearDevice;

   GetMem( PAS, sizeof( PtrPasType ) );

   sair:=False;
   tipo:=1;
   defname:='';

   while not sair do begin

     ControlObj( a );

   end;

   CloseGraph;

   WriteLn;
   WriteLn(' Draw v6.0 - Copyright (c) 1999 David Maziero / DGM Inform†tica');
   WriteLn(' Obrigado por usar os programas DGM Inform†tica.');
   WriteLn; WriteLn;

  End.
