codeunit 123456731 "SEM Seminar Jnl.-Check Line"
{
    TableNo = "SEM Seminar Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        CannotBeClosingDateErr: Label 'cannot be a closing date';

    procedure RunCheck(var SeminarJnlLine: Record "SEM Seminar Journal Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeRunCheck(SeminarJnlLine, IsHandled);
        if IsHandled then
            exit;

        with SeminarJnlLine do begin
            if EmptyLine then
                exit;

            TestField("Seminar No.");
            TestField("Posting Date");

            CheckPostingDate(SeminarJnlLine);

            if "Document Date" <> 0D then
                if "Document Date" <> NormalDate("Document Date") then
                    FieldError("Document Date", CannotBeClosingDateErr);
        end;

        OnAfterRunCheck(SeminarJnlLine);
    end;

    local procedure CheckPostingDate(SeminarJnlLine: Record "SEM Seminar Journal Line")
    var
        UserSetupManagement: Codeunit "User Setup Management";
        IsHandled: Boolean;
    begin
        with SeminarJnlLine do begin
            if "Posting Date" <> NormalDate("Posting Date") then
                FieldError("Posting Date", CannotBeClosingDateErr);

            IsHandled := false;
            OnCheckPostingDateOnBeforeCheckAllowedPostingDate("Posting Date", IsHandled);
            if IsHandled then
                exit;

            UserSetupManagement.CheckAllowedPostingDate("Posting Date");
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRunCheck(var SeminarJnlLine: Record "SEM Seminar Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRunCheck(var SeminarJnlLine: Record "SEM Seminar Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckPostingDateOnBeforeCheckAllowedPostingDate(PostingDate: Date; var IsHandled: Boolean);
    begin
    end;

}
