page 50112 "Battery Test Setup"
{
    PageType = Card;
    SourceTable = "Battery Test Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    AdditionalSearchTerms = 'Battery, Test, Setup';

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Primary Key"; Rec.Code)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Setting1"; Rec."No. Series")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        SetupRec: Record "Battery Test Setup";
    begin
        if not SetupRec.Get('SETUP') then begin
            SetupRec.Init();
            SetupRec.Code := 'SETUP';
            SetupRec.Insert();
            CurrPage.Update(false);
        end;
    end;

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(InitializeSetup)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Initialize Setup';
    //             trigger OnAction()
    //             var
    //                 SetupRec: Record "Battery Test Setup";
    //             begin
    //                 if not SetupRec.Get('SETUP') then begin
    //                     SetupRec.Init();
    //                     SetupRec.Code := 'SETUP';
    //                     SetupRec.Insert();
    //                 end;
    //             end;
    //         }
    //     }
    // }
}