codeunit 50117 "Battery Utility Functions"
{
    procedure BatteryTestToJsonObject(var Rec: Record "Battery Test"): JsonObject
    var
        Object: JsonObject;
        RecRef: RecordRef;
        FieldRef, PKRef : FieldRef;
        FieldNo: Integer;
        FieldName: Text;
        FieldValue: Text;
    begin
        RecRef.SetTable(Rec);
        PKRef := RecRef.Field(1);
        PKRef.Value := Rec.Code;
        if RecRef.Find('=') then begin
            for FieldNo := 1 to RecRef.FieldCount do begin
                FieldRef := RecRef.Field(FieldNo);
                FieldName := FieldRef.Name;
                Evaluate(FieldValue, FieldRef.Value);
                Object.Add(FieldName, FieldValue);
            end;
        end;
        exit(Object);
    end;

    procedure TempBatteryToJsonObject(Rec: Record Battery): JsonObject
    var
        Object: JsonObject;
        FieldValue: Text;
    begin
        Evaluate(FieldValue, Rec.Data);
        Object.Add('Data', FieldValue);
        exit(Object);
    end;

    procedure BatteryToJsonObject(Rec: Record Battery): JsonObject
    var
        Object: JsonObject;
        Value: JsonValue;
        Token: JsonToken;
        RecRef: RecordRef;
        FieldRef, PKRef : FieldRef;
        FieldNo: Integer;
        FieldName: Text;
        FieldValue: Text;
        Battery: Record Battery;
    begin
        RecRef.Open(Database::Battery);
        PKRef := RecRef.Field(1);
        PKRef.Value := Rec.ItemLedgerEntry;
        if RecRef.Find('=') then begin
            for FieldNo := 1 to RecRef.FieldCount do begin
                FieldRef := RecRef.Field(FieldNo);
                FieldName := FieldRef.Name;
                FieldValue := FORMAT(FieldRef.Value);
                Object.Add(FieldName, FieldValue);
            end;
        end;
        exit(Object);
    end;

    procedure TableToJsonObject(Rec: Record Battery; DataObject: JsonObject): JsonObject
    var
        FinalObject: JsonObject;
        RecRef: RecordRef;
        FieldRef, PKRef : FieldRef;
        FieldNo: Integer;
        FieldName: Text;
        FieldValue: Text;
        Battery: Record Battery;

        Object: JsonObject;
        Token: JsonToken;
        Value: JsonValue;
    begin
        RecRef.SetTable(Battery);
        PKRef := RecRef.Field(1);
        PKRef.Value := Rec.ItemLedgerEntry;
        if RecRef.Find('=') then begin
            for FieldNo := 1 to RecRef.FieldCount do begin
                FieldRef := RecRef.Field(FieldNo);
                FieldName := FieldRef.Name;
                Evaluate(FieldValue, FieldRef.Value);
                if Object.ReadFrom(FieldValue) then begin

                end;
            end;
        end;
    end;

    procedure SortListOfDecimal(DecimalList: List of [Decimal]; Reverse: Boolean)
    var
        i, j : Integer;
        Temp: Decimal;
    begin
        for i := 1 to DecimalList.Count() - 1 do begin
            for j := 1 to DecimalList.Count() - i do begin
                if Reverse then begin
                    if DecimalList.Get(j) > DecimalList.Get(j + 1) then begin
                        Temp := DecimalList.Get(j);
                        DecimalList.Set(j, DecimalList.Get(j + 1));
                        DecimalList.Set(j + 1, Temp);
                    end;
                end else if not Reverse then begin
                    if DecimalList.Get(j) < DecimalList.Get(j + 1) then begin
                        Temp := DecimalList.Get(j);
                        DecimalList.Set(j, DecimalList.Get(j + 1));
                        DecimalList.Set(j + 1, Temp);
                    end;
                end;
            end;
        end;
    end;

    procedure ContainsFalse(List: List of [Boolean]): Boolean
    var
        element: Boolean;
    begin
        foreach element in List do begin
            if not element then
                exit(true);
        end;
        exit(false);
    end;



    procedure IsLastElement(List: List of [Text]; Element: Text): Boolean
    begin
        exit(List.Get(List.Count()) = Element);
    end;

    procedure FieldExistInTable(TableId: Integer; FieldName: Text): Boolean
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldId: Integer;
    begin
        // Open the table
        RecRef.Open(TableId);

        // Loop through the fields to check if the field exists
        for FieldId := 1 to RecRef.FieldCount() do begin
            FieldRef := RecRef.Field(FieldId);
            if FieldRef.Name = FieldName then begin
                exit(true);
            end;
        end;

        // If the field was not found, return false
        exit(false);
    end;

    procedure FieldExistInJson(Object: JsonObject; FieldName: Text): Boolean
    var
        ObjectKey: Text;
    begin
        foreach ObjectKey in Object.Keys() do begin
            if ObjectKey = FieldName then
                exit(true);
        end;
        exit(false);
    end;

    procedure GetFieldValue(TableId: Integer; PrimaryKey: Code[20]; FieldName: Text): Text
    var
        RecRef: RecordRef;
        FieldRef, PKRef : FieldRef;
        FieldId: Integer;
        FieldValue: Text;
    begin
        // Open the table
        RecRef.Open(TableId);

        PKRef := RecRef.Field(1);
        PKRef.Value := PrimaryKey;
        // Find the record by primary key
        if RecRef.Find('=') then begin
            // Loop through the fields to find the matching field name
            for FieldId := 1 to RecRef.FieldCount do begin
                FieldRef := RecRef.Field(FieldId);
                if FieldRef.Name = FieldName then begin
                    FieldValue := Format(FieldRef.Value);
                    exit(FieldValue);
                end;
            end;
        end;
    end;

    procedure NewValueList(): List of [Decimal]
    var
        List: List of [Decimal];
    begin
        exit(List);
    end;

    procedure NewBoolList(): List of [Boolean]
    var
        List: List of [Boolean];
    begin
        exit(List);
    end;

    procedure WithinRange(num1: Decimal; num2: Decimal; range: Decimal): Boolean
    var
        val: Decimal;
        test1, test2 : Boolean;
    begin
        val := GetRange(num1, num2);
        test1 := val >= -range;
        test2 := val <= range;
        if test1 and test2 then
            exit(true);
        exit(false);
    end;

    procedure SortJsonArray(Array: JsonArray; Reverse: Boolean)
    var
        NewArray: JsonArray;
        TempToken, jToken, jPlusToken : JsonToken;
        i, j : Integer;
    begin
        for i := 1 to Array.Count() - 1 do begin
            for j := 1 to Array.Count() - i do begin
                if Reverse then begin
                    Array.Get(j, jToken);
                    Array.Get(j + 1, jPlusToken);
                    if jToken.AsValue().AsDecimal() > jPlusToken.AsValue().AsDecimal() then begin
                        Array.Set(j, jPlusToken);
                        Array.Set(j + 1, jToken);
                    end;
                end else if not Reverse then begin
                    Array.Get(j, jToken);
                    Array.Get(j + 1, jPlusToken);
                    if jToken.AsValue().AsDecimal() < jPlusToken.AsValue().AsDecimal() then begin
                        Array.Set(j, jPlusToken);
                        Array.Set(j + 1, jToken);
                    end;
                end;
            end;
        end;
    end;

    procedure GetRange(num1: Decimal; num2: Decimal): Decimal
    begin
        if num1 >= num2 then
            exit(num1 - num2);
        exit(num2 - num1);
    end;

    procedure GetListRange(List: List of [Decimal]): Decimal
    var
        num1, num2 : Decimal;
    begin
        num1 := List.Get(1);
        num2 := List.Get(List.Count());
        exit(GetRange(num1, num2));
    end;

    procedure CountCharacterOccurrences(InputString: Text; CharacterToCount: Char): Integer
    var
        i: Integer;
        count: Integer;
    begin
        count := 0;
        for i := 1 to STRLEN(InputString) do begin
            if InputString[i] = CharacterToCount then
                count += 1;
        end;
        exit(count);
    end;

    procedure GetEmptyJsonToken(): JsonToken
    var
        Token: JsonToken;
    begin
        exit(Token);
    end;

    procedure GetNewJsonDict(): Dictionary of [Text, List of [JsonObject]];
    var
        NewDict: Dictionary of [Text, List of [JsonObject]];
    begin
        exit(NewDict);
    end;

    procedure GetNewJsonObject(): JsonObject
    var
        newObject: JsonObject;
    begin
        exit(newObject);
    end;

    procedure GetNewJsonObjectList(): List of [JsonObject]
    var
        NewArray: List of [JsonObject];
    begin
        exit(NewArray);
    end;

    procedure GetNewJsonArray(): JsonArray
    var
        NewArray: JsonArray;
    begin
        exit(NewArray);
    end;

    procedure SortJsonObjectListByKey(List: List of [JsonObject]; SortKey: Text; Reverse: Boolean)
    var
        SortedListIndex1, SortedListIndex2 : Integer;
        SortedListJsonToken1, SortedListJsonToken2 : JsonToken;
        SortedListJsonValue1, SortedListJsonValue2 : JsonValue;
        TempObject, IndexedJsonObject1, IndexedJsonObject2 : JsonObject;
        DecimalListValue1, DecimalListValue2 : Decimal;
        BigIntegerListValue1, BigIntegerListValue2 : BigInteger;
        TextListValue1, TextListValue2 : Text;
    begin

        for SortedListIndex1 := 1 to List.Count - 1 do begin
            for SortedListIndex2 := 1 to List.Count - SortedListIndex1 do begin

                IndexedJsonObject1 := List.Get(SortedListIndex2);
                if IndexedJsonObject1.Contains(SortKey) then
                    IndexedJsonObject1.Get(SortKey, SortedListJsonToken1)
                else
                    SortedListJsonToken1 := GetEmptyJsonToken();

                IndexedJsonObject2 := List.Get(SortedListIndex2 + 1);
                if IndexedJsonObject2.Contains(SortKey) then
                    IndexedJsonObject2.Get(SortKey, SortedListJsonToken2)
                else
                    SortedListJsonToken2 := GetEmptyJsonToken();

                SortedListJsonValue1 := SortedListJsonToken1.AsValue();
                SortedListJsonValue2 := SortedListJsonToken2.AsValue();

                if TryJsonValueDecimal(SortedListJsonValue1) and TryJsonValueDecimal(SortedListJsonValue2) then begin
                    DecimalListValue1 := SortedListJsonValue1.AsDecimal();
                    DecimalListValue2 := SortedListJsonValue2.AsDecimal();
                    if Reverse then begin
                        if DecimalListValue1 < DecimalListValue2 then begin
                            TempObject := List.Get(SortedListIndex2);
                            List.Set(SortedListIndex2, List.Get(SortedListIndex2 + 1));
                            List.Set(SortedListIndex2 + 1, TempObject);
                        end;
                    end else begin
                        if SortedListJsonValue1.AsBigInteger() > SortedListJsonValue2.AsBigInteger() then begin
                            TempObject := List.Get(SortedListIndex2);
                            List.Set(SortedListIndex2, List.Get(SortedListIndex2 + 1));
                            List.Set(SortedListIndex2 + 1, TempObject);
                        end;
                    end;

                end else if TryJsonValueBigInteger(SortedListJsonValue1) and TryJsonValueBigInteger(SortedListJsonValue2) then begin
                    BigIntegerListValue1 := SortedListJsonValue1.AsBigInteger();
                    BigIntegerListValue2 := SortedListJsonValue2.AsBigInteger();
                    if Reverse then begin
                        if BigIntegerListValue1 < BigIntegerListValue2 then begin
                            TempObject := List.Get(SortedListIndex2);
                            List.Set(SortedListIndex2, List.Get(SortedListIndex2 + 1));
                            List.Set(SortedListIndex2 + 1, TempObject);
                        end;
                    end else begin
                        if SortedListJsonValue1.AsBigInteger() > SortedListJsonValue2.AsBigInteger() then begin
                            TempObject := List.Get(SortedListIndex2);
                            List.Set(SortedListIndex2, List.Get(SortedListIndex2 + 1));
                            List.Set(SortedListIndex2 + 1, TempObject);
                        end;
                    end;
                end else if TryJsonValueText(SortedListJsonValue1) and TryJsonValueText(SortedListJsonValue2) then begin
                    TextListValue1 := SortedListJsonValue1.AsText();
                    TextListValue2 := SortedListJsonValue2.AsText();
                    if Reverse then begin
                        if TextListValue1 < TextListValue2 then begin
                            TempObject := List.Get(SortedListIndex2);
                            List.Set(SortedListIndex2, List.Get(SortedListIndex2 + 1));
                            List.Set(SortedListIndex2 + 1, TempObject);
                        end;
                    end else begin
                        if SortedListJsonValue1.AsBigInteger() > SortedListJsonValue2.AsBigInteger() then begin
                            TempObject := List.Get(SortedListIndex2);
                            List.Set(SortedListIndex2, List.Get(SortedListIndex2 + 1));
                            List.Set(SortedListIndex2 + 1, TempObject);
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure SortJsonObjectList(List: List of [JsonObject]; Reverse: Boolean)
    var
        SortedListIndex1, SortedListIndex2 : Integer;
        SortedListJsonToken1, SortedListJsonToken2 : JsonToken;
        TempObject: JsonObject;
        value1, value2 : BigInteger;
    begin
        for SortedListIndex1 := 1 to List.Count - 1 do begin
            for SortedListIndex2 := 1 to List.Count - SortedListIndex1 do begin
                if List.Get(SortedListIndex2).Contains('tm') then begin
                    List.Get(SortedListIndex2).Get('tm', SortedListJsonToken1);
                    value1 := SortedListJsonToken1.AsValue().AsBigInteger();
                end else begin
                    value1 := 0;
                end;

                if List.Get(SortedListIndex2 + 1).Contains('tm') then begin
                    List.Get(SortedListIndex2 + 1).Get('tm', SortedListJsonToken2);
                    value2 := SortedListJsonToken2.AsValue().AsBigInteger();
                end else begin
                    value2 := 0;
                end;

                if Reverse then begin
                    if value1 < value2 then begin
                        TempObject := List.Get(SortedListIndex2);
                        List.Set(SortedListIndex2, List.Get(SortedListIndex2 + 1));
                        List.Set(SortedListIndex2 + 1, TempObject);
                    end;
                end else begin
                    if value1 > value2 then begin
                        TempObject := List.Get(SortedListIndex2);
                        List.Set(SortedListIndex2, List.Get(SortedListIndex2 + 1));
                        List.Set(SortedListIndex2 + 1, TempObject);
                    end;
                end;
            end;
        end;
    end;

    procedure GetNewBooleanList(): List of [Boolean]
    var
        List: List of [Boolean];
    begin
        exit(List);
    end;

    procedure GetItemNoFromBattery(Records: Record Battery): Code[20]
    var
        Battery: Record Battery;
        BatteryTest: Record "Battery Test";
    begin
        Battery := Records;
        if Battery.FindFirst() then begin
            BatteryTest.Get(Battery.BatteryTest);
            exit(BatteryTest.Item);
        end;
        exit('');
    end;

    procedure SliceList(var OriginalList: List of [JsonObject]; StartIndex: Integer; EndIndex: Integer): List of [JsonObject]
    var
        SlicedList: List of [JsonObject];
        i: Integer;
    begin
        // Ensure valid indices
        if StartIndex < 0 then
            StartIndex := 0;
        if StartIndex > EndIndex then
            StartIndex := EndIndex;
        if EndIndex > OriginalList.Count() then
            EndIndex := OriginalList.Count();

        // Copy elements from the original list to the sliced list
        for i := StartIndex to EndIndex do
            SlicedList.Add(OriginalList.Get(i));

        exit(SlicedList);
    end;

    procedure GetKeyFromItemData(DataText: Text[2048]; DataKey: Text): Variant
    var
        JsonObject: JsonObject;
        Token: JsonToken;
    begin
        if DataText = '' then
            exit(JsonObject);
        JsonObject.ReadFrom(DataText);

        if JsonObject.Contains(DataKey) then begin
            JsonObject.Get(DataKey, Token);
            if Token.IsArray() then begin
                exit(Token.AsArray());
            end else if Token.IsValue() then begin
                exit(Token.AsValue());
            end else begin
                exit(Token.AsObject());
            end;
        end;
        exit(JsonObject);
    end;


    [TryFunction]
    local procedure TryJsonValueBigInteger(Value: JsonValue)
    var
        TempValue: BigInteger;
    begin
        TempValue := Value.AsBigInteger();
    end;


    [TryFunction]
    local procedure TryJsonValueDecimal(Value: JsonValue)
    var
        TempValue: Decimal;
    begin
        TempValue := Value.AsDecimal();
    end;


    [TryFunction]
    local procedure TryJsonValueText(Value: JsonValue)
    var
        TempValue: Text;
    begin
        TempValue := Value.AsText();
    end;


    [TryFunction]
    procedure JsonCanReadFrom(ReadFromText: Text)
    var
        Token: JsonToken;
    begin
        Token.ReadFrom(ReadFromText)
    end;
}