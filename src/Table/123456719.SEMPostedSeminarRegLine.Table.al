table 123456719 "SEM Posted Seminar Reg. Line"
{
    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "SEM Posted Seminar Reg. Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(4; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;
        }
        field(5; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup (Contact.Name where("No." = field("Participant Contact No.")));
        }
        field(6; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
        }
        field(7; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            InitValue = true;
        }
        field(8; Participated; Boolean)
        {
            Caption = 'Participated';
        }
        field(9; "Confirmation Date"; Date)
        {
            Caption = 'Confirmation Date';
        }
        field(10; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            MinValue = 0;
            AutoFormatType = 1;
        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 0 : 5;
        }
        field(12; "Line Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Line Discount Amount (LCY)';
            AutoFormatType = 1;
        }
        field(13; "Line Amount (LCY)"; Decimal)
        {
            Caption = 'Line Amount (LCY)';
            AutoFormatType = 1;
        }
        field(14; Registered; Boolean)
        {
            Caption = 'Registered';
            Editable = false;
        }
        field(15; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(18; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(42; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        DimMgt: Codeunit DimensionManagement;
        SeminarCommentLine: Record "SEM Seminar Comment Line";

    trigger OnDelete()
    begin
        SeminarCommentLine.SetRange("Document Type", SeminarCommentLine."Document Type"::"Posted Seminar Registration");
        SeminarCommentLine.SetRange("No.", "Document No.");
        SeminarCommentLine.SetRange("Line No.", "Line No.");
        SeminarCommentLine.DeleteAll();
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "Document No."));
    end;

    procedure ShowLineComments()
    var
        SeminarCommentLine: Record "SEM Seminar Comment Line";
    begin
        SeminarCommentLine.ShowComments(SeminarCommentLine."Document Type"::"Posted Seminar Registration", "Document No.", "Line No.");
    end;

}