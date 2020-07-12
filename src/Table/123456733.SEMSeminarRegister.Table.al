table 123456733 "SEM Seminar Register"
{

    Caption = 'Seminar Register';

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(2; "From Entry No."; Integer)
        {
            Caption = 'From Entry No.';
            TableRelation = "SEM Seminar Ledger Entry";
        }
        field(3; "To Entry No."; Integer)
        {
            Caption = 'To Entry No.';
            TableRelation = "SEM Seminar Ledger Entry";
        }
        field(4; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(5; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
        }
        field(7; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(10; Reversed; Boolean)
        {
            Caption = 'Reversed';
        }
        field(11; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Creation Date")
        {
        }
        key(Key3; "Source Code", "Journal Batch Name", "Creation Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "From Entry No.", "To Entry No.", "Creation Date", "Source Code")
        {
        }
    }

    procedure GetLastEntryNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("No.")))
    end;

    procedure Initialize(NextRegNo: Integer; FromEntryNo: Integer; SourceCode: Code[10]; BatchName: Code[10]; TemplateName: Code[10])
    begin
        Init;
        "No." := NextRegNo;
        "Creation Date" := Today;
        "Creation Time" := Time;
        "Source Code" := SourceCode;
        "User ID" := UserId;
        "From Entry No." := FromEntryNo;
        "Journal Batch Name" := BatchName;
        Clear(TemplateName);
    end;
}
