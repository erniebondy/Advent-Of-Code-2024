program Main;
uses SysUtils; { StrToInt }

type
    TermCode = (INVALID, OP, OPAREN, NUM, NUM_DELIM, CPAREN, END_OF_TermCode);
    TermData = record
        IsEmpty: Boolean;
        Code: TermCode;
        Value: Integer;
        Symbol: Char;
    end;
    TermArray = Array of TermData;

procedure PrintTermArr(TermArr: TermArray);
var
    T: TermData;
begin
    for T in TermArr do begin
        WriteLn(' > ', T.Code, ' ', T.Value, ' ', T.Symbol);
    end;
end;

function GetTermCode(const Data: packed Array of Char): TermArray;
var
    TermArr: TermArray;
    ArrLength: LongWord;
    I: LongWord;
    Ch: Char;
    T: TermData;
begin
    //SetLength(TermArr, Length(Data));

    I:= 0;
    ArrLength:= 0;
    SetLength(TermArr, ArrLength);

    while I <= High(Data) do begin
        Ch:= Data[I];
        case Ch of
            'm': begin
                if I + 2 < Length(Data) then begin
                    if (Data[I+1] = 'u') and (Data[I+2] = 'l') then begin
                        Inc(ArrLength);
                        SetLength(TermArr, ArrLength);
                        TermArr[High(TermArr)].IsEmpty:= false;
                        TermArr[High(TermArr)].Code:= OP;
                        TermArr[High(TermArr)].Value:= 0;
                        TermArr[High(TermArr)].Symbol:= '*';
                        Inc(I, 3);
                    end;
                end;
            end;
            '0'..'9': begin
                Inc(ArrLength);
                SetLength(TermArr, ArrLength);
                TermArr[High(TermArr)].IsEmpty:= false;
                TermArr[High(TermArr)].Code:= NUM;
                TermArr[High(TermArr)].Value:= StrToInt(Ch);
                TermArr[High(TermArr)].Symbol:= Ch;
                Inc(I);
            end;
            '(': begin
                Inc(ArrLength);
                SetLength(TermArr, ArrLength);
                TermArr[High(TermArr)].IsEmpty:= false;
                TermArr[High(TermArr)].Code:= OPAREN;
                TermArr[High(TermArr)].Value:= 0;
                TermArr[High(TermArr)].Symbol:= Ch;
                Inc(I);
            end;
            ')': begin
                Inc(ArrLength);
                SetLength(TermArr, ArrLength);
                TermArr[High(TermArr)].IsEmpty:= false;
                TermArr[High(TermArr)].Code:= CPAREN;
                TermArr[High(TermArr)].Value:= 0;
                TermArr[High(TermArr)].Symbol:= Ch;
                Inc(I);
            end;
            ',': begin
                Inc(ArrLength);
                SetLength(TermArr, ArrLength);
                TermArr[High(TermArr)].IsEmpty:= false;
                TermArr[High(TermArr)].Code:= NUM_DELIM;
                TermArr[High(TermArr)].Value:= 0;
                TermArr[High(TermArr)].Symbol:= Ch;
                Inc(I);
            end;
            else begin
                //Inc(ArrLength);
                //SetLength(TermArr, ArrLength);
                //TermArr[ArrLength].Code:= INVALID;
                //TermArr[ArrLength].Value:= -1;
                //TermArr[ArrLength].Symbol:= Ch;
                Inc(I);
            end;
        end;

    end;

    //WriteLn();
    //WriteLn(ArrLength);
    //PrintTermArr(TermArr);
    
    exit(TermArr);
end;

function NextTerm(const TermArr: TermArray): TermData;
    TD: TermData;
begin

    if TermIdx < Length(TermArr) then begin
        Inc(TermIdx);
        exit(TermArr[TermIdx -1])
    end else begin
        TD.IsEmpty:= true;
        exit(TD);
    end;
end;

procedure Part1(var Data: packed Array of Char);
var
    TermArr: TermArray;
    TD: TermData;
    I: LongWord;
    Nums: Array of Integer;
    NumsSize: Word;
    NbNums: Word;
    Number: ;
begin
    
    { OP OPAREN NUM:REPEAT SEPARATOR NUM:REPEAT CPAREN }
    SetLength(TermArr, 0);
    TermArr:= GetTermCode(Data);

    TermIdx:= 0;
    

    //WriteLn();
    //WriteLn('---------------');
    //PrintTermArr(TermArr);

    while true do begin

        { Get OP }
        while (TD:= NextTerm(TermArr)).IsEmpty = false do begin
            if TD.Code = OP then break;
        end;

        if TD.IsEmpty then break

        { Get OPAREN }
        if (TD:= NextTerm(TermArr)).IsEmpty then break;
        if TD.Code <> OPAREN then continue;

        { Get numbers }
        if (TD:= NextTerm(TermArr)).IsEmpty then break;

        NumsSize:= 0;
        NbNums:= 0;
        while (TD:= NextTerm(TermArr)).Code = NUM do begin
            
            //Inc(NumsSize);
            //SetLength(Nums, NumsSize);
            //Nums[High(Nums)]:= TD.Value;
        end;

    end;


end;

//procedure PrintArr(const arr: array of string);
//var
//    s: string;
//begin
//    for s in arr do begin
//        WriteLn('> ', s);
//    end;
//end;

{ Main entry }
var
    InFile: File;
    Buf: packed Array of Char;
    InFileSize: LongWord;
    TermIdx: LongWord;
begin

{
    NOTE: SetLength preserves the elements of the array.
          Set length to 0 to clear the array from memory.
}

    Assign(InFile, ParamStr(1));
    Reset(InFile, 1);

    InFileSize:= FileSize(InFile);
    SetLength(Buf, InFileSize);
{
    When using a dynamic array, the first element of the buffer must be passed to BlockRead.
    As opposed to when using a static array, the name of the array must be passed to BlockRead. Wow.
}
    BlockRead(InFile, Buf[0], InFileSize);

    Close(InFile);

    Part1(Buf);
end.