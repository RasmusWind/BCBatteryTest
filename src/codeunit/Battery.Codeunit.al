codeunit 50114 Battery
{
    var
        BUF: Codeunit "Battery Utility Functions";

    procedure GroupBatteries(Rec: Record Battery)
    var
        BUF: Codeunit "Battery Utility Functions";
        Battery: Record Battery;
        BatteryTest: Record "Battery Test";
        BatteryGroupSetup: Record "Battery Group Setup";
        BatteryGroup: Record "Battery Group";
        GroupTestCriteria: Record "Test Criteria";
        TestOption, TestOption2 : Record "Test Criteria Test Option";
        GroupCapacity: Integer;
        BatteryJsonObject: JsonObject;
        BatteryJsonObjects: JsonArray;
        LoopInt: Integer;
        RangeArray: JsonArray;
        GroupTestToken, SingleToken, SingleTestToken : JsonToken;
        GroupTestValue, SingleTestValue, Range, TestValue : Decimal;
        GroupPassChecklist: List of [Boolean];
        GroupTestResult: Boolean;
        GroupNoSeries: Record "No. Series";
        GroupNoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit "No. Series";
        ProgressDialog: Dialog;
        TotalSteps, StepCounter : Integer;
        ProgressText: Label '#1 out of #2';
    begin
        BatteryTest.Get(Rec.BatteryTest);

        Rec.SetRange(Passed, Battery.Passed::Passed);
        Rec.SetRange(Group, '');

        if BatteryGroupSetup.Get(BatteryTest.BatteryGroupSetup) then
            GroupCapacity := BatteryGroupSetup.Capacity
        else
            GroupCapacity := 0;

        GroupTestCriteria.SetRange("BatteryTest", BatteryTest.Code);
        GroupTestCriteria.SetRange("Group Criteria", true);
        GroupTestCriteria.FindFirst();


        if Rec.FindFirst() then begin
            repeat
                BatteryJsonObject := BUF.BatteryToJsonObject(Rec);
                BatteryJsonObjects.Add(BatteryJsonObject);
            until Rec.Next() = 0;
        end;
        TotalSteps := BatteryJsonObjects.Count();
        ProgressDialog.Open(ProgressText, StepCounter, TotalSteps);

        if not TestOption.Get(GroupTestCriteria."Test Option") then begin
            exit;
        end;

        if GroupTestCriteria."Test Option 2" <> '' then
            TestOption2.Get(GroupTestCriteria."Test Option 2");

        LoopInt := 0;
        while LoopInt < BatteryJsonObjects.Count() do begin
            RangeArray := SliceJsonArray(BatteryJsonObjects, LoopInt, (LoopInt + GroupCapacity) - 1);
            if RangeArray.Count() < GroupCapacity then begin
                exit;
            end;
            GroupTestToken := RecursiveFunction(GroupTestCriteria, RangeArray.AsToken(), TestOption);

            GroupTestValue := GroupTestToken.AsValue().AsDecimal();
            GroupPassChecklist := BUF.NewBoolList();
            if GroupTestCriteria."Test Option 2" <> '' then begin
                foreach SingleToken in RangeArray do begin
                    SingleTestToken := RecursiveFunction(GroupTestCriteria, SingleToken, TestOption2);
                    SingleTestValue := SingleTestToken.AsValue().AsDecimal();

                    case true of
                        GroupTestCriteria.Operator = GroupTestCriteria.Operator::Range:
                            begin
                                Range := BUF.GetRange(GroupTestValue, SingleTestValue);
                                if GroupTestCriteria."Test Value Percent" then begin
                                    TestValue := (Range / GroupTestValue) * 100;
                                end else begin
                                    TestValue := Range;
                                end;

                                if TestValue <= GroupTestCriteria."Test Value" then
                                    GroupTestResult := true
                                else
                                    GroupTestResult := false;
                            end;
                        GroupTestCriteria.Operator = GroupTestCriteria.Operator::"Greater than":
                            begin
                                if GroupTestCriteria."Test Value" <> 0 then begin
                                    GroupTestResult := (SingleTestValue > GroupTestCriteria."Test Value") and (GroupTestValue > GroupTestCriteria."Test Value");
                                end else begin
                                    GroupTestResult := SingleTestValue > GroupTestValue;
                                end;
                            end;
                        GroupTestCriteria.Operator = GroupTestCriteria.Operator::"Greater than or equal":
                            begin
                                if GroupTestCriteria."Test Value" <> 0 then begin
                                    GroupTestResult := (SingleTestValue >= GroupTestCriteria."Test Value") and (GroupTestValue >= GroupTestCriteria."Test Value");
                                end else begin
                                    GroupTestResult := SingleTestValue >= GroupTestValue;
                                end;
                            end;
                        GroupTestCriteria.Operator = GroupTestCriteria.Operator::"Less than":
                            begin
                                if GroupTestCriteria."Test Value" <> 0 then begin
                                    GroupTestResult := (SingleTestValue < GroupTestCriteria."Test Value") and (GroupTestValue < GroupTestCriteria."Test Value");
                                end else begin
                                    GroupTestResult := SingleTestValue < GroupTestValue;
                                end;
                            end;
                        GroupTestCriteria.Operator = GroupTestCriteria.Operator::"Less than or equal":
                            begin
                                if GroupTestCriteria."Test Value" <> 0 then begin
                                    GroupTestResult := (SingleTestValue <= GroupTestCriteria."Test Value") and (GroupTestValue <= GroupTestCriteria."Test Value");
                                end else begin
                                    GroupTestResult := SingleTestValue <= GroupTestValue;
                                end;
                            end;
                        GroupTestCriteria.Operator = GroupTestCriteria.Operator::"Not equal":
                            begin
                                if GroupTestCriteria."Test Value" <> 0 then begin
                                    GroupTestResult := (SingleTestValue <> GroupTestCriteria."Test Value") and (GroupTestValue <> GroupTestCriteria."Test Value");
                                end else begin
                                    GroupTestResult := SingleTestValue <> GroupTestValue;
                                end;
                            end;
                        GroupTestCriteria.Operator = GroupTestCriteria.Operator::"Equal":
                            begin
                                if GroupTestCriteria."Test Value" <> 0 then begin
                                    GroupTestResult := (SingleTestValue = GroupTestCriteria."Test Value") and (GroupTestValue = GroupTestCriteria."Test Value");
                                end else begin
                                    GroupTestResult := SingleTestValue = GroupTestValue;
                                end;
                            end;
                    end;

                    GroupPassChecklist.Add(GroupTestResult);

                    StepCounter += 1;
                    ProgressDialog.Update();
                end;

            end else begin

                case true of
                    GroupTestCriteria.Operator = GroupTestCriteria.Operator::Range:
                        begin
                            GroupTestResult := GroupTestValue <= GroupTestCriteria."Test Value";
                        end;
                    GroupTestCriteria.Operator = GroupTestCriteria.Operator::"Greater than":
                        begin
                            GroupTestResult := GroupTestValue > GroupTestCriteria."Test Value";
                        end;
                    GroupTestCriteria.Operator = GroupTestCriteria.Operator::"Greater than or equal":
                        begin
                            GroupTestResult := GroupTestValue >= GroupTestCriteria."Test Value";
                        end;
                    GroupTestCriteria.Operator = GroupTestCriteria.Operator::"Less than":
                        begin
                            GroupTestResult := GroupTestValue < GroupTestCriteria."Test Value";
                        end;
                    GroupTestCriteria.Operator = GroupTestCriteria.Operator::"Less than or equal":
                        begin
                            GroupTestResult := GroupTestValue <= GroupTestCriteria."Test Value";
                        end;
                    GroupTestCriteria.Operator = GroupTestCriteria.Operator::"Not equal":
                        begin
                            GroupTestResult := GroupTestValue <> GroupTestCriteria."Test Value";
                        end;
                    GroupTestCriteria.Operator = GroupTestCriteria.Operator::"Equal":
                        begin
                            GroupTestResult := GroupTestValue = GroupTestCriteria."Test Value";
                        end;
                end;

                GroupPassChecklist.Add(GroupTestResult);

            end;

            if BUF.ContainsFalse(GroupPassChecklist) then begin
                LoopInt := LoopInt + 1;
            end else begin
                BatteryGroup.Init();

                if not GroupNoSeries.Get(BatteryTest.Code) then begin
                    GroupNoSeries.Init();
                    GroupNoSeries.Code := BatteryTest.Code;
                    GroupNoSeries."Default Nos." := true;
                    GroupNoSeries.Insert();

                    GroupNoSeriesLine.Init();
                    GroupNoSeriesLine."Series Code" := GroupNoSeries.Code;
                    GroupNoSeriesLine."Starting No." := GroupNoSeries.Code + '-001';
                    GroupNoSeriesLine."Ending No." := GroupNoSeries.Code + '-999';
                    GroupNoSeriesLine.Insert();
                end;

                BatteryGroup.Code := NoSeriesMgt.GetNextNo(GroupNoSeries.Code);
                BatteryGroup.Insert();

                foreach SingleToken in RangeArray do begin
                    SingleToken.AsObject().Get('ItemLedgerEntry', SingleToken);

                    if Battery.Get(SingleToken.AsValue().AsText()) then begin
                        Battery.Group := BatteryGroup.Code;
                        Battery.Modify();
                    end;
                end;
                LoopInt := LoopInt + GroupCapacity;
            end;
        end;
        ProgressDialog.Close();
    end;

    // procedure NestedCriteria()

    procedure SliceJsonArray(Array: JsonArray; startIndex: Integer; endIndex: Integer): JsonArray
    var
        NewArray: JsonArray;
        ArrayElement: JsonToken;
        LoopInt: Integer;
    begin
        if Array.Count() < startIndex then begin
            exit(NewArray);
        end;

        for LoopInt := startIndex to endIndex do begin
            if LoopInt >= Array.Count() then begin
                exit(NewArray);
            end;
            Array.Get(LoopInt, ArrayElement);
            NewArray.Add(ArrayElement);
        end;
        exit(NewArray);
    end;

    procedure RecursiveFunction(SingleTestCriteria: Record "Test Criteria"; Data: JsonToken; TestOption: Record "Test Criteria Test Option"): JsonToken
    var
        NextTestOption: Record "Test Criteria Test Option";
        NextLevelExists: Boolean;
        NewData, ArrayToken : JsonToken;
        ValueList: List of [Decimal];
        Range, Num, SmallestNum, BiggestNum : Decimal;
        ReturnValue: JsonValue;
        Array: JsonArray;
        ArrayLastToken: JsonToken;
        AverageValue, DecimalValue : Decimal;
        AverageValueToken: JsonToken;
        AverageValueArray: List of [Decimal];
        JsonSerializerObject: JsonObject;
    begin
        NextLevelExists := NextTestOption.Get(TestOption."Test Option");

        if Data.IsObject() then begin
            if not Data.AsObject().Get(TestOption."Field Name", NewData) then begin
                Error('Cannot find key: %1 in object on Test Option: %2.', TestOption."Field Name", TestOption.Code);
            end;
            // Check if NewData can be converted to JsonObject, since it could be a serialized value
            if NewData.IsValue() then begin
                if JsonSerializerObject.ReadFrom(NewData.AsValue().AsText()) then
                    NewData := JsonSerializerObject.AsToken();
                if NewData.IsValue() then begin
                    if TestOption."Test Option" <> '' then begin
                        Error('Cannot parse single value to Test Option.');
                    end;
                    exit(NewData);
                end;
            end;
            if NewData.IsArray() then begin
                if NextLevelExists then begin
                    case true of
                        NextTestOption.Operation = NextTestOption.Operation::count:
                            begin
                                if NewData.IsArray() then begin
                                    ReturnValue.SetValue(NewData.AsArray().Count());
                                    exit(ReturnValue.AsToken());
                                end;
                            end;
                        NextTestOption.Operation = NextTestOption.Operation::maximum:
                            begin
                                if NewData.IsArray() then begin
                                    Array := NewData.AsArray();
                                    BUF.SortJsonArray(Array, false);
                                    Array.Get(Array.Count(), ArrayLastToken);
                                    exit(ArrayLastToken.AsValue().AsToken());
                                end;
                            end;
                        NextTestOption.Operation = NextTestOption.Operation::minimum:
                            begin
                                if NewData.IsArray() then begin
                                    Array := NewData.AsArray();
                                    BUF.SortJsonArray(Array, true);
                                    Array.Get(Array.Count(), ArrayLastToken);
                                    exit(ArrayLastToken.AsValue().AsToken());
                                end;
                            end;
                        NextTestOption.Operation = NextTestOption.Operation::average:
                            begin
                                if NewData.IsArray() then begin
                                    if NextTestOption."Field Name" = '' then begin
                                        Error('Cannot create average. Missing "field name" on Test Option: %1.', NextTestOption.Code)
                                    end;
                                    Array := NewData.AsArray();

                                    foreach AverageValueToken in Array do begin
                                        AverageValue += RecursiveFunction(SingleTestCriteria, AverageValueToken, NextTestOption).AsValue().AsDecimal();
                                    end;
                                    if Array.Count() > 0 then
                                        AverageValue := AverageValue / Array.Count();
                                    ReturnValue.SetValue(AverageValue);
                                    exit(ReturnValue.AsToken());
                                end;
                            end;
                    end;
                end;


                foreach ArrayToken in NewData.AsArray() do begin
                    ValueList.Add(RecursiveFunction(SingleTestCriteria, ArrayToken, NextTestOption).AsValue().AsDecimal());
                end;

                case true of
                    SingleTestCriteria.Operator = SingleTestCriteria.Operator::Range:
                        begin
                            BUF.SortListOfDecimal(ValueList, false);
                            Range := BUF.GetListRange(ValueList);
                            ReturnValue.SetValue(Range);
                            exit(ReturnValue.AsToken());
                        end;
                    SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Greater than":
                        begin
                            BUF.SortListOfDecimal(ValueList, false);
                            SmallestNum := ValueList.Get(1);
                            ReturnValue.SetValue(SmallestNum);
                            exit(ReturnValue.AsToken());
                        end;
                    SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Greater than or equal":
                        begin
                            // If we return the smallest number found, then we match that to the greater than or equal case.
                            // If it is greater, then all must be greater.
                            BUF.SortListOfDecimal(ValueList, false);
                            SmallestNum := ValueList.Get(1);
                            ReturnValue.SetValue(SmallestNum);
                            exit(ReturnValue.AsToken());
                        end;
                    SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Less than":
                        begin
                            // Same as Greater than, just returning the biggest number instead.
                            BUF.SortListOfDecimal(ValueList, false);
                            BiggestNum := ValueList.Get(ValueList.Count());
                            ReturnValue.SetValue(BiggestNum);
                            exit(ReturnValue.AsToken());
                        end;
                    SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Less than or equal":
                        begin
                            BUF.SortListOfDecimal(ValueList, false);
                            BiggestNum := ValueList.Get(ValueList.Count());
                            ReturnValue.SetValue(BiggestNum);
                            exit(ReturnValue.AsToken());
                        end;
                    SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Not equal":
                        begin
                            // Going to have to check directly against the criteria here. 
                            // Returning the test value or test value + 1, because then we can check against that.
                            foreach Num in ValueList do begin
                                if Num = SingleTestCriteria."Test Value" then begin
                                    ReturnValue.SetValue(SingleTestCriteria."Test Value");
                                    exit(ReturnValue.AsToken());
                                end;
                            end;
                            ReturnValue.SetValue(SingleTestCriteria."Test Value" + 1);
                            exit(ReturnValue.AsToken());
                        end;
                    SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Equal":
                        begin
                            // Do the opposite here 
                            foreach Num in ValueList do begin
                                if Num <> SingleTestCriteria."Test Value" then begin
                                    ReturnValue.SetValue(SingleTestCriteria."Test Value" + 1);
                                    exit(ReturnValue.AsToken());
                                end;
                            end;
                            ReturnValue.SetValue(SingleTestCriteria."Test Value");
                            exit(ReturnValue.AsToken());
                        end;
                end;
            end;
            if NewData.IsObject() then begin
                exit(RecursiveFunction(SingleTestCriteria, NewData, NextTestOption));
            end;
        end else if Data.IsValue() then begin
            if NextLevelExists then
                Message('Cannot parse value to Test Option.');
            exit(Data);
        end else if Data.IsArray() then begin
            if NextLevelExists then begin
                case true of
                    TestOption.Operation = TestOption.Operation::count:
                        begin
                            ReturnValue.SetValue(Data.AsArray().Count());
                            exit(ReturnValue.AsToken());
                        end;
                    TestOption.Operation = TestOption.Operation::maximum:
                        begin
                            Array := Data.AsArray();
                            BUF.SortJsonArray(Array, false);
                            Array.Get(Array.Count(), ArrayLastToken);
                            exit(ArrayLastToken.AsValue().AsToken());
                        end;
                    TestOption.Operation = TestOption.Operation::minimum:
                        begin
                            Array := Data.AsArray();
                            BUF.SortJsonArray(Array, true);
                            Array.Get(Array.Count(), ArrayLastToken);
                            exit(ArrayLastToken.AsValue().AsToken());
                        end;
                    TestOption.Operation = TestOption.Operation::average:
                        begin

                            if NextTestOption."Field Name" = '' then begin
                                Error('Cannot create average. Missing "field name" on Test Option: %1.', NextTestOption.Code)
                            end;
                            Array := Data.AsArray();

                            foreach AverageValueToken in Array do begin
                                AverageValue += RecursiveFunction(SingleTestCriteria, AverageValueToken, NextTestOption).AsValue().AsDecimal();
                            end;
                            if Array.Count() > 0 then
                                AverageValue := AverageValue / Array.Count();
                            ReturnValue.SetValue(AverageValue);
                            exit(ReturnValue.AsToken());
                        end;
                end;
            end;


            foreach ArrayToken in NewData.AsArray() do begin
                ValueList.Add(RecursiveFunction(SingleTestCriteria, ArrayToken, NextTestOption).AsValue().AsDecimal());
            end;

            case true of
                SingleTestCriteria.Operator = SingleTestCriteria.Operator::Range:
                    begin
                        BUF.SortListOfDecimal(ValueList, false);
                        Range := BUF.GetListRange(ValueList);
                        ReturnValue.SetValue(Range);
                        exit(ReturnValue.AsToken());
                    end;
                SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Greater than":
                    begin
                        BUF.SortListOfDecimal(ValueList, false);
                        SmallestNum := ValueList.Get(1);
                        ReturnValue.SetValue(SmallestNum);
                        exit(ReturnValue.AsToken());
                    end;
                SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Greater than or equal":
                    begin
                        // If we return the smallest number found, then we match that to the greater than or equal case.
                        // If it is greater, then all must be greater.
                        BUF.SortListOfDecimal(ValueList, false);
                        SmallestNum := ValueList.Get(1);
                        ReturnValue.SetValue(SmallestNum);
                        exit(ReturnValue.AsToken());
                    end;
                SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Less than":
                    begin
                        // Same as Greater than, just returning the biggest number instead.
                        BUF.SortListOfDecimal(ValueList, false);
                        BiggestNum := ValueList.Get(ValueList.Count());
                        ReturnValue.SetValue(BiggestNum);
                        exit(ReturnValue.AsToken());
                    end;
                SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Less than or equal":
                    begin
                        BUF.SortListOfDecimal(ValueList, false);
                        BiggestNum := ValueList.Get(ValueList.Count());
                        ReturnValue.SetValue(BiggestNum);
                        exit(ReturnValue.AsToken());
                    end;
                SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Not equal":
                    begin
                        // Going to have to check directly against the criteria here. 
                        // Returning the test value or test value + 1, because then we can check against that.
                        foreach Num in ValueList do begin
                            if Num = SingleTestCriteria."Test Value" then begin
                                ReturnValue.SetValue(SingleTestCriteria."Test Value");
                                exit(ReturnValue.AsToken());
                            end;
                        end;
                        ReturnValue.SetValue(SingleTestCriteria."Test Value" + 1);
                        exit(ReturnValue.AsToken());
                    end;
                SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Equal":
                    begin
                        // Do the opposite here 
                        foreach Num in ValueList do begin
                            if Num <> SingleTestCriteria."Test Value" then begin
                                ReturnValue.SetValue(SingleTestCriteria."Test Value" + 1);
                                exit(ReturnValue.AsToken());
                            end;
                        end;
                        ReturnValue.SetValue(SingleTestCriteria."Test Value");
                        exit(ReturnValue.AsToken());
                    end;
            end;
        end;
    end;

    procedure EvaluateBattery(Rec: Record Battery; SingleTestCriteria: Record "Test Criteria")
    var
        TestOption: Record "Test Criteria Test Option";
        TestOption2: Record "Test Criteria Test Option";
        SingleTestResult: Boolean;
        SingleTestToken, TestOption2Token : JsonToken;
        SingleTestValueText: Text;
        SingleTestValue, TestOption2Value : Decimal;
        SingleTestResults: List of [Boolean];
        BatteryTestJson, BatteryJson, DataJson : JsonObject;
    begin
        SingleTestResults := BUF.GetNewBooleanList();
        BatteryJson := BUF.BatteryToJsonObject(Rec);
        DataJson := BUF.GetNewJsonObject();
        DataJson.ReadFrom(Rec.Data);
        BatteryJson.Remove('Data');
        BatteryJson.Add('Data', DataJson);
        if SingleTestCriteria.FindFirst() then begin
            repeat
                if TestOption.Get(SingleTestCriteria."Test Option") then begin
                    SingleTestToken := RecursiveFunction(SingleTestCriteria, BatteryJson.AsToken(), TestOption);
                    if not SingleTestToken.AsValue().IsNull() then begin

                        SingleTestValue := SingleTestToken.AsValue().AsDecimal();
                        case true of
                            SingleTestCriteria.Operator = SingleTestCriteria.Operator::Range:
                                begin
                                    SingleTestResult := SingleTestValue <= SingleTestCriteria."Test Value";
                                end;
                            SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Greater than":
                                begin
                                    SingleTestResult := SingleTestValue > SingleTestCriteria."Test Value";
                                end;
                            SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Greater than or equal":
                                begin
                                    SingleTestResult := SingleTestValue >= SingleTestCriteria."Test Value";
                                end;
                            SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Less than":
                                begin
                                    SingleTestResult := SingleTestValue < SingleTestCriteria."Test Value";
                                end;
                            SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Less than or equal":
                                begin
                                    SingleTestResult := SingleTestValue <= SingleTestCriteria."Test Value";
                                end;
                            SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Not equal":
                                begin
                                    SingleTestResult := SingleTestValue <> SingleTestCriteria."Test Value";
                                end;
                            SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Equal":
                                begin
                                    SingleTestResult := SingleTestValue = SingleTestCriteria."Test Value";
                                end;
                        end;

                        SingleTestResults.Add(SingleTestResult);
                    end;
                end;
            until SingleTestCriteria.Next() = 0;
            if not BUF.ContainsFalse(SingleTestResults) then begin
                Rec.Passed := Rec.Passed::Passed;
                Rec.Modify();
            end else begin
                Rec.Passed := Rec.Passed::Failed;
                Rec.Modify();
            end;

        end;
    end;

    procedure EvaluateBatteryList(Rec: Record Battery)
    var
        BatteryTest: Record "Battery Test";
        SingleTestCriteria: Record "Test Criteria";
    begin
        BatteryTest.Get(Rec.BatteryTest);

        // BatteryTestJson := BatteryTestToJsonObject(BatteryTest);
        SingleTestCriteria.SetRange("BatteryTest", BatteryTest.Code);
        SingleTestCriteria.SetRange("Group Criteria", false);
        SingleTestCriteria.SetRange(Active, SingleTestCriteria.Active::Yes);
        SingleTestCriteria.SetFilter("Test Option", '<>%1', '');
        Rec.SetFilter(Data, '<>%1', '');
        if Rec.FindFirst() then begin
            repeat
                EvaluateBattery(Rec, SingleTestCriteria);
            until Rec.Next() = 0;
        end;
    end;

    procedure EvaluateBatteryList2(Rec: Record Battery)
    var
        SingleTestCriteria: Record "Test Criteria";
        GroupTestCriteria: Record "Test Criteria";
        BatteryTest: Record "Battery Test";
        FieldNameList, FieldValueList : List of [Text];
        TestOption: Record "Test Criteria Test Option";
        FieldValue, FieldName : Text;
        FieldExist: Boolean;
        Object: JsonObject;
        Token, ReadFromToken : JsonToken;
        SingleToken: JsonToken;
        TestValue, FieldValueDecimal : Decimal;
        TestValueList: List of [Decimal];
        TestProgress: List of [Boolean];
        LoopCounter: Integer;
        WriteToText: Text;
    begin
        BatteryTest.Get(Rec.BatteryTest);
        SingleTestCriteria.SetRange("BatteryTest", BatteryTest.Code);
        SingleTestCriteria.SetRange("Group Criteria", false);
        SingleTestCriteria.SetRange(Active, SingleTestCriteria.Active::Yes);
        SingleTestCriteria.SetFilter("Test Option", '<>%1', '');

        GroupTestCriteria.SetRange("BatteryTest", BatteryTest.Code);
        GroupTestCriteria.SetRange("Group Criteria", true);

        if Rec.FindFirst then begin
            repeat
                if SingleTestCriteria.FindFirst() then begin
                    TestProgress := BUF.NewBoolList();
                    repeat
                        TestOption.Get(SingleTestCriteria."Test Option");
                        FieldNameList := TestOption."Field Name".Split('__');
                        LoopCounter := 0;
                        foreach FieldName in FieldNameList do begin
                            LoopCounter += 1;
                            if BUF.FieldExistInTable(50101, FieldName) then begin
                                FieldValue := BUF.GetFieldValue(50101, Rec.ItemLedgerEntry, FieldName);
                                FieldValueList.Add(FieldValue);
                                if LoopCounter = FieldNameList.Count() then begin
                                    if Evaluate(FieldValueDecimal, FieldValue) then
                                        TestValueList.Add(FieldValueDecimal);
                                end;
                            end else if FieldValueList.Count() > 0 then begin
                                if BUF.JsonCanReadFrom(FieldValueList.Get(FieldValueList.Count())) then begin
                                    ReadFromToken.ReadFrom(FieldValueList.Get(FieldValueList.Count()));
                                    if FieldNameList.Count() = LoopCounter then begin
                                        if TestOption.List then begin
                                            foreach SingleToken in ReadFromToken.AsArray() do begin
                                                SingleToken.AsObject().Get(FieldName, SingleToken);
                                                TestValueList.Add(SingleToken.AsValue().AsDecimal());
                                            end;
                                        end else begin
                                            ReadFromToken.AsObject().Get(FieldName, Token);
                                            if Token.IsArray() then
                                                TestValueList.Add(Token.AsArray().Count())
                                            else if Token.IsObject() then
                                                Error('Cannot compare object to decimal field. Maybe you missed a field name in test criteria test option?')
                                            else
                                                TestValueList.Add(Token.AsValue().AsDecimal());
                                        end;
                                    end else begin
                                        ReadFromToken.AsObject().Get(FieldName, Token);
                                        Token.WriteTo(WriteToText);
                                        FieldValueList.Add(WriteToText);
                                    end;
                                end;
                            end;
                        end;

                        BUF.SortListOfDecimal(TestValueList, false);
                        if TestValueList.Count() > 0 then begin
                            case true of
                                SingleTestCriteria.Operator = SingleTestCriteria.Operator::Equal:
                                    foreach TestValue in TestValueList do begin
                                        if TestValue <> SingleTestCriteria."Test Value" then begin
                                            TestProgress.Add(false);
                                        end;
                                    end;

                                SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Greater than":
                                    foreach TestValue in TestValueList do begin
                                        if TestValue <= SingleTestCriteria."Test Value" then begin
                                            TestProgress.Add(false);
                                        end;
                                    end;

                                SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Greater than or equal":
                                    foreach TestValue in TestValueList do begin
                                        if TestValue < SingleTestCriteria."Test Value" then begin
                                            TestProgress.Add(false);
                                        end;
                                    end;

                                SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Less than":
                                    foreach TestValue in TestValueList do begin
                                        if TestValue >= SingleTestCriteria."Test Value" then begin
                                            TestProgress.Add(false);
                                        end;
                                    end;

                                SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Less than or equal":
                                    foreach TestValue in TestValueList do begin
                                        if TestValue > SingleTestCriteria."Test Value" then begin
                                            TestProgress.Add(false);
                                        end;
                                    end;

                                SingleTestCriteria.Operator = SingleTestCriteria.Operator::"Not equal":
                                    foreach TestValue in TestValueList do begin
                                        if TestValue = SingleTestCriteria."Test Value" then begin
                                            TestProgress.Add(false);
                                        end;
                                    end;

                                SingleTestCriteria.Operator = SingleTestCriteria.Operator::Range:
                                    if TestValueList.Get(1) - TestValueList.Get(TestValueList.Count()) > 30 then
                                        TestProgress.Add(false)
                                    else if TestValueList.Get(1) - TestValueList.Get(TestValueList.Count()) < -30 then
                                        TestProgress.Add(false);

                            end;
                        end else begin
                            TestProgress.Add(false);
                        end;

                        // Empty TestValueList
                        TestValueList := BUF.NewValueList();
                    until SingleTestCriteria.Next = 0;
                    if not BUF.ContainsFalse(TestProgress) then begin
                        Rec.Passed := Rec.Passed::Passed;
                        Rec.Modify();
                    end else begin
                        Rec.Passed := Rec.Passed::Failed;
                        Rec.Modify();
                    end;
                end;
            until Rec.Next = 0;

        end;
    end;


    procedure ProcessFileContent(Rec: Record Battery; InStream: InStream)
    var
        Line: Text;
        StartBracesCount, EndBracesCount, CID : Integer;
        JsonObjectInstance, TempObject, DischargeRun1, DischargeRun2, ItemDischargeRun1, ItemDischargeRun2 : JsonObject;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        CIDTxt: Text;
        IntresVH, IntresVL, IntresI, IntresR : Decimal;
        JsonObjectList, JsonObjectInternalList, DischargeList, IntresList : List of [JsonObject];
        JsonDict: Dictionary of [Text, List of [JsonObject]];
        DataDict: Dictionary of [Integer, Dictionary of [Text, List of [JsonObject]]];
        ItemNo: Code[20];
    begin
        while not InStream.EOS() do begin
            InStream.ReadText(Line);
            StartBracesCount := BUF.CountCharacterOccurrences(Line, '{');
            EndBracesCount := BUF.CountCharacterOccurrences(Line, '}');

            if (StartBracesCount = EndBracesCount) AND (StartBracesCount > 0) then begin
                JsonObjectInstance := BUF.GetNewJsonObject();
                if JsonObjectInstance.ReadFrom(Line) then
                    JsonObjectList.Add(JsonObjectInstance);
            end;
        end;

        foreach TempObject in JsonObjectList do begin
            TempObject.Get('cid', JsonToken);
            JsonValue := JsonToken.AsValue();
            CID := JsonValue.AsInteger();

            if DataDict.ContainsKey(CID) then begin
                if TempObject.Contains('discharge') then begin
                    if DataDict.Get(CID).ContainsKey('discharge') then begin
                        DataDict.Get(CID).Get('discharge').Add(TempObject)
                    end else begin
                        JsonObjectInternalList := BUF.GetNewJsonObjectList();
                        JsonObjectInternalList.Add(TempObject);
                        DataDict.Get(CID).Add('discharge', JsonObjectInternalList);
                    end;
                end else if TempObject.Contains('intres') then begin
                    if DataDict.Get(CID).ContainsKey('intres') then begin
                        DataDict.Get(CID).Get('intres').Add(TempObject)
                    end else begin
                        JsonObjectInternalList := BUF.GetNewJsonObjectList();
                        JsonObjectInternalList.Add(TempObject);
                        DataDict.Get(CID).Add('intres', JsonObjectInternalList);
                    end;
                end;
            end else begin
                JsonDict := BUF.GetNewJsonDict();
                JsonObjectInternalList := BUF.GetNewJsonObjectList();
                JsonObjectInternalList.Add(TempObject);

                if TempObject.Contains('discharge') then begin
                    if JsonDict.ContainsKey('discharge') then begin
                        JsonDict.Get('discharge').Add(TempObject);
                    end else begin
                        JsonDict.Add('discharge', JsonObjectInternalList);
                    end;
                    DataDict.Add(CID, JsonDict);
                end else if TempObject.Contains('intres') then begin
                    if JsonDict.ContainsKey('intres') then begin
                        JsonDict.Get('intres').Add(TempObject);
                    end else begin
                        JsonDict.Add('intres', JsonObjectInternalList)
                    end;
                    DataDict.Add(CID, JsonDict);
                end;
            end;
        end;

        foreach CID in DataDict.Keys() do begin
            if DataDict.Get(CID).ContainsKey('discharge') then
                DischargeList := DataDict.Get(CID).Get('discharge');
            if DataDict.Get(CID).ContainsKey('intres') then
                IntresList := DataDict.Get(CID).Get('intres');

            BUF.SortJsonObjectList(DischargeList, true);
            BUF.SortJsonObjectList(IntresList, true);

            IntresList := BUF.SliceList(IntresList, 1, 6);
            DischargeList := BUF.SliceList(DischargeList, 1, 2);
            BUF.SortJsonObjectList(DischargeList, false);

            ItemNo := BUF.GetItemNoFromBattery(Rec);

            CIDTxt := FORMAT(CID);
            if STRLEN(CIDTxt) < 6 then
                CIDTxt := PADSTR('', 5 - STRLEN(CIDTxt), '0') + CIDTxt;

            if Rec.Get(ItemNo + '-' + CIDTxt) then begin
                SetNewDischargeRuns(Rec, DischargeList);
                Rec.Get(Rec.ItemLedgerEntry);
                SetNewIntresRuns(Rec, IntresList);
            end;
        end;
    end;

    procedure SetNewIntresRuns(BatteryRec: Record Battery; IntresList: List of [JsonObject])
    var
        CollectedIntres: List of [JsonObject];
        CollectedIntresArray: JsonArray;
        NewBatteryData: Text;
        BatteryRecData, SingleIntresRun : JsonObject;
        TokenArray, Token, CollectedIntresToken : JsonToken;
    begin
        BatteryRecData := BUF.GetKeyFromItemData(BatteryRec.Data, 'InvalidKey');
        if BatteryRecData.Contains('intres') then begin
            BatteryRecData.Get('intres', TokenArray);
            if TokenArray.IsArray then begin
                foreach Token in TokenArray.AsArray() do begin
                    CollectedIntres.Add(Token.AsObject());
                end;
            end;
        end;

        foreach SingleIntresRun in IntresList do begin
            if not CollectedIntres.Contains(SingleIntresRun) then
                CollectedIntres.Add(SingleIntresRun);
        end;

        BUF.SortJsonObjectListByKey(CollectedIntres, 'tm', true);

        CollectedIntres := BUF.SliceList(CollectedIntres, 1, 6);

        BUF.SortJsonObjectListByKey(CollectedIntres, 'tm', false);

        foreach SingleIntresRun in CollectedIntres do begin
            CollectedIntresArray.Add(SingleIntresRun.AsToken());
        end;

        if BatteryRecData.Contains('intres') then
            BatteryRecData.Remove('intres');
        BatteryRecData.Add('intres', CollectedIntresArray.AsToken());

        BatteryRecData.WriteTo(NewBatteryData);
        BatteryRec.Data := NewBatteryData;
        BatteryRec.Modify();
    end;

    procedure SetNewDischargeRuns(BatteryRec: Record Battery; DischargeList: List of [JsonObject])
    var
        ItemJsonDataVariant: Variant;
        ItemJsonData, ItemDischargeRun1, ItemDischargeRun2, DischargeRun, DischargeRun1, DischargeRun2 : JsonObject;
        DischargeToken, Token, DischargeArrayToken : JsonToken;
        DischargeArray, TempJsonArray : JsonArray;
        ItemDischargeRun1TM, ItemDischargeRun2TM, DischargeRunTM : BigInteger;
        NewBatteryData: Text;
        DischargeRuns: List of [JsonObject];
    begin
        ItemJsonDataVariant := BUF.GetKeyFromItemData(BatteryRec.Data, 'InvalidKey');
        if ItemJsonDataVariant.IsJsonObject() then
            ItemJsonData := ItemJsonDataVariant;

        if ItemJsonData.Contains('discharge') then begin
            ItemJsonData.Get('discharge', DischargeToken);
            if DischargeToken.IsArray() then
                DischargeArray := DischargeToken.AsArray();

            foreach DischargeArrayToken in DischargeArray do begin
                DischargeRuns.Add(DischargeArrayToken.AsObject());
            end;

            foreach DischargeRun in DischargeList do begin
                if not DischargeRuns.Contains(DischargeRun) then
                    DischargeRuns.Add(DischargeRun);
            end;

            BUF.SortJsonObjectList(DischargeRuns, true);
            BUF.SliceList(DischargeRuns, 1, 2);
            BUF.SortJsonObjectList(DischargeRuns, false);

            foreach DischargeRun in DischargeRuns do begin
                TempJsonArray.Add(DischargeRun.AsToken());
            end;

            ItemJsonData.Remove('discharge');
            ItemJsonData.Add('discharge', TempJsonArray.AsToken());
            ItemJsonData.WriteTo(NewBatteryData);
            BatteryRec.Data := NewBatteryData;
            BatteryRec.Modify();
        end else begin
            foreach DischargeRun in DischargeList do begin
                TempJsonArray.Add(DischargeRun.AsToken());
            end;
            ItemJsonData.Add('discharge', TempJsonArray.AsToken());
            ItemJsonData.WriteTo(NewBatteryData);
            BatteryRec.Data := NewBatteryData;
            BatteryRec.Modify();
        end;
    end;


}
