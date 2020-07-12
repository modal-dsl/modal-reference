codeunit 123456740 "SEM Seminar Event Subscribers"
{
    var
        LastResEntryNo: Integer;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Res. Jnl.-Post Line", 'OnBeforeResLedgEntryInsert', '', true, false)]
    local procedure ResJnlPostLineOnBeforeResLedgEntryInsert(var ResLedgerEntry: Record "Res. Ledger Entry"; ResJournalLine: Record "Res. Journal Line")
    begin
        LastResEntryNo := ResLedgerEntry."Entry No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEM Seminar-Post", 'OnPostHeader', '', true, false)]
    local procedure SeminarPostOnPostHeader(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; TempSeminarRegLineGlobal: Record "SEM Seminar Reg. Line" temporary; SrcCode: Code[10]; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
        // Instructor
        PostResJnlLine(0, SeminarRegHeader, PostedSeminarRegHeader, SrcCode);
        PostSeminarJnlLine(0, SeminarRegHeader, PostedSeminarRegHeader, TempSeminarRegLineGlobal, SrcCode);

        // Room
        PostResJnlLine(1, SeminarRegHeader, PostedSeminarRegHeader, SrcCode);
        PostSeminarJnlLine(1, SeminarRegHeader, PostedSeminarRegHeader, TempSeminarRegLineGlobal, SrcCode);
    end;

    local procedure PostResJnlLine(ChargeType: Option Instructor,Room; SeminarRegHeader: Record "SEM Seminar Reg. Header"; PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; SrcCode: Code[10])
    var
        Instr: Record "SEM Instructor";
        InstrRes: Record Resource;
        SemRoom: Record "SEM Seminar Room";
        RoomRes: Record Resource;
        ResJnlLine: Record "Res. Journal Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
    begin
        with SeminarRegHeader do begin
            ResJnlLine.Init;
            ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
            ResJnlLine."Document No." := PostedSeminarRegHeader."No.";
            ResJnlLine."Posting Date" := "Posting Date";
            ResJnlLine.Description := "Seminar Description";
            ResJnlLine."Source Code" := SrcCode;
            ResJnlLine."Reason Code" := "Reason Code";
            ResJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            ResJnlLine."Document Date" := "Document Date";
            ResJnlLine."Posting No. Series" := "Posting No. Series";
            case ChargeType of
                ChargeType::Instructor:
                    begin
                        if Instr.Code <> "Instructor Code" then
                            Instr.Get("Instructor Code");
                        if InstrRes."No." <> Instr."Resource No." then
                            InstrRes.Get(Instr."Resource No.");
                        ResJnlLine."Resource No." := Instr."Resource No.";
                        ResJnlLine."Unit of Measure Code" := InstrRes."Base Unit of Measure";
                        ResJnlLine.Quantity := "Duration Days";
                        ResJnlLine."Qty. per Unit of Measure" := 1;
                        ResJnlLine."Unit Cost" := InstrRes."Unit Cost";
                    end;
                ChargeType::Room:
                    begin
                        if SemRoom.Code <> "Room Code" then
                            SemRoom.Get("Room Code");
                        if RoomRes."No." <> SemRoom."Resource No." then
                            RoomRes.Get(SemRoom."Resource No.");
                        ResJnlLine."Resource No." := SemRoom."Resource No.";
                        ResJnlLine."Unit of Measure Code" := RoomRes."Base Unit of Measure";
                        ResJnlLine.Quantity := "Duration Days";
                        ResJnlLine."Qty. per Unit of Measure" := 1;
                        ResJnlLine."Unit Cost" := RoomRes."Unit Cost";
                    end;
            end;
            ResJnlPostLine.RunWithCheck(ResJnlLine);
        end;
    end;

    local procedure PostSeminarJnlLine(ChargeType: Option Instructor,Room,Participant; SeminarRegHeader: Record "SEM Seminar Reg. Header"; PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; TempSeminarRegLine: Record "SEM Seminar Reg. Line" temporary; SrcCode: Code[10])
    var
        Instr: Record "SEM Instructor";
        SemRoom: Record "SEM Seminar Room";
        SeminarJnlLine: Record "SEM Seminar Journal Line";
        SeminarJnlPostLine: Codeunit "SEM Seminar Jnl.-Post Line";
    begin
        with SeminarRegHeader do begin
            SeminarJnlLine.Init;
            SeminarJnlLine."Seminar No." := "Seminar No.";
            SeminarJnlLine."Posting Date" := "Posting Date";
            SeminarJnlLine."Document Date" := "Document Date";
            SeminarJnlLine."Entry Type" := SeminarJnlLine."Entry Type"::Registration;
            SeminarJnlLine."Document No." := PostedSeminarRegHeader."No.";
            SeminarJnlLine."Starting Date" := "Starting Date";
            SeminarJnlLine."Seminar Registration No." := "No.";
            SeminarJnlLine."Res. Ledger Entry No." := LastResEntryNo;
            LastResEntryNo := 0;
            SeminarJnlLine."Source Type" := SeminarJnlLine."Source Type"::Seminar;
            SeminarJnlLine."Source No." := "Seminar No.";
            SeminarJnlLine."Source Code" := SrcCode;
            SeminarJnlLine."Reason Code" := "Reason Code";
            SeminarJnlLine."Posting No. Series" := "Posting No. Series";
            SeminarJnlLine."Charge Type" := ChargeType;
            case ChargeType of
                ChargeType::Instructor:
                    begin
                        SeminarJnlLine.Chargeable := false;
                        Instr.Get("Instructor Code");
                        SeminarJnlLine."Instructor Code" := "Instructor Code";
                        SeminarJnlLine.Description := Instr.Name;
                        SeminarJnlLine.Quantity := "Duration Days";
                    end;
                ChargeType::Room:
                    begin
                        SeminarJnlLine.Chargeable := false;
                        SemRoom.Get("Room Code");
                        SeminarJnlLine."Seminar Room Code" := "Room Code";
                        SeminarJnlLine.Description := SemRoom.Name;
                        SeminarJnlLine.Quantity := "Duration Days";
                    end;
                ChargeType::Participant:
                    begin
                        TempSeminarRegLine.CalcFields("Participant Name");
                        SeminarJnlLine.Description := TempSeminarRegLine."Participant Name";
                        SeminarJnlLine."Participant Contact No." := TempSeminarRegLine."Participant Contact No.";
                        SeminarJnlLine."Participant Name" := TempSeminarRegLine."Participant Name";
                        SeminarJnlLine."Bill-to Customer No." := TempSeminarRegLine."Bill-to Customer No.";
                        SeminarJnlLine.Quantity := 1;
                        SeminarJnlLine."Unit Price" := TempSeminarRegLine."Line Amount (LCY)";
                        SeminarJnlLine."Total Price" := TempSeminarRegLine."Line Amount (LCY)";
                        SeminarJnlLine.Chargeable := TempSeminarRegLine."To Invoice";
                    end;
            end;

            SeminarJnlPostLine.RunWithCheck(SeminarJnlLine);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEM Seminar-Post", 'OnCheckNothingToPost', '', true, false)]
    local procedure SeminarPostOnCheckNothingToPost(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var TempSeminarRegLineGlobal: Record "SEM Seminar Reg. Line" temporary)
    var
        NothingToPostErr: Label 'There is nothing to post.';
    begin
        TempSeminarRegLineGlobal.SetRange("To Invoice", true);
        if TempSeminarRegLineGlobal.IsEmpty() then
            Error(NothingToPostErr);

        TempSeminarRegLineGlobal.SetRange("To Invoice");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEM Seminar-Post", 'OnCheckPostRestrictions', '', true, false)]
    local procedure SeminarPostOnCheckPostRestrictions(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    var
        Instr: Record "SEM Instructor";
        SemRoom: Record "SEM Seminar Room";
    begin
        // Instructor
        Instr.Get(SeminarRegHeader."Instructor Code");
        Instr.TestField(Blocked, false);
        Instr.TestField("Resource No.");

        // Room
        SemRoom.Get(SeminarRegHeader."Room Code");
        SemRoom.TestField(Blocked, false);
        SemRoom.TestField("Resource No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEM Seminar-Post", 'OnAfterCheckMandatoryFields', '', true, false)]
    local procedure SeminarPostOnAfterCheckMandatoryFields(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; CommitIsSuppressed: Boolean)
    begin
        with SeminarRegHeader do begin
            TestField(Status, SeminarRegHeader.Status::Closed);
            TestField("Instructor Code");
            TestField("Room Code");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEM Seminar-Post", 'OnTestLine', '', true, false)]
    local procedure SeminarPostOnTestLine(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var SeminarRegLine: Record "SEM Seminar Reg. Line"; CommitIsSuppressed: Boolean)
    begin
        with SeminarRegLine do begin
            TestField("Participant Contact No.");
            TestField("Registration Date");

            if "To Invoice" then begin
                TestField("Seminar Price");
                TestField("Line Amount (LCY)");
                TestField("Gen. Bus. Posting Group");
                TestField("Bill-to Customer No.");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEM Seminar-Post", 'OnUpdateLineBeforePost', '', true, false)]
    local procedure SeminarPostOnUpdateLineBeforePost(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var SeminarRegLine: Record "SEM Seminar Reg. Line"; CommitIsSuppressed: Boolean)
    begin
        if not SeminarRegLine."To Invoice" then begin
            SeminarRegLine."Seminar Price" := 0;
            SeminarRegLine."Line Amount (LCY)" := 0;
            SeminarRegLine."Line Discount %" := 0;
            SeminarRegLine."Line Discount Amount (LCY)" := 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEM Seminar-Post", 'OnBeforePostedLineInsert', '', true, false)]
    local procedure SeminarPostOnBeforePostedLineInsert(var PostedSeminarRegLine: Record "SEM Posted Seminar Reg. Line"; PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; var TempSeminarRegLineGlobal: Record "SEM Seminar Reg. Line" temporary; SeminarRegHeader: Record "SEM Seminar Reg. Header"; SrcCode: Code[10]; CommitIsSuppressed: Boolean)
    begin
        // Participant
        PostSeminarJnlLine(2, SeminarRegHeader, PostedSeminarRegHeader, TempSeminarRegLineGlobal, SrcCode);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEM Seminar-Post", 'OnPostUpdatePostedLineOnBeforeModify', '', true, false)]
    local procedure SeminarPostOnPostUpdatePostedLineOnBeforeModify(var SeminarRegLine: Record "SEM Seminar Reg. Line"; var TempSeminarRegLine: Record "SEM Seminar Reg. Line" temporary)
    begin
        SeminarRegLine.Registered := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEM Seminar Jnl.-Check Line", 'OnAfterRunCheck', '', true, false)]
    local procedure SeminarJnlCheckLineOnAfterRunCheck(var SeminarJnlLine: Record "SEM Seminar Journal Line")
    begin
        with SeminarJnlLine do begin
            TestField("Document No.");
            TestField("Seminar Registration No.");

            case "Charge Type" of
                "Charge Type"::Instructor:
                    begin
                        TestField("Instructor Code");
                    end;
                "Charge Type"::Participant:
                    begin

                        TestField("Participant Contact No.");
                        TestField("Participant Name");
                    end;
                "Charge Type"::Room:
                    begin
                        TestField("Seminar Room Code");
                    end;
            end;

            if Chargeable then
                TestField("Bill-to Customer No.");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEM Seminar Jnl.-Post Line", 'OnBeforePostJnlLine', '', true, false)]
    local procedure SeminarJnlPostLineOnBeforePostJnlLine(var SeminarJnlLine: Record "SEM Seminar Journal Line")
    var
        Res: Record Resource;
        Instructor: Record "SEM Instructor";
        SeminarRoom: Record "SEM Seminar Room";
        SeminarRegHeader: Record "SEM Seminar Reg. Header";
        Cust: Record Customer;
    begin
        with SeminarJnlLine do begin
            case "Charge Type" of
                "Charge Type"::Instructor:
                    begin
                        TestField("Instructor Code");
                        Instructor.Get("Instructor Code");
                        Instructor.TestField(Blocked, false);
                        Res.Get(Instructor."Resource No.");
                        Res.CheckResourcePrivacyBlocked(true);
                        Res.TestField(Blocked, false);
                        Res.TestField("Gen. Prod. Posting Group");
                    end;
                "Charge Type"::Participant:
                    begin
                        TestField("Participant Contact No.");
                        TestField("Participant Name");
                    end;
                "Charge Type"::Room:
                    begin
                        TestField("Seminar Room Code");
                        SeminarRoom.Get("Seminar Room Code");
                        SeminarRoom.TestField(Blocked, false);
                        Res.Get(SeminarRoom."Resource No.");
                        Res.CheckResourcePrivacyBlocked(true);
                        Res.TestField(Blocked, false);
                        Res.TestField("Gen. Prod. Posting Group");
                    end;
            end;

            if "Seminar Registration No." <> '' then begin
                SeminarRegHeader.Get("Seminar Registration No.");
                SeminarRegHeader.TestField("Gen. Prod. Posting Group");
            end;

            if Chargeable then begin
                Cust.Get("Bill-to Customer No.");
                // check invoice posting
                Cust.CheckBlockedCustOnJnls(Cust, 2, true);
            end;
        end;
    end;

}