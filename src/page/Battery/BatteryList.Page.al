page 50111 "Battery List"
{
    PageType = List;
    SourceTable = Battery;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    Caption = 'Batteries';
    AdditionalSearchTerms = 'batteries, battery, bats';
    CardPageId = "Battery Card";

    layout
    {
        area(content)
        {
            repeater(RepeaterGroup)
            {
                field(ItemLedgerEntry; Rec.ItemLedgerEntry)
                {
                    ApplicationArea = All;
                    StyleExpr = RowColor;
                }
                field(BatteryTest; Rec.BatteryTest) { ApplicationArea = All; StyleExpr = RowColor; }
                field(Group; Rec.Group)
                {
                    ApplicationArea = All;
                    StyleExpr = RowColor;

                    trigger OnDrillDown()
                    var
                        GroupRec: Record "Battery Group";
                        GroupCard: Page "Battery Group Card";
                    begin
                        if GroupRec.Get(Rec.Group) then begin
                            GroupCard.SetRecord(GroupRec);
                            GroupCard.RunModal();
                        end;
                    end;
                }
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

    actions
    {
        area(Processing)
        {
            action(EvaluateBatteries)
            {
                Caption = 'Evaluate batteries';
                Promoted = true;
                PromotedCategory = Process;
                Image = SetupLines;

                trigger OnAction()
                var
                    BCU: Codeunit Battery;
                begin
                    BCU.EvaluateBatteryList(Rec);
                end;

            }
            action(GroupBatteries)
            {
                Caption = 'Group Batteries';
                Promoted = true;
                PromotedCategory = Process;
                Image = Group;
                trigger OnAction()
                var
                    BCU: Codeunit Battery;
                begin
                    BCU.GroupBatteries(Rec);
                end;
            }
            action(ImportBatteryData)
            {
                Caption = 'Import battery data';
                Promoted = true;
                PromotedCategory = Process;
                Image = Import;

                trigger OnAction()
                var
                    InStream: InStream;
                    FileName: Text;
                    BatteryCU: Codeunit Battery;
                begin
                    if UploadIntoStream('Upload Text File', '', 'Text Files (*.txt)|*.txt|Zip Files|*.zip', FileName, InStream) then begin
                        BatteryCU.ProcessFileContent(Rec, InStream);
                    end;
                end;
            }
            action(EmptyData)
            {
                Caption = 'Remove all data';
                Promoted = true;
                PromotedCategory = Process;
                Image = "Invoicing-MDL-Delete";

                trigger OnAction()
                var
                    Battery: Record Battery;
                begin
                    if Dialog.Confirm('Are you sure, you want to remove all data from batteries within this list?') then begin
                        repeat
                            Rec.Data := '';
                            Rec.Passed := Rec.Passed::"Not Tested";
                            Rec.Modify();
                        until Rec.Next() = 0;
                    end;
                end;
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