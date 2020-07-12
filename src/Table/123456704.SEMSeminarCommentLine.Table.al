table 123456704 "SEM Seminar Comment Line"
{
    Caption = 'Seminar Comment Line';
    DrillDownPageID = "SEM Seminar Comment List";
    LookupPageID = "SEM Seminar Comment List";

    fields
    {
        field(1; "Document Type"; Enum "SEM Seminar Comment Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(7; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure SetUpNewLine()
    var
        SeminarCommentLine: Record "SEM Seminar Comment Line";
    begin
        SeminarCommentLine.SetRange("Document Type", "Document Type");
        SeminarCommentLine.SetRange("No.", "No.");
        SeminarCommentLine.SetRange("Document Line No.", "Document Line No.");
        SeminarCommentLine.SetRange(Date, WorkDate);
        if not SeminarCommentLine.FindFirst then
            Date := WorkDate;

        OnAfterSetUpNewLine(Rec, SeminarCommentLine);
    end;

    procedure CopyComments(FromDocumentType: Enum "SEM Seminar Comment Document Type"; ToDocumentType: Enum "SEM Seminar Comment Document Type"; FromNumber: Code[20]; ToNumber: Code[20])
    var
        SeminarCommentLine: Record "SEM Seminar Comment Line";
        SeminarCommentLine2: Record "SEM Seminar Comment Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCopyComments(SeminarCommentLine, ToDocumentType, IsHandled, FromDocumentType, FromNumber, ToNumber);
        if IsHandled then
            exit;

        SeminarCommentLine.SetRange("Document Type", FromDocumentType);
        SeminarCommentLine.SetRange("No.", FromNumber);
        if SeminarCommentLine.FindSet() then
            repeat
                SeminarCommentLine2 := SeminarCommentLine;
                SeminarCommentLine2."Document Type" := ToDocumentType;
                SeminarCommentLine2."No." := ToNumber;
                SeminarCommentLine2.Insert();
            until SeminarCommentLine.Next() = 0;
    end;

    procedure CopyLineComments(FromDocumentType: Enum "SEM Seminar Comment Document Type"; ToDocumentType: Enum "SEM Seminar Comment Document Type"; FromNumber: Code[20]; ToNumber: Code[20]; FromDocumentLineNo: Integer; ToDocumentLineNo: Integer)
    var
        SeminarCommentLineSource: Record "SEM Seminar Comment Line";
        SeminarCommentLineTarget: Record "SEM Seminar Comment Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCopyLineComments(
          SeminarCommentLineTarget, IsHandled, FromDocumentType, ToDocumentType, FromNumber, ToNumber, FromDocumentLineNo, ToDocumentLineNo);
        if IsHandled then
            exit;

        SeminarCommentLineSource.SetRange("Document Type", FromDocumentType);
        SeminarCommentLineSource.SetRange("No.", FromNumber);
        SeminarCommentLineSource.SetRange("Document Line No.", FromDocumentLineNo);
        if SeminarCommentLineSource.FindSet() then
            repeat
                SeminarCommentLineTarget := SeminarCommentLineSource;
                SeminarCommentLineTarget."Document Type" := ToDocumentType;
                SeminarCommentLineTarget."No." := ToNumber;
                SeminarCommentLineTarget."Document Line No." := ToDocumentLineNo;
                SeminarCommentLineTarget.Insert();
            until SeminarCommentLineSource.Next() = 0;
    end;

    procedure CopyHeaderComments(FromDocumentType: Enum "SEM Seminar Comment Document Type"; ToDocumentType: Enum "SEM Seminar Comment Document Type"; FromNumber: Code[20]; ToNumber: Code[20])
    var
        SeminarCommentLineSource: Record "SEM Seminar Comment Line";
        SeminarCommentLineTarget: Record "SEM Seminar Comment Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCopyHeaderComments(SeminarCommentLineTarget, IsHandled, FromDocumentType, ToDocumentType, FromNumber, ToNumber);
        if IsHandled then
            exit;

        SeminarCommentLineSource.SetRange("Document Type", FromDocumentType);
        SeminarCommentLineSource.SetRange("No.", FromNumber);
        SeminarCommentLineSource.SetRange("Document Line No.", 0);
        if SeminarCommentLineSource.FindSet() then
            repeat
                SeminarCommentLineTarget := SeminarCommentLineSource;
                SeminarCommentLineTarget."Document Type" := ToDocumentType;
                SeminarCommentLineTarget."No." := ToNumber;
                SeminarCommentLineTarget.Insert();
            until SeminarCommentLineSource.Next() = 0;
    end;

    procedure DeleteComments(DocType: Enum "SEM Seminar Comment Document Type"; DocNo: Code[20])
    begin
        SetRange("Document Type", DocType);
        SetRange("No.", DocNo);
        if not IsEmpty then
            DeleteAll();
    end;

    procedure ShowComments(DocType: Enum "SEM Seminar Comment Document Type"; DocNo: Code[20]; DocLineNo: Integer)
    var
        SeminarCommentCommentSheet: Page "SEM Seminar Comment Sheet";
    begin
        SetRange("Document Type", DocType);
        SetRange("No.", DocNo);
        SetRange("Document Line No.", DocLineNo);
        Clear(SeminarCommentCommentSheet);
        SeminarCommentCommentSheet.SetTableView(Rec);
        SeminarCommentCommentSheet.RunModal;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetUpNewLine(var SeminarCommentLineRec: Record "SEM Seminar Comment Line"; var SeminarCommentLineFilter: Record "SEM Seminar Comment Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyComments(var SeminarCommentLine: Record "SEM Seminar Comment Line"; ToDocumentType: Enum "SEM Seminar Comment Document Type"; var IsHandled: Boolean; FromDocumentType: Enum "SEM Seminar Comment Document Type"; FromNumber: Code[20]; ToNumber: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyLineComments(var SeminarCommentLine: Record "SEM Seminar Comment Line"; var IsHandled: Boolean; FromDocumentType: Enum "SEM Seminar Comment Document Type"; ToDocumentType: Enum "SEM Seminar Comment Document Type"; FromNumber: Code[20]; ToNumber: Code[20]; FromDocumentLineNo: Integer; ToDocumentLine: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyHeaderComments(var SeminarCommentLine: Record "SEM Seminar Comment Line"; var IsHandled: Boolean; FromDocumentType: Enum "SEM Seminar Comment Document Type"; ToDocumentType: Enum "SEM Seminar Comment Document Type"; FromNumber: Code[20]; ToNumber: Code[20])
    begin
    end;
}

