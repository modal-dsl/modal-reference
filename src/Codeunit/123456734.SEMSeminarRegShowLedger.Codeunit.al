codeunit 123456734 "SEM Seminar Reg.-Show Ledger"
{
    TableNo = "SEM Seminar Register";

    trigger OnRun()
    begin
        SLEntry.SetRange("Entry No.", "From Entry No.", "To Entry No.");
        PAGE.Run(PAGE::"SEM Seminar Ledger Entries", SLEntry);
    end;

    var
        SLEntry: Record "SEM Seminar Ledger Entry";
}
