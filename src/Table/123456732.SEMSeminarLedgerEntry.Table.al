table 123456732 "SEM Seminar Ledger Entry"
{
    Caption = 'Seminar Ledger Entry';
    DrillDownPageID = "SEM Seminar Ledger Entries";
    LookupPageID = "SEM Seminar Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "SEM Seminar";
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(5; "Entry Type"; Enum "SEM Seminar LE Entry Type")
        {
            Caption = 'Entry Type';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(9; "Charge Type"; Enum "SEM Seminar LE Charge Type")
        {
            Caption = 'Charge Type';
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(12; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(13; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
        }
        field(14; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;
        }
        field(15; "Participant Name"; Text[50])
        {
            Caption = 'Participant Name';
        }
        field(16; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            InitValue = true;
        }
        field(17; "Seminar Room Code"; Code[10])
        {
            Caption = 'Room Code';
            TableRelation = "SEM Seminar Room";
        }
        field(18; "Instructor Code"; Code[10])
        {
            Caption = 'Instructor Code';
            TableRelation = "SEM Instructor";
        }
        field(19; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(20; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
        }
        field(21; "Res. Ledger Entry No."; Integer)
        {
            Caption = 'Res. Ledger Entry No.';
            TableRelation = "Res. Ledger Entry";
        }
        field(22; "Source Type"; Enum "SEM Seminar LE Source Type")
        {
            Caption = 'Source Type';
        }
        field(23; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const(Seminar)) "SEM Seminar";
        }
        field(24; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(25; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(26; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(27; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(28; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(8005; "Last Modified DateTime"; DateTime)
        {
            Caption = 'Last Modified DateTime';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.")
        {
        }
        key(Key3; "Seminar No.", "Posting Date", "Seminar Room Code")
        {
            SumIndexFields = Quantity;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Last Modified DateTime" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified DateTime" := CurrentDateTime;
    end;

    trigger OnRename()
    begin
        "Last Modified DateTime" := CurrentDateTime;
    end;

    procedure GetLastEntryNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Entry No.")))
    end;

    procedure GetLastEntry(var LastEntryNo: Integer)
    var
        FindRecordManagement: Codeunit "Find Record Management";
        FieldNoValues: List of [Integer];
    begin
        FieldNoValues.Add(FieldNo("Entry No."));
        FindRecordManagement.GetLastEntryIntFieldValues(Rec, FieldNoValues);
        LastEntryNo := FieldNoValues.Get(1);
    end;

    procedure CopyFromSeminarJnlLine(SeminarJnlLine: Record "SEM Seminar Journal Line")
    begin
        "Seminar No." := SeminarJnlLine."Seminar No.";
        "Posting Date" := SeminarJnlLine."Posting Date";
        "Document Date" := SeminarJnlLine."Document Date";
        "Entry Type" := SeminarJnlLine."Entry Type";
        "Document No." := SeminarJnlLine."Document No.";
        Description := SeminarJnlLine.Description;
        "Bill-to Customer No." := SeminarJnlLine."Bill-to Customer No.";
        "Charge Type" := SeminarJnlLine."Charge Type";
        Quantity := SeminarJnlLine.Quantity;
        "Unit Price" := SeminarJnlLine."Unit Price";
        "Total Price" := SeminarJnlLine."Total Price";
        "Participant Contact No." := SeminarJnlLine."Participant Contact No.";
        "Participant Name" := SeminarJnlLine."Participant Name";
        Chargeable := SeminarJnlLine.Chargeable;
        "Seminar Room Code" := SeminarJnlLine."Seminar Room Code";
        "Instructor Code" := SeminarJnlLine."Instructor Code";
        "Starting Date" := SeminarJnlLine."Starting Date";
        "Seminar Registration No." := SeminarJnlLine."Seminar Registration No.";
        "Res. Ledger Entry No." := SeminarJnlLine."Res. Ledger Entry No.";
        "Source Type" := SeminarJnlLine."Source Type";
        "Source No." := SeminarJnlLine."Source No.";
        "Journal Batch Name" := SeminarJnlLine."Journal Batch Name";
        "Source Code" := SeminarJnlLine."Source Code";
        "Reason Code" := SeminarJnlLine."Reason Code";
        "No. Series" := SeminarJnlLine."Posting No. Series";

        OnAfterCopySeminarLedgerEntryFromSeminarJnlLine(Rec, SeminarJnlLine);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopySeminarLedgerEntryFromSeminarJnlLine(var SeminarLE: Record "SEM Seminar Ledger Entry"; var SeminarJnlLine: Record "SEM Seminar Journal Line")
    begin
    end;

}

