table 123456710 "SEM Seminar Reg. Header"
{
    Caption = 'Seminar Registration Header';
    DataCaptionFields = "No.", "Seminar Description";
    LookupPageId = "SEM Seminar Registration";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    GetSeminarSetup;
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Registration Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                TestStatusPlanning();
                TestNoPostedLines();

                if "Starting Date" < Today then
                    Message(PostingDateInPastMsg, FieldCaption("Starting Date"));
            end;
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "SEM Seminar";

            trigger OnValidate()
            begin
                if "No." = '' then
                    InitRecord;

                TestStatusPlanning();
                if ("Seminar No." <> xRec."Seminar No.") and (xRec."Seminar No." <> '') then begin
                    if GetHideValidationDialog or not GuiAllowed then
                        Confirmed := true
                    else
                        Confirmed := Confirm(ConfirmChangeQst, false, FieldCaption("Seminar No."));

                    if Confirmed then begin
                        SeminarRegLine.SetRange("Document No.", "No.");
                        if "Seminar No." = '' then begin
                            if not SeminarRegLine.IsEmpty then
                                Error(ExistingLinesErr, FieldCaption("Seminar No."));
                            Init();
                            OnValidateSeminarNoAfterInit(Rec, xRec);
                            GetSeminarSetup();
                            "No. Series" := xRec."No. Series";
                            InitRecord();
                            InitNoSeries();
                            exit;
                        end;

                        SeminarRegLine.Reset();
                    end else begin
                        Rec := xRec;
                        exit;
                    end;
                end;

                GetSeminar("Seminar No.");
                Seminar.TestBlocked();
                OnAfterCheckSeminarNo(Rec, xRec, Seminar);

                "Seminar Description" := Seminar.Description;
                "Shortcut Dimension 1 Code" := Seminar."Global Dimension 1 Code";
                "Shortcut Dimension 2 Code" := Seminar."Global Dimension 2 Code";
                "Duration Days" := Seminar."Duration Days";
                "Minimum Participants" := Seminar."Minimum Participants";
                "Maximum Participants" := Seminar."Maximum Participants";
                "Language Code" := Seminar."Language Code";
                VALIDATE("Seminar Price", Seminar."Seminar Price");
            end;
        }
        field(4; "Seminar Description"; Text[50])
        {
            Caption = 'Seminar Description';
        }
        field(5; "Instructor Code"; Code[10])
        {
            Caption = 'Instructor Code';
            TableRelation = "SEM Instructor";

            trigger OnValidate()
            begin
                if "Instructor Code" <> xRec."Instructor Code" then begin
                    TestNoPostedLines();
                    CalcFields("Instructor Name");
                end;
            end;
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

            trigger OnValidate()
            begin
                if ("Minimum Participants" <> 0) and ("Minimum Participants" > "Maximum Participants") then
                    FieldError("Minimum Participants", StrSubstNo(NotGreaterErr, FieldCaption("Maximum Participants")));
            end;
        }
        field(11; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            MinValue = 0;

            trigger OnValidate()
            begin
                if ("Maximum Participants" <> 0) and ("Maximum Participants" < "Minimum Participants") then
                    FieldError("Maximum Participants", StrSubstNo(NotLessErr, FieldCaption("Minimum Participants")));
            end;
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

            trigger OnValidate()
            begin
                ValidateSalesPersonCode();
            end;
        }
        field(14; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            MinValue = 0;
            AutoFormatType = 1;

            trigger OnValidate()
            begin
                TestStatusPlanning();

                SeminarRegLine.SetRange("Document No.", "No.");
                SeminarRegLine.SetRange(Registered, false);
                SeminarRegLine.SetFilter("Seminar Price", '<>%1', "Seminar Price");
                If not SeminarRegLine.IsEmpty then
                    IF Confirm(UpdateLinesQst) then begin
                        If SeminarRegLine.FindSet(true) then
                            repeat
                                SeminarRegLine.Validate("Seminar Price", "Seminar Price");
                                SeminarRegLine.Modify();
                            until SeminarRegLine.Next() = 0;
                        Modify();
                    end;
            end;
        }
        field(15; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        field(20; "Room Code"; Code[10])
        {
            Caption = 'Room Code';
            TableRelation = "SEM Seminar Room";

            trigger OnValidate()
            begin
                TestStatusPlanning();
                if ("Room Code" <> xRec."Room Code") and (xRec."Room Code" <> '') then begin
                    if GetHideValidationDialog or not GuiAllowed then
                        Confirmed := true
                    else
                        Confirmed := Confirm(ConfirmChangeQst, false, FieldCaption("Room Code"));

                    if Confirmed then begin
                        TestNoPostedLines();
                        if "Room Code" = '' then
                            exit;
                    end else begin
                        Rec := xRec;
                        exit;
                    end;
                end;

                If "Room Code" = '' then
                    SeminarRoom.Init()
                else begin
                    GetRoom("Room Code");
                    SeminarRoom.TestBlocked;
                end;

                "Room Name" := SeminarRoom.Name;
                "Room Name 2" := SeminarRoom."Name 2";
                "Room Address" := SeminarRoom.Address;
                "Room Address 2" := SeminarRoom."Address 2";
                "Room City" := SeminarRoom.City;
                "Room Contact Person" := SeminarRoom."Contact Person";
                "Room Country/Region Code" := SeminarRoom."Country/Region Code";
                "Room Post Code" := SeminarRoom."Post Code";
                "Room County" := SeminarRoom.County;
            end;
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

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("Room City", "Room Post Code", "Room County", "Room Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity("Room City", "Room Post Code", "Room County", "Room Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(26; "Room Contact Person"; Text[50])
        {
            Caption = 'Room Contact Person';
        }
        field(27; "Room Country/Region Code"; Code[10])
        {
            Caption = 'Room Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                PostCode.CheckClearPostCodeCityCounty("Room City", "Room Post Code", "Room County", "Room Country/Region Code", xRec."Room Country/Region Code");
            end;
        }
        field(28; "Room Post Code"; Code[20])
        {
            Caption = 'Post Code';

            TableRelation = if ("Room Country/Region Code" = const('')) "Post Code"
            else
            if ("Room Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Room Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                OnBeforeLookupPostCode(Rec, PostCode);

                PostCode.LookupPostCode("Room City", "Room Post Code", "Room County", "Room Country/Region Code");
            end;

            trigger OnValidate()
            begin
                OnBeforeValidatePostCode(Rec, PostCode);

                PostCode.ValidatePostCode("Room City", "Room Post Code", "Room County", "Room Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
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

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                TestField("Posting Date");
                TestNoSeriesDate("Posting No.", "Posting No. Series",
                    FieldCaption("Posting No."), FieldCaption("Posting No. Series"));

                IsHandled := false;
                OnValidatePostingDateOnBeforeAssignDocumentDate(Rec, IsHandled);
                if not IsHandled then
                    Validate("Document Date", "Posting Date");

            end;
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

            trigger OnLookup()
            begin
                with SeminarRegHeader do begin
                    SeminarRegHeader := Rec;
                    GetSeminarSetup();
                    TestNoSeries;
                    if NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode, "Posting No. Series") then
                        Validate("Posting No. Series");
                    Rec := SeminarRegHeader;
                end;
            end;

            trigger OnValidate()
            begin
                if "Posting No. Series" <> '' then begin
                    GetSeminarSetup();
                    TestNoSeries;
                    NoSeriesMgt.TestSeries(GetPostingNoSeriesCode, "Posting No. Series");
                end;
                TestField("Posting No.", '');
            end;
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

            trigger OnLookup()
            begin
                ShowDocDim;
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Seminar No.") { }
    }

    var
        SeminarSetup: Record "SEM Seminar Setup";
        SeminarSetupRead: Boolean;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SeminarRegHeader: Record "SEM Seminar Reg. Header";
        SeminarRegLine: Record "SEM Seminar Reg. Line";
        Seminar: Record "SEM Seminar";
        SeminarRoom: Record "SEM Seminar Room";
        SeminarCommentLine: Record "SEM Seminar Comment Line";
        NotGreaterErr: Label 'must not be greater than %1';
        NotLessErr: Label 'must not be less than %1';
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        DimMgt: Codeunit DimensionManagement;
        PostingDescrTxt: Label 'Seminar Reg.';
        Confirmed: Boolean;
        ConfirmChangeQst: Label 'Do you want to change %1?';
        UpdateLinesQst: Label 'Would you like to update the lines?';
        SelectNoSeriesAllowed: Boolean;
        AlreadyExistsErr: Label 'The %1 %2 already exists.';
        HideValidationDialog: Boolean;
        StatusCheckSuspended: Boolean;
        PostCode: Record "Post Code";
        PostingDateInPastMsg: Label 'The %1 is in the past.';
        ExistingLinesErr: Label 'You cannot reset %1 because the document still has one or more lines.';
        ExistingUnpostedLinesErr: Label 'The %1 cannot be deleted because of at least one unposted Line.';
        RenameNotAllowedErr: Label 'You cannot rename a %1.';
        StatusCanceledOrClosedErr: Label 'must be ''Canceled'' or ''Closed''';
        NoSeriesDateOrderErr: Label 'You can not change the %1 field because %2 %3 has %4 = %5 and the document has already been assigned %6 %7.';
        ExistingPostedLinesErr: Label 'This action is not allowed because of existing posted lines.';
        UpdateLinesDimQst: Label 'You may have changed a dimension.\\Do you want to update the lines?';

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            GetSeminarSetup;
            SeminarSetup.TESTFIELD("Seminar Registration Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Registration Nos.", xRec."No. Series", "Posting Date", "No.", "No. Series");
        END;

        InitRecord;

        if GetFilterSeminarNo <> '' then
            Validate("Seminar No.", GetFilterSeminarNo);

        if GetFilterInstructorCode <> '' then
            Validate("Instructor Code", GetFilterInstructorCode);

        if GetFilterRoomCode <> '' then
            Validate("Room Code", GetFilterRoomCode);
    end;

    trigger OnRename()
    begin
        Error(RenameNotAllowedErr, TableCaption);
    end;

    trigger OnDelete()
    begin
        SeminarCommentLine.SetRange("Document Type", SeminarCommentLine."Document Type"::"Seminar Registration");
        SeminarCommentLine.SetRange("No.", "No.");
        SeminarCommentLine.DeleteAll();

        if not (Status in [Status::Canceled, Status::Closed]) then
            FieldError(Status, StatusCanceledOrClosedErr);

        SeminarRegLine.SetRange("Document No.", "No.");
        SeminarRegLine.SetRange(Registered, false);
        if not SeminarRegLine.IsEmpty then begin
            SeminarRegLine.SetRange(Registered, true);
            if not SeminarRegLine.IsEmpty then
                Error(ExistingUnpostedLinesErr, TableCaption);
        end;

        SeminarRegLine.SetRange(Registered);
        SeminarRegLine.DeleteAll();
    end;

    local procedure GetFilterSeminarNo(): Code[20]
    begin
        if GetFilter("Seminar No.") <> '' then
            if GetRangeMin("Seminar No.") = GetRangeMax("Seminar No.") then
                exit(GetRangeMax("Seminar No."));
    end;

    local procedure GetFilterInstructorCode(): Code[20]
    begin
        if GetFilter("Instructor Code") <> '' then
            if GetRangeMin("Instructor Code") = GetRangeMax("Instructor Code") then
                exit(GetRangeMax("Instructor Code"));
    end;

    local procedure GetFilterRoomCode(): Code[20]
    begin
        if GetFilter("Room Code") <> '' then
            if GetRangeMin("Room Code") = GetRangeMax("Room Code") then
                exit(GetRangeMax("Room Code"));
    end;

    procedure InitRecord()
    var
        IsHandled: Boolean;
    begin
        GetSeminarSetup;

        IsHandled := false;
        OnBeforeInitRecord(Rec, IsHandled, xRec);
        if not IsHandled then
            NoSeriesMgt.SetDefaultSeries("Posting No. Series", SeminarSetup."Posted Seminar Reg. Nos.");

        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();

        "Document Date" := WorkDate();
        "Posting Description" := PostingDescrTxt + ' ' + "No.";

        OnAfterInitRecord(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitRecord(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var IsHandled: Boolean; xSeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitRecord(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
    end;

    local procedure InitNoSeries()
    begin
        if xRec."Posting No." <> '' then begin
            "Posting No. Series" := xRec."Posting No. Series";
            "Posting No." := xRec."Posting No.";
        end;

        OnAfterInitNoSeries(Rec, xRec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitNoSeries(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; xSeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
    end;

    procedure AssistEdit(OldSeminarRegHeader: Record "SEM Seminar Reg. Header"): Boolean
    var
        SeminarRegHeader2: Record "SEM Seminar Reg. Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeAssistEdit(Rec, OldSeminarRegHeader, IsHandled);
        if IsHandled then
            exit;

        with SeminarRegHeader do begin
            Copy(Rec);
            GetSeminarSetup;
            TestNoSeries;
            if NoSeriesMgt.SelectSeries(GetNoSeriesCode(), OldSeminarRegHeader."No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries("No.");
                if SeminarRegHeader2.Get("No.") then
                    Error(AlreadyExistsErr, TableCaption, "No.");
                Rec := SeminarRegHeader;
                exit(true);
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAssistEdit(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; OldSeminarRegHeader: Record "SEM Seminar Reg. Header"; var IsHandled: Boolean)
    begin
    end;

    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    procedure GetHideValidationDialog(): Boolean
    begin
        exit(HideValidationDialog);
    end;

    procedure GetNoSeriesCode(): Code[20]
    var
        NoSeriesCode: Code[20];
        IsHandled: Boolean;
    begin
        GetSeminarSetup();

        IsHandled := false;
        OnBeforeGetNoSeriesCode(Rec, SeminarSetup, NoSeriesCode, IsHandled);
        if IsHandled then
            exit;

        NoSeriesCode := SeminarSetup."Seminar Registration Nos.";

        OnAfterGetNoSeriesCode(Rec, SeminarSetup, NoSeriesCode);
        exit(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode, SelectNoSeriesAllowed, "No. Series"));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetNoSeriesCode(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; SeminarSetup: Record "SEM Seminar Setup"; var NoSeriesCode: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetNoSeriesCode(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; SeminarSetup: Record "SEM Seminar Setup"; var NoSeriesCode: Code[20])
    begin
    end;

    procedure SetAllowSelectNoSeries()
    begin
        SelectNoSeriesAllowed := true;
    end;

    procedure TestNoSeries()
    var
        IsHandled: Boolean;
    begin
        GetSeminarSetup();

        IsHandled := false;
        OnBeforeTestNoSeries(Rec, IsHandled);
        if IsHandled then
            exit;

        SeminarSetup.TestField("Seminar Registration Nos.");

        OnAfterTestNoSeries(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTestNoSeries(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
    end;

    local procedure TestNoSeriesDate(No: Code[20]; NoSeriesCode: Code[20]; NoCapt: Text[1024]; NoSeriesCapt: Text[1024])
    var
        NoSeries: Record "No. Series";
    begin
        if (No <> '') and (NoSeriesCode <> '') then begin
            NoSeries.Get(NoSeriesCode);
            if NoSeries."Date Order" then
                Error(
                  NoSeriesDateOrderErr,
                  FieldCaption("Posting Date"), NoSeriesCapt, NoSeriesCode,
                  NoSeries.FieldCaption("Date Order"), NoSeries."Date Order",
                  NoCapt, No);
        end;
    end;

    local procedure ValidateSalesPersonCode()
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
    begin
        if "Salesperson Code" <> '' then
            if SalespersonPurchaser.GET("Salesperson Code") then
                if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
                    Error(SalespersonPurchaser.GetPrivacyBlockedGenericText(SalespersonPurchaser, true));
    end;

    local procedure TestNoPostedLines()
    var
        SeminarRegistrationLine: Record "SEM Seminar Reg. Line";
    begin
        SeminarRegistrationLine.SetRange("Document No.", "No.");
        SeminarRegistrationLine.SetRange(Registered, true);
        if not (SeminarRegistrationLine.IsEmpty) then
            Error(ExistingPostedLinesErr);
    end;

    procedure TestStatusPlanning()
    begin
        OnBeforeTestStatusPlanning(Rec);

        if StatusCheckSuspended then
            exit;

        TestField(Status, Status::Planning);

        OnAfterTestStatusPlanning(Rec);
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnBeforeTestStatusPlanning(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterTestStatusPlanning(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
    end;

    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;

    local procedure GetSeminar(SeminarNo: Code[20])
    begin
        if not (SeminarNo = '') then begin
            if SeminarNo <> Seminar."No." then
                seminar.Get(SeminarNo);
        end else
            Clear(Seminar);
    end;

    local procedure GetRoom(SeminarRoomCode: Code[10])
    begin
        if not (SeminarRoomCode = '') then begin
            if SeminarRoomCode <> SeminarRoom.Code then
                SeminarRoom.Get(SeminarRoomCode);
        end else
            Clear(SeminarRoom);
    end;

    local procedure GetSeminarSetup()
    begin
        if not SeminarSetupRead then
            SeminarSetup.Get();

        SeminarSetupRead := true;
        OnAfterGetSeminarSetup(Rec, SeminarSetup, CurrFieldNo);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetSeminarSetup(SeminarRegHeader: Record "SEM Seminar Reg. Header"; var SeminarSetup: Record "SEM Seminar Setup"; CalledByFieldNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidateSeminarNoAfterInit(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; xSeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckSeminarNo(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; xSeminarRegHeader: Record "SEM Seminar Reg. Header"; Seminar: Record "SEM Seminar")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupPostCode(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var PostCodeRec: Record "Post Code")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidatePostCode(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var PostCodeRec: Record "Post Code")
    begin
    end;

    procedure SeiminarRegLineExist(): Boolean
    begin
        SeminarRegLine.Reset();
        SeminarRegLine.SetRange("Document No.", "No.");
        exit(not SeminarRegLine.IsEmpty);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OnBeforeValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if SeiminarRegLineExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;

        OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateShortcutDimCode(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; xSeminarRegHeader: Record "SEM Seminar Reg. Header"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; xSeminarRegHeader: Record "SEM Seminar Reg. Header"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateAllLineDim(Rec, NewParentDimSetID, OldParentDimSetID, IsHandled);
        if IsHandled then
            exit;

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not GetHideValidationDialog and GuiAllowed then
            if not Confirm(UpdateLinesDimQst) then
                exit;

        SeminarRegLine.Reset();
        SeminarRegLine.SetRange("Document No.", "No.");
        SeminarRegLine.LockTable();
        if SeminarRegLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(SeminarRegLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if SeminarRegLine."Dimension Set ID" <> NewDimSetID then begin
                    SeminarRegLine."Dimension Set ID" := NewDimSetID;

                    DimMgt.UpdateGlobalDimFromDimSetID(
                      SeminarRegLine."Dimension Set ID", SeminarRegLine."Shortcut Dimension 1 Code", SeminarRegLine."Shortcut Dimension 2 Code");

                    OnUpdateAllLineDimOnBeforeSeminarRegLineModify(SeminarRegLine);
                    SeminarRegLine.Modify();
                end;
            until SeminarRegLine.Next = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateAllLineDim(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; NewParentDimSetID: Integer; OldParentDimSetID: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateAllLineDimOnBeforeSeminarRegLineModify(var SeminarRegLine: Record "SEM Seminar Reg. Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnValidatePostingDateOnBeforeAssignDocumentDate(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var IsHandled: Boolean)
    begin
    end;

    local procedure GetPostingNoSeriesCode() PostingNos: Code[20]
    var
        IsHandled: Boolean;
    begin
        GetSeminarSetup();
        IsHandled := false;
        OnBeforeGetPostingNoSeriesCode(Rec, SeminarSetup, PostingNos, IsHandled);
        if IsHandled then
            exit;

        PostingNos := SeminarSetup."Posted Seminar Reg. Nos.";

        OnAfterGetPostingNoSeriesCode(Rec, PostingNos);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetPostingNoSeriesCode(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; SeminarSetup: Record "SEM Seminar Setup"; var NoSeriesCode: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetPostingNoSeriesCode(SeminarRegHeader: Record "SEM Seminar Reg. Header"; var PostingNos: Code[20])
    begin
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", "No.",
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if SeiminarRegLineExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

}
