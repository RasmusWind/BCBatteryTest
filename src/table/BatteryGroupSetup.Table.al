table 50115 "Battery Group Setup"{
    DataPerCompany = true;

    fields{
        field(1; Code; Code[20]){}
        field(2; Capacity; Integer){
            ToolTip = 'Maximum amount if members of this group.';
        }
    }
}