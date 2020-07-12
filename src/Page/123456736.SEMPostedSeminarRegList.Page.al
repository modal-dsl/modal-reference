page 123456736 "SEM Posted Seminar Reg. List"
{
    ApplicationArea = All;
    Caption = 'Posted Seminar Registrations';
    CardPageID = "SEM Posted Sem. Registration";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Seminar Registration,Navigate,Print/Send';
    RefreshOnActivate = true;
    SourceTable = "SEM Posted Seminar Reg. Header";
    SourceTableView = SORTING("Posting Date")
                      ORDER(Descending);
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Seminar No."; "Seminar No.")
                {
                    ApplicationArea = All;
                }
                field("Seminar Description"; "Seminar Description")
                {
                    ApplicationArea = All;
                }
                field("Instructor Code"; "Instructor Code")
                {
                    ApplicationArea = All;
                }
                field("Room Code"; "Room Code")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Seminar &Registration")
            {
                Caption = 'Seminar &Registration';
                action(Comments)
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "SEM Seminar Comment Sheet";
                    RunPageLink = "No." = field("No."),
                                  "Document Line No." = const(0);
                    ToolTip = 'View or add comments for the record.';
                }
            }
        }
        area(processing)
        {
            action(Navigate)
            {
                CaptionML = DEU = '&Navigate',
                            ENU = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }
}

