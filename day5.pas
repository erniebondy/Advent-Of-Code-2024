program Main_Program;
uses
    StrUtils, SysUtils, Math;
type
    Page = record
        Id: longWord;
        IsSet: boolean;
        Value: word;
        PreNums: array of word;
        PostNums: array of word;
    end;

    ArrayOfArrayOfWord = array of array of word;

function GetPage(const pages: array of Page; const value: word): Page;
var
    p: Page;
begin
    for p in pages do begin
        if p.Value = value then exit(p);
    end;
    
    // "Zero out" record
    p.Id:= -1;
    p.IsSet:= false;
    p.Value:= 0;
    SetLength(p.PreNums, 0);
    SetLength(p.PostNums, 0);
    exit(p);
end;

function FindNum(const nums: array of word; num: word): boolean;
var
    i: integer;
begin
    for i:= 0 to Length(nums) -1 do begin
        if nums[i] = num then exit(true);
    end;
    exit(false);
end;

procedure Part1(const pages: array of Page; const pagesToUpdate: ArrayOfArrayOfWord);
var
    midNum, res: word;
    curPgIdx, i, j: integer;
    preNumChk, postNumChk, pagesChk: boolean;
    pg: Page;
begin

    res:= 0;

    for i:= 0 to Length(pagesToUpdate) -1 do begin

        pagesChk:= true;
        for curPgIdx:= 0 to Length(pagesToUpdate[i]) -1 do begin
            preNumChk:= true;
            postNumChk:= true;
            pg:= GetPage(pages, pagesToUpdate[i][curPgIdx]);

            //WriteLn('> Checking pg', pg.Value);
            
            // Check page prenums
            j:= curPgIdx-1;
            while (j >= 0) and (preNumChk) do begin
                //WriteLn(' > Searching pg.PreNums ', pagesToUpdate[i][j]);
                preNumChk:= FindNum(pg.PreNums, pagesToUpdate[i][j]);
                Inc(j, -1);
            end;

            if not preNumChk then begin
                pagesChk:= false;
                break;
            end;

            // Check page postnums
            j:= curPgIdx+1;
            while (j < Length(pagesToUpdate[i])) and (postNumChk) do begin
                //WriteLn(' > Searching pg.PostNums ', pagesToUpdate[i][j]);
                postNumChk:= FindNum(pg.PostNums, pagesToUpdate[i][j]);
                Inc(j);
            end;

            if not ((preNumChk) and (postNumChk)) then begin
                //Write('  > Failed PreChk ', preNumChk);
                //WriteLn(' PostChk ', postNumChk);
                pagesChk:= false;
                break;
            end;

            //Write('  > Passed PreChk ', preNumChk);
            //WriteLn(' PostChk ', postNumChk);

        end;

        if pagesChk then begin
            midNum:= pagesToUpdate[i][ceil(Length(pagesToUpdate[i])/2)-1];
            Inc(res, midNum);
            //WriteLn('> Mid ', midNum);
        end;

    end;

    WriteLn('> Part 1 ', res);

end;

function ReorderNums(const pages: array of Page; var nums: array of word): boolean;
var
    i, j, idx: integer;
    reorderedNums: array of word;
    pg: Page;
begin

    SetLength(reorderedNums, Length(nums));

    for i:= Low(nums) to High(nums) do begin
        pg:= GetPage(pages, nums[i]);
        idx:= 0;
        //WriteLn('Selected ', nums[i]);
        for j:= Low(nums) to High(nums) do begin
            if j = i then continue;
            //WriteLn('  searching ', nums[j]);
            if FindNum(pg.PreNums, nums[j]) then begin
                //WriteLn('  found ', nums[j]);
                Inc(idx);
            end;
        end;

        Assert(idx <= High(nums), 'BAD INDEX!');
        //WriteLn('idx ', idx);
        reorderedNums[idx]:= nums[i];

    end;

    for i:= Low(nums) to High(nums) do begin
        nums[i]:= reorderedNums[i];
    end;
    exit(true);
end;

procedure Part2(const pages: array of Page; const pagesToUpdate: ArrayOfArrayOfWord);
var
    midNum, res: word;
    curPgIdx, i, j: integer;
    preNumChk, postNumChk, pagesChk: boolean;
    pg: Page;
begin

    res:= 0;

    for i:= 0 to Length(pagesToUpdate) -1 do begin

        pagesChk:= true;
        for curPgIdx:= 0 to Length(pagesToUpdate[i]) -1 do begin
            preNumChk:= true;
            postNumChk:= true;
            pg:= GetPage(pages, pagesToUpdate[i][curPgIdx]);
            
            // Check page prenums
            j:= curPgIdx-1;
            while (j >= 0) and (preNumChk) do begin
                preNumChk:= FindNum(pg.PreNums, pagesToUpdate[i][j]);
                Inc(j, -1);
            end;

            if not preNumChk then begin
                pagesChk:= false;
                break;
            end;

            // Check page postnums
            j:= curPgIdx+1;
            while (j < Length(pagesToUpdate[i])) and (postNumChk) do begin
                postNumChk:= FindNum(pg.PostNums, pagesToUpdate[i][j]);
                Inc(j);
            end;

            if not ((preNumChk) and (postNumChk)) then begin
                pagesChk:= false;
                break;
            end;

        end;

        if not pagesChk then begin
            if ReorderNums(pages, pagesToUpdate[i]) then begin
                midNum:= pagesToUpdate[i][ceil(Length(pagesToUpdate[i])/2)-1];
                Inc(res, midNum);
            end;
            //break;
        end;

    end;

    WriteLn('> Part 2 ', res);

end;

procedure Main();
var
    inFile: text;
    str: ansistring;
    pages: array of Page;
    pg: Page;
    pgA, pgB: word;
    i, j: longInt;
    temp: array of ansistring;
    pagesToUpdate: array of array of word;
begin


    SetLength(pages, 0);
    Assign(inFile, ParamStr(1));
    Reset(inFile);

    while true do begin
        ReadLn(inFile, str);
        if str = '' then break;

        pgA:= StrToUInt(str.Split('|')[0]);
        pgB:= StrToUInt(str.Split('|')[1]);
        
        // Page A
        pg:= GetPage(pages, pgA);

        if not pg.IsSet then begin
            SetLength(pages, Length(pages) + 1);
            pg.Id:= Length(pages) - 1;
            pg.IsSet:= true;
            pg.Value:= pgA;
        end;
        
        SetLength(pg.PostNums, Length(pg.PostNums) + 1);
        pg.PostNums[Length(pg.PostNums) -1]:= pgB;

        pages[pg.Id]:= pg;
        
        // Page B
        pg:= GetPage(pages, pgB);
        
        if not pg.IsSet then begin
            SetLength(pages, Length(pages) + 1);
            pg.Id:= Length(pages) - 1;
            pg.IsSet:= true;
            pg.Value:= pgB;
        end;
        
        SetLength(pg.PreNums, Length(pg.PreNums) + 1);
        pg.PreNums[Length(pg.PreNums) -1]:= pgA;

        pages[pg.Id]:= pg;
        //break;
    end;

    //for pg in pages do begin
    //    Write('Pg ', pg.Id);
    //    Write(': ', pg.Value);
    //    Write(' PrN ');
    //    for i:= 0 to Length(pg.PreNums) -1 do begin
    //        Write(pg.PreNums[i], ', ');
    //    end;
    //    Write('PoN ');
    //    for i:= 0 to Length(pg.PostNums) -1 do begin
    //        Write(pg.PostNums[i], ', ');
    //    end;
    //    WriteLn();
    //end;
    //WriteLn('-----------------');

    SetLength(pagesToUpdate, 0);
    while not EOF(inFile) do begin
        ReadLn(inFile, str);
        temp:= str.Split(',');
        SetLength(pagesToUpdate, Length(pagesToUpdate) + 1);
        SetLength(pagesToUpdate[Length(pagesToUpdate) - 1], 0); // Set inner array length to 0
        for i:= 0 to Length(temp) -1 do begin
            SetLength(pagesToUpdate[Length(pagesToUpdate) - 1], i + 1);
            pagesToUpdate[Length(pagesToUpdate) - 1][i]:= StrToUInt(temp[i]);
        end;
    end;
    
    Close(inFile);

    //for i:= 0 to Length(pagesToUpdate) -1 do begin
    //    for j:= 0 to Length(pagesToUpdate[i]) -1 do begin
    //        Write(pagesToUpdate[i][j], ' ');
    //    end;
    //    WriteLn();
    //end;

    //Part1(pages, pagesToUpdate);
    Part2(pages, pagesToUpdate);
end;

begin
    Main();
end.