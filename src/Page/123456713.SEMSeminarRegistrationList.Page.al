page 123456713 "SEM Seminar Registration List"
{
    ApplicationArea = All;
    Caption = 'Seminar Registrations';
    CardPageID = "SEM Seminar Registration";
    DataCaptionFields = "Seminar No.";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Posting,Print/Send,Seminar Registration,Navigate';
    RefreshOnActivate = true;
    SourceTable = "SEM Seminar Reg. Header";
    UsageCategory = Lists;

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
                Image = "Order";
                action("&Seminar Card")
                {
                    ApplicationArea = All;
                    Caption = '&Seminar Card';
                    Image = "Event";
                    RunObject = Page "SEM Seminar Card";
                    RunPageLink = "No." = FIELD("Seminar No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View detailed information about the seminar.';
                }
                action(Comments)
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Page "SEM Seminar Comment Sheet";
                    RunPageLink = "No." = field("No."),
                                  "Document Line No." = const(0);
                    ToolTip = 'View or add comments for the record.';
                }
            }
        }
    }
}

