page 50107 "Battery Test List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    Caption = 'Battery Tests';
    SourceTable = "Battery Test";
    AdditionalSearchTerms = 'batteries, battery, bats';
    CardPageId = "Battery Test Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field("Item"; Rec.Item)
                {
                    ApplicationArea = All;
                }
                field("Status"; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Purchase Receipt"; Rec."Purch. Rcpt. Header No.")
                {
                    ApplicationArea = All;

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
                            Message('Missing Item!');
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
                            // exit true if good
                            exit(true);
                        end;
                        // exit false if bad
                        exit(false);
                    end;

                }

                field("Purchase Receipt Line"; Rec."Purch. Rcpt. Line No.")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemRec: Record Item;
                        PrcptLine: Record "Purch. Rcpt. Line";
                    begin
                        ItemRec.Get(Rec.Item);
                        if Rec.Item = '' then begin
                            Message('Missing Item!');
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
                }
            }
        }
    }
}