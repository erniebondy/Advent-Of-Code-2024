program Main;
uses
    SysUtils, StrUtils;
const 
    SEARCH_TERM = 'XMAS';
type
    Cell = record
        Null: boolean;
        Row: word;
        Col: word;
        Value: char;
    end;
    Direction = (N, NE, E, SE, S, SW, W, NW);

function GetCell(const Cells: array of Cell; const Row, Col: longWord): Cell;
var
    C: Cell;
begin
    for C in Cells do if (C.Row = Row) and (C.Col = Col) then exit(C);
    C.Null:= true;
    exit(C);
end;

procedure Part2(const Cells: array of Cell);
var
    CurCell: Cell;
    Row, Col, LastRow, LastCol: longWord;
    Dx, Dy: integer;
    Nums: array [0..3, 0..1] of integer;
    I, Count, LegCount: word;
    M, S: boolean;
begin

    LastRow:= Cells[High(Cells)].Row;
    LastCol:= Cells[High(Cells)].Col;
    Count:= 0;

    Nums[0,0]:= -1;
    Nums[0,1]:= -1;
    Nums[1,0]:= 1;
    Nums[1,1]:= 1;
    Nums[2,0]:= -1;
    Nums[2,1]:= 1;
    Nums[3,0]:= 1;
    Nums[3,1]:= -1;
    
    for Row:= 1 to LastRow -1 do begin
        for Col:= 1 to LastCol -1 do begin

            CurCell:= GetCell(Cells, Row, Col);
            if CurCell.Value = 'A' then begin
                Found:= true;

                I:= 0;
                LegCount:= 0;
                while I < High(Nums) do begin
                    M:= false;
                    S:= false;
                    
                    Dy:= Row + Nums[I, 0];
                    Dx:= Col + Nums[I, 1];
                    CurCell:= GetCell(Cells, Dy, Dx);

                    if CurCell.Value = 'M' then begin
                        M:= true;
                    end else if CurCell.Value = 'S' then begin
                        S:= true;
                    end;

                    Dy:= Row + Nums[I +1, 0];
                    Dx:= Col + Nums[I +1, 1];
                    CurCell:= GetCell(Cells, Dy, Dx);

                    if ((CurCell.Value = 'M') and (S)) or ((CurCell.Value = 'S') and (M)) then Inc(LegCount);

                    Inc(I, 2); { Using while loop because Pascal doesn't support for loops that increment by 1 or -1 }
                end;

                if LegCount = 2 then Inc(Count);

            end;

        end;

    end;

    WriteLn('> Part 2 ', Count);
end;

procedure Part1(const Cells: array of Cell);
var
    C, NextCell: Cell;
    Row, Col: longInt;
    I, Count: Word;
    LastRow, LastCol: longWord;
    Dir: Direction;
    Found: boolean;
begin

    Count:= 0;
    LastRow:= Cells[High(Cells)].Row;
    LastCol:= Cells[High(Cells)].Col;

    for C in Cells do begin
        if C.Value = SEARCH_TERM[1] then begin

            for Dir in Direction do begin

                Found:= true; // Assume true
                for I:= 0 to Length(SEARCH_TERM) -1 do begin

                    case Dir of
                        N: begin
                            Col:= C.Col;
                            Row:= C.Row - I;
                        end;
                        NE: begin
                            Col:= C.Col + I;
                            Row:= C.Row - I;
                        end;
                        E: begin
                            Col:= C.Col + I;
                            Row:= C.Row;
                        end;
                        SE: begin
                            Col:= C.Col + I;
                            Row:= C.Row + I;
                        end;
                        S: begin
                            Col:= C.Col;
                            Row:= C.Row + I;
                        end;
                        SW: begin
                            Col:= C.Col - I;
                            Row:= C.Row + I;
                        end;
                        W: begin
                            Col:= C.Col - I;
                            Row:= C.Row;
                        end;
                        NW: begin
                            Col:= C.Col - I;
                            Row:= C.Row - I;
                        end;
                    end;

                    if (Row < 0) or (Row > LastRow) or (Col < 0) or (Col > LastCol) then begin
                        Found:= false;
                        break;
                    end;
                    
                    NextCell:= GetCell(Cells, Row, Col);
                    if NextCell.Null then begin
                        Found:= false;
                        break;
                    end;

                    if NextCell.Value <> SEARCH_TERM[I+1] then begin
                        Found:= false;
                        break;
                    end;

                end;

                if Found then Inc(Count);

            end;
        end;
    end;

    WriteLn('> Part 1 ', Count);

end;

{ Main }
var
    InFile: text;
    Cells: array of Cell;
    DataSize: longWord;
    NbRows: word;
    Line: ansistring;
    Idx: word;
begin
    
    Assign(InFile, ParamStr(1));
    Reset(InFile);

    { Well, well... There's a .ToCharArray. This only works on ansistring -_- }
    //WriteLn(Length(Line.ToCharArray));

    NbRows:= 0;
    DataSize:= 0;
    SetLength(Cells, 1024*20);

    while not EOF(InFile) do begin
        ReadLn(InFile, Line);
        
        for Idx:= 0 to Line.Length-1 do begin
            Cells[DataSize].Null:= false;
            Cells[DataSize].Row:= NbRows;
            Cells[DataSize].Col:= Idx;
            Cells[DataSize].Value:= Line.Chars[Idx];
            Inc(DataSize);
        end;

        Inc(NbRows);

    end;

    Close(InFile);

    SetLength(Cells, DataSize);
    WriteLn('DataSize, ', DataSize);
    
    Part1(Cells);
    Part2(Cells);
end.