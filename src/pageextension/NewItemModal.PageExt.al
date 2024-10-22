pageextension 50105 "NewItemModal" extends "Item List"
{
    actions
    {
        addfirst(processing)
        {

            action("New Item")
            {
                ApplicationArea = All;
                Caption = 'Item creation wizard';
                Image = NewItem;
                Promoted = true;
                PromotedCategory = New;
                PromotedOnly = true;

                trigger OnAction()
                var
                    NewItem: Record Item;
                    TemplateItem: Record "Item Templ.";
                    NoSeries: Record "No. Series";
                    NoSeriesMgt: Codeunit "No. Series";
                    TrackingNoSeries: Record "No. Series";
                begin
                    TemplateItem := ShowTemplateSelectionModal();
                    if TemplateItem.Code = '' then exit;

                    NewItem.Init();
                    NewItem.TransferFields(TemplateItem);
                    NewItem.Description := TemplateItem.Description;

                    if TemplateItem."No. Series" <> '' then begin
                        NewItem."No." := NoSeriesMgt.GetNextNo(TemplateItem."No. Series", Today);
                    end;

                    if NewItem."Item Tracking Code" = 'SN' then begin
                        TrackingNoSeries := CreateNewItemTrackingNoSeries(NewItem);
                        NewItem."Serial Nos." := TrackingNoSeries.Code;
                    end else if NewItem."Item Tracking Code" = 'LOT' then begin
                        TrackingNoSeries := CreateNewItemTrackingNoSeries(NewItem);
                        NewItem."Lot Nos." := TrackingNoSeries.Code;
                    end;

                    NewItem.Insert();
                    PAGE.Run(PAGE::"Item Card", NewItem);
                end;
            }


        }
    }

    procedure CreateNewItemTrackingNoSeries(Item: Record Item): Record "No. Series"
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        NoSeries.Init();
        NoSeries.Code := Item."No.";
        NoSeries.Description := Item.Description;
        NoSeries."Default Nos." := true;
        NoSeries.Insert();

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := Item."No.";
        NoSeriesLine."Starting No." := Item."No." + '-' + '0001';
        NoSeriesLine."Ending No." := Item."No." + '-' + '99999';
        NoSeriesLine.Insert();

        exit(NoSeries);
    end;

    procedure ShowTemplateSelectionModal(): Record "Item Templ."
    var
        ItemTemplate: Record "Item Templ.";
        ItemTemplateQuery: Record "Item Templ.";
        NewItemTemplate: Record "Item Templ.";
        ItemCategory: Record "Item Category";
        CategoryPaddingNumber: Integer;
        NewNoSeries: Record "No. Series";
        NewNoSeriesLine: Record "No. Series Line";
        ItemCatCodeStr: Text;
    begin
        ItemTemplate.Setfilter("Inventory Posting Group", '<>%1', '');

        if PAGE.RunModal(PAGE::"Item Templ. List", ItemTemplate) = Action::LookupOK then begin
            if ItemTemplate."Item Category Code" <> '' then begin
                exit(ItemTemplate);
            end;
            if ItemTemplate."Inventory Posting Group" = 'FÆRDIGVARE' then begin
                exit(ItemTemplate);
            end;

            if PAGE.RunModal(PAGE::"Item Categories", ItemCategory) = Action::LookupOK then begin
                ItemTemplateQuery.SetRange("Item Category Code", ItemCategory.Code);
                ItemTemplateQuery.SetRange("Gen. Prod. Posting Group", ItemTemplate."Gen. Prod. Posting Group");

                if ItemTemplateQuery.FindFirst() then
                    exit(ItemTemplateQuery);

                NewItemTemplate.Init();
                NewItemTemplate.TransferFields(ItemTemplate);
                NewItemTemplate."Item Category Code" := ItemCategory.Code;

                ItemCatCodeStr := FORMAT(ItemCategory.Code);
                CategoryPaddingNumber := 2 - STRLEN(ItemCatCodeStr);
                if CategoryPaddingNumber < 0 then
                    CategoryPaddingNumber := 0;

                ItemCatCodeStr := PADSTR('', CategoryPaddingNumber, '0') + ItemCatCodeStr;
                NewItemTemplate.Code := FORMAT(ItemTemplate.Code) + ItemCatCodeStr;
                NewItemTemplate.Description := ItemCategory.Description;

                NewNoSeries.Init();
                NewNoSeries.Code := NewItemTemplate.Code;
                NewNoSeries.Description := NewItemTemplate.Description;
                NewNoSeries."Default Nos." := true;

                NewNoSeriesLine.Init();
                NewNoSeriesLine."Series Code" := NewNoSeries.Code;
                NewNoSeriesLine."Starting No." := FORMAT(NewItemTemplate.Code) + '-4001';
                NewNoSeriesLine."Ending No." := FORMAT(NewItemTemplate.Code) + '-99999';

                NewItemTemplate."No. Series" := NewNoSeries.Code;

                NewItemTemplate.Insert();
                NewNoSeries.Insert();
                NewNoSeriesLine.Insert();

                exit(NewItemTemplate);
            end;
        end;
    end;


}