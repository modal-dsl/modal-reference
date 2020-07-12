table 123456701 "SEM Seminar Setup"
{
    Caption = 'Seminar Setup';
    DrillDownPageID = "SEM Seminar Setup";
    LookupPageID = "SEM Seminar Setup";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Seminar Nos."; Code[20])
        {
            Caption = 'Seminar Nos.';
            TableRelation = "No. Series";
        }
        field(3; "Seminar Registration Nos."; Code[20])
        {
            Caption = 'Seminar Registration Nos.';
            TableRelation = "No. Series";
        }
        field(4; "Posted Seminar Reg. Nos."; Code[20])
        {
            Caption = 'Posted Seminar Reg. Nos.';
            TableRelation = "No. Series";
        }
        field(10; "Copy Comments"; Boolean)
        {
            AccessByPermission = TableData "SEM Posted Seminar Reg. Header" = R;
            Caption = 'Copy Comments To Posted Reg.';
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        RecordHasBeenRead: Boolean;

    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;
        Get;
        RecordHasBeenRead := true;
    end;

}
