table 123456700 "SEM Seminar"
{
    Caption = 'Seminar';
    DataCaptionFields = "No.", Description;
    DrillDownPageID = "SEM Seminar List";
    LookupPageId = "SEM Seminar List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    GetSeminarSetup();
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                if ("Search Description" = UpperCase(xRec.Description)) or ("Search Description" = '') then
                    "Search Description" := CopyStr(Description, 1, MaxStrLen("Search Description"));
            end;
        }
        field(3; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
        }
        field(4; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(21; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(22; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(24; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(39; Comment; Boolean)
        {
            CalcFormula = Exist ("Comment Line" where("Table Name" = const(Seminar), "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(31; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(32; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(40; "Duration Days"; Decimal)
        {
            Caption = 'Duration Days';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(41; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            MinValue = 0;

            trigger OnValidate()
            begin
                if ("Minimum Participants" <> 0) and ("Minimum Participants" > "Maximum Participants") then
                    FieldError("Minimum Participants", StrSubstNo(NotGreaterErr, FieldCaption("Maximum Participants")));
            end;
        }
        field(42; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            MinValue = 0;

            trigger OnValidate()
            begin
                if ("Maximum Participants" <> 0) and ("Maximum Participants" < "Minimum Participants") then
                    FieldError("Maximum Participants", StrSubstNo(NotLessErr, FieldCaption("Minimum Participants")));
            end;
        }
        field(43; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(44; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            MinValue = 0;
            AutoFormatType = 2;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Description") { }
        key(Key3; "Gen. Prod. Posting Group") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description) { }
        fieldgroup(Brick; "No.", Description, "Description 2") { }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            TestSeminarNoSeries();
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        DimMgt.UpdateDefaultDim(Database::"SEM Seminar", "No.", "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnDelete()
    begin
        DimMgt.DeleteDefaultDim(Database::"SEM Seminar", "No.");

        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Seminar);
        CommentLine.SetRange("No.", "No.");
        CommentLine.DeleteAll();

        SeminarRegistrationHeader.SetCurrentKey("Seminar No.");
        SeminarRegistrationHeader.SetRange("Seminar No.", "No.");
        IF NOT SeminarRegistrationHeader.IsEmpty THEN
            Error(
              ExistingDocumentsErr,
              TableCaption, "No.", SeminarRegistrationHeader.TableCaption);
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        SeminarSetupRead: Boolean;
        SeminarSetup: Record "SEM Seminar Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        CommentLine: Record "Comment Line";
        Seminar: Record "SEM Seminar";
        SeminarRegistrationHeader: Record "SEM Seminar Reg. Header";
        NotGreaterErr: Label 'must not be greater than %1';
        NotLessErr: Label 'must not be less than %1';
        ExistingDocumentsErr: Label 'You cannot delete %1 %2 because there is at least one outstanding %3 for this seminar.';

    procedure AssistEdit(OldSeminar: Record "SEM Seminar"): Boolean
    begin
        with Seminar do begin
            Seminar := Rec;
            TestSeminarNoSeries();
            if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Nos.", OldSeminar."No. Series", "No. Series") then begin
                TestSeminarNoSeries();
                NoSeriesMgt.SetSeries("No.");
                Rec := Seminar;
                exit(true);
            end;
        end;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        OnBeforeValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);

        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        if not IsTemporary then begin
            DimMgt.SaveDefaultDim(Database::"SEM Seminar", "No.", FieldNumber, ShortcutDimCode);
            Modify;
        end;

        OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);
    end;

    local procedure GetSeminarSetup()
    begin
        if not SeminarSetupRead then
            SeminarSetup.Get();

        SeminarSetupRead := true;

        OnAfterGetSeminarSetup(SeminarSetup);
    end;

    local procedure TestSeminarNoSeries()
    begin
        GetSeminarSetup();
        SeminarSetup.TestField("Seminar Nos.");
    end;

    procedure TestBlocked()
    begin
        TestField(Blocked, false);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetSeminarSetup(var SeminarSetup: Record "SEM Seminar Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var Seminar: Record "SEM Seminar"; var xSeminar: Record "SEM Seminar"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateShortcutDimCode(var Seminar: Record "SEM Seminar"; var xSeminar: Record "SEM Seminar"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

}