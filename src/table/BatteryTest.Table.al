table 50100 "Battery Test"
{
    DataCaptionFields = Code, Item, "Purch. Rcpt. Header No.", Status;

    fields
    {
        field(1; Code; Code[20]) { }
        field(2; Item; Code[20])
        {
            TableRelation = "Item";
            NotBlank = true;
        }
        field(3; "Purch. Rcpt. Header No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Purch. Rcpt. Header No.';
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
        field(4; "Purch. Rcpt. Line No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Purch. Rcpt. Line No.';
            TableRelation = "Purch. Rcpt. Line"."Line No.";
        }
        field(5; Description; Text[200])
        {
            Caption = 'Description';
        }
        field(6; "Status"; Option)
        {
            OptionMembers = "Open","Released","In progress","Finished";
            InitValue = "Open";
        }
        field(7; "Released date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Finished date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; BatteryGroupSetup; Code[20])
        {
            Caption = 'Group setup';
            TableRelation = "Battery Group Setup";
        }
    }
    keys
    {
        key(PrimaryKey; Code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        SetupRec: Record "Battery Test Setup";
        NoSeries: Record "No. Series";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if Rec.Code = '' then begin
            if SetupRec.Get('SETUP') then begin
                if NoSeries.Get(SetupRec."No. Series") then begin
                    Rec.Code := NoSeriesMgt.GetNextNo(NoSeries.Code, Today);
                    exit;
                end;
            end;
        end;
        if Rec.Code = '' then
            Error('Code must be filled in. Could not get code from "Battery Test Setup". Enter a value or setup "Battery Test Setup".');
    end;
}