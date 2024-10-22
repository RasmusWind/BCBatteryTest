pageextension 50130 "CreateItemSN" extends "Item Card"
{
    actions
    {
        addfirst(processing)
        {

            action("Create SN/LOT No. Series.")
            {
                ApplicationArea = All;
                Caption = 'Create SN/LOT No. Series.';
                Image = SerialNo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TrackingNoSeries: Record "No. Series";
                begin
                    if Rec."Item Tracking Code" = '' then
                        Error('Missing "Item Tacking Code".');

                    if Rec."Serial Nos." <> '' then
                        Error('Item already contains a "No. Series" for serial numbers.');
                    if Rec."Lot Nos." <> '' then
                        Error('Item already contains a "No. Series" for lot numbers.');

                    TrackingNoSeries := CreateNewItemTrackingNoSeries(Rec);
                    if Rec."Item Tracking Code" = 'SN' then begin
                        Rec."Serial Nos." := TrackingNoSeries.Code;
                    end else if Rec."Item Tracking Code" = 'LOT' then begin
                        Rec."Lot Nos." := TrackingNoSeries.Code;
                    end;
                    Rec.Modify();
                end;
            }
        }
    }

    procedure CreateNewItemTrackingNoSeries(Item: Record Item): Record "No. Series"
    var
        CheckNoSeries: Record "No. Series";
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if CheckNoSeries.Get(Item."No.") then
            Error('No. Series for %1 already exists.', Item."No.");

        NoSeries.Init();
        NoSeries.Code := Item."No.";
        NoSeries.Description := Item.Description;
        NoSeries."Default Nos." := true;
        NoSeries.Insert();

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := Item."No.";
        NoSeriesLine."Starting No." := Item."No." + '-' + '0001';
        NoSeriesLine."Ending No." := Item."No." + '-' + '99999';
        NoSeriesLine."Starting Date" := Today();
        NoSeriesLine.Insert();

        exit(NoSeries);
    end;
}

