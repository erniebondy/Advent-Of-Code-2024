program Main;
uses SysUtils, StrUtils;

procedure PrintArr(Arr: Array of AnsiString);
var
    I: Word;
begin
    Write('[ ');
    for I:= Low(Arr) to High(Arr) do begin
        Write(Arr[I], ' ');
    end;
    WriteLn(']');
    ///WriteLn();
end;

{ We must define a Type alias for the dynamic array 
  or else the compiler will treat the dynamic array as a static one.
  This is a major issue, as we need to delete an element from the array.
  The Delete function can only accept a dynamic array - not a static one.
  Thanks Pascal... }
Type
    DynArrayOfAnsiString = Array of AnsiString;

function IsLevelSafe(var Levels: DynArrayOfAnsiString): Boolean;
var
    A, B, I: Word;
    Diff: Integer;
    IsInc, IsDec: Boolean;
begin

    I:=0;
    IsInc:= false;
    IsDec:= false;

    A:= StrToInt(Levels[I]);
    Inc(I);

    while I <= High(Levels) do begin

        B:= StrToInt(Levels[I]);
        Diff:= A - B;

        if Diff = 0 then begin
            exit(false);
        end;

        if (IsInc) or (IsDec) then begin
            //WriteLn('[DEBUG] IsInc or IsDec');
            if Diff < 0 then begin // Increasing
                IsInc:= true;
                if (IsInc) and (IsDec) then begin
                    exit(false);
                end;
            end else begin
                IsDec:= true;
                if (IsInc) and (IsDec) then begin
                    exit(false);
                end;
            end;
        end else begin
            if Diff < 0 then begin
                IsInc:= true;
            end else if Diff > 0 then begin
                IsDec:= true;
            end else begin
                WriteLn('YOU ARE NOT SUPPOSED TO BE HERE!');
                abort();
            end;
        end;

        if not((Abs(Diff) >= 1) and (Abs(Diff) <= 3)) then begin
            exit(false);
        end;

        A:= B;
        Inc(I);
    end;

    exit(true);

end;

{ Entry }
var
    TxtFile: Text;
    NbSafe, Lvl: Word;
    Row: String;
    Levels, NewLevels: Array of AnsiString;
    I, J, UnsafeIdx: Word;
    IsSafe: Boolean;
begin
    Assign(TxtFile, ParamStr(1));
    Reset(TxtFile);
    
    NbSafe:= 0;
    Lvl:= 1;

    while not EOF(TxtFile) do begin

        ReadLn(TxtFile, Row);
        Levels:= SplitString(Row, ' ');
        SetLength(NewLevels, Length(Levels)-1);

        if IsLevelSafe(Levels) then begin
            //WriteLn('Level ', Lvl, ' is SAFE!');
            Inc(NbSafe);
        end else begin

            //Write('UNSAFE ');
            //PrintArr(Levels);

            UnsafeIdx:= 0;
            IsSafe:= false;

            for UnsafeIdx:= 0 to High(Levels) do begin
                J:= 0;
                for I:= Low(Levels) to High(Levels) do begin
                    if I <> UnsafeIdx then begin
                        NewLevels[J]:= Levels[I];
                        Inc(J);
                    end;
                end;

                //Write('  CHECKING ');
                //PrintArr(NewLevels);

                if IsLevelSafe(NewLevels) then begin
                    Inc(NbSafe);
                    //Write('    NOW SAFE ');
                    //PrintArr(NewLevels);
                    IsSafe:= true;
                    break;
                end;

            end;

            //if not IsSafe then begin
            //    Write('    DEF UNSAFE ');
            //    PrintArr(Levels);
            //end;
        end;

        Inc(Lvl);
    end;

    Close(TxtFile);

    WriteLn();
    WriteLn('> Number of SAFE levels: ', NbSafe);
end.