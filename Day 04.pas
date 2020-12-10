program Day_04;
uses
    Classes, SysUtils;
var
    textData : AnsiString;
    textList: TStrings;
    dataList: TStrings;
    valList: TStrings;
    l: Integer;
    i: Integer;
    a: Integer;
    d: Integer;
    dl: Integer;
    v: Integer;
    p: Integer;
    sl: Integer;
    index: Integer;
    valid: boolean;
    height: string;
    hgtName: string;
    hairHex: string;
    required: array[0..6] of string = ('byr','iyr','eyr','hgt','hcl','ecl','pid');
    validEcl: array[0..6] of string = ('amb','blu','brn','gry','grn','hzl','oth');
    hex:array[0..15] of string= ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
    data: array[0..6] of string;
    number: array[0..9] of string=('0','1','2','3','4','5','6','7','8','9');
    function has(a: array of string; str: string): boolean;
        var
            i: Integer;
        begin
            for i := 0 to Length(a)-1 do
                begin
                    if (a[i] = str) then 
                        begin
                            Exit(true);
                        end;
                end;
            Exit(false);
        end;
    
    function IsNumber(str: string): boolean;
        var
            n: Integer;
        begin
            for n := 1 to Length(str) do
                begin
                    if (not has(number, str[n])) then 
                        begin
                            Exit(false);
                        end;
                end;
            Exit(true);
        end;
    function IsHex(str: string): boolean;
        var
            h: Integer;
        begin
            for h := 1 to Length(str) do
                begin
                    if (not has(hex, str[h])) then 
                        begin
                            Exit(false);
                        end;
                end;
            Exit(true);
        end;
begin
    textList := TStringList.Create;
    textList.Text := textData;
    
    dataList := TStringList.Create;
    dataList.Delimiter := ' ';
    
    valList := TStringList.Create;
    valList.Delimiter := ':';
    
    valid := true;
    v := 0;
    l := textList.Count;
    index := 0;
    for i := 0 to l-1 do
        //writeln('Test: '+ IntToStr(Length(dataList[i])) + ': '+dataList[i]);
        begin
            if (Length(textList[i]) = 0) then
                begin
                    for a := 0 to index-1 do
                        begin
                            data[a] := '';
                        end;
                    if (index = 7) and valid then
                        begin
                            v := v+1;
                        end;
                    valid := true;
                    index := 0;
                end
            else
                begin
                    dataList.DelimitedText := textList[i];
                    dl := dataList.Count;
                    for d := 0 to dl-1 do
                        begin
                            valList.DelimitedText := dataList[d];
                            if has(required, valList[0]) then
                                begin
                                    data[index] := valList[0];
                                    index := index+1;
                                    case(valList[0]) of
                                        'byr':
                                            if (not IsNumber(valList[1])) or (StrToInt(valList[1]) < 1920) or (StrToInt(valList[1]) > 2002) then
                                                begin
                                                    valid := false;
                                                end;
                                        'iyr':
                                            if (not IsNumber(valList[1])) or (StrToInt(valList[1]) < 2010) or (StrToInt(valList[1]) > 2020) then
                                                begin
                                                    valid := false;
                                                end;
                                        'eyr':
                                            if (not IsNumber(valList[1])) or (StrToInt(valList[1]) < 2020) or (StrToInt(valList[1]) > 2030) then
                                                begin
                                                    valid := false;
                                                end;
                                        'hgt':
                                            begin
                                                p := Pos('cm', valList[1]);
                                                if (p = 0) then 
                                                    begin
                                                        p := Pos('in', valList[1]);
                                                    end;
                                                if (p = 0) then
                                                    begin
                                                        valid := false;
                                                    end
                                                else
                                                    begin
                                                        height := LeftStr(valList[1], p-1);
                                                        hgtName := RightStr(valList[1], Length(valList[1]) - (p-1));
                                                        case(hgtName) of
                                                            'in':
                                                                if (not IsNumber(height)) or (StrToInt(height) < 59) or (StrToInt(height) > 76) then
                                                                    begin
                                                                        valid := false;
                                                                    end;
                                                            'cm':
                                                                if (not IsNumber(height)) or (StrToInt(height) < 150) or (StrToInt(height) > 193) then
                                                                    begin
                                                                        valid := false;
                                                                    end;
                                                            else
                                                                begin
                                                                    valid := false;
                                                                end;
                                                        end;
                                                    end;
                                            end;
                                        'hcl':
                                            if (Length(valList[1]) <> 7) then
                                                begin
                                                    valid := false;
                                                end
                                            else if not (LeftStr(valList[1], 1) = '#') then
                                                    begin
                                                        valid := false;
                                                    end
                                                else
                                                    begin
                                                        hairHex := RightStr(valList[1], 6);
                                                        if IsHex(hairHex[sl]) then
                                                            begin
                                                                valid := false;
                                                            end;
                                                    end;
                                        'ecl':
                                            if not has(validEcl, valList[1]) then
                                                begin
                                                    valid := false;
                                                end;
                                        'pid':
                                            begin
                                                if (not IsNumber(valList[1])) or (Length(valList[1]) <> 9) then
                                                    begin
                                                        valid := false;
                                                    end;
                                            end;
                                        else
                                            begin
                                                valid := false;
                                            end;
                                    end;
                                end;
                        end;
                end;
        end;
    if (index = 7) and valid then
        begin
            v := v+1;
        end;
    dataList.Free;
    writeln ('Valid: '+ IntToStr(v));
    writeln ('Done.');
end.

