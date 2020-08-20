codeunit 123456741 "SEM Seminar Mgt."
{

    SingleInstance = true;

    var
        LastResEntryNo: Integer;

    procedure SetLastResEntryNo(EntryNo: Integer)
    begin
        LastResEntryNo := EntryNo;
    end;

    procedure GetLastResEntryNo(): Integer
    begin
        exit(LastResEntryNo);
    end;

}