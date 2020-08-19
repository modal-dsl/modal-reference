table 123456718 "SEM Posted Seminar Reg. Header"
{
    Caption = 'Posted Seminar Registration Header';
    DataCaptionFields = "No.", "Seminar Description";
    LookupPageId = "SEM Posted Sem. Registration";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }

        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "SEM Seminar";
        }
        field(4; "Seminar Description"; Text[50])
        {
            Caption = 'Seminar Description';
        }
        field(5; "Instructor Code"; Code[10])
        {
            Caption = 'Instructor Code';
            TableRelation = "SEM Instructor";
        }
        field(6; "Instructor Name"; Text[50])
        {
            Caption = 'Instructor Name';
            FieldClass = FlowField;
            CalcFormula = Lookup ("SEM Instructor".Name where(Code = field("Instructor Code")));
            Editable = false;
        }
        field(7; Status; Enum "SEM Seminar Registration Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(8; "Duration Days"; Decimal)
        {
            Caption = 'Duration Days';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
        }
        field(10; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            MinValue = 0;
        }
        field(11; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            MinValue = 0;
        }
        field(12; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(13; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(14; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            MinValue = 0;
            AutoFormatType = 1;
        }
        field(15; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        field(20; "Room Code"; Code[10])
        {
            Caption = 'Room Code';
            TableRelation = "SEM Seminar Room";
        }
        field(21; "Room Name"; Text[100])
        {
            Caption = 'Room Name';
        }
        field(22; "Room Name 2"; Text[50])
        {
            Caption = 'Room Name 2';
        }
        field(23; "Room Address"; Text[100])
        {
            Caption = 'Room Address';
        }
        field(24; "Room Address 2"; Text[50])
        {
            Caption = 'Room Address 2';
        }
        field(25; "Room City"; Text[30])
        {
            Caption = 'Room City';

            TableRelation = if ("Room Country/Region Code" = const('')) "Post Code".City
            else
            if ("Room Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Room Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(26; "Room Contact Person"; Text[50])
        {
            Caption = 'Room Contact Person';
        }
        field(27; "Room Country/Region Code"; Code[10])
        {
            Caption = 'Room Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(28; "Room Post Code"; Code[20])
        {
            Caption = 'Post Code';

            TableRelation = if ("Room Country/Region Code" = const('')) "Post Code"
            else
            if ("Room Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Room Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(29; "Room County"; Text[30])
        {
            CaptionClass = '5,1,' + "Room Country/Region Code";
            Caption = 'County';
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
        }
        field(42; Comment; Boolean)
        {
            Caption = 'Comment';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = exist ("SEM Seminar Comment Line" where("No." = field("No."), "Document Line No." = const(0)));
        }
        field(43; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(52; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(53; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(54; "Posting Description"; Text[100])
        {
            Caption = 'Posting Description';
        }
        field(55; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';

        }
        field(56; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(60; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(61; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(62; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(63; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "SEM Posted Seminar Reg. Header";
        }
        field(100; "No. of Participants"; Integer)
        {
            Caption = 'No. of Participants';
            FieldClass = FlowField;
            CalcFormula = count ("SEM Seminar Reg. Line" where("Document No." = field("No.")));
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(500; "Seminar Reg. No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
        }
        field(501; "Seminar Reg. No. Series"; Code[20])
        {
            Caption = 'Seminar Registration No. Series';
            TableRelation = "No. Series".Code;
        }
        field(503; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(504; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Posting Date")
        {
        }
    }

    procedure Navigate()
    var
        NavigatePage: Page Navigate;
    begin
        NavigatePage.SetDoc("Posting Date", "No.");
        NavigatePage.SetRec(Rec);
        NavigatePage.Run;
    end;

}
