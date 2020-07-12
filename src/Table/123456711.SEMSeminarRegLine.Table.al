table 123456711 "SEM Seminar Reg. Line"
{
    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "SEM Seminar Reg. Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                TempSeminarRegLine: Record "SEM Seminar Reg. Line" temporary;
            begin
                if "Bill-to Customer No." = xRec."Bill-to Customer No." then
                    EXIT;

                if "Bill-to Customer No." <> xRec."Bill-to Customer No." then begin
                    TestStatusPlanning();
                    TestField(Registered, false);
                    TestField("Confirmation Date", 0D);
                end;

                TempSeminarRegLine := Rec;

                if xRec."Bill-to Customer No." <> '' then begin
                    InitRecord;
                    "Bill-to Customer No." := TempSeminarRegLine."Bill-to Customer No.";
                end;

                if "Bill-to Customer No." <> '' then begin
                    Cust.Get("Bill-to Customer No.");
                    Cust.TestField(Blocked, Cust.Blocked::" ");
                    "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                end;
            end;
        }
        field(4; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                if "Participant Contact No." <> '' then
                    if Cont.Get("Participant Contact No.") then
                        Cont.SetRange("Company No.", Cont."Company No.")
                    else
                        if ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer, "Participant Contact No.") then
                            Cont.SetRange("Company No.", ContBusinessRelation."Contact No.")
                        else
                            Cont.SetRange("No.", '');

                if "Participant Contact No." <> '' then
                    if Cont.Get("Participant Contact No.") then;
                if PAGE.RunModal(0, Cont) = ACTION::LookupOK then begin
                    xRec := Rec;
                    Validate("Participant Contact No.", Cont."No.");
                end;
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
                TempSeminarRegLine: Record "SEM Seminar Reg. Line" temporary;
            begin
                if "Participant Contact No." = xRec."Participant Contact No." then
                    exit;

                if "Participant Contact No." <> '' then
                    if Cont.Get("Participant Contact No.") then
                        Cont.CheckIfPrivacyBlockedGeneric;

                if ("Participant Contact No." <> xRec."Participant Contact No.") and (xRec."Participant Contact No." <> '') then begin
                    if GetHideValidationDialog or not GuiAllowed then
                        Confirmed := true
                    else
                        Confirmed := Confirm(ConfirmChangeQst, false, FieldCaption("Participant Contact No."));
                    if not Confirmed then begin
                        "Participant Contact No." := xRec."Participant Contact No.";
                        exit;
                    end;
                end;

                if "Participant Contact No." = '' then
                    exit;

                TempSeminarRegLine := Rec;

                InitRecord();
                "Bill-to Customer No." := TempSeminarRegLine."Bill-to Customer No.";
                "Participant Contact No." := TempSeminarRegLine."Participant Contact No.";
                "Gen. Bus. Posting Group" := TempSeminarRegLine."Gen. Bus. Posting Group";

                CalcFields("Participant Name");

                if "Bill-to Customer No." = '' then begin
                    ContBusinessRelation.SETRANGE("Contact No.", Cont."Company No.");
                    ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                    if ContBusinessRelation.FINDFIRST then begin
                        Cust.GET(ContBusinessRelation."No.");
                        if Cust.Blocked = Cust.Blocked::" " then begin
                            "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                            "Bill-to Customer No." := Cust."No.";
                        end;
                    end;
                end;
            end;
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

            trigger OnValidate()
            begin
                Validate("Line Discount %");
            end;
        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestStatusPlanning();
                "Line Discount Amount (LCY)" := Round("Seminar Price" * "Line Discount %" / 100);
                UpdateAmounts();
            end;
        }
        field(12; "Line Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Line Discount Amount (LCY)';
            AutoFormatType = 1;
            //AutoFormatExpression = "Currency Code";

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                TestStatusPlanning();
                if xRec."Line Discount Amount (LCY)" <> "Line Discount Amount (LCY)" then
                    UpdateLineDiscPct();
                UpdateAmounts();
            end;
        }
        field(13; "Line Amount (LCY)"; Decimal)
        {
            Caption = 'Line Amount (LCY)';
            AutoFormatType = 1;
            //AutoFormatExpression = "Currency Code";

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeValidateLineAmount(Rec, xRec, CurrFieldNo, IsHandled);
                if IsHandled then
                    exit;

                TestStatusPlanning();
                "Line Amount (LCY)" := Round("Line Amount (LCY)");
                Validate(
                  "Line Discount Amount (LCY)", "Seminar Price" - "Line Amount (LCY)");
            end;
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
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(42; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
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
        Confirmed: Boolean;
        DimMgt: Codeunit DimensionManagement;
        SeminarRegHeader: Record "SEM Seminar Reg. Header";
        SeminarCommentLine: Record "SEM Seminar Comment Line";
        Cust: Record Customer;
        StatusCheckSuspended: Boolean;
        HideValidationDialog: Boolean;
        LineDiscountPctErr: Label 'The value in the Line Discount % field must be between 0 and 100.';
        ConfirmChangeQst: Label 'Do you want to change %1?';
        RenameNotAllowedErr: Label 'You cannot rename a %1.';

    trigger OnRename()
    begin
        Error(RenameNotAllowedErr, TableCaption);
    end;

    trigger OnDelete()
    begin
        SeminarCommentLine.SetRange("Document Type", SeminarCommentLine."Document Type"::"Seminar Registration");
        SeminarCommentLine.SetRange("No.", "Document No.");
        SeminarCommentLine.SetRange("Line No.", "Line No.");
        SeminarCommentLine.DeleteAll();

        GetSeminarRegHeader;
        SeminarRegHeader.TestField(Status, SeminarRegHeader.Status::Registration);
        TestField(Registered, false);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        OnBeforeValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);

        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");

        OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateShortcutDimCode(var SeminarRegLine: Record "SEM Seminar Reg. Line"; xSeminarRegLine: Record "SEM Seminar Reg. Line"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var SeminarRegLine: Record "SEM Seminar Reg. Line"; xSeminarRegLine: Record "SEM Seminar Reg. Line"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    procedure ShowDimensions() IsChanged: Boolean
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%2 %3', "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IsChanged := OldDimSetID <> "Dimension Set ID";

        OnAfterShowDimensions(Rec, xRec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterShowDimensions(var SeminarRegLine: Record "SEM Seminar Reg. Line"; xSeminarRegLine: Record "SEM Seminar Reg. Line")
    begin
    end;

    procedure TestStatusPlanning()
    begin
        GetSeminarRegHeader();
        OnBeforeTestStatusPlanning(Rec, SeminarRegHeader);

        if StatusCheckSuspended then
            exit;

        SeminarRegHeader.Testfield(Status, SeminarRegHeader.Status::Planning);

        OnAfterTestStatusPlanning(Rec, SeminarRegHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestStatusPlanning(var SeminarRegLine: Record "SEM Seminar Reg. Line"; var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTestStatusPlanning(var SeminarRegLine: Record "SEM Seminar Reg. Line"; var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
    end;

    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;

    procedure GetSeminarRegHeader()
    var
        IsHandled: Boolean;
    begin
        OnBeforeGetSeminarRegHeader(Rec, SeminarRegHeader, IsHandled);
        if IsHandled then
            exit;

        TestField("Document No.");
        if "Document No." <> SeminarRegHeader."No." then
            SeminarRegHeader.Get("Document No.");

        OnAfterGetSeminarRegHeader(Rec, SeminarRegHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetSeminarRegHeader(var SeminarRegLine: Record "SEM Seminar Reg. Line"; var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var IsHanded: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetSeminarRegHeader(var SeminarRegLine: Record "SEM Seminar Reg. Line"; var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
    end;

    local procedure InitRecord()
    begin
        GetSeminarRegHeader;

        Init();
        If "Registration Date" = 0D then
            "Registration Date" := WorkDate();
        Validate("Seminar Price", SeminarRegHeader."Seminar Price");
        "External Document No." := SeminarRegHeader."External Document No.";
        "Shortcut Dimension 1 Code" := SeminarRegHeader."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := SeminarRegHeader."Shortcut Dimension 2 Code";
    end;

    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    procedure GetHideValidationDialog(): Boolean
    begin
        exit(HideValidationDialog);
    end;

    procedure UpdateAmounts()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateAmounts(Rec, xRec, CurrFieldNo, IsHandled);
        if IsHandled then
            exit;

        "Line Amount (LCY)" := "Seminar Price" - "Line Discount Amount (LCY)";

        OnAfterUpdateAmounts(Rec, xRec, CurrFieldNo);
    end;

    procedure UpdateLineDiscPct()
    var
        LineDiscountPct: Decimal;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateLineDiscPct(Rec, IsHandled);
        if IsHandled then
            exit;

        if "Seminar Price" <> 0 then begin
            LineDiscountPct := Round("Line Discount Amount (LCY)" / "Seminar Price" * 100,
            0.00001);
            if not (LineDiscountPct in [0 .. 100]) then
                Error(LineDiscountPctErr);
            "Line Discount %" := LineDiscountPct;
        end else
            "Line Discount %" := 0;

        OnAfterUpdateLineDiscPct(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateLineDiscPct(var SeminarRegLine: Record "SEM Seminar Reg. Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateLineDiscPct(var SeminarRegLine: Record "SEM Seminar Reg. Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateAmounts(var SeminarRegLine: Record "SEM Seminar Reg. Line"; xSeminarRegLine: Record "SEM Seminar Reg. Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateAmounts(var SeminarRegLine: Record "SEM Seminar Reg. Line"; var xSeminarRegLine: Record "SEM Seminar Reg. Line"; CurrentFieldNo: Integer)
    begin
    end;

    procedure ShowLineComments()
    var
        SeminarCommentLine: Record "SEM Seminar Comment Line";
        SeminarCommentSheet: Page "SEM Seminar Comment Sheet";
    begin
        TestField("Document No.");
        TestField("Line No.");
        SeminarCommentLine.SetRange("Document Type", SeminarCommentLine."Document Type"::"Seminar Registration");
        SeminarCommentLine.SetRange("No.", "Document No.");
        SeminarCommentLine.SetRange("Document Line No.", "Line No.");
        SeminarCommentSheet.SetTableView(SeminarCommentLine);
        SeminarCommentSheet.RunModal;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateLineAmount(var SeminarRegLine: Record "SEM Seminar Reg. Line"; xSeminarRegLine: Record "SEM Seminar Reg. Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;

}