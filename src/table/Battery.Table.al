table 50101 Battery
{
    Caption = 'Battery';
    DataPerCompany = true;

    fields
    {
        field(1; ItemLedgerEntry; Code[20])
        {
            TableRelation = "Item Ledger Entry"."Serial No.";
        }
        field(2; BatteryTest; Code[20])
        {
            TableRelation = "Battery Test";
        }
        field(3; Weight; Decimal) { }
        // field(4; DischargeRun1; Decimal)
        // {
        //     Caption = 'First discharge run';
        // }
        // field(5; DischargeRun2; Decimal)
        // {
        //     Caption = 'Second discharge run';
        // }
        // field(6; DischargeRun1Timestamp; BigInteger)
        // {
        //     Caption = 'Timestamp for first discharge run.';
        // }
        // field(7; DischargeRun2Timestamp; BigInteger)
        // {
        //     Caption = 'Timestamp for second discharge run.';
        // }
        // field(8; Intres_VH; Decimal) { }
        // field(9; Intres_VL; Decimal) { }
        // field(10; Intres_I; Decimal) { }
        // field(11; Intres_R; Decimal) { }

        field(4; TimestampStart; BigInteger)
        {
            Caption = 'Timestamp for test start';
        }
        field(5; TimestampEnd; BigInteger)
        {
            Caption = 'Timestamp for test end';
        }
        field(6; Passed; Option)
        {
            OptionMembers = "Not Tested","Passed","Failed";
            InitValue = "Not Tested";
        }
        field(7; Data; Text[2048]) { }
        field(8; Group; Code[20])
        {
            TableRelation = "Battery Group";
        }
    }
    keys
    {
        key(PrimaryKey; ItemLedgerEntry)
        {
            Clustered = true;
        }
    }
}