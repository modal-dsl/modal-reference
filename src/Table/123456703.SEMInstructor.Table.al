table 123456703 "SEM Instructor"
{

    Caption = 'Instructor';
    DataCaptionFields = Code, Name;
    LookupPageId = "SEM Instructors";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(4; "E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                MailManagement.ValidateEmailAddressField("E-Mail");
            end;
        }
        field(5; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(6; "Contact No."; Code[20])
        {
            TableRelation = Contact;
            Caption = 'Contact No.';
        }
        field(7; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource where(Type = const(Person));
        }
        field(8; "Internal/External"; Option)
        {
            Caption = 'Internal/External';
            OptionCaption = ' ,Internal,External';
            OptionMembers = " ","Internal","External";
        }
        field(9; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            begin
                ValidateSalesPersonCode();
            end;
        }
        field(10; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(34; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(35; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Name) { }
    }

    var
        DimMgt: Codeunit DimensionManagement;

    local procedure ValidateSalesPersonCode()
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
    begin
        if "Salesperson Code" <> '' then
            if SalespersonPurchaser.Get("Salesperson Code") then
                if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
                    Error(SalespersonPurchaser.GetPrivacyBlockedGenericText(SalespersonPurchaser, true));
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        OnBeforeValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);

        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        if not IsTemporary then begin
            DimMgt.SaveDefaultDim(Database::"SEM Instructor", Code, FieldNumber, ShortcutDimCode);
            Modify;
        end;

        OnAfterValidateShortcutDimCode(Rec, xRec, FieldNumber, ShortcutDimCode);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var Instructor: Record "SEM Instructor"; xInstructor: Record "SEM Instructor"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateShortcutDimCode(var Instructor: Record "SEM Instructor"; xInstructor: Record "SEM Instructor"; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;

}
