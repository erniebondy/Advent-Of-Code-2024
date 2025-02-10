program Main;
uses SysUtils, StrUtils, Character;

procedure Part2(const Data: AnsiString);
var
    BeginIdx, EndIdx: Integer;
    //Len: Word;
    NumA, NumB, Pos, Rezult: LongInt; //OpPos, CmdPos,
    Enabled: Boolean;
    DoCmd, DontCmd, Op: String;
begin

{ 
    NOTE TO SELF: Make sure the variable that can go negative is a signed integer,
    otherwise Pascal doesn't care and wraps the value around. Thanks.
}
    Pos:= 0;
    BeginIdx:= 0;
    EndIdx:= 0;
    Rezult:= 0;
    Enabled:= true;
    DoCmd:= 'do()';
    DontCmd:= 'don''t()';
    Op:= 'mul';

    while Pos < Length(Data) do begin

        if Enabled then begin
            if Data.SubString(Pos, Length(DontCmd)) = DontCmd then begin
                Enabled:= false;
                Inc(Pos, Length(DontCmd));
            end else if Data.SubString(Pos, Length(Op)) = Op then begin
                Inc(Pos, Length(Op));
                // Check for (
                if Data.Chars[Pos] <> '(' then continue;
                // Inc pos
                Inc(Pos);
                if Pos >= Length(Data) then break;
                // do while number
                BeginIdx:= Pos;
                if (IsDigit(Data.Chars[Pos])) or (Data.Chars[Pos] = '-') then begin
                    Inc(Pos);
                    if Pos >= Length(Data) then break;
                    while (IsDigit(Data.Chars[Pos])) and (Pos < Length(Data)) do begin
                        Inc(Pos);
                    end;
                end else begin
                    continue;
                end;

                if Pos >= Length(Data) then break;
                // check for ,
                if Data.Chars[Pos] <> ',' then continue;
                // get numA
                EndIdx:= Pos;
                NumA:= StrToInt(Data.SubString(BeginIdx, EndIdx-BeginIdx));
                // inc pos
                Inc(Pos);
                if Pos >= Length(Data) then break;

                BeginIdx:= Pos;
                // do while number
                if (IsDigit(Data.Chars[Pos])) or (Data.Chars[Pos] = '-') then begin
                    Inc(Pos);
                    if Pos >= Length(Data) then break;
                    while (IsDigit(Data.Chars[Pos])) and (Pos < Length(Data)) do begin
                        Inc(Pos);
                    end;
                end else begin
                    continue;
                end;

                if Pos >= Length(Data) then break;
                // check for )
                if Data.Chars[Pos] <> ')' then continue;
                // get numB
                EndIdx:= Pos;
                NumB:= StrToInt(Data.SubString(BeginIdx, EndIdx-BeginIdx));
                // rez += numA * numB
                Rezult:= Rezult + (NumA * NumB);
                // inc pos
                Inc(Pos);
            end else begin
                Inc(Pos);
            end;
        end else begin
            if Data.SubString(Pos, Length(DoCmd)) = DoCmd then begin
                Enabled:= true;
                Inc(Pos, Length(DoCmd));
                continue;
            end;
            
            Inc(Pos);
        end;

        //WriteLn('>Pos ', Pos);

    end;

    WriteLn();
    WriteLn('> Part 2: ', Rezult);

end;

procedure Part1(const Data: AnsiString);
var
    BeginIdx, EndIdx: Integer;
    Len: Word;
    NumA, NumB, Pos, Rezult: LongInt;
begin

{ 
    NOTE TO SELF: Make sure the variable that can go negative is a signed integer,
    otherwise Pascal doesn't care and wraps the value around. Thanks.
}
    Pos:= 0;
    BeginIdx:= 0;
    EndIdx:= 0;
    Rezult:= 0;

    while Pos < Length(Data) do begin

        Pos:= Data.IndexOf('mul(', Pos);
        if Pos < 0 then break;
        
        Inc(Pos, Length('mul('));
        BeginIdx:= Pos;
{       
        NOTE: MyString.Chars[] gives a ZERO indexed based access to the string 
        as opposed to accessing the string array directly (MyString[]) which is ONE indexed based.
}
        NumA:= 0;
        while (TryStrToInt(Data.Chars[Pos], NumA)) or (Data.Chars[Pos] = '-') do begin
            Inc(Pos);
            If Pos >= Length(Data) then break;
        end;

        If Pos >= Length(Data) then break;
        if Data.Chars[Pos] <> ',' then continue;

        EndIdx:= Pos;
        if EndIdx = BeginIdx then continue;

        Len:= EndIdx - BeginIdx;
        if not TryStrToInt(Data.SubString(BeginIdx, Len), NumA) then continue;
        //WriteLn(' >NumA: ', NumA);

        Pos:= EndIdx + 1;
        if Pos >= Length(Data) then break;

        BeginIdx:= Pos;
        NumB:= 0;
        while (TryStrToInt(Data.Chars[Pos], NumB)) or (Data.Chars[Pos] = '-') do begin
            Inc(Pos);
            If Pos >= Length(Data) then break;
        end;

        If Pos >= Length(Data) then break;
        if Data.Chars[Pos] <> ')' then continue;

        EndIdx:= Pos;
        if EndIdx = BeginIdx then continue;

        Len:= EndIdx - BeginIdx;
        if not TryStrToInt(Data.SubString(BeginIdx, Len), NumB) then continue;
        //WriteLn(' >NumB: ', NumB);

        { Good result }
        //WriteLn(' >Nums: ', NumA, ' x ', NumB);
        Rezult:= Rezult + (NumA * NumB);
        Pos:= EndIdx + 1;

    end;

    WriteLn();
    WriteLn('> Part 1: ', Rezult);

end;
    
  
{ Main entry }
var
    InFile: Text;
    Data, Line: AnsiString;
begin

{
    NOTE: SetLength preserves the elements of the array.
          Set length to 0 to clear the array from memory.
}

    Assign(InFile, ParamStr(1));
    Reset(InFile);

    while not EOF(InFile) do begin
        ReadLn(InFile, Line);
        AppendStr(Data, Line);
    end;

    Close(InFile);

{
    When using a dynamic array, the first element of the buffer must be passed to BlockRead.
    As opposed to when using a static array, the name of the array must be passed to BlockRead. Wow.
}   

    Part1(Data);
    Part2(Data);
end.