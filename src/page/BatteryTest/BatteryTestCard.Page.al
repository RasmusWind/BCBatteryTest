page 50108 "Battery Test Card"
{
    PageType = Card;
    RefreshOnActivate = true;
    Caption = 'Battery Test';
    SourceTable = "Battery Test";


    layout
    {

        area(content)
        {
            group(Images)
            {
                part(ImageControl; ImageControlAddInPart)
                {
                    ApplicationArea = All;
                    Visible = false;
                }

            }
            group("Initial Data")
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Editable = Locked;
                }
                field(Item; Rec.Item)
                {
                    ApplicationArea = All;
                    Editable = Locked;
                }

                field("Item amount"; ItemAmount)
                {
                    ApplicationArea = All;
                    Editable = false;

                }

                field("Purch. Rcpt. Header No."; Rec."Purch. Rcpt. Header No.")
                {
                    ApplicationArea = All;
                    Editable = Locked;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemRec: Record Item;
                        Prcpt: Record "Purch. Rcpt. Header";
                        PrcptLine: Record "Purch. Rcpt. Line";
                        PrcptHeaderNos: List of [Code[20]];
                        FilterString: Text;
                        FKey: Code[20];
                    begin

                        if Rec.Item = '' then begin
                            Error('Missing Item!');
                            exit(false);
                        end;

                        ItemRec.Get(Rec.Item);
                        // Get a list of Purchase receipt lines, every line holding the item.
                        PrcptLine.SetRange("Type", PrcptLine.Type::Item);
                        PrcptLine.SetRange("No.", ItemRec."No.");

                        // If values exists in the query then we loop them
                        if PrcptLine.FindSet() then begin
                            // Loop via "Repeat - Until"
                            repeat
                                FKey := PrcptLine."Document No.";
                                // If our list of numbers doesnt contain the new key, then we add it.
                                // We also start building the FilterString.
                                if not PrcptHeaderNos.Contains(FKey) then begin
                                    PrcptHeaderNos.Add(FKey);
                                    if FilterString = '' then
                                        FilterString := FKey
                                    else
                                        FilterString := FilterString + '|' + FKey;
                                end;
                            // Loop untill the next element is null.
                            until PrcptLine.Next() = 0;
                        end;

                        // Apply the created filter
                        Prcpt.SetFilter("No.", FilterString);

                        // Run a model of a certain page with the filtered receipt headers. The Page and Record needs to match.
                        If PAGE.RunModal(PAGE::"Posted Purchase Receipts", Prcpt) = Action::LookupOK then begin
                            // If the lookup went okay, then we set the Text to whatever value we found.
                            Text := Prcpt."No.";
                            Rec."Purch. Rcpt. Line No." := '';
                            UpdateItemAmount();
                            // exit true if good
                            exit(true);
                        end;
                        // exit false if bad
                        exit(false);
                    end;
                }

                field("Purch. Rcpt. Line No."; Rec."Purch. Rcpt. Line No.")
                {
                    ApplicationArea = All;
                    Editable = Locked;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemRec: Record Item;
                        PrcptLine: Record "Purch. Rcpt. Line";
                    begin
                        ItemRec.Get(Rec.Item);
                        if Rec.Item = '' then begin
                            Error('Missing Item!');
                            exit(false);
                        end;

                        PrcptLine.SetRange("Type", PrcptLine.Type::Item);
                        if Rec."Purch. Rcpt. Header No." = '' then
                            PrcptLine.SetRange("No.", ItemRec."No.")
                        else
                            PrcptLine.SetRange("Document No.", Rec."Purch. Rcpt. Header No.");

                        // Run a model of a certain page with the filtered receipt headers. The Page and Record needs to match.
                        If PAGE.RunModal(PAGE::"Posted Purchase Receipt Lines", PrcptLine) = Action::LookupOK then begin
                            // If the lookup went okay, then we set the Text to whatever value we found.
                            Text := FORMAT(PrcptLine."Line No.");
                            Rec."Purch. Rcpt. Header No." := PrcptLine."Document No.";
                            // exit true if good
                            exit(true);
                        end;
                        // exit false if bad
                        exit(false);


                    end;

                    trigger OnValidate()
                    begin
                        UpdateItemAmount();
                    end;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        StatusOption: Option;
                    begin
                        if Rec.Status = Rec.Status::Released then begin
                            if Rec."Purch. Rcpt. Line No." = '' then
                                Error('"Purch. Rcpt. Line No." must have a value before the test can be released.');
                        end;

                        if Rec.Status = Rec.Status::Finished then begin
                            if Rec."Purch. Rcpt. Line No." = '' then
                                Error('"Purch. Rcpt. Line No." must have a value before the test can be released.');
                            if PreviousStatus = Rec.Status::Finished then
                                exit;
                            if PreviousStatus <> Rec.Status::"In progress" then
                                Error('Cannot finish an open and unreleased test. Please release the test first.');
                        end;
                        PreviousStatus := Rec.Status;
                    end;
                }

                field("Released date"; Rec."Released date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Finished date"; Rec."Finished date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(BatteryGroupSetup; Rec.BatteryGroupSetup)
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        BGSList: Page "Battery Group Setup List";
                    begin
                        if BGSList.RunModal() = Action::LookupOK then
                            CurrPage.Update(false);
                    end;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Editable = Locked;
                }
            }
            group("Battery single Criteria")
            {
                part(SingleTestCriteriaList; "Single Test Criteria List Part")
                {
                    Editable = Locked;
                    Caption = 'Battery single criteria';
                    ApplicationArea = All;
                    SubPageLink = BatteryTest = FIELD(Code);
                }
            }

            group("Battery group Criteria")
            {
                part(GroupTestCriteriaList; "Group Test Criteria List Part")
                {
                    Editable = Locked;
                    Caption = 'Battery group criteria';
                    ApplicationArea = All;
                    SubPageLink = BatteryTest = FIELD(Code);
                }

            }
            group("Battery Groups")
            {
                part("Groups"; "Battery Group List Part")
                {
                    Editable = false;
                    Caption = 'Battery Groups';
                    ApplicationArea = All;
                    // SubPageLink = BatteryTest = FIELD(Code);
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Battery List")
            {
                ApplicationArea = All;
                Caption = 'Battery list';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Battery: Record "Battery";
                begin
                    Battery.SetRange(BatteryTest, Rec.Code);
                    Page.RunModal(Page::"Battery List", Battery);
                end;
            }
            action("Group List")
            {
                ApplicationArea = All;
                Caption = 'Group List';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    BatteryGroup: Record "Battery Group";
                begin
                    BatteryGroup.SetRange(BatteryTest, Rec.Code);
                    Page.RunModal(Page::"Battery Group List");
                end;
            }
            action("Get Batteries")
            {
                ApplicationArea = All;
                Caption = 'Create Batteries';
                Image = Timesheet;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CheckBattery: Record "Battery";
                    Battery: Record "Battery";
                    LedgerEntries: Record "Item Ledger Entry";
                begin
                    LedgerEntries.SetRange("Item No.", Rec.Item);
                    LedgerEntries.Setfilter("Serial No.", '<>%1', '');
                    LedgerEntries.SetRange("Document No.", Rec."Purch. Rcpt. Header No.");


                    repeat
                        if not CheckBattery.Get(LedgerEntries."Serial No.") then begin
                            if LedgerEntries."Serial No." <> '' then begin
                                Battery.Init();
                                Battery.ItemLedgerEntry := LedgerEntries."Serial No.";
                                Battery.BatteryTest := Rec.Code;
                                Battery.Insert();
                            end;
                        end;
                    until LedgerEntries.Next() = 0;
                    Message('Succesfully created batteries!');

                    // Battery.SetRange(BatteryTest, Rec.Code);
                    // Page.RunModal(Page::"Battery List", Battery);
                end;
            }
        }
    }

    var
        PreviousStatus: Option;
        ItemAmount: Decimal;
        Locked: Boolean;
        TempRec: Record "Battery Test";



    trigger OnOpenPage();
    begin
        TempRec.Copy(Rec);
        PreviousStatus := Rec.Status;
        UpdateItemAmount();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if TempRec.Status <> Rec.Status then begin
            TempRec.Status := Rec.Status;
            CurrPage.Update(false);
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Status <> Rec.Status::Open then
            Locked := false
        else
            Locked := true;

        CurrPage.SingleTestCriteriaList.PAGE.SetParent(Rec.Code);
        CurrPage.GroupTestCriteriaList.PAGE.SetParent(Rec.Code);
    end;

    local procedure UpdateItemAmount()
    var
        PurchaseLine: Record "Purch. Rcpt. Line";
    begin
        if Rec."Purch. Rcpt. Header No." = '' then
            exit;
        if Rec."Purch. Rcpt. Line No." = '' then
            exit;
        PurchaseLine.Get(Rec."Purch. Rcpt. Header No.", Rec."Purch. Rcpt. Line No.");
        ItemAmount := PurchaseLine.Quantity;
    end;
}