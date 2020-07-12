codeunit 123456700 "SEM Seminar-Post"
{
    Permissions = TableData "SEM Seminar Reg. Line" = imd,
                  TableData "SEM Posted Seminar Reg. Header" = imd,
                  TableData "SEM Posted Seminar Reg. Line" = imd;
    TableNo = "SEM Seminar Reg. Header";

    trigger OnRun()
    var
        SavedPreviewMode: Boolean;
        SavedSuppressCommit: Boolean;
        LinesProcessed: Boolean;
    begin
        OnBeforePostSeminarReg(Rec, SuppressCommit, PreviewMode, HideProgressWindow);
        if not GuiAllowed then
            LockTimeout(false);

        SavedPreviewMode := PreviewMode;
        SavedSuppressCommit := SuppressCommit;
        ClearAllVariables();
        SuppressCommit := SavedSuppressCommit;
        PreviewMode := SavedPreviewMode;

        GetSeminarSetup();
        SeminarRegHeader := Rec;
        FillTempLines(SeminarRegHeader, TempSeminarRegLineGlobal);

        EverythingPosted := true;

        // Header
        CheckAndUpdate();
        PostHeader(SeminarRegHeader, PostedSeminarRegHeader);


        // Lines
        OnBeforePostLines(TempSeminarRegLineGlobal, SeminarRegHeader, SuppressCommit, PreviewMode);

        LineCount := 0;

        LinesProcessed := false;
        if TempSeminarRegLineGlobal.FindSet() then
            repeat
                LineCount := LineCount + 1;
                if not HideProgressWindow then
                    Window.Update(2, LineCount);

                PostLine(SeminarRegHeader, TempSeminarRegLineGlobal);
            until TempSeminarRegLineGlobal.Next() = 0;

        OnAfterPostPostedLines(SeminarRegHeader, PostedSeminarRegHeader, LinesProcessed, SuppressCommit, EverythingPosted);

        UpdateLastPostingNos(SeminarRegHeader);

        OnRunOnBeforeFinalizePosting(
          SeminarRegHeader, PostedSeminarRegHeader, SuppressCommit);

        FinalizePosting(SeminarRegHeader, EverythingPosted);

        Rec := SeminarRegHeader;

        if not SuppressCommit then
            Commit();

        OnAfterPostPostedDoc(Rec, PostedSeminarRegHeader."No.", SuppressCommit);
    end;

    var
        SeminarRegHeader: Record "SEM Seminar Reg. Header";
        SeminarRegLine: Record "SEM Seminar Reg. Line";
        TempSeminarRegLineGlobal: Record "SEM Seminar Reg. Line" temporary;
        PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header";
        PostedSeminarRegLine: Record "SEM Posted Seminar Reg. Line";
        SeminarCommentLine: Record "SEM Seminar Comment Line";
        SourceCodeSetup: Record "Source Code Setup";
        ModifyHeader: Boolean;
        Window: Dialog;
        LineCount: Integer;
        PostingLinesMsg: Label 'Posting lines              #2######', Comment = 'Counter';
        PostedSeminarRegNoMsg: Label 'Registration %1  -> Posted Reg. %2';
        PostingPreviewNoTok: Label '***', Locked = true;
        EverythingPosted: Boolean;
        SuppressCommit: Boolean;
        PreviewMode: Boolean;
        HideProgressWindow: Boolean;
        SrcCode: Code[10];
        SeminarSetup: Record "SEM Seminar Setup";
        SeminarSetupRead: Boolean;

    [IntegrationEvent(false, false)]
    local procedure OnRunOnBeforeFinalizePosting(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostPostedDoc(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; PostedSeminarRegHeaderNo: Code[20]; CommitIsSuppressed: Boolean)
    begin
    end;

    local procedure FinalizePosting(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; EverythingInvoiced: Boolean)
    begin
        OnBeforeFinalizePosting(SeminarRegHeader, TempSeminarRegLineGlobal, EverythingInvoiced, SuppressCommit);

        with SeminarRegHeader do begin
            if not EverythingInvoiced then begin
                OnFinalizePostingOnNotEverythingInvoiced(SeminarRegHeader, TempSeminarRegLineGlobal, SuppressCommit)
            end else begin
                PostUpdatePostedLine;
            end;

            if not PreviewMode then
                DeleteAfterPosting(SeminarRegHeader);
        end;

        OnAfterFinalizePostingOnBeforeCommit(SeminarRegHeader, PostedSeminarRegHeader, SuppressCommit, PreviewMode);

        if PreviewMode then begin
            if not HideProgressWindow then
                Window.Close();
            exit;
        end;
        if not SuppressCommit then
            Commit();

        if not HideProgressWindow then
            Window.Close();

        OnAfterFinalizePosting(SeminarRegHeader, PostedSeminarRegHeader, SuppressCommit, PreviewMode);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFinalizePostingOnNotEverythingInvoiced(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var TempSeminarRegLineGlobal: Record "SEM Seminar Reg. Line" temporary; SuppressCommit: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFinalizePostingOnBeforeCommit(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFinalizePosting(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFinalizePosting(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var TempSeminarRegLineGlobal: Record "SEM Seminar Reg. Line" temporary; var EverythingInvoiced: Boolean; SuppressCommit: Boolean)
    begin
    end;

    local procedure DeleteAfterPosting(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    var
        SeminarCommentLine: Record "SEM Seminar Comment Line";
        SeminarRegLine: Record "SEM Seminar Reg. Line";
        TempSeminarRegLineLocal: Record "SEM Seminar Reg. Line" temporary;
        SkipDelete: Boolean;
    begin
        OnBeforeDeleteAfterPosting(SeminarRegHeader, PostedSeminarRegHeader, SkipDelete, SuppressCommit);
        if SkipDelete then
            exit;

        with SeminarRegHeader do begin
            if HasLinks then
                DeleteLinks;

            Delete;

            ResetTempLines(TempSeminarRegLineLocal);
            if TempSeminarRegLineLocal.FindFirst() then
                repeat
                    if TempSeminarRegLineLocal.HasLinks then
                        TempSeminarRegLineLocal.DeleteLinks;
                until TempSeminarRegLineLocal.Next() = 0;

            SeminarRegLine.SetRange("Document No.", "No.");
            OnBeforeSeminarRegLineDeleteAll(SeminarRegLine, SuppressCommit);
            SeminarRegLine.DeleteAll();

            SeminarCommentLine.DeleteComments(SeminarCommentLine."Document Type"::"Seminar Registration", "No.");
        end;

        OnAfterDeleteAfterPosting(SeminarRegHeader, PostedSeminarRegHeader, SuppressCommit);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteAfterPosting(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; var SkipDelete: Boolean; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSeminarRegLineDeleteAll(var SeminerRegLine: Record "SEM Seminar Reg. Line"; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterDeleteAfterPosting(SeminarRegHeader: Record "SEM Seminar Reg. Header"; PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; CommitIsSuppressed: Boolean)
    begin
    end;


    local procedure PostUpdatePostedLine()
    var
        SeminarRegLine: Record "SEM Seminar Reg. Line";
        TempSeminarRegLine: Record "SEM Seminar Reg. Line" temporary;
    begin
        ResetTempLines(TempSeminarRegLine);
        with TempSeminarRegLine do begin
            OnPostUpdatePostedLineOnBeforeFindSet(TempSeminarRegLine);
            if FindSet() then
                repeat
                    SeminarRegLine.Get("Document No.", "Line No.");
                    OnPostUpdatePostedLineOnBeforeModify(SeminarRegLine, TempSeminarRegLine);
                    SeminarRegLine.Modify();
                until Next() = 0;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostUpdatePostedLineOnBeforeFindSet(var TempSeminarRegLine: Record "SEM Seminar Reg. Line" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostUpdatePostedLineOnBeforeModify(var SeminarRegLine: Record "SEM Seminar Reg. Line"; var TempSeminarRegLine: Record "SEM Seminar Reg. Line" temporary)
    begin
    end;

    local procedure ResetTempLines(var TempSeminarRegLineLocal: Record "SEM Seminar Reg. Line" temporary)
    begin
        TempSeminarRegLineLocal.Reset();
        TempSeminarRegLineLocal.Copy(TempSeminarRegLineGlobal, true);
        OnAfterResetTempLines(TempSeminarRegLineLocal);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterResetTempLines(var TempSeminarRegLineLocal: Record "SEM Seminar Reg. Line" temporary)
    begin
    end;

    local procedure UpdateLastPostingNos(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
        with SeminarRegHeader do begin
            "Last Posting No." := PostedSeminarRegHeader."No.";
            "Posting No." := '';
        end;

        OnAfterUpdateLastPostingNos(SeminarRegHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateLastPostingNos(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
    end;

    local procedure PostLine(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var SeminarRegLine: Record "SEM Seminar Reg. Line")
    var
        IsHandled: Boolean;
    begin
        with SeminarRegLine do begin
            TestLine(SeminarRegHeader, SeminarRegLine);

            UpdateLineBeforePost(SeminarRegHeader, SeminarRegLine);

            IsHandled := false;
            OnPostLineOnBeforeInsertPostedLine(SeminarRegHeader, SeminarRegLine, IsHandled, PostedSeminarRegHeader);
            if not IsHandled then begin
                PostedSeminarRegLine.Init;
                PostedSeminarRegLine.TransferFields(SeminarRegLine);
                PostedSeminarRegLine."Document No." := PostedSeminarRegHeader."No.";

                OnBeforePostedLineInsert(PostedSeminarRegLine, PostedSeminarRegHeader, TempSeminarRegLineGlobal, SeminarRegHeader, SrcCode, SuppressCommit);
                PostedSeminarRegLine.Insert(true);
                OnAfterPostedLineInsert(PostedSeminarRegLine, PostedSeminarRegHeader, TempSeminarRegLineGlobal, SeminarRegHeader, SrcCode, SuppressCommit);
            end;
        end;

        OnAfterPostPostedLine(SeminarRegHeader, SeminarRegLine, SuppressCommit, PostedSeminarRegLine);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostLineOnBeforeInsertPostedLine(SeminarRegHeader: Record "SEM Seminar Reg. Header"; SeminarRegLine: Record "SEM Seminar Reg. Line"; var IsHandled: Boolean; PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostedLineInsert(var PostedSeminarRegLine: Record "SEM Posted Seminar Reg. Line"; PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; var TempSeminarRegLineGlobal: Record "SEM Seminar Reg. Line" temporary; SeminarRegHeader: Record "SEM Seminar Reg. Header"; SrcCode: Code[10]; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostedLineInsert(var PostedSeminarRegLine: Record "SEM Posted Seminar Reg. Line"; PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; var TempSeminarRegLineGlobal: Record "SEM Seminar Reg. Line" temporary; SeminarRegHeader: Record "SEM Seminar Reg. Header"; SrcCode: Code[10]; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostPostedLine(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var SeminarRegLine: Record "SEM Seminar Reg. Line"; CommitIsSuppressed: Boolean; var PostedSeminarRegLine: Record "SEM Posted Seminar Reg. Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostPostedLines(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; var LinesProcessed: Boolean; CommitIsSuppressed: Boolean; EverythingPosted: Boolean)
    begin
    end;

    local procedure TestLine(SeminarRegHeader: Record "SEM Seminar Reg. Header"; SeminarRegLine: Record "SEM Seminar Reg. Line")
    begin
        OnTestLine(SeminarRegHeader, SeminarRegLine, SuppressCommit);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnTestLine(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var SeminarRegLine: Record "SEM Seminar Reg. Line"; CommitIsSuppressed: Boolean)
    begin
    end;

    local procedure UpdateLineBeforePost(SeminarRegHeader: Record "SEM Seminar Reg. Header"; SeminarRegLine: Record "SEM Seminar Reg. Line")
    begin
        OnUpdateLineBeforePost(SeminarRegHeader, SeminarRegLine, SuppressCommit);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateLineBeforePost(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var SeminarRegLine: Record "SEM Seminar Reg. Line"; CommitIsSuppressed: Boolean)
    begin
    end;

    local procedure ClearAllVariables()
    begin
        ClearAll;
        TempSeminarRegLineGlobal.DeleteAll();
    end;

    procedure FillTempLines(SeminarRegHeader: Record "SEM Seminar Reg. Header"; var TempSeminarRegLine: Record "SEM Seminar Reg. Line" temporary)
    begin
        TempSeminarRegLine.Reset();
        if TempSeminarRegLine.IsEmpty() then
            CopyToTempLines(SeminarRegHeader, SeminarRegLine);
    end;

    procedure CopyToTempLines(SeminarRegHeader: Record "SEM Seminar Reg. Header"; var TempSeminarRegLine: Record "SEM Seminar Reg. Line" temporary)
    var
        SeminarRegLine: Record "SEM Seminar Reg. Line";
    begin
        SeminarRegLine.SetRange("Document No.", SeminarRegHeader."No.");
        OnCopyToTempLinesOnAfterSetFilters(SeminarRegLine, SeminarRegHeader);
        if SeminarRegLine.FindSet() then
            repeat
                TempSeminarRegLine := SeminarRegLine;
                TempSeminarRegLine.Insert();
            until SeminarRegLine.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCopyToTempLinesOnAfterSetFilters(var SeminarRegLine: Record "SEM Seminar Reg. Line"; SalesHeader: Record "SEM Seminar Reg. Header")
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforePostLines(var TempSeminarRegLineGlobal: Record "SEM Seminar Reg. Line" temporary; var SeminarRegHeader: Record "SEM Seminar Reg. Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
    end;

    procedure SetSuppressCommit(NewSuppressCommit: Boolean)
    begin
        SuppressCommit := NewSuppressCommit;
    end;

    procedure SetPreviewMode(NewPreviewMode: Boolean)
    begin
        PreviewMode := NewPreviewMode;
    end;

    local procedure PostHeader(SeminarRegHeader: Record "SEM Seminar Reg. Header"; PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header")
    begin
        OnPostHeader(SeminarRegHeader, PostedSeminarRegHeader, TempSeminarRegLineGlobal, SrcCode, SuppressCommit, PreviewMode);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostHeader(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; var TempSeminarRegLineGlobal: Record "SEM Seminar Reg. Line" temporary; SrcCode: Code[10]; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
    end;

    local procedure CheckAndUpdate()
    begin
        with SeminarRegHeader do begin
            // Check
            CheckMandatoryHeaderFields(SeminarRegHeader);
            CheckPostRestrictions(SeminarRegHeader);

            if not HideProgressWindow then
                InitProgressWindow(SeminarRegHeader);

            CheckNothingToPost(SeminarRegHeader);

            OnAfterCheckSeminarReg(SeminarRegHeader, SuppressCommit);

            // Update
            ModifyHeader := UpdatePostingNo(SeminarRegHeader);

            OnBeforePostCommitSeminarReg(SeminarRegHeader, PreviewMode, ModifyHeader, SuppressCommit, TempSeminarRegLineGlobal);
            if not PreviewMode and ModifyHeader then begin
                Modify;
                if not SuppressCommit then
                    Commit();
            end;

            LockTables(SeminarRegHeader);

            SourceCodeSetup.Get();
            SrcCode := SourceCodeSetup.Sales;

            OnCheckAndUpdateOnAfterSetSourceCode(SeminarRegHeader, SourceCodeSetup, SrcCode);

            InsertPostedHeaders(SeminarRegHeader);
        end;

        OnAfterCheckAndUpdate(SeminarRegHeader, SuppressCommit, PreviewMode);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckAndUpdate(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
    end;

    local procedure InsertPostedHeaders(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    var
        PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler";
        IsHandled: Boolean;
    begin
        if PreviewMode then
            PostingPreviewEventHandler.PreventCommit();

        PostedSeminarRegHeader.LockTable();

        IsHandled := false;
        OnBeforeInsertPostedSeminarRegHeader(SeminarRegHeader, IsHandled);
        if not IsHandled then
            InsertPostedSeminarRegHeader(SeminarRegHeader, PostedSeminarRegHeader);

        OnAfterInsertPostedSeminarRegHeader(SeminarRegHeader, PostedSeminarRegHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertPostedSeminarRegHeader(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertPostedSeminarRegHeader(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header")
    begin
    end;

    local procedure InsertPostedSeminarRegHeader(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header")
    var
        SalesCommentLine: Record "Sales Comment Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        with SeminarRegHeader do begin
            PostedSeminarRegHeader.Init();
            PostedSeminarRegHeader.TransferFields(SeminarRegHeader);

            PostedSeminarRegHeader."No." := "Posting No.";
            PostedSeminarRegHeader."No. Series" := "Posting No. Series";
            PostedSeminarRegHeader."Seminar Reg. No." := "No.";
            PostedSeminarRegHeader."Seminar Reg. No. Series" := "No. Series";
            if GuiAllowed and not HideProgressWindow then
                Window.Update(1, StrSubstNo(PostedSeminarRegNoMsg, "No.", PostedSeminarRegHeader."No."));
            PostedSeminarRegHeader."Source Code" := SrcCode;
            PostedSeminarRegHeader."User ID" := UserId;
            PostedSeminarRegHeader."No. Printed" := 0;

            OnBeforePostedSeminarRegHeaderInsert(PostedSeminarRegHeader, SeminarRegHeader, SuppressCommit);
            PostedSeminarRegHeader.Insert(true);
            OnAfterPostedSeminarRegHeaderInsert(PostedSeminarRegHeader, SeminarRegHeader, SuppressCommit);

            if SeminarSetup."Copy Comments" then begin
                SeminarCommentLine.CopyComments(SeminarCommentLine."Document Type"::"Seminar Registration", SeminarCommentLine."Document Type"::"Posted Seminar Registration", "No.", PostedSeminarRegHeader."No.");
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostedSeminarRegHeaderInsert(var PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; SeminarRegHeader: Record "SEM Seminar Reg. Header"; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostedSeminarRegHeaderInsert(var PostedSeminarRegHeader: Record "SEM Posted Seminar Reg. Header"; SeminarRegHeader: Record "SEM Seminar Reg. Header"; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckAndUpdateOnAfterSetSourceCode(SeminarRegHeader: Record "SEM Seminar Reg. Header"; SourceCodeSetup: Record "Source Code Setup"; var SrcCode: Code[10]);
    begin
    end;

    local procedure LockTables(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    var
        SeminarRegLine: Record "SEM Seminar Reg. Line";
    begin
        OnBeforeLockTables(SeminarRegHeader, PreviewMode, SuppressCommit);

        SeminarRegLine.LockTable();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLockTables(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; PreviewMode: Boolean; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostCommitSeminarReg(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; PreviewMode: Boolean; var ModifyHeader: Boolean; var CommitIsSuppressed: Boolean; var TempSeminarRegLineGlobal: Record "SEM Seminar Reg. Line" temporary)
    begin
    end;

    local procedure UpdatePostingNo(var SeminarRegHeader: Record "SEM Seminar Reg. Header") ModifyHeader: Boolean
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        IsHandled: Boolean;
    begin
        with SeminarRegHeader do begin
            OnBeforeUpdatePostingNo(SeminarRegHeader, PreviewMode, ModifyHeader, IsHandled);

            if not IsHandled then
                if "Posting No." = '' then
                    if not PreviewMode then begin
                        TestField("Posting No. Series");
                        "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series", "Posting Date", true);
                        ModifyHeader := true;
                    end else
                        "Posting No." := PostingPreviewNoTok;
        end;

        OnAfterUpdatePostingNo(SeminarRegHeader, NoSeriesMgt, SuppressCommit);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdatePostingNo(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; PreviewMode: Boolean; var ModifyHeader: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdatePostingNo(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var NoSeriesMgt: Codeunit NoSeriesManagement; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckSeminarReg(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; CommitIsSuppressed: Boolean)
    begin
    end;

    procedure InitProgressWindow(SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
        Window.Open(
                '#1#################################\\' +
                  PostingLinesMsg);
        Window.Update(1, StrSubstNo('%1', SeminarRegHeader."No."));
    end;

    local procedure CheckMandatoryHeaderFields(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckMandatoryFields(SeminarRegHeader, SuppressCommit, IsHandled);
        if not IsHandled then begin
            SeminarRegHeader.TestField("Posting Date");
        end;

        OnAfterCheckMandatoryFields(SeminarRegHeader, SuppressCommit);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckMandatoryFields(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckMandatoryFields(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; CommitIsSuppressed: Boolean)
    begin
    end;

    local procedure CheckPostRestrictions(SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
        OnCheckPostRestrictions(SeminarRegHeader);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckPostRestrictions(var SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
    end;

    local procedure CheckNothingToPost(SeminarRegHeader: Record "SEM Seminar Reg. Header")
    begin
        OnCheckNothingToPost(SeminarRegHeader, TempSeminarRegLineGlobal);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckNothingToPost(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; var TempSeminarRegLineGlobal: Record "SEM Seminar Reg. Line" temporary)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforePostSeminarReg(var SeminarRegHeader: Record "SEM Seminar Reg. Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean)
    begin
    end;

    local procedure GetSeminarSetup()
    begin
        if not SeminarSetupRead then
            SeminarSetup.Get;

        SeminarSetupRead := true;

        OnAfterGetSeminarSetup(SeminarSetup);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetSeminarSetup(var SeminarSetup: Record "SEM Seminar Setup")
    begin
    end;

}

