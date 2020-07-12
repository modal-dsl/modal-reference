codeunit 123456732 "SEM Seminar Jnl.-Post Line"
{
    Permissions = TableData "SEM Seminar Ledger Entry" = imd,
                  TableData "SEM Seminar Register" = imd;
    TableNo = "SEM Seminar Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        NextEntryNo: Integer;
        SeminarJnlLine: Record "SEM Seminar Journal Line";
        SeminarJnlCheckLine: Codeunit "SEM Seminar Jnl.-Check Line";
        SeminarLedgEntry: Record "SEM Seminar Ledger Entry";
        SeminarReg: Record "SEM Seminar Register";
        Seminar: Record "SEM Seminar";

    procedure RunWithCheck(var SeminarJnlLine2: Record "SEM Seminar Journal Line")
    begin
        SeminarJnlLine.Copy(SeminarJnlLine2);
        Code;
        SeminarJnlLine2 := SeminarJnlLine;
    end;

    local procedure "Code"()
    var
        IsHandled: Boolean;
    begin
        OnBeforePostJnlLine(SeminarJnlLine);

        with SeminarJnlLine do begin
            if EmptyLine then
                exit;

            SeminarJnlCheckLine.RunCheck(SeminarJnlLine);

            if NextEntryNo = 0 then begin
                SeminarLedgEntry.LockTable();
                NextEntryNo := SeminarLedgEntry.GetLastEntryNo() + 1;
            end;

            if "Document Date" = 0D then
                "Document Date" := "Posting Date";

            if SeminarReg."No." = 0 then begin
                SeminarReg.LockTable;
                if (not SeminarReg.FindLast()) or (SeminarReg."To Entry No." <> 0) then begin
                    SeminarReg.Init();
                    SeminarReg."No." := SeminarReg."No." + 1;
                    SeminarReg."From Entry No." := NextEntryNo;
                    SeminarReg."To Entry No." := NextEntryNo;
                    SeminarReg."Creation Date" := Today;
                    SeminarReg."Creation Time" := Time;
                    SeminarReg."Source Code" := "Source Code";
                    SeminarReg."Journal Batch Name" := "Journal Batch Name";
                    SeminarReg."User ID" := UserId;
                    SeminarReg.Insert();
                end;
            end;
            SeminarReg."To Entry No." := NextEntryNo;
            SeminarReg.Modify();

            Seminar.Get("Seminar No.");

            IsHandled := false;
            OnBeforeCheckSeminarBlocked(Seminar, IsHandled);
            if not IsHandled then
                Seminar.TestField(Blocked, false);

            SeminarLedgEntry.Init();
            SeminarLedgEntry.CopyFromSeminarJnlLine(SeminarJnlLine);

            SeminarLedgEntry."User ID" := UserId;
            SeminarLedgEntry."Entry No." := NextEntryNo;

            OnBeforeLedgerEntryInsert(SeminarLedgEntry, SeminarJnlLine);

            SeminarLedgEntry.Insert(true);

            NextEntryNo := NextEntryNo + 1;
        end;

        OnAfterPostJnlLine(SeminarJnlLine);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostJnlLine(var SeminarJnlLine: Record "SEM Seminar Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckSeminarBlocked(Seminar: Record "SEM Seminar"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLedgerEntryInsert(var SeminarLedgerEntry: Record "SEM Seminar Ledger Entry"; SeminarJnlLine: Record "SEM Seminar Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostJnlLine(var SeminarJnlLine: Record "SEM Seminar Journal Line")
    begin
    end;

}
