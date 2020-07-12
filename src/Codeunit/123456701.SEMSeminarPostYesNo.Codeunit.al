codeunit 123456701 "SEM Seminar-Post (Yes/No)"
{
    TableNo = "SEM Seminar Reg. Header";

    trigger OnRun()
    var
        SeminarRegHeader: Record "SEM Seminar Reg. Header";
    begin
        if not Find then
            Error(NothingToPostErr);

        SeminarRegHeader.Copy(Rec);
        Code(SeminarRegHeader);
        Rec := SeminarRegHeader;
    end;

    var
        PostConfirmQst: Label 'Do you want to post the %1?';
        NothingToPostErr: Label 'There is nothing to post.';

    local procedure "Code"(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    var
        HideDialog: Boolean;
        IsHandled: Boolean;
    begin
        HideDialog := false;
        IsHandled := false;
        OnBeforeConfirmPost(SeminarRegHeader, HideDialog, IsHandled);
        if IsHandled then
            exit;

        if not HideDialog then
            if not Confirm(PostConfirmQst, false, SeminarRegHeader.TableCaption) then
                exit;

        CODEUNIT.Run(CODEUNIT::"SEM Seminar-Post", SeminarRegHeader);

        OnAfterPost(SeminarRegHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeConfirmPost(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var HideDialog: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPost(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
    end;

}
