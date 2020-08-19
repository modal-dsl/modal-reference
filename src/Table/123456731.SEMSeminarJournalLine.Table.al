table 123456731 "SEM Seminar Journal Line"
{
    Caption = 'Seminar Journal Line';

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "SEM Seminar";
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                TestField("Posting Date");
                Validate("Document Date", "Posting Date");
            end;
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(6; "Entry Type"; Enum "SEM Seminar LE Entry Type")
        {
            Caption = 'Entry Type';
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(10; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(11; "Charge Type"; Enum "SEM Seminar LE Charge Type")
        {
            Caption = 'Charge Type';
        }
        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(14; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(15; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
        }
        field(16; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;
        }
        field(17; "Participant Name"; Text[50])
        {
            Caption = 'Participant Name';
        }
        field(18; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            InitValue = true;
        }
        field(19; "Seminar Room Code"; Code[20])
        {
            Caption = 'Seminar Room No.';
            TableRelation = "SEM Seminar Room";
        }
        field(20; "Instructor Code"; Code[20])
        {
            Caption = 'Instructor No.';
            TableRelation = "SEM Instructor";
        }
        field(21; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(22; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
        }
        field(23; "Res. Ledger Entry No."; Integer)
        {
            Caption = 'Res. Ledger Entry No.';
            TableRelation = "Res. Ledger Entry";
        }
        field(30; "Source Type"; Enum "SEM Seminar LE Source Type")
        {
            Caption = 'Source Type';
        }
        field(31; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Source Type" = const(Seminar)) "SEM Seminar";
        }
        field(32; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(33; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(34; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(35; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(8005; "Last Modified DateTime"; DateTime)
        {
            Caption = 'Last Modified DateTime';
        }
    }

    keys
    {
        key(Key1; "Journal Batch Name", "Journal Template Name", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        SetLastModifiedDateTime;
    end;

    trigger OnModify()
    var
        IsHandled: Boolean;
    begin
        SetLastModifiedDateTime;
    end;

    procedure EmptyLine() Result: Boolean
    var
        IsHandled: Boolean;
    begin
        OnBeforeEmptyLine(Rec, Result, IsHandled);
        if IsHandled then
            exit(Result);
        exit(
          ("Seminar No." = '') and ("Total Price" = 0));
    end;

    procedure GetNewLineNo(TemplateName: Code[10]; BatchName: Code[10]): Integer
    var
        SeminarJnlLine: Record "SEM Seminar Journal Line";
    begin
        SeminarJnlLine.Validate("Journal Template Name", TemplateName);
        SeminarJnlLine.Validate("Journal Batch Name", BatchName);
        SeminarJnlLine.SetRange("Journal Template Name", TemplateName);
        SeminarJnlLine.SetRange("Journal Batch Name", BatchName);
        if SeminarJnlLine.FindLast then
            exit(SeminarJnlLine."Line No." + 10000);
        exit(10000);
    end;

    local procedure SetLastModifiedDateTime()
    var
        DotNet_DateTimeOffset: Codeunit DotNet_DateTimeOffset;
    begin
        "Last Modified DateTime" := DotNet_DateTimeOffset.ConvertToUtcDateTime(CurrentDateTime);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeEmptyLine(SeminarJnlLine: Record "SEM Seminar Journal Line"; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;

}

