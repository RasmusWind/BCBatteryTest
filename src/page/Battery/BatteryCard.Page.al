page 50113 "Battery Card"
{
    PageType = Card;
    RefreshOnActivate = true;
    Caption = 'Battery';
    SourceTable = "Battery";

    // Editable = false;

    layout
    {
        area(content)
        {
            group("Battery data")
            {
                field(ItemLedgerEntry; Rec.ItemLedgerEntry) { ApplicationArea = All; Editable = false; }
                field(BatteryTest; Rec.BatteryTest) { ApplicationArea = All; Editable = false; }
                field(Group; Rec.Group) { ApplicationArea = All; Editable = true; }
                field(Weight; Rec.Weight) { ApplicationArea = All; Editable = true; }
                field(TimestampStart; Rec.TimestampStart) { ApplicationArea = All; Editable = false; }
                field(TimestampEnd; Rec.TimestampEnd) { ApplicationArea = All; Editable = false; }
                field(Passed; Rec.Passed) { ApplicationArea = All; Editable = false; }
            }
            group("Discharge runs")
            {
                field("Run 1 timestamp"; DischargeRun1Timestamp)
                {
                    Caption = 'Run 1 timestamp';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("DischargeRun1"; DischargeRun1)
                {
                    Caption = 'Run 1';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Run 2 timestamp"; DischargeRun2Timestamp)
                {
                    Caption = 'Run 2 timestamp';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DischargeRun2; DischargeRun2)
                {
                    Caption = 'Run 2';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group("Intres runs")
            {
                Editable = false;
                group("Run 1")
                {
                    field("RUN1_timestamp"; RUN1_timestamp)
                    {
                        Caption = 'Timestamp';
                        ApplicationArea = All;
                    }
                    field("VH1"; RUN1_Intres_VH)
                    {
                        Caption = 'VH';
                        ApplicationArea = All;
                    }
                    field("VL1"; RUN1_Intres_VL)
                    {
                        Caption = 'VL';
                        ApplicationArea = All;
                    }
                    field("I1"; RUN1_Intres_I)
                    {
                        Caption = 'I';
                        ApplicationArea = All;
                    }
                    field("R1"; RUN1_Intres_R)
                    {
                        Caption = 'R';
                        ApplicationArea = All;
                    }
                }
                group("Run 2")
                {
                    field("RUN2_timestamp"; RUN2_timestamp)
                    {
                        Caption = 'Timestamp';
                        ApplicationArea = All;
                    }
                    field("VH2"; RUN2_Intres_VH)
                    {
                        Caption = 'VH';
                        ApplicationArea = All;
                    }
                    field("VL2"; RUN2_Intres_VL)
                    {
                        Caption = 'VL';
                        ApplicationArea = All;
                    }
                    field("I2"; RUN2_Intres_I)
                    {
                        Caption = 'I';
                        ApplicationArea = All;
                    }
                    field("R2"; RUN2_Intres_R)
                    {
                        Caption = 'R';
                        ApplicationArea = All;
                    }
                }
                group("Run 3")
                {
                    field("RUN3_timestamp"; RUN3_timestamp)
                    {
                        Caption = 'Timestamp';
                        ApplicationArea = All;
                    }
                    field("VH3"; RUN3_Intres_VH)
                    {
                        Caption = 'VH';
                        ApplicationArea = All;
                    }
                    field("VL3"; RUN3_Intres_VL)
                    {
                        Caption = 'VL';
                        ApplicationArea = All;
                    }
                    field("I3"; RUN3_Intres_I)
                    {
                        Caption = 'I';
                        ApplicationArea = All;
                    }
                    field("R3"; RUN3_Intres_R)
                    {
                        Caption = 'R';
                        ApplicationArea = All;
                    }
                }
                group("Run 4")
                {
                    field("RUN4_timestamp"; RUN4_timestamp)
                    {
                        Caption = 'Timestamp';
                        ApplicationArea = All;
                    }
                    field("VH4"; RUN4_Intres_VH)
                    {
                        Caption = 'VH';
                        ApplicationArea = All;
                    }
                    field("VL4"; RUN4_Intres_VL)
                    {
                        Caption = 'VL';
                        ApplicationArea = All;
                    }
                    field("I4"; RUN4_Intres_I)
                    {
                        Caption = 'I';
                        ApplicationArea = All;
                    }
                    field("R4"; RUN4_Intres_R)
                    {
                        Caption = 'R';
                        ApplicationArea = All;
                    }
                }
                group("Run 5")
                {
                    field("RUN5_timestamp"; RUN5_timestamp)
                    {
                        Caption = 'Timestamp';
                        ApplicationArea = All;
                    }
                    field("VH5"; RUN5_Intres_VH)
                    {
                        Caption = 'VH';
                        ApplicationArea = All;
                    }
                    field("VL5"; RUN5_Intres_VL)
                    {
                        Caption = 'VL';
                        ApplicationArea = All;
                    }
                    field("I5"; RUN5_Intres_I)
                    {
                        Caption = 'I';
                        ApplicationArea = All;
                    }
                    field("R5"; RUN5_Intres_R)
                    {
                        Caption = 'R';
                        ApplicationArea = All;
                    }
                }
                group("Run 6")
                {
                    field("RUN6_timestamp"; RUN6_timestamp)
                    {
                        Caption = 'Timestamp';
                        ApplicationArea = All;
                    }
                    field("VH6"; RUN6_Intres_VH)
                    {
                        Caption = 'VH';
                        ApplicationArea = All;
                    }
                    field("VL6"; RUN6_Intres_VL)
                    {
                        Caption = 'VL';
                        ApplicationArea = All;
                    }
                    field("I6"; RUN6_Intres_I)
                    {
                        Caption = 'I';
                        ApplicationArea = All;
                    }
                    field("R6"; RUN6_Intres_R)
                    {
                        Caption = 'R';
                        ApplicationArea = All;
                    }
                }
            }
            group("Raw data")
            {
                field(Data; Rec.Data) { ApplicationArea = All; Editable = false; MultiLine = true; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(EmptyData)
            {
                ApplicationArea = All;
                Caption = 'Remove data';
                Promoted = true;
                PromotedCategory = Process;
                Image = "Invoicing-MDL-Delete";

                trigger OnAction()
                begin
                    if Dialog.Confirm('Are you sure, you want to remove all data from this battery?') then begin
                        Rec.Data := '';
                        Rec.Passed := Rec.Passed::"Not Tested";
                        Rec.TimestampStart := 0;
                        Rec.TimestampEnd := 0;
                        CurrPage.Update(true);
                        ModifyRecord();
                    end;
                end;
            }
        }
    }

    var
        DischargeRun1Timestamp: BigInteger;
        DischargeRun2Timestamp: BigInteger;
        DischargeRun1: Decimal;
        DischargeRun2: Decimal;

        RUN1_timestamp: BigInteger;
        RUN1_Intres_VH: Decimal;
        RUN1_Intres_VL: Decimal;
        RUN1_Intres_I: Decimal;
        RUN1_Intres_R: Decimal;

        RUN2_timestamp: BigInteger;
        RUN2_Intres_VH: Decimal;
        RUN2_Intres_VL: Decimal;
        RUN2_Intres_I: Decimal;
        RUN2_Intres_R: Decimal;

        RUN3_timestamp: BigInteger;
        RUN3_Intres_VH: Decimal;
        RUN3_Intres_VL: Decimal;
        RUN3_Intres_I: Decimal;
        RUN3_Intres_R: Decimal;

        RUN4_timestamp: BigInteger;
        RUN4_Intres_VH: Decimal;
        RUN4_Intres_VL: Decimal;
        RUN4_Intres_I: Decimal;
        RUN4_Intres_R: Decimal;

        RUN5_timestamp: BigInteger;
        RUN5_Intres_VH: Decimal;
        RUN5_Intres_VL: Decimal;
        RUN5_Intres_I: Decimal;
        RUN5_Intres_R: Decimal;

        RUN6_timestamp: BigInteger;
        RUN6_Intres_VH: Decimal;
        RUN6_Intres_VL: Decimal;
        RUN6_Intres_I: Decimal;
        RUN6_Intres_R: Decimal;


    trigger OnAfterGetCurrRecord()
    begin
        AfterGetRecord();
    end;

    local procedure ModifyRecord()
    begin
        DischargeRun1Timestamp := 0;
        DischargeRun2Timestamp := 0;
        DischargeRun1 := 0;
        DischargeRun2 := 0;

        RUN1_timestamp := 0;
        RUN1_Intres_VH := 0;
        RUN1_Intres_VL := 0;
        RUN1_Intres_I := 0;
        RUN1_Intres_R := 0;

        RUN2_timestamp := 0;
        RUN2_Intres_VH := 0;
        RUN2_Intres_VL := 0;
        RUN2_Intres_I := 0;
        RUN2_Intres_R := 0;

        RUN3_timestamp := 0;
        RUN3_Intres_VH := 0;
        RUN3_Intres_VL := 0;
        RUN3_Intres_I := 0;
        RUN3_Intres_R := 0;

        RUN4_timestamp := 0;
        RUN4_Intres_VH := 0;
        RUN4_Intres_VL := 0;
        RUN4_Intres_I := 0;
        RUN4_Intres_R := 0;

        RUN5_timestamp := 0;
        RUN5_Intres_VH := 0;
        RUN5_Intres_VL := 0;
        RUN5_Intres_I := 0;
        RUN5_Intres_R := 0;

        RUN6_timestamp := 0;
        RUN6_Intres_VH := 0;
        RUN6_Intres_VL := 0;
        RUN6_Intres_I := 0;
        RUN6_Intres_R := 0;
    end;


    local procedure AfterGetRecord()
    var
        BCU: Codeunit Battery;
        BUF: Codeunit "Battery Utility Functions";
        JsonObject: JsonObject;
        DischargeToken, IntresToken : JsonToken;
        run1, run2, run1Token, run2Token : JsonToken;
        intresTokenList: List of [JsonToken];
        intres, intres1, intres1Token, intres2, intres2Token, intres3, intres3Token, intres4, intres4Token, intres5, intres5Token, intres6, intres6Token : JsonToken;
        RunsDataList: List of [Decimal];
    begin
        if Rec.Data <> '' then begin
            JsonObject.ReadFrom(Rec.Data);

            if JsonObject.Contains('discharge') then begin
                JsonObject.Get('discharge', DischargeToken);

                if DischargeToken.AsArray().Count >= 1 then begin
                    DischargeToken.AsArray().Get(0, run1Token);
                    if run1Token.AsObject().Contains('discharge') then begin
                        run1Token.AsObject().Get('discharge', run1);
                        DischargeRun1 := run1.AsValue().AsDecimal();
                        run1Token.AsObject().Get('tm', run1);
                        DischargeRun1Timestamp := run1.AsValue().AsBigInteger();
                    end else begin
                        DischargeRun1 := 0;
                    end;
                end;

                if DischargeToken.AsArray().Count >= 2 then begin
                    DischargeToken.AsArray().Get(1, run2Token);
                    if run2Token.AsObject().Contains('discharge') then begin
                        run2Token.AsObject().Get('discharge', run2);
                        DischargeRun2 := run2.AsValue().AsDecimal();
                        run2Token.AsObject().Get('tm', run2);
                        DischargeRun2Timestamp := run2.AsValue().AsBigInteger();
                    end else begin
                        DischargeRun2 := 0;
                    end;
                end;
            end;

            if JsonObject.Contains('intres') then begin

                JsonObject.Get('intres', IntresToken);
                if IntresToken.AsArray().Count >= 1 then
                    IntresToken.AsArray().Get(0, intres1)
                else
                    intres1 := BUF.GetEmptyJsonToken();
                if IntresToken.AsArray().Count >= 2 then
                    IntresToken.AsArray().Get(1, intres2)
                else
                    intres2 := BUF.GetEmptyJsonToken();
                if IntresToken.AsArray().Count >= 3 then
                    IntresToken.AsArray().Get(2, intres3)
                else
                    intres3 := BUF.GetEmptyJsonToken();
                if IntresToken.AsArray().Count >= 4 then
                    IntresToken.AsArray().Get(3, intres4)
                else
                    intres4 := BUF.GetEmptyJsonToken();
                if IntresToken.AsArray().Count >= 5 then
                    IntresToken.AsArray().Get(4, intres5)
                else
                    intres5 := BUF.GetEmptyJsonToken();
                if IntresToken.AsArray().Count >= 6 then
                    IntresToken.AsArray().Get(5, intres6)
                else
                    intres6 := BUF.GetEmptyJsonToken();

                intresTokenList.Add(intres1);
                intresTokenList.Add(intres2);
                intresTokenList.Add(intres3);
                intresTokenList.Add(intres4);
                intresTokenList.Add(intres5);
                intresTokenList.Add(intres6);

                foreach intres in intresTokenList do begin
                    if intres.IsObject() then begin
                        if intres.AsObject().Contains('intres') then begin
                            if intres.IsObject() then begin
                                intres.AsObject().Get('intres', IntresToken);

                                IntresToken.AsObject().Get('vh', intres);
                                RunsDataList.Add(intres.AsValue().AsDecimal());

                                IntresToken.AsObject().Get('vl', intres);
                                RunsDataList.Add(intres.AsValue().AsDecimal());

                                IntresToken.AsObject().Get('i', intres);
                                RunsDataList.Add(intres.AsValue().AsDecimal());

                                IntresToken.AsObject().Get('r', intres);
                                RunsDataList.Add(intres.AsValue().AsDecimal());
                            end;
                        end;
                    end;
                end;
                if RunsDataList.Count >= 4 then begin
                    intres1.AsObject().Get('tm', intres1);
                    RUN1_timestamp := intres1.AsValue().AsBigInteger();
                    RUN1_Intres_VH := RunsDataList.Get(1);
                    RUN1_Intres_VL := RunsDataList.Get(2);
                    RUN1_Intres_I := RunsDataList.Get(3);
                    RUN1_Intres_R := RunsDataList.Get(4);
                end;

                if RunsDataList.Count >= 8 then begin
                    intres2.AsObject().Get('tm', intres2);
                    RUN2_timestamp := intres2.AsValue().AsBigInteger();
                    RUN2_Intres_VH := RunsDataList.Get(5);
                    RUN2_Intres_VL := RunsDataList.Get(6);
                    RUN2_Intres_I := RunsDataList.Get(7);
                    RUN2_Intres_R := RunsDataList.Get(8);
                end;

                if RunsDataList.Count >= 12 then begin
                    intres3.AsObject().Get('tm', intres3);
                    RUN3_timestamp := intres3.AsValue().AsBigInteger();
                    RUN3_Intres_VH := RunsDataList.Get(9);
                    RUN3_Intres_VL := RunsDataList.Get(10);
                    RUN3_Intres_I := RunsDataList.Get(11);
                    RUN3_Intres_R := RunsDataList.Get(12);
                end;


                if RunsDataList.Count >= 16 then begin
                    intres4.AsObject().Get('tm', intres4);
                    RUN4_timestamp := intres4.AsValue().AsBigInteger();
                    RUN4_Intres_VH := RunsDataList.Get(13);
                    RUN4_Intres_VL := RunsDataList.Get(14);
                    RUN4_Intres_I := RunsDataList.Get(15);
                    RUN4_Intres_R := RunsDataList.Get(16);
                end;

                if RunsDataList.Count >= 20 then begin
                    intres5.AsObject().Get('tm', intres5);
                    RUN5_timestamp := intres5.AsValue().AsBigInteger();
                    RUN5_Intres_VH := RunsDataList.Get(17);
                    RUN5_Intres_VL := RunsDataList.Get(18);
                    RUN5_Intres_I := RunsDataList.Get(19);
                    RUN5_Intres_R := RunsDataList.Get(20);
                end;

                if RunsDataList.Count >= 24 then begin
                    intres6.AsObject().Get('tm', intres6);
                    RUN6_timestamp := intres6.AsValue().AsBigInteger();
                    RUN6_Intres_VH := RunsDataList.Get(21);
                    RUN6_Intres_VL := RunsDataList.Get(22);
                    RUN6_Intres_I := RunsDataList.Get(23);
                    RUN6_Intres_R := RunsDataList.Get(24);
                end;
            end;
        end;
    end;
}