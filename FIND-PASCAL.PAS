{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2024
  @website(https://www.gladir.com/coleco-tools)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Program FIND_PASCAL;

Const
 VECTOR_SIZE=17;

Type
 VectorTableRec=Record
  Addr:Word;
  Name:Array[0..31] of Char;
 End;

Const
 VectorTable:Array[0..VECTOR_SIZE-1] of VectorTableRec=(
  (Addr:$1F64;Name:'ACTIVATEP'),
  (Addr:$1F67;Name:'PUTOBJP'),
  (Addr:$1F8B;Name:'INIT_TABLEP'),
  (Addr:$1F8E;Name:'GET_VRAMP'),
  (Addr:$1F91;Name:'PUT_VRAMP'),
  (Addr:$1F94;Name:'INIT_SPR_ORDERP'),
  (Addr:$1F97;Name:'WR_SPR_NM_TBLP'),
  (Addr:$1F9A;Name:'INIT_TIMERP'),
  (Addr:$1F9D;Name:'FREE_SIGNALP'),
  (Addr:$1FA0;Name:'REQUEST_SIGNALP'),
  (Addr:$1FA3;Name:'TEST_SIGNALP'),
  (Addr:$1FA6;Name:'WRITE_REGISTERP'),
  (Addr:$1FA9;Name:'WRITE_VRAMP'),
  (Addr:$1FAC;Name:'READ_VRAMP'),
  (Addr:$1FAF;Name:'INIT_WRITERP'),
  (Addr:$1FB2;Name:'SOUND_INITP'),
  (Addr:$1FB5;Name:'PLAY_ITP')
 );

Var
 HasPascalFuncs:Boolean;
 ByteReaded:Word;
 FP:File;
 B:Byte;
 A:Word;
 I:Integer;

BEGIN
 If(ParamStr(1)='/?')or(ParamStr(1)='--help')or(ParamStr(1)='-h')or
   (ParamStr(1)='/h')or(ParamStr(1)='/H')Then Begin
  WriteLn('FIND-PASCAL - Cette commande permet d''analyser les ',
                         'cartouches de jeu Coleco pour une ',
                         'utilisation vectorielle Pascal.');
  WriteLn;
  WriteLn('Syntaxe: FIND-PASCAL [/?] fichier.rom');
  WriteLn;
  WriteLn(' fichier.rom  Indique le nom du fichier Ö analyser');
 End
  Else
 If ParamCount>0 Then Begin
  HasPascalFuncs:=False;
  {$I-}Assign(fp, ParamStr(1));
  Reset(fp, 1);{$I+}
  If IOResult<>0 Then Begin
   WriteLn('Erreur de lecture du fichier ', ParamStr(1));
   Halt(1);
  End;
  While Not EOF(FP)do Begin
   BlockRead(fp,b,SizeOf(b),ByteReaded);
   If B=$CD Then Begin
    BlockRead(FP,A,SizeOf(A),ByteReaded);
    For I:=0 to VECTOR_SIZE-1 do Begin
     If A=VectorTable[i].addr Then Begin
      If Not HasPascalFuncs Then Begin
       WriteLn(ParamStr(1)+':');
       HasPascalFuncs:=True;
      End;
      WriteLn(#9,VectorTable[i].Name);
     End;
    End;
   End;
  End;
  If(hasPascalFuncs)Then WriteLn;
  Close(fp);
 End
  Else
 Begin
  WriteLn('Paramätre requis');
  Halt(1);
 End;
END.