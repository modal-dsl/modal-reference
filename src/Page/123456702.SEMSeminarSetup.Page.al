page 123456702 "SEM Seminar Setup"
{
    ApplicationArea = All;
    Caption = 'Seminar Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "SEM Seminar Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(CopyComments; "Copy Comments")
                {
                    ApplicationArea = All;
                }
            }
            group("Number Series")
            {
                Caption = 'Number Series';

                field(SeminarNos; "Seminar Nos.")
                {
                    ApplicationArea = All;
                }
                field(SeminarRegistrationNos; "Seminar Registration Nos.")
                {
                    ApplicationArea = All;
                }
                field(PostedSeminarRegNos; "Posted Seminar Reg. Nos.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}
