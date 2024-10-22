page 50121 "Battery List Part"
{
    PageType = ListPart;
    SourceTable = Battery;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ItemLedgerEntry; Rec.ItemLedgerEntry)
                {
                    ApplicationArea = All;
                    StyleExpr = RowColor;
                }
                field(BatteryTest; Rec.BatteryTest) { ApplicationArea = All; StyleExpr = RowColor; }
                field(Weight; Rec.Weight) { ApplicationArea = All; StyleExpr = RowColor; }
                field("DischargeRun1"; DischargeRun1)
                {
                    Caption = '1st discharge run';
                    ApplicationArea = All;
                    StyleExpr = RowColor;
                }
                field(DischargeRun2; DischargeRun2)
                {
                    Caption = '2nd discharge run';
                    ApplicationArea = All;
                    StyleExpr = RowColor;
                }
                field("VH"; Intres_VH)
                {
                    ApplicationArea = All;
                    StyleExpr = RowColor;
                }
                field("VL"; Intres_VL)
                {
                    ApplicationArea = All;
                    StyleExpr = RowColor;
                }
                field("I"; Intres_I)
                {
                    ApplicationArea = All;
                    StyleExpr = RowColor;
                }
                field("R"; Intres_R)
                {
                    ApplicationArea = All;
                    StyleExpr = RowColor;
                }
                field(TimestampStart; Rec.TimestampStart) { ApplicationArea = All; StyleExpr = RowColor; }
                field(TimestampEnd; Rec.TimestampEnd) { ApplicationArea = All; StyleExpr = RowColor; }
                field(Passed; Rec.Passed) { ApplicationArea = All; StyleExpr = RowColor; }
            }
        }
    }

    var
        DischargeRun1, DischargeRun2 : Decimal;
        Intres_VH, Intres_VL, Intres_I, Intres_R : Decimal;
        RowColor: Text;

    trigger OnAfterGetRecord()
    var
        BCU: Codeunit Battery;
        JsonObject: JsonObject;
        DischargeToken, IntresToken : JsonToken;
        run1, run2, intres, vh, vl, i, r : JsonToken;
    begin
        if Rec.Data <> '' then begin
            JsonObject.ReadFrom(Rec.Data);
            if JsonObject.Contains('discharge') then begin
                JsonObject.Get('discharge', DischargeToken);

                if DischargeToken.AsArray().Count >= 1 then begin
                    DischargeToken.AsArray().Get(0, run1);
                    if run1.AsObject().Contains('discharge') then begin
                        run1.AsObject().Get('discharge', run1);
                        DischargeRun1 := run1.AsValue().AsDecimal();
                    end else begin
                        DischargeRun1 := 0;
                    end;
                end else begin
                    DischargeRun1 := 0;
                end;

                if DischargeToken.AsArray().Count >= 2 then begin
                    DischargeToken.AsArray().Get(1, run2);
                    if run2.AsObject().Contains('discharge') then begin
                        run2.AsObject().Get('discharge', run2);
                        DischargeRun2 := run2.AsValue().AsDecimal();
                    end else begin
                        DischargeRun2 := 0;
                    end;
                end else begin
                    DischargeRun2 := 0;
                end;
            end;

            if JsonObject.Contains('intres') then begin
                JsonObject.Get('intres', IntresToken);
                if IntresToken.AsArray().Count >= 1 then begin
                    IntresToken.AsArray().Get(0, intres);
                    intres.AsObject().Get('intres', intres);
                    intres.AsObject().Get('vh', vh);
                    Intres_VH := vh.AsValue().AsDecimal();
                    intres.AsObject().Get('vl', vl);
                    Intres_VL := vl.AsValue().AsDecimal();
                    intres.AsObject().Get('i', i);
                    Intres_I := i.AsValue().AsDecimal();
                    intres.AsObject().Get('r', r);
                    Intres_R := r.AsValue().AsDecimal();
                end;
            end;
        end else begin
            DischargeRun1 := 0;
            DischargeRun2 := 0;
            Intres_VH := 0;
            Intres_VL := 0;
            Intres_I := 0;
            Intres_R := 0;
        end;
        if Rec.Group <> '' then begin
            RowColor := 'strongaccent';
        end else if Rec.Passed = Rec.Passed::Failed then begin
            RowColor := 'unfavorable';
        end else if Rec.Passed = Rec.Passed::Passed then begin
            RowColor := 'favorable';
        end else begin
            RowColor := 'standard';
        end;
    end;
}